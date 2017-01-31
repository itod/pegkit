#import "ElementAssignParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


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
    PKParser_weakSelfDecl;

    [self tryAndRecover:TOKEN_KIND_BUILTIN_EOF block:^{
        [PKParser_weakSelf start_];
        [PKParser_weakSelf matchEOF:YES];
    } completion:^{
        [self matchEOF:YES];
    }];

}

- (void)start_ {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf stat_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf stat_];}]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)stat_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [self tryAndRecover:ELEMENTASSIGN_TOKEN_KIND_DOT block:^{ [PKParser_weakSelf assign_];[PKParser_weakSelf dot_];} completion:^{ [PKParser_weakSelf dot_];}];}]) {
        [self tryAndRecover:ELEMENTASSIGN_TOKEN_KIND_DOT block:^{ 
            [PKParser_weakSelf assign_];
            [PKParser_weakSelf dot_];
        } completion:^{ 
            [PKParser_weakSelf dot_];
        }];
    } else if ([PKParser_weakSelf speculate:^{ [self tryAndRecover:ELEMENTASSIGN_TOKEN_KIND_SEMI block:^{ [PKParser_weakSelf list_];[PKParser_weakSelf semi_];} completion:^{ [PKParser_weakSelf semi_];}];}]) {
        [self tryAndRecover:ELEMENTASSIGN_TOKEN_KIND_SEMI block:^{ 
            [PKParser_weakSelf list_];
            [PKParser_weakSelf semi_];
        } completion:^{ 
            [PKParser_weakSelf semi_];
        }];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'stat'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStat:)];
}

- (void)assign_ {
    PKParser_weakSelfDecl;
    [self tryAndRecover:ELEMENTASSIGN_TOKEN_KIND_EQ block:^{ 
        [PKParser_weakSelf list_];
        [PKParser_weakSelf eq_];
    } completion:^{ 
        [PKParser_weakSelf eq_];
    }];
        [PKParser_weakSelf list_];

    [self fireDelegateSelector:@selector(parser:didMatchAssign:)];
}

- (void)list_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf lbracket_];
    [self tryAndRecover:ELEMENTASSIGN_TOKEN_KIND_RBRACKET block:^{ 
        [PKParser_weakSelf elements_];
        [PKParser_weakSelf rbracket_];
    } completion:^{ 
        [PKParser_weakSelf rbracket_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchList:)];
}

- (void)elements_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf element_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf comma_];[PKParser_weakSelf element_];}]) {
        [PKParser_weakSelf comma_];
        [PKParser_weakSelf element_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchElements:)];
}

- (void)element_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [PKParser_weakSelf matchNumber:NO];
    } else if ([PKParser_weakSelf predicts:ELEMENTASSIGN_TOKEN_KIND_LBRACKET, 0]) {
        [PKParser_weakSelf list_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'element'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchElement:)];
}

- (void)lbracket_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:ELEMENTASSIGN_TOKEN_KIND_LBRACKET discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchLbracket:)];
}

- (void)rbracket_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:ELEMENTASSIGN_TOKEN_KIND_RBRACKET discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchRbracket:)];
}

- (void)comma_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:ELEMENTASSIGN_TOKEN_KIND_COMMA discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchComma:)];
}

- (void)eq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:ELEMENTASSIGN_TOKEN_KIND_EQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)dot_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:ELEMENTASSIGN_TOKEN_KIND_DOT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchDot:)];
}

- (void)semi_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:ELEMENTASSIGN_TOKEN_KIND_SEMI discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchSemi:)];
}

@end