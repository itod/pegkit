#import "GreedyFailureNestedParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


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
    PKParser_weakSelfDecl;

    [self tryAndRecover:TOKEN_KIND_BUILTIN_EOF block:^{
        [PKParser_weakSelf structs_];
        [PKParser_weakSelf matchEOF:YES];
    } completion:^{
        [self matchEOF:YES];
    }];

}

- (void)structs_ {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf structure_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf structure_];}]);

    [self fireDelegateSelector:@selector(parser:didMatchStructs:)];
}

- (void)structure_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf lcurly_];
    [self tryAndRecover:GREEDYFAILURENESTED_TOKEN_KIND_RCURLY block:^{ 
        [PKParser_weakSelf pair_];
        while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf comma_];[PKParser_weakSelf pair_];}]) {
            [PKParser_weakSelf comma_];
            [PKParser_weakSelf pair_];
        }
        [PKParser_weakSelf rcurly_];
    } completion:^{ 
        [PKParser_weakSelf rcurly_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchStructure:)];
}

- (void)pair_ {
    PKParser_weakSelfDecl;
    [self tryAndRecover:GREEDYFAILURENESTED_TOKEN_KIND_COLON block:^{ 
        [PKParser_weakSelf name_];
        [PKParser_weakSelf colon_];
    } completion:^{ 
        [PKParser_weakSelf colon_];
    }];
        [PKParser_weakSelf value_];

    [self fireDelegateSelector:@selector(parser:didMatchPair:)];
}

- (void)name_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchQuotedString:NO];

    [self fireDelegateSelector:@selector(parser:didMatchName:)];
}

- (void)value_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchWord:NO];

    [self fireDelegateSelector:@selector(parser:didMatchValue:)];
}

- (void)comma_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:GREEDYFAILURENESTED_TOKEN_KIND_COMMA discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchComma:)];
}

- (void)lcurly_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:GREEDYFAILURENESTED_TOKEN_KIND_LCURLY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchLcurly:)];
}

- (void)rcurly_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:GREEDYFAILURENESTED_TOKEN_KIND_RCURLY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchRcurly:)];
}

- (void)colon_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:GREEDYFAILURENESTED_TOKEN_KIND_COLON discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchColon:)];
}

@end