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
#import <PEGKit/PKTypes.h>

@class PKTokenizer;
@class PKToken;
@class PKTokenizerState;
@class PKNumberState;
@class PKQuoteState;
@class PKCommentState;
@class PKSymbolState;
@class PKWhitespaceState;
@class PKWordState;
@class PKDelimitState;
@class PKURLState;
#if PK_PLATFORM_EMAIL_STATE
@class PKEmailState;
#endif
#if PK_PLATFORM_TWITTER_STATE
@class PKTwitterState;
@class PKHashtagState;
#endif
@class PKReader;

@protocol PKTokenizerDelegate <NSObject>
- (NSInteger)tokenizer:(PKTokenizer *)t tokenKindForStringValue:(NSString *)str;
@end

/*!
    @class      PKTokenizer
    @brief      A tokenizer divides a string into tokens.
    @details    <p>This class is highly customizable with regard to exactly how this division occurs, but it also has defaults that are suitable for many languages. This class assumes that the character values read from the string lie in the range <tt>0-MAXINT</tt>. For example, the Unicode value of a capital A is 65, so <tt>NSLog(@"%C", (unichar)65);</tt> prints out a capital A.</p>
                <p>The behavior of a tokenizer depends on its character state table. This table is an array of 256 <tt>PKTokenizerState</tt> states. The state table decides which state to enter upon reading a character from the input string.</p>
                <p>For example, by default, upon reading an 'A', a tokenizer will enter a "word" state. This means the tokenizer will ask a <tt>PKWordState</tt> object to consume the 'A', along with the characters after the 'A' that form a word. The state's responsibility is to consume characters and return a complete token.</p>
                <p>The default table sets a <tt>PKSymbolState</tt> for every character from 0 to 255, and then overrides this with:</p>
@code
     From     To    State
        0    ' '    whitespaceState
      'a'    'z'    URLState
      'A'    'Z'    URLState
      160    255    wordState
      '0'    '9'    numberState
      '-'    '-'    numberState
      '.'    '.'    numberState
      '@'    '@'    twitterState
      '#'    '#'    hashtagState
      '"'    '"'    quoteState
     '\''   '\''    quoteState
      '/'    '/'    commentState
@endcode
                <p>In addition to allowing modification of the state table, this class makes each of the states above available. Some of these states are customizable. For example, wordState allows customization of what characters can be part of a word, after the first character.</p>
*/
@interface PKTokenizer : NSObject <NSFastEnumeration>

/*!
    @brief      Convenience factory method. Sets string from which to to read to <tt>nil</tt>.
    @result     An initialized tokenizer.
*/
+ (PKTokenizer *)tokenizer;

/*!
    @brief      Convenience factory method.
    @param      s string to read from.
    @result     An autoreleased initialized tokenizer.
*/
+ (PKTokenizer *)tokenizerWithString:(NSString *)s;
+ (PKTokenizer *)tokenizerWithStream:(NSInputStream *)s;

/*!
    @brief      Designated Initializer. Constructs a tokenizer to read from the supplied string.
    @param      s string to read from.
    @result     An initialized tokenizer.
*/
- (instancetype)initWithString:(NSString *)s;
- (instancetype)initWithStream:(NSInputStream *)s;

/*!
    @brief      Returns the next token.
    @result     the next token.
*/
- (PKToken *)nextToken;

/*!
    @brief      Enumerate tokens in this tokenizer using block
    @details    repeatedly executes block by passing the token returned from calling <tt>-nextToken</tt> on this tokenizer
    @param      block the code to execute with every token returned by calling <tt>-nextToken</tt> on this tokenizer
*/
- (void)enumerateTokensUsingBlock:(void (^)(PKToken *tok, BOOL *stop))block;

/*!
    @brief      Change the state the tokenizer will enter upon reading any character between "start" and "end".
    @param      state the state for this character range
    @param      start the "start" character. e.g. <tt>'a'</tt> or <tt>65</tt>.
    @param      end the "end" character. <tt>'z'</tt> or <tt>90</tt>.
*/
- (void)setTokenizerState:(PKTokenizerState *)state from:(PKUniChar)start to:(PKUniChar)end;

/*!
    @property   string
    @brief      The string to read from.
*/
@property (nonatomic, copy) NSString *string;
@property (nonatomic, retain) NSInputStream *stream;

/*!
    @property    numberState
    @brief       The state this tokenizer uses to build numbers.
*/
@property (nonatomic, retain) PKNumberState *numberState;

/*!
    @property   quoteState
    @brief      The state this tokenizer uses to build quoted strings.
*/
@property (nonatomic, retain) PKQuoteState *quoteState;

/*!
    @property   commentState
    @brief      The state this tokenizer uses to recognize (and possibly ignore) comments.
*/
@property (nonatomic, retain) PKCommentState *commentState;

/*!
    @property   symbolState
    @brief      The state this tokenizer uses to recognize symbols.
*/
@property (nonatomic, retain) PKSymbolState *symbolState;

/*!
    @property   whitespaceState
    @brief      The state this tokenizer uses to recognize (and possibly ignore) whitespace.
*/
@property (nonatomic, retain) PKWhitespaceState *whitespaceState;

/*!
    @property   wordState
    @brief      The state this tokenizer uses to build words.
*/
@property (nonatomic, retain) PKWordState *wordState;

/*!
    @property   delimitState
    @brief      The state this tokenizer uses to build delimited strings.
*/
@property (nonatomic, retain) PKDelimitState *delimitState;

@property (nonatomic, retain) PKURLState *URLState;
#if PK_PLATFORM_EMAIL_STATE
@property (nonatomic, retain) PKEmailState *emailState;
#endif
#if PK_PLATFORM_TWITTER_STATE
@property (nonatomic, retain) PKTwitterState *twitterState;
@property (nonatomic, retain) PKHashtagState *hashtagState;
#endif

@property (nonatomic, readonly) NSUInteger lineNumber;
@property (nonatomic, assign) id <PKTokenizerDelegate>delegate;

/*!
    @property   isStreamInUTF8
    @brief      Passthrough to PKReader.isStreamInUTF8.
*/
@property (nonatomic) BOOL isStreamInUTF8;

@end
