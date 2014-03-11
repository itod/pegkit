//
//  PKCompositeNode.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 10/5/12.
//
//

#import "PKCompositeNode.h"
#import "PKToken.h"

@implementation PKCompositeNode

- (NSUInteger)type {
    return PKNodeTypeComposite;
}


- (void)visit:(id <PKNodeVisitor>)v; {
    [v visitComposite:self];
}


- (BOOL)isTerminal {
    return NO;
}

@end
