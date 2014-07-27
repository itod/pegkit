// The MIT License (MIT)
// 
// Copyright (c) 2014 Todd Ditchendorf
// Copyright (c) 2014 Ewan Mellor
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

/*
 * isLegalUTF8, UTF8SequenceLength, and readUTF8Sequence are derived
 * from the code detailed below.  They have been modified to use
 * different types and to conform to the newer UTF-8 specification
 * (maximum 4 byte sequences).
 *
 * http://opensource.apple.com/source/JavaScriptCore/JavaScriptCore-7534.57.3/wtf/unicode/UTF8.cpp
 *
 * Copyright (C) 2007 Apple Inc.  All rights reserved.
 * Copyright (C) 2010 Patrick Gansterer <paroga@paroga.com>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE COMPUTER, INC. ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL APPLE COMPUTER, INC. OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <PEGKit/PKReader.h>

@interface PKReader ()
@property (nonatomic) NSUInteger offset;
@property (nonatomic) NSUInteger length;

/*!
    @property   buffer
    @brief      A circular buffer holding the last bufsize characters that were read from self.stream.

    This is used to support [self unread]; by moving backwards through this buffer we can unread characters.
    If self.length == 0, characters are written at self.offset and self.offset is incremented.
    If self.length > 0, characters are read at self.offset and self.offset is incremented and self.length is decremented.
    When a character is unread, self.offset is decremented and self.length is incremented.
    self.offset wraps at 0 and self.bufsize of course.

    This is not used if self.stream is not in use.
 */
@property (nonatomic) PKUniChar * buffer;
@property (nonatomic) NSUInteger bufsize;
@end

@implementation PKReader

- (instancetype)init {
    self = [super init];
    if (self) {
        _bufsize = 256;
    }
    return self;
}


- (instancetype)initWithString:(NSString *)s {
    self = [self init];
    if (self) {
        self.string = s;
    }
    return self;
}


- (instancetype)initWithStream:(NSInputStream *)s {
    self = [self init];
    if (self) {
        self.stream = s;
    }
    return self;
}


- (void)dealloc {
    self.string = nil;
    self.stream = nil;
    free(self.buffer);
    [super dealloc];
}


- (NSString *)debugDescription {
    NSString *buff = [NSString stringWithFormat:@"%@^%@", [_string substringToIndex:_offset], [_string substringFromIndex:_offset]];
    return [NSString stringWithFormat:@"<%@ %p `%@`>", [self class], self, buff];
}


- (void)setString:(NSString *)s {
    NSAssert(!_stream, @"");
    
    if (_string != s) {
        [_string autorelease];
        _string = [s copy];
        self.length = [_string length];
    }
    // reset cursor
    self.offset = 0;
}


- (void)setStream:(NSInputStream *)s {
    NSAssert(!_string, @"");

    if (_stream != s) {
        [_stream autorelease];
        _stream = [s retain];
        _length = NSNotFound;
    }
    // reset cursor
    free(self.buffer);
    self.buffer = malloc(sizeof(PKUniChar) * self.bufsize);
    self.offset = 0;
    self.length = 0;
}


- (PKUniChar)read {
    if (_string) {
        return [self readFromString];
    }
    else {
        if (self.length > 0) {
            return [self popPKUniCharFromBuffer];
        }
        else if (self.isStreamInUTF8) {
            return [self readFromStreamInUTF8];
        }
        else {
            return [self readFromStreamAsBytes];
        }
    }
}


-(PKUniChar)readFromString {
    if (_length && _offset < _length) {
        return [_string characterAtIndex:self.offset++];
    }
    else {
        return PKEOF;
    }
}


-(PKUniChar)readFromStreamInUTF8 {
    UTF32Char ch32 = [self readUTF32Char];
    if (ch32 == (UTF32Char)-1) {
        return PKEOF;
    }

    unichar unichars[2];
    BOOL isPair = CFStringGetSurrogatePairForLongCharacter(ch32, unichars);
    if (isPair) {
        // ch32 is represented by two unichars (two UTF-16 code points).
        // Return the first, and put the second in the buffer and unread it so that
        // it will be returned next time.
        [self addPKUniCharToBuffer:unichars[0]];
        [self addPKUniCharToBuffer:unichars[1]];
        [self unread];
    }
    else {
        [self addPKUniCharToBuffer:unichars[0]];
    }
    return unichars[0];
}


-(PKUniChar)readFromStreamAsBytes {
    PKUniChar result = [self readByte];
    if (result != PKEOF) {
        [self addPKUniCharToBuffer:result];
    }
    return result;
}


-(PKUniChar)readByte {
    uint8_t c;
    if ([self.stream read:&c maxLength:1]) {
        return (PKUniChar)c;
    }
    else {
        return PKEOF;
    }
}


-(UTF32Char)readUTF32Char {
    uint8_t bytes[4];

    NSInteger read = [self.stream read:bytes maxLength:1];
    if (read <= 0) {
        return (UTF32Char)-1;
    }
    size_t seqlen = UTF8SequenceLength(bytes[0]);
    size_t byteCount = 1;

#define LOGGABLE_BYTE(__i) \
    (__i < byteCount ? (unsigned)bytes[__i] : UINT_MAX)
#define LOGGABLE_BYTES \
    LOGGABLE_BYTE(0), LOGGABLE_BYTE(1), LOGGABLE_BYTE(2), LOGGABLE_BYTE(3)

    while (byteCount < seqlen) {
        NSInteger read = [self.stream read:(bytes + byteCount) maxLength:1];
        if (read <= 0) {
            NSLog(@"Invalid UTF-8 sequence %x%x%x%x followed by EOF", LOGGABLE_BYTES);
            return (UTF32Char)-1;
        }
        byteCount++;
    }
    if (isLegalUTF8(bytes, seqlen)) {
        return readUTF8Sequence(bytes, seqlen);
    }
    else {
        NSLog(@"Invalid UTF-8 sequence %x%x%x%x.", LOGGABLE_BYTES);
        return (UTF32Char)-1;
    }

#undef LOGGABLE_BYTE
#undef LOGGABLE_BYTES
}


-(void)addPKUniCharToBuffer:(PKUniChar)ch {
    assert(ch != PKEOF);
    assert(self.length == 0);

    self.buffer[self.offset] = ch;
    self.offset++;
    if (self.offset >= self.bufsize) {
        self.offset = 0;
    }
}


-(PKUniChar)popPKUniCharFromBuffer {
    assert(self.length > 0);

    PKUniChar result = self.buffer[self.offset];
    self.offset++;
    if (self.offset >= self.bufsize) {
        self.offset = 0;
    }
    self.length--;
    return result;
}


- (void)unread {
    if (self.stream) {
        if (self.offset == 0) {
            self.offset = self.bufsize - 1;
        }
        else {
            self.offset--;
        }
        self.length++;
    }
    else {
        self.offset = (0 == _offset) ? 0 : _offset - 1;
    }
}


- (void)unread:(NSUInteger)count {
    for (NSUInteger i = 0; i < count; i++) {
        [self unread];
    }
}


static int UTF8SequenceLength(uint8_t b0) {
    if ((b0 & 0x80) == 0)
        return 1;
    if ((b0 & 0xC0) != 0xC0)
        return 0;
    if ((b0 & 0xE0) == 0xC0)
        return 2;
    if ((b0 & 0xF0) == 0xE0)
        return 3;
    if ((b0 & 0xF8) == 0xF0)
        return 4;
    return 0;
}


// This must be called with the length pre-determined by the first byte (i.e. by UTF8SequenceLength).
// If presented with a length > 4, this returns false.  The Unicode
// definition of UTF-8 goes up to 4-byte sequences.
static bool isLegalUTF8(const uint8_t * source, size_t length) {
    uint8_t a;
    const uint8_t * srcptr = source + length;
    switch (length) {
        default: return false;
            // Everything else falls through when "true"...
        case 4: if ((a = (*--srcptr)) < 0x80 || a > 0xBF) return false;
        case 3: if ((a = (*--srcptr)) < 0x80 || a > 0xBF) return false;
        case 2: if ((a = (*--srcptr)) > 0xBF) return false;

            switch (*source) {
                    // no fall-through in this inner switch
                case 0xE0: if (a < 0xA0) return false; break;
                case 0xED: if (a > 0x9F) return false; break;
                case 0xF0: if (a < 0x90) return false; break;
                case 0xF4: if (a > 0x8F) return false; break;
                default:   if (a < 0x80) return false;
            }

        case 1: if (*source >= 0x80 && *source < 0xC2) return false;
    }
    if (*source > 0xF4)
        return false;
    return true;
}


static const UTF32Char offsetsFromUTF8[4] = { 0x00000000UL, 0x00003080UL, 0x000E2080UL, 0x03C82080UL };

static UTF32Char readUTF8Sequence(const uint8_t * sequence, size_t length) {
    UTF32Char character = 0;

    // The cases all fall through.
    switch (length) {
        case 4: character += *sequence++; character <<= 6;
        case 3: character += *sequence++; character <<= 6;
        case 2: character += *sequence++; character <<= 6;
        case 1: character += *sequence++;
    }

    return character - offsetsFromUTF8[length - 1];
}


@end
