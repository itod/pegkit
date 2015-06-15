#import "PEGKitParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface PEGKitParser ()

@end

@implementation PEGKitParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"Symbol"] = @(PEGKIT_TOKEN_KIND_SYMBOL_TITLE);
        self.tokenKindTab[@"{,}?"] = @(PEGKIT_TOKEN_KIND_SEMANTICPREDICATE);
        self.tokenKindTab[@"|"] = @(PEGKIT_TOKEN_KIND_PIPE);
        self.tokenKindTab[@"after"] = @(PEGKIT_TOKEN_KIND_AFTERKEY);
        self.tokenKindTab[@"}"] = @(PEGKIT_TOKEN_KIND_CLOSE_CURLY);
        self.tokenKindTab[@"~"] = @(PEGKIT_TOKEN_KIND_TILDE);
        self.tokenKindTab[@"Email"] = @(PEGKIT_TOKEN_KIND_EMAIL_TITLE);
        self.tokenKindTab[@"Comment"] = @(PEGKIT_TOKEN_KIND_COMMENT_TITLE);
        self.tokenKindTab[@"!"] = @(PEGKIT_TOKEN_KIND_DISCARD);
        self.tokenKindTab[@"init"] = @(PEGKIT_TOKEN_KIND_INITKEY);
        self.tokenKindTab[@"h"] = @(PEGKIT_TOKEN_KIND_HKEY);
        self.tokenKindTab[@"Number"] = @(PEGKIT_TOKEN_KIND_NUMBER_TITLE);
        self.tokenKindTab[@"Any"] = @(PEGKIT_TOKEN_KIND_ANY_TITLE);
        self.tokenKindTab[@";"] = @(PEGKIT_TOKEN_KIND_SEMI_COLON);
        self.tokenKindTab[@"S"] = @(PEGKIT_TOKEN_KIND_S_TITLE);
        self.tokenKindTab[@"{,}"] = @(PEGKIT_TOKEN_KIND_ACTION);
        self.tokenKindTab[@"="] = @(PEGKIT_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"&"] = @(PEGKIT_TOKEN_KIND_AMPERSAND);
        self.tokenKindTab[@"/,/"] = @(PEGKIT_TOKEN_KIND_PATTERNNOOPTS);
        self.tokenKindTab[@"m"] = @(PEGKIT_TOKEN_KIND_MKEY);
        self.tokenKindTab[@"?"] = @(PEGKIT_TOKEN_KIND_PHRASEQUESTION);
        self.tokenKindTab[@"/,/i"] = @(PEGKIT_TOKEN_KIND_PATTERNIGNORECASE);
        self.tokenKindTab[@"("] = @(PEGKIT_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"@"] = @(PEGKIT_TOKEN_KIND_AT);
        self.tokenKindTab[@"QuotedString"] = @(PEGKIT_TOKEN_KIND_QUOTEDSTRING_TITLE);
        self.tokenKindTab[@"before"] = @(PEGKIT_TOKEN_KIND_BEFOREKEY);
        self.tokenKindTab[@"EOF"] = @(PEGKIT_TOKEN_KIND_EOF_TITLE);
        self.tokenKindTab[@")"] = @(PEGKIT_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"*"] = @(PEGKIT_TOKEN_KIND_PHRASESTAR);
        self.tokenKindTab[@"URL"] = @(PEGKIT_TOKEN_KIND_URL_TITLE);
        self.tokenKindTab[@"Empty"] = @(PEGKIT_TOKEN_KIND_EMPTY_TITLE);
        self.tokenKindTab[@"+"] = @(PEGKIT_TOKEN_KIND_PHRASEPLUS);
        self.tokenKindTab[@"Letter"] = @(PEGKIT_TOKEN_KIND_LETTER_TITLE);
        self.tokenKindTab[@"["] = @(PEGKIT_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@","] = @(PEGKIT_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"dealloc"] = @(PEGKIT_TOKEN_KIND_DEALLOCKEY);
        self.tokenKindTab[@"-"] = @(PEGKIT_TOKEN_KIND_MINUS);
        self.tokenKindTab[@"Word"] = @(PEGKIT_TOKEN_KIND_WORD_TITLE);
        self.tokenKindTab[@"]"] = @(PEGKIT_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"Char"] = @(PEGKIT_TOKEN_KIND_CHAR_TITLE);
        self.tokenKindTab[@"SpecificChar"] = @(PEGKIT_TOKEN_KIND_SPECIFICCHAR_TITLE);
        self.tokenKindTab[@"extension"] = @(PEGKIT_TOKEN_KIND_EXTENSIONKEY);
        self.tokenKindTab[@"Digit"] = @(PEGKIT_TOKEN_KIND_DIGIT_TITLE);
        self.tokenKindTab[@"interface"] = @(PEGKIT_TOKEN_KIND_INTERFACEKEY);
        self.tokenKindTab[@"implementation"] = @(PEGKIT_TOKEN_KIND_IMPLEMENTATIONKEY);
        self.tokenKindTab[@"ivars"] = @(PEGKIT_TOKEN_KIND_IVARSKEY);
        self.tokenKindTab[@"%{"] = @(PEGKIT_TOKEN_KIND_DELIMOPEN);

        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_SYMBOL_TITLE] = @"Symbol";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_SEMANTICPREDICATE] = @"{,}?";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_PIPE] = @"|";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_AFTERKEY] = @"after";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_TILDE] = @"~";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_EMAIL_TITLE] = @"Email";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_COMMENT_TITLE] = @"Comment";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_DISCARD] = @"!";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_INITKEY] = @"init";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_HKEY] = @"h";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_NUMBER_TITLE] = @"Number";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_ANY_TITLE] = @"Any";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_SEMI_COLON] = @";";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_S_TITLE] = @"S";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_ACTION] = @"{,}";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_AMPERSAND] = @"&";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_PATTERNNOOPTS] = @"/,/";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_MKEY] = @"m";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_PHRASEQUESTION] = @"?";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_PATTERNIGNORECASE] = @"/,/i";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_AT] = @"@";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_QUOTEDSTRING_TITLE] = @"QuotedString";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_BEFOREKEY] = @"before";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_EOF_TITLE] = @"EOF";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_PHRASESTAR] = @"*";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_URL_TITLE] = @"URL";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_EMPTY_TITLE] = @"Empty";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_PHRASEPLUS] = @"+";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_LETTER_TITLE] = @"Letter";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_DEALLOCKEY] = @"dealloc";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_WORD_TITLE] = @"Word";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_CHAR_TITLE] = @"Char";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_SPECIFICCHAR_TITLE] = @"SpecificChar";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_EXTENSIONKEY] = @"extension";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_DIGIT_TITLE] = @"Digit";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_INTERFACEKEY] = @"interface";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_IMPLEMENTATIONKEY] = @"implementation";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_IVARSKEY] = @"ivars";
        self.tokenKindNameTab[PEGKIT_TOKEN_KIND_DELIMOPEN] = @"%{";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    PKParser_weakSelfDecl;

    [PKParser_weakSelf start_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)start_ {
    PKParser_weakSelfDecl;
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf grammarAction_];}]) {
        [PKParser_weakSelf grammarAction_];
    }
    do {
        [PKParser_weakSelf rule_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf rule_];}]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)grammarAction_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_AT discard:YES];
    if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_HKEY, 0]) {
        [PKParser_weakSelf hKey_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_INTERFACEKEY, 0]) {
        [PKParser_weakSelf interfaceKey_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_MKEY, 0]) {
        [PKParser_weakSelf mKey_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_EXTENSIONKEY, 0]) {
        [PKParser_weakSelf extensionKey_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_IVARSKEY, 0]) {
        [PKParser_weakSelf ivarsKey_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_IMPLEMENTATIONKEY, 0]) {
        [PKParser_weakSelf implementationKey_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_INITKEY, 0]) {
        [PKParser_weakSelf initKey_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_DEALLOCKEY, 0]) {
        [PKParser_weakSelf deallocKey_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_BEFOREKEY, 0]) {
        [PKParser_weakSelf beforeKey_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_AFTERKEY, 0]) {
        [PKParser_weakSelf afterKey_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'grammarAction'."];
    }
    [PKParser_weakSelf action_];

    [self fireDelegateSelector:@selector(parser:didMatchGrammarAction:)];
}

- (void)hKey_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_HKEY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchHKey:)];
}

- (void)interfaceKey_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_INTERFACEKEY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchInterfaceKey:)];
}

- (void)mKey_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_MKEY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchMKey:)];
}

- (void)extensionKey_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_EXTENSIONKEY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchExtensionKey:)];
}

- (void)ivarsKey_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_IVARSKEY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchIvarsKey:)];
}

- (void)implementationKey_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_IMPLEMENTATIONKEY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchImplementationKey:)];
}

- (void)initKey_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_INITKEY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchInitKey:)];
}

- (void)deallocKey_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_DEALLOCKEY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchDeallocKey:)];
}

- (void)beforeKey_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_BEFOREKEY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchBeforeKey:)];
}

- (void)afterKey_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_AFTERKEY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchAfterKey:)];
}

- (void)rule_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf production_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf namedAction_];}]) {
        [PKParser_weakSelf namedAction_];
    }
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_EQUALS discard:NO];
    if ([self predicts:PEGKIT_TOKEN_KIND_ACTION, 0]) {
        [PKParser_weakSelf action_];
    }
    [PKParser_weakSelf expr_];
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_SEMI_COLON discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchRule:)];
}

- (void)production_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf varProduction_];

    [self fireDelegateSelector:@selector(parser:didMatchProduction:)];
}

- (void)namedAction_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_AT discard:YES];
    if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_BEFOREKEY, 0]) {
        [PKParser_weakSelf beforeKey_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_AFTERKEY, 0]) {
        [PKParser_weakSelf afterKey_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'namedAction'."];
    }
    [PKParser_weakSelf action_];

    [self fireDelegateSelector:@selector(parser:didMatchNamedAction:)];
}

- (void)varProduction_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchWord:NO];

    [self fireDelegateSelector:@selector(parser:didMatchVarProduction:)];
}

- (void)expr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf term_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf orTerm_];}]) {
        [PKParser_weakSelf orTerm_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)term_ {
    PKParser_weakSelfDecl;
    if ([self predicts:PEGKIT_TOKEN_KIND_SEMANTICPREDICATE, 0]) {
        [PKParser_weakSelf semanticPredicate_];
    }
    [PKParser_weakSelf factor_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf nextFactor_];}]) {
        [PKParser_weakSelf nextFactor_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchTerm:)];
}

- (void)orTerm_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_PIPE discard:NO];
    [PKParser_weakSelf term_];

    [self fireDelegateSelector:@selector(parser:didMatchOrTerm:)];
}

- (void)factor_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf phrase_];
    if ([self predicts:PEGKIT_TOKEN_KIND_PHRASEPLUS, PEGKIT_TOKEN_KIND_PHRASEQUESTION, PEGKIT_TOKEN_KIND_PHRASESTAR, 0]) {
        if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_PHRASESTAR, 0]) {
            [PKParser_weakSelf phraseStar_];
        } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_PHRASEPLUS, 0]) {
            [PKParser_weakSelf phrasePlus_];
        } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_PHRASEQUESTION, 0]) {
            [PKParser_weakSelf phraseQuestion_];
        } else {
            [PKParser_weakSelf raise:@"No viable alternative found in rule 'factor'."];
        }
    }
    if ([self predicts:PEGKIT_TOKEN_KIND_ACTION, 0]) {
        [PKParser_weakSelf action_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchFactor:)];
}

- (void)nextFactor_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf factor_];

    [self fireDelegateSelector:@selector(parser:didMatchNextFactor:)];
}

- (void)phrase_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf primaryExpr_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf predicate_];}]) {
        [PKParser_weakSelf predicate_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPhrase:)];
}

- (void)phraseStar_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_PHRASESTAR discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchPhraseStar:)];
}

- (void)phrasePlus_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_PHRASEPLUS discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchPhrasePlus:)];
}

- (void)phraseQuestion_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_PHRASEQUESTION discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchPhraseQuestion:)];
}

- (void)action_ {
    PKParser_weakSelfDecl;
    [self match:PEGKIT_TOKEN_KIND_ACTION discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAction:)];
}

- (void)semanticPredicate_ {
    PKParser_weakSelfDecl;
    [self match:PEGKIT_TOKEN_KIND_SEMANTICPREDICATE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchSemanticPredicate:)];
}

- (void)predicate_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_AMPERSAND, 0]) {
        [PKParser_weakSelf intersection_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_MINUS, 0]) {
        [PKParser_weakSelf difference_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'predicate'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPredicate:)];
}

- (void)intersection_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_AMPERSAND discard:YES];
    [PKParser_weakSelf primaryExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchIntersection:)];
}

- (void)difference_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_MINUS discard:YES];
    [PKParser_weakSelf primaryExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchDifference:)];
}

- (void)primaryExpr_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_TILDE, 0]) {
        [PKParser_weakSelf negatedPrimaryExpr_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_ANY_TITLE, PEGKIT_TOKEN_KIND_CHAR_TITLE, PEGKIT_TOKEN_KIND_COMMENT_TITLE, PEGKIT_TOKEN_KIND_DELIMOPEN, PEGKIT_TOKEN_KIND_DIGIT_TITLE, PEGKIT_TOKEN_KIND_EMAIL_TITLE, PEGKIT_TOKEN_KIND_EMPTY_TITLE, PEGKIT_TOKEN_KIND_EOF_TITLE, PEGKIT_TOKEN_KIND_LETTER_TITLE, PEGKIT_TOKEN_KIND_NUMBER_TITLE, PEGKIT_TOKEN_KIND_OPEN_BRACKET, PEGKIT_TOKEN_KIND_OPEN_PAREN, PEGKIT_TOKEN_KIND_PATTERNIGNORECASE, PEGKIT_TOKEN_KIND_PATTERNNOOPTS, PEGKIT_TOKEN_KIND_QUOTEDSTRING_TITLE, PEGKIT_TOKEN_KIND_SPECIFICCHAR_TITLE, PEGKIT_TOKEN_KIND_SYMBOL_TITLE, PEGKIT_TOKEN_KIND_S_TITLE, PEGKIT_TOKEN_KIND_URL_TITLE, PEGKIT_TOKEN_KIND_WORD_TITLE, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf barePrimaryExpr_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'primaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimaryExpr:)];
}

- (void)negatedPrimaryExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_TILDE discard:YES];
    [PKParser_weakSelf barePrimaryExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchNegatedPrimaryExpr:)];
}

- (void)barePrimaryExpr_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_ANY_TITLE, PEGKIT_TOKEN_KIND_CHAR_TITLE, PEGKIT_TOKEN_KIND_COMMENT_TITLE, PEGKIT_TOKEN_KIND_DELIMOPEN, PEGKIT_TOKEN_KIND_DIGIT_TITLE, PEGKIT_TOKEN_KIND_EMAIL_TITLE, PEGKIT_TOKEN_KIND_EMPTY_TITLE, PEGKIT_TOKEN_KIND_EOF_TITLE, PEGKIT_TOKEN_KIND_LETTER_TITLE, PEGKIT_TOKEN_KIND_NUMBER_TITLE, PEGKIT_TOKEN_KIND_PATTERNIGNORECASE, PEGKIT_TOKEN_KIND_PATTERNNOOPTS, PEGKIT_TOKEN_KIND_QUOTEDSTRING_TITLE, PEGKIT_TOKEN_KIND_SPECIFICCHAR_TITLE, PEGKIT_TOKEN_KIND_SYMBOL_TITLE, PEGKIT_TOKEN_KIND_S_TITLE, PEGKIT_TOKEN_KIND_URL_TITLE, PEGKIT_TOKEN_KIND_WORD_TITLE, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf atomicValue_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_OPEN_PAREN, 0]) {
        [PKParser_weakSelf subSeqExpr_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [PKParser_weakSelf subTrackExpr_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'barePrimaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBarePrimaryExpr:)];
}

- (void)subSeqExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_OPEN_PAREN discard:NO];
    [PKParser_weakSelf expr_];
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_CLOSE_PAREN discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchSubSeqExpr:)];
}

- (void)subTrackExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_OPEN_BRACKET discard:NO];
    [PKParser_weakSelf expr_];
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_CLOSE_BRACKET discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchSubTrackExpr:)];
}

- (void)atomicValue_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf parser_];
    if ([self predicts:PEGKIT_TOKEN_KIND_DISCARD, 0]) {
        [PKParser_weakSelf discard_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAtomicValue:)];
}

- (void)parser_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf variable_];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [PKParser_weakSelf literal_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_PATTERNIGNORECASE, PEGKIT_TOKEN_KIND_PATTERNNOOPTS, 0]) {
        [PKParser_weakSelf pattern_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_DELIMOPEN, 0]) {
        [PKParser_weakSelf delimitedString_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_ANY_TITLE, PEGKIT_TOKEN_KIND_CHAR_TITLE, PEGKIT_TOKEN_KIND_COMMENT_TITLE, PEGKIT_TOKEN_KIND_DIGIT_TITLE, PEGKIT_TOKEN_KIND_EMAIL_TITLE, PEGKIT_TOKEN_KIND_EMPTY_TITLE, PEGKIT_TOKEN_KIND_EOF_TITLE, PEGKIT_TOKEN_KIND_LETTER_TITLE, PEGKIT_TOKEN_KIND_NUMBER_TITLE, PEGKIT_TOKEN_KIND_QUOTEDSTRING_TITLE, PEGKIT_TOKEN_KIND_SPECIFICCHAR_TITLE, PEGKIT_TOKEN_KIND_SYMBOL_TITLE, PEGKIT_TOKEN_KIND_S_TITLE, PEGKIT_TOKEN_KIND_URL_TITLE, PEGKIT_TOKEN_KIND_WORD_TITLE, 0]) {
        [PKParser_weakSelf constant_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'parser'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchParser:)];
}

- (void)discard_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_DISCARD discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchDiscard:)];
}

- (void)pattern_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_PATTERNNOOPTS, 0]) {
        [PKParser_weakSelf patternNoOpts_];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_PATTERNIGNORECASE, 0]) {
        [PKParser_weakSelf patternIgnoreCase_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'pattern'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPattern:)];
}

- (void)patternNoOpts_ {
    PKParser_weakSelfDecl;
    [self match:PEGKIT_TOKEN_KIND_PATTERNNOOPTS discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPatternNoOpts:)];
}

- (void)patternIgnoreCase_ {
    PKParser_weakSelfDecl;
    [self match:PEGKIT_TOKEN_KIND_PATTERNIGNORECASE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPatternIgnoreCase:)];
}

- (void)delimitedString_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf delimOpen_];
    [PKParser_weakSelf matchQuotedString:NO];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_COMMA discard:YES];[PKParser_weakSelf matchQuotedString:NO];}]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_COMMA discard:YES];
        [PKParser_weakSelf matchQuotedString:NO];
    }
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_CLOSE_CURLY discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchDelimitedString:)];
}

- (void)literal_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchQuotedString:NO];

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)constant_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_EOF_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_EOF_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_WORD_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_WORD_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_NUMBER_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_NUMBER_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_QUOTEDSTRING_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_QUOTEDSTRING_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_SYMBOL_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_SYMBOL_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_COMMENT_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_COMMENT_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_EMPTY_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_EMPTY_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_ANY_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_ANY_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_S_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_S_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_URL_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_URL_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_EMAIL_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_EMAIL_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_DIGIT_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_DIGIT_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_LETTER_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_LETTER_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_CHAR_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_CHAR_TITLE discard:NO];
    } else if ([PKParser_weakSelf predicts:PEGKIT_TOKEN_KIND_SPECIFICCHAR_TITLE, 0]) {
        [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_SPECIFICCHAR_TITLE discard:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'constant'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchConstant:)];
}

- (void)variable_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchWord:NO];

    [self fireDelegateSelector:@selector(parser:didMatchVariable:)];
}

- (void)delimOpen_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:PEGKIT_TOKEN_KIND_DELIMOPEN discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchDelimOpen:)];
}

@end