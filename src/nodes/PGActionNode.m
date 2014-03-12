//
//  PKActionNode.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGActionNode.h"

@implementation PGActionNode

- (id)copyWithZone:(NSZone *)zone {
    PGActionNode *that = (PGActionNode *)[super copyWithZone:zone];
    that->_source = [_source retain];
    return that;
}


- (BOOL)isEqual:(id)obj {
    if (![super isEqual:obj]) {
        return NO;
    }
    
    PGActionNode *that = (PGActionNode *)obj;
    
    if (![_source isEqualToString:that->_source]) {
        return NO;
    }
    
    return YES;
}


- (NSUInteger)type {
    return PGNodeTypeAction;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitAction:self];
}

@end
