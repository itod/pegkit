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

@class PKToken;

@interface PKParser ()

// lookahead
- (PKToken *)LT:(NSInteger)i;
- (NSInteger)LA:(NSInteger)i;
- (double)LD:(NSInteger)i;
- (NSString *)LS:(NSInteger)i;

// parsing control flow
- (void)consume:(PKToken *)tok;
- (BOOL)predicts:(NSInteger)tokenKind, ...;
- (BOOL)speculate:(PKSSpeculateBlock)block;
- (void)match:(NSInteger)tokenKind discard:(BOOL)discard;

// error reporting
- (void)raise:(NSString *)msg;

// builtin token types
- (void)matchEOF:(BOOL)discard;
- (void)matchAny:(BOOL)discard;
- (void)matchEmpty:(BOOL)discard;
- (void)matchWord:(BOOL)discard;
- (void)matchNumber:(BOOL)discard;
- (void)matchSymbol:(BOOL)discard;
- (void)matchComment:(BOOL)discard;
- (void)matchWhitespace:(BOOL)discard;
- (void)matchQuotedString:(BOOL)discard;
- (void)matchDelimitedString:(BOOL)discard;
- (void)matchURL:(BOOL)discard;
- (void)matchEmail:(BOOL)discard;

// semantic predicates
- (BOOL)test:(PKSPredicateBlock)block;
- (void)testAndThrow:(PKSPredicateBlock)block;

// actions
- (void)execute:(PKSActionBlock)block;

// delegate callbacks
- (void)fireDelegateSelector:(SEL)sel;
- (void)fireSyntaxSelector:(SEL)sel withRuleName:(NSString *)ruleName;

// memoization
- (void)parseRule:(SEL)ruleSelector withMemo:(NSMutableDictionary *)memoization;

// error recovery
- (void)tryAndRecover:(NSInteger)tokenKind block:(PKSRecoverBlock)block completion:(PKSRecoverBlock)completion;

// convenience
- (BOOL)popBool;
- (NSInteger)popInteger;
- (NSUInteger)popUnsignedInteger;
- (float)popFloat;
- (double)popDouble;
- (PKToken *)popToken;
- (NSString *)popString;
- (NSString *)popQuotedString;

- (void)pushBool:(BOOL)yn;
- (void)pushInteger:(NSInteger)i;
- (void)pushUnsignedInteger:(NSUInteger)u;
- (void)pushFloat:(float)f;
- (void)pushDouble:(double)d;
- (void)pushAll:(NSArray *)a;

- (NSArray *)reversedArray:(NSArray *)a;

@property (nonatomic, retain) NSMutableDictionary *tokenKindTab;
@property (nonatomic, retain) NSMutableArray *tokenKindNameTab;
@property (nonatomic, retain) NSString *startRuleName;
@property (nonatomic, retain) NSString *statementTerminator;
@property (nonatomic, retain) NSString *singleLineCommentMarker;
@property (nonatomic, retain) NSString *multiLineCommentStartMarker;
@property (nonatomic, retain) NSString *multiLineCommentEndMarker;
@property (nonatomic, retain) NSString *blockStartMarker;
@property (nonatomic, retain) NSString *blockEndMarker;
@property (nonatomic, retain) NSString *braces;
@end

#if __has_feature(objc_arc)
#define PKParser_weakSelfDecl __unused typeof (self) __weak PKParser_weakSelf = self
#else
#define PKParser_weakSelfDecl
#define PKParser_weakSelf self
#endif

#define LT(i) [PKParser_weakSelf LT:(i)]
#define LA(i) [PKParser_weakSelf LA:(i)]
#define LS(i) [PKParser_weakSelf LS:(i)]
#define LD(i) [PKParser_weakSelf LD:(i)]

#define POP()            [PKParser_weakSelf.assembly pop]
#define POP_STR()        [PKParser_weakSelf popString]
#define POP_QUOTED_STR() [PKParser_weakSelf popQuotedString]
#define POP_TOK()        [PKParser_weakSelf popToken]
#define POP_BOOL()       [PKParser_weakSelf popBool]
#define POP_INT()        [PKParser_weakSelf popInteger]
#define POP_UINT()       [PKParser_weakSelf popUnsignedInteger]
#define POP_FLOAT()      [PKParser_weakSelf popFloat]
#define POP_DOUBLE()     [PKParser_weakSelf popDouble]

#define PUSH(obj)      [PKParser_weakSelf.assembly push:(id)(obj)]
#define PUSH_BOOL(yn)  [PKParser_weakSelf pushBool:(BOOL)(yn)]
#define PUSH_INT(i)    [PKParser_weakSelf pushInteger:(NSInteger)(i)]
#define PUSH_UINT(u)   [PKParser_weakSelf pushUnsignedInteger:(NSUInteger)(u)]
#define PUSH_FLOAT(f)  [PKParser_weakSelf pushFloat:(float)(f)]
#define PUSH_DOUBLE(d) [PKParser_weakSelf pushDouble:(double)(d)]
#define PUSH_ALL(a)    [PKParser_weakSelf pushAll:(a)]

#define REV(a) [PKParser_weakSelf reversedArray:a]

#define EQ(a, b) [(a) isEqual:(b)]
#define NE(a, b) (![(a) isEqual:(b)])
#define EQ_IGNORE_CASE(a, b) (NSOrderedSame == [(a) compare:(b)])

#define MATCHES(pattern, str)               ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:0                                  error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)
#define MATCHES_IGNORE_CASE(pattern, str)   ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:NSRegularExpressionCaseInsensitive error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)

#define ABOVE(fence) [PKParser_weakSelf.assembly objectsAbove:(fence)]
#define EMPTY() [PKParser_weakSelf.assembly isStackEmpty]

#define LOG(obj) do { NSLog(@"%@", (obj)); } while (0);
#define PRINT(str) do { printf("%s\n", (str)); } while (0);
#define ASSERT(x) do { NSAssert((x), @""); } while (0);
