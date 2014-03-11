//
//  PKPatternNode.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PKPatternNode.h"

@implementation PKPatternNode

- (NSUInteger)type {
    return PKNodeTypePattern;
}


- (void)visit:(id <PKNodeVisitor>)v; {
    [v visitPattern:self];
}


- (BOOL)isTerminal {
    return YES;
}

@end