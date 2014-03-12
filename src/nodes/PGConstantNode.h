//
//  PKNodeTerminal.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGBaseNode.h"

@class PEGTokenKindDescriptor;

@interface PGConstantNode : PGBaseNode

@property (nonatomic, copy) NSString *literal;
@property (nonatomic, retain) PEGTokenKindDescriptor *tokenKind;
@end
