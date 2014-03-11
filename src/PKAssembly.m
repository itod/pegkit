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

#if PEGKIT
#import <PEGKit/PKAssembly.h>
#else
#import "PKAssembly.h"
#endif

static NSString * const PKAssemblyDefaultDelimiter = @"/";
static NSString * const PKAssemblyDefaultCursor = @"^";

@interface PKAssembly ()
- (id)peek;
- (id)next;
- (BOOL)hasMore;
- (NSString *)consumedObjectsJoinedByString:(NSString *)delimiter;
- (NSString *)remainingObjectsJoinedByString:(NSString *)delimiter;
- (NSString *)lastConsumedObjects:(NSUInteger)len joinedByString:(NSString *)delimiter;

@property (nonatomic, readwrite, retain) NSMutableArray *stack;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) NSString *defaultDelimiter;
@property (nonatomic, retain) NSString *defaultCursor;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSUInteger objectsConsumed;
@property (nonatomic, readonly) NSUInteger objectsRemaining;
@end

@implementation PKAssembly

+ (PKAssembly *)assemblyWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
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


- (void)dealloc {
    self.stack = nil;
    self.string = nil;
    self.target = nil;
    self.defaultDelimiter = nil;
    self.defaultCursor = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    // use of NSAllocateObject() below is a *massive* optimization over calling the designated initializer -initWithString: here.
    // this line (and this method in general) is *vital* to the overall performance of the framework. dont fuck with it.
    PKAssembly *a = NSAllocateObject([self class], 0, zone);
    a->_stack = [_stack mutableCopyWithZone:zone];
    a->_string = [_string retain];

    if (_defaultDelimiter) {
        a->_defaultDelimiter = [_defaultDelimiter retain];
    } else {
        a->_defaultDelimiter = nil;
    }
    
    if (_defaultCursor) {
        a->_defaultCursor = [_defaultCursor retain];
    } else {
        a->_defaultCursor = nil;
    }
    
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
    
    if ([a length] != [self length]) {
        return NO;
    }

    if ([a.stack count] != [_stack count]) {
        return NO;
    }
    
    if (a.objectsConsumed != self.objectsConsumed) {
        return NO;
    }
    
    if (a.objectsRemaining != self.objectsRemaining) {
        return NO;
    }
    
    // this assert will (And should) pass. but it massively slows down performance.
    //NSAssert([[self description] isEqualToString:[a description]], @"");

    // These are cheaper ways (2-step) of acheiving the same check. but are apparently unnecessary.
    //    if (![[self consumedObjectsJoinedByString:@""] isEqualToString:[a consumedObjectsJoinedByString:@""]]) {
    //        return NO;
    //    }
    //    
    //    if (![[self remainingObjectsJoinedByString:@""] isEqualToString:[a remainingObjectsJoinedByString:@""]]) {
    //        return NO;
    //    }
    
    return YES;
}


- (id)next {
    NSAssert1(0, @"%s must be overriden", __PRETTY_FUNCTION__);
    return nil;
}


- (BOOL)hasMore {
    NSAssert1(0, @"%s must be overriden", __PRETTY_FUNCTION__);
    return NO;
}


- (NSString *)consumedObjectsJoinedByString:(NSString *)delimiter {
    NSAssert1(0, @"%s must be overriden", __PRETTY_FUNCTION__);
    return nil;
}


- (NSString *)remainingObjectsJoinedByString:(NSString *)delimiter {
    NSAssert1(0, @"%s must be overriden", __PRETTY_FUNCTION__);
    return nil;
}


- (NSString *)lastConsumedObjects:(NSUInteger)len joinedByString:(NSString *)delimiter {
    NSAssert1(0, @"%s must be overriden", __PRETTY_FUNCTION__);
    return nil;
}


- (NSUInteger)length {
    NSAssert1(0, @"%s must be overriden", __PRETTY_FUNCTION__);
    return 0;
}


- (NSUInteger)objectsConsumed {
    NSAssert1(0, @"%s must be overriden", __PRETTY_FUNCTION__);
    return 0;
}


- (NSUInteger)objectsRemaining {
    NSAssert1(0, @"%s must be overriden", __PRETTY_FUNCTION__);
    return 0;
}


- (id)peek {
    NSAssert1(0, @"%s must be overriden", __PRETTY_FUNCTION__);
    return nil;
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
    [s appendFormat:@"]%@%@%@", [self consumedObjectsJoinedByString:d], c, [self remainingObjectsJoinedByString:d]];
    
    return [[s copy] autorelease];
}

@end
