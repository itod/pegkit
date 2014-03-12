//
//  PKNodeDefinition.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGDefinitionNode.h"
#import <PEGKit/PKToken.h>

@implementation PGDefinitionNode

- (void)dealloc {
    self.callbackName = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    PGDefinitionNode *that = (PGDefinitionNode *)[super copyWithZone:zone];
    that->_callbackName = [_callbackName copyWithZone:zone];
    return that;
}


- (BOOL)isEqual:(id)obj {
    if (![super isEqual:obj]) {
        return NO;
    }
    
    PGDefinitionNode *that = (PGDefinitionNode *)obj;
    
    if (![_callbackName isEqual:that->_callbackName]) {
        return NO;
    }

    return YES;
}


- (NSUInteger)type {
    return PGNodeTypeDefinition;
}


- (NSString *)name {
    NSString *pname = self.token.stringValue;
    NSAssert([pname length], @"");
    
    NSString *str = [NSString stringWithFormat:@"$%@", pname];
    
    if (_callbackName) {
        str = [NSString stringWithFormat:@"%@(%@)", str, _callbackName];
    }
    
    return str;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitDefinition:self];
}


- (BOOL)isTerminal {
    NSAssert2(0, @"%s is an abastract method. Must be overridden in %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return NO;
}

@end
