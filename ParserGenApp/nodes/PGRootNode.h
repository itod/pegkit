//
//  PKRootNode.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGBaseNode.h"

@interface PGRootNode : PGBaseNode

@property (nonatomic, retain) NSString *grammarName;
@property (nonatomic, retain) NSString *startMethodName;
@property (nonatomic, retain) NSMutableArray *tokenKinds;
@end
