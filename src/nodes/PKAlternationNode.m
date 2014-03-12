//
//  PKAlternationNode.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PKAlternationNode.h"

@implementation PKAlternationNode

- (NSUInteger)type {
    return PKNodeTypeAlternation;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitAlternation:self];
}

@end
