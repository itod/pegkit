//
//  PKNodeDelimited.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/5/12.
//
//

#import "PKBaseNode.h"

@class PEGTokenKindDescriptor;

@interface PKDelimitedNode : PKBaseNode
@property (nonatomic, retain) NSString *startMarker;
@property (nonatomic, retain) NSString *endMarker;
@property (nonatomic, retain) PEGTokenKindDescriptor *tokenKind;
@end
