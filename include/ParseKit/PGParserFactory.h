//
//  PGParserFactory.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2009 Todd Ditchendorf All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKAST;

typedef enum {
    PGParserFactoryAssemblerSettingBehaviorAll        = 0, // Default
    PGParserFactoryAssemblerSettingBehaviorNone       = 1,
    PGParserFactoryAssemblerSettingBehaviorTerminals  = 2,
    PGParserFactoryAssemblerSettingBehaviorExplicit   = 3,
    PGParserFactoryAssemblerSettingBehaviorSyntax     = 4,
} PGParserFactoryAssemblerSettingBehavior;

@interface PGParserFactory : NSObject

+ (PGParserFactory *)factory;

- (PKAST *)ASTFromGrammar:(NSString *)g error:(NSError **)outError;

@property (nonatomic, assign) PGParserFactoryAssemblerSettingBehavior assemblerSettingBehavior;
@property (nonatomic, assign) BOOL collectTokenKinds;
@end
