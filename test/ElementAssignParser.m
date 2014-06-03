#import "ElementAssignParser.h"
#import <PEGKit/PEGKit.h>


@interface ElementAssignParser ()

@end

@implementation ElementAssignParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.enableAutomaticErrorRecovery = YES;

        self.tokenKindTab[@"]"] = @(ELEMENTASSIGN_TOKEN_KIND_RBRACKET);
        self.tokenKindTab[@"["] = @(ELEMENTASSIGN_TOKEN_KIND_LBRACKET);
        self.tokenKindTab[@","] = @(ELEMENTASSIGN_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"="] = @(ELEMENTASSIGN_TOKEN_KIND_EQ);
        self.tokenKindTab[@";"] = @(ELEMENTASSIGN_TOKEN_KIND_SEMI);
        self.tokenKindTab[@"."] = @(ELEMENTASSIGN_TOKEN_KIND_DOT);

        self.tokenKindNameTab[ELEMENTASSIGN_TOKEN_KIND_RBRACKET] = @"]";
        self.tokenKindNameTab[ELEMENTASSIGN_TOKEN_KIND_LBRACKET] = @"[";
        self.tokenKindNameTab[ELEMENTASSIGN_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[ELEMENTASSIGN_TOKEN_KIND_EQ] = @"=";
        self.tokenKindNameTab[ELEMENTASSIGN_TOKEN_KIND_SEMI] = @";";
        self.tokenKindNameTab[ELEMENTASSIGN_TOKEN_KIND_DOT] = @".";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {

    [self tryAndRecover:TOKEN_KIND_BUILTIN_EOF block:^{
        [self start_]; 
        [self matchEOF:YES]; 
    } completion:^{
        [self matchEOF:YES];
    }];

}

- (void)start_ {
    
    do {
        [self stat_]; 
    } while ([self speculate:^{ [self stat_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)stat_ {
    
    if ([self speculate:^{ [self tryAndRecover:ELEMENTASSIGN_TOKEN_KIND_DOT block:^{ [self assign_]; [self dot_]; } completion:^{ [self dot_]; }];}]) {
        [self tryAndRecover:ELEMENTASSIGN_TOKEN_KIND_DOT block:^{ 
            [self assign_]; 
            [self dot_]; 
        } completion:^{ 
            [self dot_]; 
        }];
    } else if ([self speculate:^{ [self tryAndRecover:ELEMENTASSIGN_TOKEN_KIND_SEMI block:^{ [self list_]; [self semi_]; } completion:^{ [self semi_]; }];}]) {
        [self tryAndRecover:ELEMENTASSIGN_TOKEN_KIND_SEMI block:^{ 
            [self list_]; 
            [self semi_]; 
        } completion:^{ 
            [self semi_]; 
        }];
    } else {
        [self raise:@"No viable alternative found in rule 'stat'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStat:)];
}

- (void)assign_ {
    
    [self tryAndRecover:ELEMENTASSIGN_TOKEN_KIND_EQ block:^{ 
        [self list_]; 
        [self eq_]; 
    } completion:^{ 
        [self eq_]; 
    }];
        [self list_]; 

    [self fireDelegateSelector:@selector(parser:didMatchAssign:)];
}

- (void)list_ {
    
    [self lbracket_]; 
    [self tryAndRecover:ELEMENTASSIGN_TOKEN_KIND_RBRACKET block:^{ 
        [self elements_]; 
        [self rbracket_]; 
    } completion:^{ 
        [self rbracket_]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchList:)];
}

- (void)elements_ {
    
    [self element_]; 
    while ([self speculate:^{ [self comma_]; [self element_]; }]) {
        [self comma_]; 
        [self element_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchElements:)];
}

- (void)element_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self matchNumber:NO]; 
    } else if ([self predicts:ELEMENTASSIGN_TOKEN_KIND_LBRACKET, 0]) {
        [self list_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'element'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchElement:)];
}

- (void)lbracket_ {
    
    [self match:ELEMENTASSIGN_TOKEN_KIND_LBRACKET discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLbracket:)];
}

- (void)rbracket_ {
    
    [self match:ELEMENTASSIGN_TOKEN_KIND_RBRACKET discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchRbracket:)];
}

- (void)comma_ {
    
    [self match:ELEMENTASSIGN_TOKEN_KIND_COMMA discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchComma:)];
}

- (void)eq_ {
    
    [self match:ELEMENTASSIGN_TOKEN_KIND_EQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)dot_ {
    
    [self match:ELEMENTASSIGN_TOKEN_KIND_DOT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDot:)];
}

- (void)semi_ {
    
    [self match:ELEMENTASSIGN_TOKEN_KIND_SEMI discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchSemi:)];
}

@end