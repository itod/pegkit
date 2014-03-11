//
//  PKNodeMultiple.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 10/5/12.
//
//

#import "PKMultipleNode.h"

@implementation PKMultipleNode

- (NSUInteger)type {
    return PKNodeTypeMultiple;
}


- (void)visit:(id <PKNodeVisitor>)v; {
    [v visitMultiple:self];
}

@end
