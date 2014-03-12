//
//  PKCompositeNode.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/5/12.
//
//

#import "PGCompositeNode.h"
#import <PEGKit/PKToken.h>

@implementation PGCompositeNode

- (NSUInteger)type {
    return PGNodeTypeComposite;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitComposite:self];
}


- (BOOL)isTerminal {
    return NO;
}

@end
