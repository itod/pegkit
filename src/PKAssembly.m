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

#import <PEGKit/PKAssembly.h>
#import <PEGKit/PKTokenizer.h>
#import <PEGKit/PKToken.h>

static NSString * const PKAssemblyDefaultDelimiter = @"/";
static NSString * const PKAssemblyDefaultCursor = @"^";

@interface PKAssembly ()
- (NSString *)consumedObjectsJoinedByString:(NSString *)delimiter;
- (NSString *)lastConsumedObjects:(NSUInteger)len joinedByString:(NSString *)delimiter;

@property (nonatomic, readwrite, retain) NSMutableArray *stack;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) NSString *defaultDelimiter;
@property (nonatomic, retain) NSString *defaultCursor;
@property (nonatomic, readonly) NSUInteger objectsConsumed;

- (void)consume:(PKToken *)tok;
@property (nonatomic, retain) PKTokenizer *tokenizer;
@property (nonatomic, retain) NSMutableArray *tokens;
@end

@implementation PKAssembly

+ (PKAssembly *)assemblyWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


+ (PKAssembly *)assemblyWithTokenizer:(PKTokenizer *)t {
    return [[[self alloc] initWithTokenzier:t] autorelease];
}


- (id)init {
    return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
    self = [super init];
    if (self) {
        self.stack = [NSMutableArray array];
        self.string = s;
    }
    return self;
}


- (id)initWithTokenzier:(PKTokenizer *)t {
    self = [self initWithString:nil];
    if (self) {
        self.tokenizer = t;
#if defined(NDEBUG)
        self.gathersConsumedTokens = NO;
        self.defaultCursor = @"";
#else
        self.gathersConsumedTokens = YES;
#endif
    }
    return self;
}


- (void)dealloc {
    self.stack = nil;
    self.string = nil;
    self.target = nil;
    self.defaultDelimiter = nil;
    self.defaultCursor = nil;
    self.tokenizer = nil;
    self.tokens = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    // use of NSAllocateObject() below is a *massive* optimization over calling the designated initializer -initWithString: here.
    // this line (and this method in general) is *vital* to the overall performance of the framework. dont fuck with it.
    PKAssembly *a = NSAllocateObject([self class], 0, zone);
    a->_stack = [_stack mutableCopyWithZone:zone];
    a->_string = [_string retain];
    a->_defaultDelimiter = [_defaultDelimiter retain];
    a->_defaultCursor = [_defaultCursor retain];
    a->_tokenizer = nil; // optimization
    a->_preservesWhitespaceTokens = _preservesWhitespaceTokens;
	a->_tokens = [_tokens mutableCopy];
    
    if (_target) {
        if ([_target conformsToProtocol:@protocol(NSMutableCopying)]) {
            a->_target = [_target mutableCopyWithZone:zone];
        } else {
            a->_target = [_target copyWithZone:zone];
        }
    } else {
        a->_target = nil;
    }

    a->_index = _index;
	
    return a;
}


- (BOOL)isEqual:(id)obj {
    if (![obj isMemberOfClass:[self class]]) {
        return NO;
    }
    
    PKAssembly *a = (PKAssembly *)obj;
    if (a->_index != _index) {
        return NO;
    }
    
    if ([a.stack count] != [_stack count]) {
        return NO;
    }
    
    if (a.objectsConsumed != self.objectsConsumed) {
        return NO;
    }
    
    // this assert will (And should) pass. but it massively slows down performance.
    //NSAssert([[self description] isEqualToString:[a description]], @"");

    // These are cheaper ways (2-step) of acheiving the same check. but are apparently unnecessary.
    //    if (![[self consumedObjectsJoinedByString:@""] isEqualToString:[a consumedObjectsJoinedByString:@""]]) {
    //        return NO;
    //    }
    //    
    return YES;
}


- (void)consume:(PKToken *)tok {
    if (_preservesWhitespaceTokens || !tok.isWhitespace) {
        [self push:tok];
        ++self.index;

        if (_gathersConsumedTokens) {
            if (!_tokens) {
                self.tokens = [NSMutableArray array];
            }
            [_tokens addObject:tok];
        }
    }
}


- (id)pop {
    id result = nil;
    if (![self isStackEmpty]) {
        result = [[[_stack lastObject] retain] autorelease];
        [_stack removeLastObject];
    }
    return result;
}


- (void)push:(id)object {
    if (object) {
        [_stack addObject:object];
    }
}


- (BOOL)isStackEmpty {
    return 0 == [_stack count];
}


- (NSArray *)objectsAbove:(id)fence {
    NSMutableArray *result = [NSMutableArray array];
    
    while (![self isStackEmpty]) {        
        id obj = [self pop];
        
        if ([obj isEqual:fence]) {
            [self push:obj];
            break;
        } else {
            [result addObject:obj];
        }
    }
    
    return result;
}


- (NSString *)description {
    NSMutableString *s = [NSMutableString stringWithString:@"["];
    
    NSUInteger i = 0;
    NSUInteger len = [_stack count];
    
    NSString *fmt = @"%@, ";
    for (id obj in _stack) {
        if (len - 1 == i++) {
            fmt = @"%@";
        }
        [s appendFormat:fmt, obj];
    }

    NSString *d = _defaultDelimiter ? _defaultDelimiter : PKAssemblyDefaultDelimiter;
    NSString *c = _defaultCursor ? _defaultCursor : PKAssemblyDefaultCursor;
    [s appendFormat:@"]%@%@", [self consumedObjectsJoinedByString:d], c];
    
    return [[s copy] autorelease];
}


- (NSUInteger)objectsConsumed {
    return self.index;
}


- (NSString *)consumedObjectsJoinedByString:(NSString *)delimiter {
    NSParameterAssert(delimiter);
    return [self objectsFrom:0 to:self.objectsConsumed separatedBy:delimiter];
}


- (NSString *)lastConsumedObjects:(NSUInteger)len joinedByString:(NSString *)delimiter {
    NSParameterAssert(delimiter);
    
    if (!_gathersConsumedTokens) return @"";

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

- (NSString *)objectsFrom:(NSUInteger)start to:(NSUInteger)end separatedBy:(NSString *)delimiter {
    NSParameterAssert(delimiter);
    NSParameterAssert(start <= end);
    
    if (!_gathersConsumedTokens) return @"";

    NSMutableString *s = [NSMutableString string];

    NSParameterAssert(end <= [_tokens count]);

    for (NSInteger i = start; i < end; i++) {
        PKToken *tok = [_tokens objectAtIndex:i];
        if (PKTokenTypeEOF != tok.tokenType) {
            [s appendString:tok.stringValue];
            if (end - 1 != i) {
                [s appendString:delimiter];
            }
        }
    }
    
    return [[s copy] autorelease];
}

@end
