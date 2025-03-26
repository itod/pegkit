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

/*!
    @class      PKReader 
    @brief      A character-stream reader that allows characters to be pushed back into the stream.
*/
@interface PKReader : NSObject

/*!
    @brief      Designated Initializer. Initializes a reader with a given string.
    @details    Designated Initializer.
    @param      s string from which to read
    @result     an initialized reader
*/
- (instancetype)initWithString:(NSString *)s;

/*!
    @brief      Initializes a reader with a given input stream.
    @details    Support for streaming input.
    @param      s stream from which to read
    @result     an initialized reader
*/
- (instancetype)initWithStream:(NSInputStream *)s;

/*!
    @brief      Read a single UTF-16 unicode character
    @result     The character read, or <tt>PKEOF</tt> (-1) if the end of the stream has been reached
*/
- (PKUniChar)read;

/*!
    @brief      Push back a single character
    @details    moves the offset back one position
*/
- (void)unread;

/*!
    @brief      Push back count characters
    @param      count of characters to push back
    @details    moves the offset back count positions
*/
- (void)unread:(NSUInteger)count;

/*!
    @property   string
    @brief      This reader's string.
*/
@property (nonatomic, copy) NSString *string;

/*!
    @property   stream
    @brief      Alternative to using `string`. Support for streaming input.
*/
@property (nonatomic, retain) NSInputStream *stream;

/*!
    @property   offset
    @brief      This reader's current offset in string or the offset from the start of the stream.
*/
@property (nonatomic, readonly) NSUInteger offset;

/*!
    @property   isStreamInUTF8
    @brief      true if self.stream is parsed as UTF-8, with each result from [self read] being a UTF-16 code point.
                false if self.stream is unparsed, with each result from [self read] being a byte from the stream.
 */
@property (nonatomic) BOOL isStreamInUTF8;

- (NSString *)debugDescription;
@end
