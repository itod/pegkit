//
//  PKBaseVisitor.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 3/16/13.
//
//

#import "PGBaseVisitor.h"

#import "PGBaseNode.h"
#import "PGRootNode.h"
#import "PGDefinitionNode.h"
#import "PGReferenceNode.h"
#import "PGConstantNode.h"
#import "PGDelimitedNode.h"
#import "PGLiteralNode.h"
#import "PGPatternNode.h"
#import "PGCompositeNode.h"
#import "PGCollectionNode.h"
#import "PGAlternationNode.h"
#import "PGOptionalNode.h"
#import "PGMultipleNode.h"
#import "PGActionNode.h"

@implementation PGBaseVisitor

- (void)dealloc {
    self.rootNode = nil;
    self.symbolTable = nil;
    [super dealloc];
}


- (void)recurse:(PGBaseNode *)node {
    for (PGBaseNode *child in node.children) {
        [child visit:self];
    }
}


- (void)visitRoot:(PGRootNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);

}


- (void)visitDefinition:(PGDefinitionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitReference:(PGReferenceNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitComposite:(PGCompositeNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitCollection:(PGCollectionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitAlternation:(PGAlternationNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitOptional:(PGOptionalNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitMultiple:(PGMultipleNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitConstant:(PGConstantNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitLiteral:(PGLiteralNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitDelimited:(PGDelimitedNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitPattern:(PGPatternNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitAction:(PGActionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}

@end
