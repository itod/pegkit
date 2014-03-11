//  Copyright 2010 Todd Ditchendorf
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <PEGKit/PKReader.h>

@interface PKReader ()
@property (nonatomic) NSUInteger offset;
@property (nonatomic) NSUInteger length;
@end

@implementation PKReader

- (id)init {
    return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
    self = [super init];
    if (self) {
        self.string = s;
    }
    return self;
}


- (id)initWithStream:(NSInputStream *)s {
    self = [super init];
    if (self) {
        self.stream = s;
    }
    return self;
}


- (void)dealloc {
    self.string = nil;
    self.stream = nil;
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
    self.offset = 0;
}


- (PKUniChar)read {
    PKUniChar result = PKEOF;
    
    if (_string) {
        if (_length && _offset < _length) {
            result = [_string characterAtIndex:self.offset++];
        }
    } else {
        NSUInteger maxLen = 1; // 2 for wide char?
        uint8_t c;
        if ([_stream read:&c maxLength:maxLen]) {
            result = (PKUniChar)c;
        }
    }
    
    return result;
}


- (void)unread {
    self.offset = (0 == _offset) ? 0 : _offset - 1;
}


- (void)unread:(NSUInteger)count {
    for (NSUInteger i = 0; i < count; i++) {
        [self unread];
    }
}

@end
