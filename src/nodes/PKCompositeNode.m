//
//  PKCompositeNode.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/5/12.
//
//

#import "PKCompositeNode.h"
#import <PEGKit/PKToken.h>

@implementation PKCompositeNode

- (NSUInteger)type {
    return PKNodeTypeComposite;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitComposite:self];
}


- (BOOL)isTerminal {
    return NO;
}

@end
