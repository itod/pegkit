//
//  PKPatternNode.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGPatternNode.h"

@implementation PGPatternNode

- (NSUInteger)type {
    return PGNodeTypePattern;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitPattern:self];
}


- (BOOL)isTerminal {
    return YES;
}

@end
