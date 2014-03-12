//
//  PKTokenKindDescriptor.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 3/27/13.
//
//

#import "PKTokenKindDescriptor.h"
#import <PEGKit/PKParser.h>

static NSMutableDictionary *sCache = nil;
static PKTokenKindDescriptor *sAnyDesc = nil;
static PKTokenKindDescriptor *sEOFDesc = nil;

@implementation PKTokenKindDescriptor

+ (void)initialize {
    if ([PKTokenKindDescriptor class] == self) {
        sCache = [[NSMutableDictionary alloc] init];
        
        sAnyDesc = [[PKTokenKindDescriptor descriptorWithStringValue:@"TOKEN_KIND_BUILTIN_ANY" name:@"TOKEN_KIND_BUILTIN_ANY"] retain];
        sEOFDesc = [[PKTokenKindDescriptor descriptorWithStringValue:@"TOKEN_KIND_BUILTIN_EOR" name:@"TOKEN_KIND_BUILTIN_EOF"] retain];
    }
}


+ (PKTokenKindDescriptor *)descriptorWithStringValue:(NSString *)s name:(NSString *)name {
    NSParameterAssert(s);
    NSParameterAssert(name);
    
    PKTokenKindDescriptor *desc = sCache[name];
    
    if (!desc) {
        desc = [[[PKTokenKindDescriptor alloc] init] autorelease];
        desc.stringValue = s;
        desc.name = name;
        
        sCache[name] = desc;
    }
    
    return desc;
}


+ (PKTokenKindDescriptor *)anyDescriptor {
    NSAssert(sAnyDesc, @"");
    return sAnyDesc;
}


+ (PKTokenKindDescriptor *)eofDescriptor {
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
    
    PKTokenKindDescriptor *that = (PKTokenKindDescriptor *)obj;
    
    if (![_stringValue isEqualToString:that->_stringValue]) {
        return NO;
    }
    
    NSAssert([_name isEqualToString:that->_name], @"if the stringValues match, so should the names");
    
    return YES;
}

@end
