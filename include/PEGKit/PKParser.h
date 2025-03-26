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

@class PKAssembly;

extern NSString * const PEGKitErrorDomain;
extern NSString * const PEGKitErrorRangeKey;
extern NSString * const PEGKitErrorLineNumberKey;

extern NSInteger PEGKitRecognitionErrorCode;
extern NSString * const PEGKitRecognitionRuleMatchFailed;
extern NSString * const PEGKitRecognitionPredicateFailed;

typedef void (^PKSActionBlock)   (void);
typedef void (^PKSSpeculateBlock)(void);
typedef BOOL (^PKSPredicateBlock)(void);
typedef void (^PKSRecoverBlock)  (void);

enum {
    TOKEN_KIND_BUILTIN_EOF = -1,
    TOKEN_KIND_BUILTIN_INVALID = 0,
    TOKEN_KIND_BUILTIN_NUMBER = 1,
    TOKEN_KIND_BUILTIN_QUOTEDSTRING = 2,
    TOKEN_KIND_BUILTIN_SYMBOL = 3,
    TOKEN_KIND_BUILTIN_WORD = 4,
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


@class PKParser;
@protocol PKParserDelegate <NSObject>

@optional

/**
 * Called just before a grammar rule will be matched.
 *
 * @param rule The name of the rule that will be matched (in sentence case, to match the willMatchFoo callback).
 */
-(void)parser:(PKParser *)parser willMatch:(NSString *)rule;

/**
 * Called after a grammar rule has been matched.
 *
 * @param rule The name of the rule that has been matched (in sentence case, to match the didMatchFoo callback).
 */
-(void)parser:(PKParser *)parser didMatch:(NSString *)rule;

/**
 * Called when the parse fails to match anything.
 */
-(void)parser:(PKParser *)parser didFailToMatch:(PKAssembly *)assembly;

@end


@interface PKParser : NSObject <PKTokenizerDelegate>

/**
 * Designated initializer.
 *
 * @param d This will receive calls to -parser:willMatchFoo: and parser:didMatchFoo:
 * where Foo is the name of the grammar rule that is being matched.  These calls
 * will receive self and self.assembly as parameters.  This delegate may optionally
 * also implement PKParserDelegate and receive calls to -parser:willMatch: and
 * -parser:didMatch:.  All these calls are optional and so the delegate need not
 * implement all of them.
 */
- (instancetype)initWithDelegate:(id)d;

- (id)parseString:(NSString *)input error:(NSError **)outErr;
- (id)parseStream:(NSInputStream *)input error:(NSError **)outErr;
- (id)parseTokens:(NSArray *)input error:(NSError **)outErr;

@property (nonatomic, assign, readonly) id delegate; // weak ref
@property (nonatomic, retain) PKTokenizer *tokenizer;
@property (nonatomic, retain) PKAssembly *assembly;

@property (nonatomic, assign) BOOL silentlyConsumesWhitespace; // default NO
@property (nonatomic, assign) BOOL enableActions; // default YES
@property (nonatomic, assign) BOOL enableAutomaticErrorRecovery; // default NO
@property (nonatomic, assign) BOOL enableVerboseErrorReporting; // default NO
@end
