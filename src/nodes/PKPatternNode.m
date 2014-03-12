//
//  PKPatternNode.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PKPatternNode.h"

@implementation PKPatternNode

- (NSUInteger)type {
    return PKNodeTypePattern;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitPattern:self];
}


- (BOOL)isTerminal {
    return YES;
}

@end
