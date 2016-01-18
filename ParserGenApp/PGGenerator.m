//
//  PGGenerator.m
//  PEGKit
//
//  Created by Ewan Mellor on 7/29/14.
//
//

#import "PGParserGenVisitor.h"
#import "PGRootNode.h"

#import "PGGenerator.h"


@interface PGGenerator ()

@property (nonatomic) PGParserFactory * factory;
@property (nonatomic) PGRootNode * root;
@property (nonatomic) PGParserGenVisitor * visitor;

@end


@implementation PGGenerator


-(instancetype)init {
    self = [super init];
    if (self) {
        _factory = [PGParserFactory factory];
        _factory.collectTokenKinds = YES;

        _visitor = [[PGParserGenVisitor alloc] init];
    }
    return self;
}


-(PGParserFactoryDelegateCallbacksOn)delegatePreMatchCallbacksOn {
    return self.visitor.delegatePreMatchCallbacksOn;
}

-(void)setDelegatePreMatchCallbacksOn:(PGParserFactoryDelegateCallbacksOn)delegatePreMatchCallbacksOn {
    self.visitor.delegatePreMatchCallbacksOn = delegatePreMatchCallbacksOn;
}

-(PGParserFactoryDelegateCallbacksOn)delegatePostMatchCallbacksOn {
    return self.visitor.delegatePostMatchCallbacksOn;
}

-(void)setDelegatePostMatchCallbacksOn:(PGParserFactoryDelegateCallbacksOn)delegatePostMatchCallbacksOn {
    self.visitor.delegatePostMatchCallbacksOn = delegatePostMatchCallbacksOn;
}


-(BOOL)enableARC {
    return self.visitor.enableARC;
}

-(void)setEnableARC:(BOOL)enableARC {
    self.visitor.enableARC = enableARC;
}

-(BOOL)enableAutomaticErrorRecovery {
    return self.visitor.enableAutomaticErrorRecovery;
}

-(void)setEnableAutomaticErrorRecovery:(BOOL)enableAutomaticErrorRecovery {
    self.visitor.enableAutomaticErrorRecovery = enableAutomaticErrorRecovery;
}

-(BOOL)enableHybridDFA {
    return self.visitor.enableHybridDFA;
}

-(void)setEnableHybridDFA:(BOOL)enableHybridDFA {
    self.visitor.enableHybridDFA = enableHybridDFA;
}

-(BOOL)enableMemoization {
    return self.visitor.enableMemoization;
}

-(void)setEnableMemoization:(BOOL)enableMemoization {
    self.visitor.enableMemoization = enableMemoization;
}


-(BOOL)generate {
    assert(self.parserName.length > 0);
    assert(self.destinationPath.length > 0);

    NSString *className = self.parserName;
    if (![className hasSuffix:@"Parser"]) {
        className = [NSString stringWithFormat:@"%@Parser", className];
    }

    NSError *err = nil;
    self.root = (id)[self.factory ASTFromGrammar:self.grammar error:&err];
    if (err) {
        self.error = err;
        return NO;
    }

    if (self.root.startMethodName.length == 0) {
        NSString * msg = NSLocalizedString(@"Failed to find start method", nil);
        self.error = [NSError errorWithDomain:@"PEGKit" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: msg}];
        return NO;
    }

    self.root.grammarName = self.parserName;

    @try {
        [self.root visit:self.visitor];
    }
    @catch (NSException *ex) {
        NSDictionary * userInfo = @{NSLocalizedFailureReasonErrorKey: ex.reason};
        self.error = [NSError errorWithDomain:ex.name code:0 userInfo:userInfo];
        return NO;
    }

    NSString *path = [[NSString stringWithFormat:@"%@/%@.h", self.destinationPath, className] stringByExpandingTildeInPath];
    err = nil;
    BOOL ok = [self.visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!ok) {
        NSString *str = [err.localizedFailureReason stringByAppendingFormat:@"\n\n%@", [path stringByDeletingLastPathComponent]];
        self.error = errorWithReason(err, str);
        return NO;
    }

    path = [[NSString stringWithFormat:@"%@/%@.m", self.destinationPath, className] stringByExpandingTildeInPath];
    err = nil;
    ok = [self.visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!ok) {
        NSString *str = [err.localizedFailureReason stringByAppendingFormat:@"\n\n%@", [path stringByDeletingLastPathComponent]];
        self.error = errorWithReason(err, str);
        return NO;
    }

    return YES;
}


static NSError * errorWithReason(NSError * err, NSString * reason) {
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionaryWithDictionary:err.userInfo];
    userInfo[NSLocalizedFailureReasonErrorKey] = reason;
    return [NSError errorWithDomain:err.domain code:err.code userInfo:userInfo];
}


@end
