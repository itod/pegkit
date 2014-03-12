//
//  PKTokenKindDescriptor.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 3/27/13.
//
//

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
        sEOFDesc = [[PGTokenKindDescriptor descriptorWithStringValue:@"TOKEN_KIND_BUILTIN_EOR" name:@"TOKEN_KIND_BUILTIN_EOF"] retain];
    }
}


+ (PGTokenKindDescriptor *)descriptorWithStringValue:(NSString *)s name:(NSString *)name {
    NSParameterAssert(s);
    NSParameterAssert(name);
    
    PGTokenKindDescriptor *desc = sCache[name];
    
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
