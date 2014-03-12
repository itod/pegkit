//
//  PKBaseVisitor.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 3/16/13.
//
//

#import "PGNodeVisitor.h"

// convenience
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

@interface PGBaseVisitor : NSObject <PGNodeVisitor>

- (void)recurse:(PGBaseNode *)node;

@property (nonatomic, retain) PGBaseNode *rootNode;
@property (nonatomic, retain) NSMutableDictionary *symbolTable;
@end
