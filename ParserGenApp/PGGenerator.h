//
//  PGGenerator.h
//  PEGKit
//
//  Created by Ewan Mellor on 8/1/14.
//
//

#import <Foundation/Foundation.h>

#import "PGParserFactory.h"


@interface PGGenerator : NSObject

@property (nonatomic, strong) NSString * destinationPath;
@property (nonatomic, assign) BOOL enableARC;
@property (nonatomic, assign) BOOL enableAutomaticErrorRecovery;
@property (nonatomic, assign) BOOL enableHybridDFA;
@property (nonatomic, assign) BOOL enableMemoization;
@property (nonatomic, strong) NSString * parserName;
@property (nonatomic, strong) NSString * grammar;
@property (nonatomic, assign) PGParserFactoryDelegateCallbacksOn delegatePreMatchCallbacksOn;
@property (nonatomic, assign) PGParserFactoryDelegateCallbacksOn delegatePostMatchCallbacksOn;

@property (nonatomic, strong) NSError * error;

-(BOOL)generate;

@end
