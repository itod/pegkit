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

#import "PKTokenAssembly.h"
#import "PKTokenizer.h"
#import "PKToken.h"

@interface PKTokenAssembly ()
- (id)initWithString:(NSString *)s tokenzier:(PKTokenizer *)t tokenArray:(NSArray *)a;
- (void)tokenize;
- (NSString *)objectsFrom:(NSUInteger)start to:(NSUInteger)end separatedBy:(NSString *)delimiter;

@property (nonatomic, retain) PKTokenizer *tokenizer;
@property (nonatomic, copy) NSArray *tokens;
@property (nonatomic, retain) NSString *string;
@property (nonatomic, assign) NSUInteger index;
@end

@implementation PKTokenAssembly

+ (PKTokenAssembly *)assemblyWithTokenizer:(PKTokenizer *)t {
    return [[[self alloc] initWithTokenzier:t] autorelease];
}


+ (PKTokenAssembly *)assemblyWithTokenArray:(NSArray *)a {
    return [[[self alloc] initWithTokenArray:a] autorelease];
}


+ (PKTokenAssembly *)assemblyWithString:(NSString *)s {
    return (PKTokenAssembly *)[super assemblyWithString:s];
}


- (id)initWithTokenzier:(PKTokenizer *)t {
    return [self initWithString:t.string tokenzier:t tokenArray:nil];
}


- (id)initWithTokenArray:(NSArray *)a {
    return [self initWithString:[a componentsJoinedByString:@""] tokenzier:nil tokenArray:a];
}


- (id)initWithString:(NSString *)s {
    return [self initWithTokenzier:[[[PKTokenizer alloc] initWithString:s] autorelease]];
}


// designated initializer. this method is private and should not be called from other classes
- (id)initWithString:(NSString *)s tokenzier:(PKTokenizer *)t tokenArray:(NSArray *)a {
    self = [super initWithString:s];
    if (self) {
        if (t) {
            self.tokenizer = t;
        } else {
            self.tokens = a;
        }
    }
    return self;
}


- (void)dealloc {
    self.tokenizer = nil;
    self.tokens = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    PKTokenAssembly *a = (PKTokenAssembly *)[super copyWithZone:zone];
    a->_tokenizer = nil; // optimization
    if (_tokens) {
        a->_tokens = [_tokens copyWithZone:zone];
    } else {
        a->_tokens = nil;
    }

    a->_preservesWhitespaceTokens = _preservesWhitespaceTokens;
    return a;
}


- (NSArray *)tokens {
    if (!_tokens) {
        [self tokenize];
    }
    return _tokens;
}


- (id)peek {
    PKToken *tok = nil;
    
    for (;;) {
        if (self.index >= [_tokens count]) {
            tok = nil;
            break;
        }
        
        tok = [_tokens objectAtIndex:self.index];
        if (!_preservesWhitespaceTokens) {
            break;
        }
        if (PKTokenTypeWhitespace == tok.tokenType) {
            [self push:tok];
            self.index++;
        } else {
            break;
        }
    }
    
    return tok;
}


- (id)next {
    id tok = [self peek];
    if (tok) {
        self.index++;
    }
    return tok;
}


- (BOOL)hasMore {
    return (self.index < [_tokens count]);
}


- (NSUInteger)length {
    return [_tokens count];
} 


- (NSUInteger)objectsConsumed {
    return self.index;
}


- (NSUInteger)objectsRemaining {
    return ([_tokens count] - self.index);
}


- (NSString *)consumedObjectsJoinedByString:(NSString *)delimiter {
    NSParameterAssert(delimiter);
    return [self objectsFrom:0 to:self.objectsConsumed separatedBy:delimiter];
}


- (NSString *)remainingObjectsJoinedByString:(NSString *)delimiter {
    NSParameterAssert(delimiter);
    return [self objectsFrom:self.objectsConsumed to:[self length] separatedBy:delimiter];
}


- (NSString *)lastConsumedObjects:(NSUInteger)len joinedByString:(NSString *)delimiter {
    NSParameterAssert(delimiter);
    
    NSUInteger end = self.objectsConsumed;

    len = MIN(end, len);
    NSUInteger loc = end - len;

    NSAssert(loc < [_tokens count], @"");
    NSAssert(len <= [_tokens count], @"");
    NSAssert(loc + len <= [_tokens count], @"");
    
    NSRange r = NSMakeRange(loc, len);
    NSArray *objs = [_tokens subarrayWithRange:r];
    
    NSString *s = [objs componentsJoinedByString:delimiter];
    return s;
}


#pragma mark -
#pragma mark Private

- (void)tokenize {
    if (!_tokenizer) {
        self.tokenizer = [PKTokenizer tokenizerWithString:self.string];
    }
    
    NSMutableArray *a = [NSMutableArray array];
    
    PKToken *eof = [PKToken EOFToken];
    PKToken *tok = nil;
    while ((tok = [_tokenizer nextToken]) != eof) {
        [a addObject:tok];
    }

    self.tokens = a;
}


- (NSString *)objectsFrom:(NSUInteger)start to:(NSUInteger)end separatedBy:(NSString *)delimiter {
    NSParameterAssert(delimiter);
    NSParameterAssert(start <= end);

    NSMutableString *s = [NSMutableString string];

    NSParameterAssert(end <= [_tokens count]);

    for (NSInteger i = start; i < end; i++) {
        PKToken *tok = [_tokens objectAtIndex:i];
        [s appendString:tok.stringValue];
        if (end - 1 != i) {
            [s appendString:delimiter];
        }
    }
    
    return [[s copy] autorelease];
}

@end
