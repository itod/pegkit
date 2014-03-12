//
//  PKNodeMultiple.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/5/12.
//
//

#import "PGMultipleNode.h"

@implementation PGMultipleNode

- (NSUInteger)type {
    return PGNodeTypeMultiple;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitMultiple:self];
}

@end
