#import "GreedyFailureNestedParser.h"
#import <PEGKit/PEGKit.h>


@interface GreedyFailureNestedParser ()

@end

@implementation GreedyFailureNestedParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"structs";
        self.enableAutomaticErrorRecovery = YES;

        self.tokenKindTab[@","] = @(GREEDYFAILURENESTED_TOKEN_KIND_COMMA);
        self.tokenKindTab[@":"] = @(GREEDYFAILURENESTED_TOKEN_KIND_COLON);
        self.tokenKindTab[@"}"] = @(GREEDYFAILURENESTED_TOKEN_KIND_RCURLY);
        self.tokenKindTab[@"{"] = @(GREEDYFAILURENESTED_TOKEN_KIND_LCURLY);

        self.tokenKindNameTab[GREEDYFAILURENESTED_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[GREEDYFAILURENESTED_TOKEN_KIND_COLON] = @":";
        self.tokenKindNameTab[GREEDYFAILURENESTED_TOKEN_KIND_RCURLY] = @"}";
        self.tokenKindNameTab[GREEDYFAILURENESTED_TOKEN_KIND_LCURLY] = @"{";

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
    [self tryAndRecover:GREEDYFAILURENESTED_TOKEN_KIND_RCURLY block:^{ 
        [self pair_]; 
        while ([self speculate:^{ [self comma_]; [self pair_]; }]) {
            [self comma_]; 
            [self pair_]; 
        }
        [self rcurly_]; 
    } completion:^{ 
        [self rcurly_]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchStructure:)];
}

- (void)pair_ {
    
    [self tryAndRecover:GREEDYFAILURENESTED_TOKEN_KIND_COLON block:^{ 
        [self name_]; 
        [self colon_]; 
    } completion:^{ 
        [self colon_]; 
    }];
        [self value_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPair:)];
}

- (void)name_ {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchName:)];
}

- (void)value_ {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchValue:)];
}

- (void)comma_ {
    
    [self match:GREEDYFAILURENESTED_TOKEN_KIND_COMMA discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchComma:)];
}

- (void)lcurly_ {
    
    [self match:GREEDYFAILURENESTED_TOKEN_KIND_LCURLY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLcurly:)];
}

- (void)rcurly_ {
    
    [self match:GREEDYFAILURENESTED_TOKEN_KIND_RCURLY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchRcurly:)];
}

- (void)colon_ {
    
    [self match:GREEDYFAILURENESTED_TOKEN_KIND_COLON discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchColon:)];
}

@end