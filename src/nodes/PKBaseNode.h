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
    PKNodeTypeRoot = 0,
    PKNodeTypeDefinition,
    PKNodeTypeReference,
    PKNodeTypeConstant,
    PKNodeTypeLiteral,
    PKNodeTypeDelimited,
    PKNodeTypePattern,
    PKNodeTypeWhitespace,
    PKNodeTypeComposite,
    PKNodeTypeCollection,
    PKNodeTypeAlternation,
    PKNodeTypeOptional,
    PKNodeTypeMultiple,
    PKNodeTypeAction,
} PKNodeType;

@interface PKBaseNode : PKAST
+ (id)nodeWithToken:(PKToken *)tok;

- (void)visit:(id <PGNodeVisitor>)v;

- (void)replaceChild:(PKBaseNode *)oldChild withChild:(PKBaseNode *)newChild;
- (void)replaceChild:(PKBaseNode *)oldChild withChildren:(NSArray *)newChildren;

@property (nonatomic, assign, readonly) BOOL isTerminal;

@property (nonatomic, assign) BOOL discard;
@property (nonatomic, retain) PKActionNode *actionNode;
@property (nonatomic, retain) PKActionNode *semanticPredicateNode;
@property (nonatomic, retain) PKActionNode *before;
@property (nonatomic, retain) PKActionNode *after;
@property (nonatomic, retain) NSString *defName;
@end
