//
//  PGParserFactory.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2009 Todd Ditchendorf All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKAST;

typedef NS_ENUM(NSUInteger, PGParserFactoryDelegateCallbacksOn) {
    PGParserFactoryDelegateCallbacksOnAll        = 0, // Default
    PGParserFactoryDelegateCallbacksOnNone       = 1,
    PGParserFactoryDelegateCallbacksOnTerminals  = 2,
    PGParserFactoryDelegateCallbacksOnExplicit   = 3,
    PGParserFactoryDelegateCallbacksOnSyntax     = 4,
};

@interface PGParserFactory : NSObject

+ (PGParserFactory *)factory;

- (PKAST *)ASTFromGrammar:(NSString *)g error:(NSError **)outError;

@property (nonatomic, assign) PGParserFactoryDelegateCallbacksOn delegatePostMatchCallbacksOn;
@property (nonatomic, assign) BOOL collectTokenKinds;
@end
