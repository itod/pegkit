//
//  PKAlternationNode.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGAlternationNode.h"

@implementation PGAlternationNode

- (NSUInteger)type {
    return PGNodeTypeAlternation;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitAlternation:self];
}

@end
