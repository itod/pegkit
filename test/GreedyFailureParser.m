#import "GreedyFailureParser.h"
#import <PEGKit/PEGKit.h>


@interface GreedyFailureParser ()

@end

@implementation GreedyFailureParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"structs";
        self.enableAutomaticErrorRecovery = YES;

        self.tokenKindTab[@"{"] = @(GREEDYFAILURE_TOKEN_KIND_LCURLY);
        self.tokenKindTab[@"}"] = @(GREEDYFAILURE_TOKEN_KIND_RCURLY);
        self.tokenKindTab[@":"] = @(GREEDYFAILURE_TOKEN_KIND_COLON);

        self.tokenKindNameTab[GREEDYFAILURE_TOKEN_KIND_LCURLY] = @"{";
        self.tokenKindNameTab[GREEDYFAILURE_TOKEN_KIND_RCURLY] = @"}";
        self.tokenKindNameTab[GREEDYFAILURE_TOKEN_KIND_COLON] = @":";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {

    [self tryAndRecover:TOKEN_KIND_BUILTIN_EOF block:^{
        [self structs_]; 
        [self matchEOF:YES]; 
    } completion:^{
        [self matchEOF:YES];
    }];

}

- (void)structs_ {
    
    do {
        [self structure_]; 
    } while ([self speculate:^{ [self structure_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchStructs:)];
}

- (void)structure_ {
    
    [self lcurly_]; 
    [self tryAndRecover:GREEDYFAILURE_TOKEN_KIND_COLON block:^{ 
        [self name_]; 
        [self colon_]; 
    } completion:^{ 
        [self colon_]; 
    }];
    [self tryAndRecover:GREEDYFAILURE_TOKEN_KIND_RCURLY block:^{ 
        [self value_]; 
        [self rcurly_]; 
    } completion:^{ 
        [self rcurly_]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchStructure:)];
}

- (void)name_ {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchName:)];
}

- (void)value_ {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchValue:)];
}

- (void)lcurly_ {
    
    [self match:GREEDYFAILURE_TOKEN_KIND_LCURLY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLcurly:)];
}

- (void)rcurly_ {
    
    [self match:GREEDYFAILURE_TOKEN_KIND_RCURLY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchRcurly:)];
}

- (void)colon_ {
    
    [self match:GREEDYFAILURE_TOKEN_KIND_COLON discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchColon:)];
}

@end