//
//  PGNodeVisitor.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/7/12.
//
//

#import <Foundation/Foundation.h>

@class PGBaseNode;
@class PGRootNode;
@class PGDefinitionNode;
@class PGReferenceNode;
@class PGConstantNode;
@class PGLiteralNode;
@class PGDelimitedNode;
@class PGPatternNode;
@class PGCompositeNode;
@class PGCollectionNode;
@class PGAlternationNode;
@class PGOptionalNode;
@class PGMultipleNode;
@class PGActionNode;

@protocol PGNodeVisitor <NSObject>
- (void)visitRoot:(PGRootNode *)node;
- (void)visitDefinition:(PGDefinitionNode *)node;
- (void)visitReference:(PGReferenceNode *)node;
- (void)visitConstant:(PGConstantNode *)node;
- (void)visitLiteral:(PGLiteralNode *)node;
- (void)visitDelimited:(PGDelimitedNode *)node;
- (void)visitPattern:(PGPatternNode *)node;
- (void)visitComposite:(PGCompositeNode *)node;
- (void)visitCollection:(PGCollectionNode *)node;
- (void)visitAlternation:(PGAlternationNode *)node;
- (void)visitOptional:(PGOptionalNode *)node;
- (void)visitMultiple:(PGMultipleNode *)node;
- (void)visitAction:(PGActionNode *)node;

@property (nonatomic, retain) PGBaseNode *rootNode;
@end
