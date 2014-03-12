//
//  PKCollectionNode.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PKCollectionNode.h"
#import <PEGKit/PKToken.h>

@implementation PKCollectionNode

- (NSUInteger)type {
    return PKNodeTypeCollection;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitCollection:self];
}

@end
