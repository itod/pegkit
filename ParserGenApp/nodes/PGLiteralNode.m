//
//  PKNodeLiteral.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/7/12.
//
//

#import "PGLiteralNode.h"

@implementation PGLiteralNode

- (void)dealloc {
    self.tokenKind = nil;
    [super dealloc];
}


- (NSUInteger)type {
    return PGNodeTypeLiteral;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitLiteral:self];
}


- (BOOL)isTerminal {
    return YES;
}

@end
