//
//  PKRootNode.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGRootNode.h"

@implementation PGRootNode

- (void)dealloc {
    self.grammarName = nil;
    self.startMethodName = nil;
    self.tokenKinds = nil;
    [super dealloc];
}


- (NSUInteger)type {
    return PGNodeTypeRoot;
}


- (void)visit:(id <PGNodeVisitor>)v {
    [v visitRoot:self];
}

@end
