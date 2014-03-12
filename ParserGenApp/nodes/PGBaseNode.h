//
//  PKNode.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PKAST.h"
#import "PGNodeVisitor.h" // convenience

typedef enum NSUInteger {
    PGNodeTypeRoot = 0,
    PGNodeTypeDefinition,
    PGNodeTypeReference,
    PGNodeTypeConstant,
    PGNodeTypeLiteral,
    PGNodeTypeDelimited,
    PGNodeTypePattern,
    PGNodeTypeWhitespace,
    PGNodeTypeComposite,
    PGNodeTypeCollection,
    PGNodeTypeAlternation,
    PGNodeTypeOptional,
    PGNodeTypeMultiple,
    PGNodeTypeAction,
} PGNodeType;

@interface PGBaseNode : PKAST
+ (id)nodeWithToken:(PKToken *)tok;

- (void)visit:(id <PGNodeVisitor>)v;

- (void)replaceChild:(PGBaseNode *)oldChild withChild:(PGBaseNode *)newChild;
- (void)replaceChild:(PGBaseNode *)oldChild withChildren:(NSArray *)newChildren;

@property (nonatomic, assign, readonly) BOOL isTerminal;

@property (nonatomic, assign) BOOL discard;
@property (nonatomic, retain) PGActionNode *actionNode;
@property (nonatomic, retain) PGActionNode *semanticPredicateNode;
@property (nonatomic, retain) PGActionNode *before;
@property (nonatomic, retain) PGActionNode *after;
@property (nonatomic, retain) NSString *defName;
@end
