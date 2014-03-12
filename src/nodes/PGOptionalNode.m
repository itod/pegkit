//
//  PKNodeOptional.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/5/12.
//
//

#import "PGOptionalNode.h"

@implementation PGOptionalNode

- (NSUInteger)type {
    return PGNodeTypeOptional;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitOptional:self];
}

@end
