//
//  PKNodeLiteral.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/7/12.
//
//

#import "PGBaseNode.h"

@class PGTokenKindDescriptor;

@interface PGLiteralNode : PGBaseNode

@property (nonatomic, assign) BOOL wantsCharacters;
@property (nonatomic, retain) PGTokenKindDescriptor *tokenKind;
@end
