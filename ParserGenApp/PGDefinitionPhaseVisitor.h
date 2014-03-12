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

@property (nonatomic, retain) id assembler;
@property (nonatomic, retain) id preassembler;
@property (nonatomic, assign) PGParserFactoryAssemblerSettingBehavior assemblerSettingBehavior;

@property (nonatomic, retain) NSMutableDictionary *tokenKinds;
@property (nonatomic, assign) BOOL collectTokenKinds;
@property (nonatomic, retain) NSMutableDictionary *defaultDefNameTab;
@property (nonatomic, assign) NSUInteger fallbackDefNameCounter;
@end
