//
//  PKNodeTerminal.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGBaseNode.h"

@class PGTokenKindDescriptor;

@interface PGConstantNode : PGBaseNode

@property (nonatomic, copy) NSString *literal;
@property (nonatomic, retain) PGTokenKindDescriptor *tokenKind;
@end
