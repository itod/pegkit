// The MIT License (MIT)
//
// Copyright (c) 2014 Todd Ditchendorf
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <PEGKit/PKParser.h>
#import <PEGKit/PKParser+Subclass.h>
#import <PEGKit/PKToken.h>
#import <PEGKit/PKTokenizer.h>
#import <PEGKit/PKWhitespaceState.h>
#import <PEGKit/PKAssembly.h>
#import <PEGKit/PKRecognitionException.h>
#import "NSArray+PEGKitAdditions.h"
#import "NSString+PEGKitAdditions.h"

#define TD_FAILED -1

NSString * const PEGKitErrorDomain = @"PEGKitErrorDomain";
NSString * const PEGKitErrorRangeKey = @"range";
NSString * const PEGKitErrorLineNumberKey = @"lineNumber";

NSInteger PEGKitRecognitionErrorCode = 1;
NSString * const PEGKitRecognitionTokenMatchFailed = @"Failed to match next input token";
NSString * const PEGKitRecognitionRuleMatchFailed = @"Failed to match next rule";
NSString * const PEGKitRecognitionPredicateFailed = @"Predicate failed";

@interface NSObject ()
- (void)parser:(PKParser *)p didFailToMatch:(PKAssembly *)a;
@end

@interface PKAssembly ()
- (void)consume:(PKToken *)tok;
@property (nonatomic, readwrite, retain) NSMutableArray *stack;
@end

@interface PKParser ()
@property (nonatomic, assign, readwrite) id delegate; // weak ref
@property (nonatomic, retain) PKRecognitionException *exception;
@property (nonatomic, retain) NSMutableArray *lookahead;
@property (nonatomic, retain) NSMutableArray *markers;
@property (nonatomic, assign) NSInteger p;
@property (nonatomic, assign, readonly) BOOL isSpeculating;
@property (nonatomic, retain) NSCountedSet *resyncSet;
@property (nonatomic, retain) NSMutableArray *tokenSource;
@property (nonatomic, assign) NSUInteger tokenSourceIndex;
@property (nonatomic, assign) NSUInteger tokenSourceCount;

- (NSInteger)tokenKindForString:(NSString *)str;
- (NSString *)stringForTokenKind:(NSInteger)tokenKind;
- (BOOL)lookahead:(NSInteger)x predicts:(NSInteger)tokenKind;

- (void)discard;

// error recovery
- (void)pushFollow:(NSInteger)tokenKind;
- (void)popFollow:(NSInteger)tokenKind;
- (BOOL)resync;

// backtracking
- (NSInteger)mark;
- (void)unmark;
- (void)seek:(NSInteger)index;
- (void)sync:(NSInteger)i;
- (void)fill:(NSInteger)n;

// memoization
- (BOOL)alreadyParsedRule:(NSMutableDictionary *)memoization;
- (void)memoize:(NSMutableDictionary *)memoization atIndex:(NSInteger)startTokenIndex failed:(BOOL)failed;
- (void)clearMemo;
@end

@implementation PKParser

- (instancetype)init {
    self = [self initWithDelegate:nil];
    return self;
}


- (instancetype)initWithDelegate:(id)d {
    self = [super init];
    if (self) {
        self.delegate = d;
        self.enableActions = YES;
        
        // create a single exception for reuse in control flow
        self.exception = [[[PKRecognitionException alloc] init] autorelease];
        
        self.tokenKindTab = [NSMutableDictionary dictionary];

        self.tokenKindNameTab = [NSMutableArray array];
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_INVALID] = @"Invalid";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_NUMBER] = @"Number";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_QUOTEDSTRING] = @"Quoted String";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_SYMBOL] = @"Symbol";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_WORD] = @"Word";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_WHITESPACE] = @"Whitespace";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_COMMENT] = @"Comment";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_DELIMITEDSTRING] = @"Delimited String";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_URL] = @"URL";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_EMAIL] = @"Email";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_TWITTER] = @"Twitter";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_HASHTAG] = @"Hashtag";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_EMPTY] = @"Empty";
        _tokenKindNameTab[TOKEN_KIND_BUILTIN_ANY] = @"Any";
    }
    return self;
}


- (void)dealloc {
    self.delegate = nil;
    self.tokenizer = nil;
    self.assembly = nil;
    self.exception = nil;
    self.lookahead = nil;
    self.markers = nil;
    self.tokenKindTab = nil;
    self.tokenKindNameTab = nil;
    self.resyncSet = nil;
    self.tokenSource = nil;
    self.startRuleName = nil;
    self.statementTerminator = nil;
    self.singleLineCommentMarker = nil;
    self.multiLineCommentStartMarker = nil;
    self.multiLineCommentEndMarker = nil;
    self.blockStartMarker = nil;
    self.blockEndMarker = nil;
    self.braces = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark PKTokenizerDelegate

- (NSInteger)tokenizer:(PKTokenizer *)t tokenKindForStringValue:(NSString *)str {
    NSParameterAssert([str length]);
    return [self tokenKindForString:str];
}


- (NSInteger)tokenKindForString:(NSString *)str {
    NSInteger tokenKind = TOKEN_KIND_BUILTIN_INVALID;
    
    id obj = self.tokenKindTab[str];
    if (obj) {
        tokenKind = [obj integerValue];
    }
    
    return tokenKind;
}


- (NSString *)stringForTokenKind:(NSInteger)tokenKind {
    NSString *str = nil;
    
    if (TOKEN_KIND_BUILTIN_EOF == tokenKind) {
        str = [[PKToken EOFToken] stringValue];
    } else {
        str = self.tokenKindNameTab[tokenKind];
    }

    return str;
}


- (id)parseStream:(NSInputStream *)input error:(NSError **)outError {
    NSParameterAssert(input);
    
    [input scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [input open];
    
    PKTokenizer *t = _tokenizer;
    
    if (t) {
        t.stream = input;
    } else {
        t = [PKTokenizer tokenizerWithStream:input];
    }

    id result = [self parseWithTokenizer:t error:outError];
    
    [input close];
    [input removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    return result;
}


- (id)parseString:(NSString *)input error:(NSError **)outError {
    NSParameterAssert(input);

    PKTokenizer *t = _tokenizer;
    
    if (t) {
        t.string = input;
    } else {
        t = [PKTokenizer tokenizerWithString:input];
    }
    
    id result = [self parseWithTokenizer:t error:outError];
    return result;
}


- (id)parseTokens:(NSArray *)input error:(NSError **)outError {
    
    self.tokenSource = [[input mutableCopy] autorelease];
    self.tokenSourceIndex = 0;
    self.tokenSourceCount = [_tokenSource count];
    
    id result = [self parse:outError];
    return result;
}


- (id)parseWithTokenizer:(PKTokenizer *)t error:(NSError **)outError {
    
    // setup tokenizer
    self.tokenizer = t;
    self.tokenizer.delegate = self;
    
    id result = [self parse:outError];
    return result;
}


- (id)parse:(NSError **)outError {
    id result = nil;

    self.assembly = [PKAssembly assembly];

    if (_silentlyConsumesWhitespace) {
        _tokenizer.whitespaceState.reportsWhitespaceTokens = YES;
        _assembly.preservesWhitespaceTokens = YES;
    }

    // setup speculation
    self.p = 0;
    self.lookahead = [NSMutableArray array];
    self.markers = [NSMutableArray array];

    if (_enableAutomaticErrorRecovery) {
        self.resyncSet = [NSCountedSet set];
    }
    
    [self clearMemo];
    
    @try {

        @autoreleasepool {
            // parse
            [self start];
            
            //NSLog(@"%@", _assembly);
            
            // get result
            if (_assembly.target) {
                result = _assembly.target;
            } else {
                result = _assembly;
            }

            [result retain]; // +1
        }
        [result autorelease]; // -1

    }
    @catch (PKRecognitionException *rex) {
        NSString *domain = PEGKitErrorDomain;
        NSString *name = rex.currentName;
        NSString *reason = rex.currentReason;
        NSRange range = rex.range;
        NSUInteger lineNumber = rex.lineNumber;
        //NSLog(@"%@: %@", name, reason);

        if (outError) {
            *outError = [self errorWithDomain:domain name:name reason:reason range:range lineNumber:lineNumber];
        } else {
            [rex raise];
        }
    }
    @catch (NSException *ex) {
        NSString *domain = PEGKitErrorDomain;
        NSString *name = [ex name];
        NSString *reason = [ex reason];
        //NSLog(@"%@", reason);
        
        if (outError) {
            *outError = [self errorWithDomain:domain name:name reason:reason range:NSMakeRange(NSNotFound, 0) lineNumber:0];
        } else {
            [ex raise];
        }
    }
    @finally {
        self.tokenSource = nil;
        self.tokenSourceIndex = 0;
        self.tokenSourceCount = 0;
        self.assembly = nil;
        self.lookahead = nil;
        self.markers = nil;
        self.resyncSet = nil;
    }
    
    return result;
}


- (NSError *)errorWithDomain:(NSString *)domain name:(NSString *)name reason:(NSString *)reason range:(NSRange)r lineNumber:(NSUInteger)lineNum {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

    // get description
    name = name ? name : NSLocalizedString(@"A parsing recognition exception occured.", @"");
    [userInfo setObject:name forKey:NSLocalizedDescriptionKey];
    
    // get reason
    reason = reason ? reason : @"";
    userInfo[NSLocalizedFailureReasonErrorKey] = reason;
    userInfo[PEGKitErrorRangeKey] = [NSValue valueWithRange:r];
    
    id lineNumVal = nil;
    if (NSNotFound == lineNum) {
        lineNumVal = NSLocalizedString(@"Unknown", @"");
    } else {
        lineNumVal = @(lineNum);
    }
    userInfo[PEGKitErrorLineNumberKey] = lineNumVal;
    
    // convert to NSError
    NSError *err = [NSError errorWithDomain:PEGKitErrorDomain code:PEGKitRecognitionErrorCode userInfo:[[userInfo copy] autorelease]];
    return err;
}


- (void)match:(NSInteger)tokenKind discard:(BOOL)discard {
    NSParameterAssert(tokenKind != TOKEN_KIND_BUILTIN_INVALID);
    NSAssert(_lookahead, @"");
    
    // always match empty without consuming
    if (TOKEN_KIND_BUILTIN_EMPTY == tokenKind) return;

    PKToken *lt = LT(1); // NSLog(@"%@", lt);
    
    BOOL matches = lt.tokenKind == tokenKind || (TOKEN_KIND_BUILTIN_ANY == tokenKind && PKTokenTypeEOF != lt.tokenType);

    if (matches) {
        if (TOKEN_KIND_BUILTIN_EOF != tokenKind) {
            [self consume:lt];
            if (discard) [self discard];
        }
    } else {
        NSString *msg = [NSString stringWithFormat:@"Expected : %@\n", [self stringForTokenKind:tokenKind]];
        [self raiseWithName:PEGKitRecognitionTokenMatchFailed message:msg];
    }
}


- (void)consume:(PKToken *)tok {
    if (!self.isSpeculating) {
        [_assembly consume:tok];
        //NSLog(@"%@", _assembly);
    }

    self.p++;
    
    // have we hit end of buffer when not backtracking?
    if (_p == [_lookahead count] && !self.isSpeculating) {
        // if so, it's an opp to start filling at index 0 again
        self.p = 0;
        [_lookahead removeAllObjects]; // size goes to 0, but retains memory on heap
        [self clearMemo]; // clear all rule_memo dictionaries
    }
    
    [self sync:1];
}


- (void)discard {
    if (self.isSpeculating) return;
    
    NSAssert(![_assembly isStackEmpty], @"");
    [_assembly pop];
}


- (void)fireDelegateSelector:(SEL)sel {
    if (self.isSpeculating) return;
    
    if (_delegate && [_delegate respondsToSelector:sel]) {
        [_delegate performSelector:sel withObject:self withObject:_assembly];
    }
}


- (void)fireSyntaxSelector:(SEL)sel withRuleName:(NSString *)ruleName {
    if (self.isSpeculating) return;
    
    if (_delegate && [_delegate respondsToSelector:sel]) {
        [_delegate performSelector:sel withObject:self withObject:ruleName];
    }
}


- (PKToken *)LT:(NSInteger)i {
    PKToken *tok = nil;
    
    for (;;) {
        [self sync:i];

        NSUInteger idx = _p + i - 1;
        NSAssert(idx < [_lookahead count], @"");
        
        tok = _lookahead[idx];
        if (_silentlyConsumesWhitespace && tok.isWhitespace) {
            [self consume:tok];
        } else {
            break;
        }
    }
    
    return tok;
}


- (NSInteger)LA:(NSInteger)i {
    return [LT(i) tokenKind];
}


- (double)LD:(NSInteger)i {
    return [LT(i) doubleValue];
}


- (NSString *)LS:(NSInteger)i {
    return [LT(i) stringValue];
}


- (NSInteger)mark {
    [_markers addObject:@(_p)];
    return _p;
}


- (void)unmark {
    NSInteger marker = [[_markers lastObject] integerValue];
    [_markers removeLastObject];
    
    [self seek:marker];
}


- (void)seek:(NSInteger)index {
    self.p = index;
}


- (BOOL)isSpeculating {
    return [_markers count] > 0;
}


- (void)sync:(NSInteger)i {
    NSInteger lastNeededIndex = _p + i - 1;
    NSInteger lastFullIndex = [_lookahead count] - 1;
    
    if (lastNeededIndex > lastFullIndex) { // out of tokens ?
        NSInteger n = lastNeededIndex - lastFullIndex; // get n tokens
        [self fill:n];
    }
}


- (void)fill:(NSInteger)n {
    for (NSInteger i = 0; i <= n; ++i) { // <= ?? fetches an extra lookahead tok
        PKToken *tok = [self nextToken];
        [_lookahead addObject:tok];
    }
}


- (PKToken *)nextToken {
    PKToken *tok = nil;
    
    if (_tokenSource) {
        NSAssert(_tokenSource, @"");
        if (_tokenSourceIndex < _tokenSourceCount) {
            tok = [_tokenSource objectAtIndex:_tokenSourceIndex];
            ++self.tokenSourceIndex;
        } else {
            tok = [PKToken EOFToken];
        }
    } else {
        NSAssert(_tokenizer, @"");
        tok = [_tokenizer nextToken];
    }
    
    NSAssert(tok, @"");

    // set token kind
    if (TOKEN_KIND_BUILTIN_INVALID == tok.tokenKind) {
        tok.tokenKind = [self tokenKindForToken:tok];
    }
    
    //NSLog(@"-nextToken: %@", [tok debugDescription]);
    return tok;
}


- (NSInteger)tokenKindForToken:(PKToken *)tok {
    NSString *key = tok.stringValue;
    
    NSInteger x = tok.tokenKind;
    
    if (TOKEN_KIND_BUILTIN_INVALID == x) {
        x = [self tokenKindForString:key];
    
        if (TOKEN_KIND_BUILTIN_INVALID == x) {
            x = tok.tokenType;
        }
    }
    
    return x;
}


- (void)raiseFormat:(NSString *)fmt, ... {
    va_list vargs;
    va_start(vargs, fmt);
    
    NSString *str = [[[NSString alloc] initWithFormat:fmt arguments:vargs] autorelease];
    
    va_end(vargs);
    
    //PKToken *lt = LT(1);
    //NSUInteger lineNum = lt.lineNumber;
    //NSRange r = NSMakeRange(lt.offset, [lt.stringValue length]);

    //_exception.currentName = PEGKitRecognitionSpeculationFailed;
    _exception.currentReason = str;
    //_exception.lineNumber = lineNum;
    //_exception.range = r;
    
    //NSLog(@"%@", str);
    
    // reuse
    @throw _exception;
}


- (void)raiseInRange:(NSRange)r lineNumber:(NSUInteger)lineNum name:(NSString *)name format:(NSString *)fmt, ... {
    va_list vargs;
    va_start(vargs, fmt);
    
    NSString *str = [[[NSString alloc] initWithFormat:fmt arguments:vargs] autorelease];

    va_end(vargs);

    NSAssert(_exception, @"");
    _exception.currentName = name;
    _exception.currentReason = str;
    _exception.lineNumber = lineNum;
    _exception.range = r;
    
    //NSLog(@"%@", str);

    // reuse
    @throw _exception;
}


- (void)raise:(NSString *)msg {
    [self raiseWithName:PEGKitRecognitionRuleMatchFailed message:msg];
}

    
- (void)raiseWithName:(NSString *)name message:(NSString *)msg {
    PKToken *lt = LT(1);
    
    if (lt.isEOF && [_lookahead count]) {
        lt = [_lookahead firstObject];
    }
    
    NSUInteger lineNum = lt.lineNumber;
    //NSAssert(NSNotFound != lineNum, @"");

    NSRange r = NSMakeRange(lt.offset, [lt.stringValue length]);

    id after = @"";
    id found = @"";
    NSString *fmt = @"%@\nLine : %@\n%@%@";

    if (_enableVerboseErrorReporting) {
        fmt = @"%@\nLine : %@\nNear : %@\nFound : %@";
        after = [NSMutableString string];
        NSString *delim = _silentlyConsumesWhitespace ? @"" : @" ";
        
        for (PKToken *tok in [_lookahead reverseObjectEnumerator]) {
            if (tok.lineNumber < lineNum - 1) break;
            if (tok.lineNumber == lineNum) {
                [after insertString:[NSString stringWithFormat:@"%@%@", tok.stringValue, delim] atIndex:0];
            }
        }
        
        found = lt ? lt.stringValue : @"-nothing-";
    }
    
    id lineNumVal = NSNotFound == lineNum ? @"Unknown" : @(lineNum);
    [self raiseInRange:r lineNumber:lineNum name:name format:fmt, msg, lineNumVal, after, found];
}


- (void)pushFollow:(NSInteger)tokenKind {
    NSParameterAssert(TOKEN_KIND_BUILTIN_INVALID != tokenKind);
    if (!_enableAutomaticErrorRecovery) return;
    
    NSAssert(_resyncSet, @"");
    [_resyncSet addObject:@(tokenKind)];
}


- (void)popFollow:(NSInteger)tokenKind {
    NSParameterAssert(TOKEN_KIND_BUILTIN_INVALID != tokenKind);
    if (!_enableAutomaticErrorRecovery) return;

    NSAssert(_resyncSet, @"");
    [_resyncSet removeObject:@(tokenKind)];
}


- (BOOL)resync {
    BOOL result = NO;

    if (_enableAutomaticErrorRecovery) {
        for (;;) {
            //NSLog(@"\n\nLT 1: '%@'\n%@\nla: %@\nresyncSet: %@", LT(1), _assembly, _lookahead, _resyncSet);
            
            PKToken *lt = LT(1);
            
            NSAssert([_resyncSet count], @"");
            result = [_resyncSet containsObject:@(lt.tokenKind)];

            if (result) {
                [self fireDelegateSelector:@selector(parser:didFailToMatch:)];
                break;
            }
            
            if (lt.isEOF) break;

            [self consume:lt];
        }
    }
    
    return result;
}


- (BOOL)predicts:(NSInteger)firstTokenKind, ... {
    NSParameterAssert(firstTokenKind != TOKEN_KIND_BUILTIN_INVALID);
    
    NSInteger la = LA(1);
    
    if ([self lookahead:la predicts:firstTokenKind]) {
        return YES;
    }
    
    BOOL result = NO;
    
    va_list vargs;
    va_start(vargs, firstTokenKind);
    
    int nextTokenKind;
    while ((nextTokenKind = va_arg(vargs, int))) {
        if ([self lookahead:la predicts:nextTokenKind]) {
            result = YES;
            break;
        }
    }
    
    va_end(vargs);
    
    return result;
}


- (BOOL)lookahead:(NSInteger)la predicts:(NSInteger)tokenKind {
    BOOL result = NO;
    
    if (TOKEN_KIND_BUILTIN_ANY == tokenKind && la != TOKEN_KIND_BUILTIN_EOF) {
        result = YES;
    } else if (la == tokenKind) {
        result = YES;
    }
    
    return result;
}


- (BOOL)speculate:(PKSSpeculateBlock)block {
    NSParameterAssert(block);
    
    BOOL success = YES;
    [self mark];
    
    @try {
        if (block) block();
    }
    @catch (PKRecognitionException *ex) {
        success = NO;
    }
    
    [self unmark];
    return success;
}


- (void)execute:(PKSActionBlock)block {
    NSParameterAssert(block);
    if (self.isSpeculating || !_enableActions) return;

    if (block) block();
}


- (void)tryAndRecover:(NSInteger)tokenKind block:(PKSRecoverBlock)block completion:(PKSRecoverBlock)completion {
    NSParameterAssert(block);
    NSParameterAssert(completion);
    
    [self pushFollow:tokenKind];
    @try {
        block();
    }
    @catch (PKRecognitionException *ex) {
        if ([self resync]) {
            completion();
        } else {
            @throw ex;
        }
    }
    @finally {
        [self popFollow:tokenKind];
    }
}


- (BOOL)test:(PKSPredicateBlock)block {
    NSParameterAssert(block);
    
    BOOL result = YES;
    if (block) result = block();
    return result;
}


- (void)testAndThrow:(PKSPredicateBlock)block {
    NSParameterAssert(block);
    
    if (![self test:block]) {
        [self raiseWithName:PEGKitRecognitionPredicateFailed message:@""];
    }
}


- (void)parseRule:(SEL)ruleSelector withMemo:(NSMutableDictionary *)memoization {
    if (self.isSpeculating && [self alreadyParsedRule:memoization]) return;
    
    BOOL failed = NO;
    NSInteger startTokenIndex = self.p;

    @try { [self performSelector:ruleSelector]; }
    @catch (PKRecognitionException *ex) { failed = YES; @throw ex; }
    @finally {
        if (self.isSpeculating) [self memoize:memoization atIndex:startTokenIndex failed:failed];
    }
}


- (BOOL)alreadyParsedRule:(NSMutableDictionary *)memoization {
    
    id idxKey = @(self.p);
    NSNumber *memoObj = memoization[idxKey];
    if (!memoObj) return NO;
    
    NSInteger memo = [memoObj integerValue];
    if (TD_FAILED == memo) {
        [self raiseFormat:@"already failed prior attempt at start token index %@", idxKey];
    }
    
    [self seek:memo];
    return YES;
}


- (void)memoize:(NSMutableDictionary *)memoization atIndex:(NSInteger)startTokenIndex failed:(BOOL)failed {
    id idxKey = @(startTokenIndex);
    
    NSInteger stopTokenIdex = failed ? TD_FAILED : self.p;
    id idxVal = @(stopTokenIdex);

    memoization[idxKey] = idxVal;
}


- (void)clearMemo {
    
}


- (BOOL)popBool {
    id obj = [_assembly pop];
    return [obj boolValue];
}


- (NSInteger)popInteger {
    id obj = [_assembly pop];
    return [obj integerValue];
}


- (NSUInteger)popUnsignedInteger {
    id obj = [_assembly pop];
    return [obj unsignedIntegerValue];
}


- (float)popFloat {
    id obj = [_assembly pop];
    if ([obj respondsToSelector:@selector(floatValue)]) {
        return [obj floatValue];
    } else {
        return [(PKToken *)obj doubleValue];
    }
}


- (double)popDouble {
    id obj = [_assembly pop];
    if ([obj respondsToSelector:@selector(doubleValue)]) {
        return [obj doubleValue];
    } else {
        return [(PKToken *)obj doubleValue];
    }
}


- (PKToken *)popToken {
    PKToken *tok = [_assembly pop];
    NSAssert([tok isKindOfClass:[PKToken class]], @"");
    return tok;
}


- (NSString *)popString {
    id obj = [_assembly pop];
    if ([obj respondsToSelector:@selector(stringValue)]) {
        return [obj stringValue];
    } else {
        return [obj description];
    }
}


- (NSString *)popQuotedString {
    NSString *str = [self popString];
    return [str stringByTrimmingQuotes];
}


- (void)pushBool:(BOOL)yn {
    [_assembly push:(id)(yn ? kCFBooleanTrue : kCFBooleanFalse)];
}


- (void)pushInteger:(NSInteger)i {
    [_assembly push:[NSNumber numberWithInteger:i]];
}


- (void)pushUnsignedInteger:(NSUInteger)u {
    [_assembly push:[NSNumber numberWithUnsignedInteger:u]];
}


- (void)pushFloat:(float)f {
    [_assembly push:[NSNumber numberWithFloat:f]];
}


- (void)pushDouble:(double)d {
    [_assembly push:[NSNumber numberWithDouble:d]];
}


- (void)pushAll:(NSArray *)a {
    for (id obj in a) {
        [_assembly push:obj];
    }
}


- (NSMutableArray *)reversedArray:(NSArray *)inArray {
    return [inArray reversedMutableArray];
}


- (void)start {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (void)matchEOF:(BOOL)discard {
    [self match:TOKEN_KIND_BUILTIN_EOF discard:discard];
}


- (void)matchAny:(BOOL)discard {
    [self match:TOKEN_KIND_BUILTIN_ANY discard:discard];
}


- (void)matchEmpty:(BOOL)discard {
    NSParameterAssert(!discard);
}


- (void)matchWord:(BOOL)discard {
    [self match:TOKEN_KIND_BUILTIN_WORD discard:discard];
}


- (void)matchNumber:(BOOL)discard {
    [self match:TOKEN_KIND_BUILTIN_NUMBER discard:discard];
}


- (void)matchSymbol:(BOOL)discard {
    [self match:TOKEN_KIND_BUILTIN_SYMBOL discard:discard];
}


- (void)matchComment:(BOOL)discard {
    [self match:TOKEN_KIND_BUILTIN_COMMENT discard:discard];
}


- (void)matchWhitespace:(BOOL)discard {
    [self match:TOKEN_KIND_BUILTIN_WHITESPACE discard:discard];
}


- (void)matchQuotedString:(BOOL)discard {
    [self match:TOKEN_KIND_BUILTIN_QUOTEDSTRING discard:discard];
}


- (void)matchDelimitedString:(BOOL)discard {
    [self match:TOKEN_KIND_BUILTIN_DELIMITEDSTRING discard:discard];
}


- (void)matchURL:(BOOL)discard {
    [self match:TOKEN_KIND_BUILTIN_URL discard:discard];
}


- (void)matchEmail:(BOOL)discard {
    [self match:TOKEN_KIND_BUILTIN_EMAIL discard:discard];
}

@end
