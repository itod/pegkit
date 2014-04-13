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

#import "PGTokenKindDescriptor.h"
#import <PEGKit/PKParser.h>

static NSMutableDictionary *sCache = nil;
static PGTokenKindDescriptor *sAnyDesc = nil;
static PGTokenKindDescriptor *sEOFDesc = nil;

@implementation PGTokenKindDescriptor

+ (void)initialize {
    if ([PGTokenKindDescriptor class] == self) {
        sCache = [[NSMutableDictionary alloc] init];
        
        sAnyDesc = [[PGTokenKindDescriptor descriptorWithStringValue:@"TOKEN_KIND_BUILTIN_ANY" name:@"TOKEN_KIND_BUILTIN_ANY"] retain];
        sEOFDesc = [[PGTokenKindDescriptor descriptorWithStringValue:@"TOKEN_KIND_BUILTIN_EOF" name:@"TOKEN_KIND_BUILTIN_EOF"] retain];
    }
}


+ (PGTokenKindDescriptor *)descriptorWithStringValue:(NSString *)s name:(NSString *)name {
    NSParameterAssert(s);
    NSParameterAssert(name);

    // escape double quotes
    s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];

    PGTokenKindDescriptor *desc = sCache[name];

    // This handles cases where the grammar has two literal tokens
    // which differ only in capitalization like `Function` and `function`.
    // This will ensure a unique token kind enum name for both.
    if (desc && ![desc.stringValue isEqualToString:s]) {
        NSString *uniqueName = name;
        NSUInteger i = 0;
        while (desc) {
            ++i;
            uniqueName = [NSString stringWithFormat:@"%@_%lu", name, i];
            desc = sCache[uniqueName];
        }
        name = uniqueName;
    }
    
    if (!desc) {
        desc = [[[PGTokenKindDescriptor alloc] init] autorelease];
        
        desc.stringValue = s;
        desc.name = name;
        
        sCache[name] = desc;
    }
    
    return desc;
}


+ (PGTokenKindDescriptor *)anyDescriptor {
    NSAssert(sAnyDesc, @"");
    return sAnyDesc;
}


+ (PGTokenKindDescriptor *)eofDescriptor {
    NSAssert(sEOFDesc, @"");
    return sEOFDesc;
}


+ (void)clearCache {
    [sCache removeAllObjects];
}


- (void)dealloc {
    self.stringValue = nil;
    self.name = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p '%@' %@>", [self class], self, _stringValue, _name];
}


- (BOOL)isEqual:(id)obj {
    if (![obj isMemberOfClass:[self class]]) {
        return NO;
    }
    
    PGTokenKindDescriptor *that = (PGTokenKindDescriptor *)obj;
    
    if (![_stringValue isEqualToString:that->_stringValue]) {
        return NO;
    }
    
    NSAssert([_name isEqualToString:that->_name], @"if the stringValues match, so should the names");
    
    return YES;
}

@end
