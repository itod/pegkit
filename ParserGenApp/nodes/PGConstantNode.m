//
//  PKNodeTerminal.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGConstantNode.h"
#import <PEGKit/PKToken.h>

@implementation PGConstantNode
- (void)dealloc {
    self.literal = nil;
    self.tokenKind = nil;
    [super dealloc];
}


- (NSUInteger)type {
    return PGNodeTypeConstant;
}


- (NSString *)name {
    NSString *res = nil;
    
    if (_literal) {
        res = [NSString stringWithFormat:@"%@('%@')", self.token.stringValue, _literal];
    } else {
        res = [super name];
    }

    return  res;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitConstant:self];
}


- (BOOL)isTerminal {
    return YES;
}

@end
