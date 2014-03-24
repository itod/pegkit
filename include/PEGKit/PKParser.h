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

#import <Foundation/Foundation.h>
#import <PEGKit/PKTokenizer.h>
#import <PEGKit/PKTokenizer.h>

@class PKToken;
@class PKAssembly;

typedef id   (^PKSActionBlock)   (void);
typedef void (^PKSSpeculateBlock)(void);
typedef BOOL (^PKSPredicateBlock)(void);
typedef void (^PKSRecoverBlock)   (void);

enum {
    TOKEN_KIND_BUILTIN_EOF = -1,
    TOKEN_KIND_BUILTIN_INVALID = 0,
    TOKEN_KIND_BUILTIN_NUMBER = 1,
    TOKEN_KIND_BUILTIN_QUOTEDSTRING = 2,
    TOKEN_KIND_BUILTIN_SYMBOL = 3,
    TOKEN_KIND_BUILTIN_WORD = 4,
    TOKEN_KIND_BUILTIN_LOWERCASEWORD = 4,
    TOKEN_KIND_BUILTIN_UPPERCASEWORD = 4,
    TOKEN_KIND_BUILTIN_WHITESPACE = 5,
    TOKEN_KIND_BUILTIN_COMMENT = 6,
    TOKEN_KIND_BUILTIN_DELIMITEDSTRING = 7,
    TOKEN_KIND_BUILTIN_URL = 8,
    TOKEN_KIND_BUILTIN_EMAIL = 9,
    TOKEN_KIND_BUILTIN_TWITTER = 10,
    TOKEN_KIND_BUILTIN_HASHTAG = 11,
    TOKEN_KIND_BUILTIN_EMPTY = 12,
    TOKEN_KIND_BUILTIN_ANY = 13,
};

@interface PKParser : NSObject <PKTokenizerDelegate>

- (id)initWithDelegate:(id)d; // designated initializer

- (id)parseString:(NSString *)input error:(NSError **)outErr;
- (id)parseStream:(NSInputStream *)input error:(NSError **)outErr;

@property (nonatomic, assign, readonly) id delegate; // weak ref
@property (nonatomic, retain) PKTokenizer *tokenizer;
@property (nonatomic, retain) PKAssembly *assembly;

@property (nonatomic, assign) BOOL silentlyConsumesWhitespace; // default NO
@property (nonatomic, assign) BOOL enableActions; // default YES
@property (nonatomic, assign) BOOL enableAutomaticErrorRecovery; // default NO
@end

@interface PKParser (Subclass)

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
- (id)execute:(PKSActionBlock)block;

// delegate callbacks
- (void)fireDelegateSelector:(SEL)sel;

// memoization
- (void)parseRule:(SEL)ruleSelector withMemo:(NSMutableDictionary *)memoization;

// error recovery
- (void)tryAndRecover:(NSInteger)tokenKind block:(PKSRecoverBlock)block completion:(PKSRecoverBlock)completion;

@end
