//
//  PKNodeLiteral.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 10/7/12.
//
//

#import "PKLiteralNode.h"

@implementation PKLiteralNode

- (void)dealloc {
    self.tokenKind = nil;
    [super dealloc];
}


- (NSUInteger)type {
    return PKNodeTypeLiteral;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitLiteral:self];
}


- (BOOL)isTerminal {
    return YES;
}

@end
