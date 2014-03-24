//
//  PKDefinitionPhaseVisitor.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGBaseVisitor.h"
#import "PGParserFactory.h"

@interface PGDefinitionPhaseVisitor : PGBaseVisitor

@property (nonatomic, assign) PGParserFactoryDelegateCallbacksOn delegatePostMatchCallbacksOn;
@property (nonatomic, retain) NSMutableDictionary *tokenKinds;
@property (nonatomic, assign) BOOL collectTokenKinds;
@property (nonatomic, retain) NSMutableDictionary *defaultDefNameTab;
@property (nonatomic, assign) NSUInteger fallbackDefNameCounter;
@end
