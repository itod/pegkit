//
//  PKCollectionNode.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGCollectionNode.h"
#import <PEGKit/PKToken.h>

@implementation PGCollectionNode

- (NSUInteger)type {
    return PGNodeTypeCollection;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitCollection:self];
}

@end
