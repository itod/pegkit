//
//  PKCollectionNode.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PKCollectionNode.h"
#import "PKToken.h"

@implementation PKCollectionNode

- (NSUInteger)type {
    return PKNodeTypeCollection;
}


- (void)visit:(id <PKNodeVisitor>)v; {
    [v visitCollection:self];
}

@end
