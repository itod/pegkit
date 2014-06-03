#import "PEGKitParser.h"
#import <PEGKit/PEGKit.h>


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

    [self start_]; 
    [self matchEOF:YES]; 

}

- (void)start_ {
    
    while ([self speculate:^{ [self grammarAction_]; }]) {
        [self grammarAction_]; 
    }
    do {
        [self rule_]; 
    } while ([self speculate:^{ [self rule_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)grammarAction_ {
    
    [self match:PEGKIT_TOKEN_KIND_AT discard:YES]; 
    if ([self predicts:PEGKIT_TOKEN_KIND_HKEY, 0]) {
        [self hKey_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_INTERFACEKEY, 0]) {
        [self interfaceKey_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_MKEY, 0]) {
        [self mKey_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_EXTENSIONKEY, 0]) {
        [self extensionKey_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_IVARSKEY, 0]) {
        [self ivarsKey_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_IMPLEMENTATIONKEY, 0]) {
        [self implementationKey_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_INITKEY, 0]) {
        [self initKey_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_DEALLOCKEY, 0]) {
        [self deallocKey_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_BEFOREKEY, 0]) {
        [self beforeKey_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_AFTERKEY, 0]) {
        [self afterKey_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'grammarAction'."];
    }
    [self action_]; 

    [self fireDelegateSelector:@selector(parser:didMatchGrammarAction:)];
}

- (void)hKey_ {
    
    [self match:PEGKIT_TOKEN_KIND_HKEY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchHKey:)];
}

- (void)interfaceKey_ {
    
    [self match:PEGKIT_TOKEN_KIND_INTERFACEKEY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchInterfaceKey:)];
}

- (void)mKey_ {
    
    [self match:PEGKIT_TOKEN_KIND_MKEY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchMKey:)];
}

- (void)extensionKey_ {
    
    [self match:PEGKIT_TOKEN_KIND_EXTENSIONKEY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchExtensionKey:)];
}

- (void)ivarsKey_ {
    
    [self match:PEGKIT_TOKEN_KIND_IVARSKEY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchIvarsKey:)];
}

- (void)implementationKey_ {
    
    [self match:PEGKIT_TOKEN_KIND_IMPLEMENTATIONKEY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchImplementationKey:)];
}

- (void)initKey_ {
    
    [self match:PEGKIT_TOKEN_KIND_INITKEY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchInitKey:)];
}

- (void)deallocKey_ {
    
    [self match:PEGKIT_TOKEN_KIND_DEALLOCKEY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDeallocKey:)];
}

- (void)beforeKey_ {
    
    [self match:PEGKIT_TOKEN_KIND_BEFOREKEY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchBeforeKey:)];
}

- (void)afterKey_ {
    
    [self match:PEGKIT_TOKEN_KIND_AFTERKEY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAfterKey:)];
}

- (void)rule_ {
    
    [self production_]; 
    while ([self speculate:^{ [self namedAction_]; }]) {
        [self namedAction_]; 
    }
    [self match:PEGKIT_TOKEN_KIND_EQUALS discard:NO]; 
    if ([self predicts:PEGKIT_TOKEN_KIND_ACTION, 0]) {
        [self action_]; 
    }
    [self expr_]; 
    [self match:PEGKIT_TOKEN_KIND_SEMI_COLON discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchRule:)];
}

- (void)production_ {
    
    [self varProduction_]; 

    [self fireDelegateSelector:@selector(parser:didMatchProduction:)];
}

- (void)namedAction_ {
    
    [self match:PEGKIT_TOKEN_KIND_AT discard:YES]; 
    if ([self predicts:PEGKIT_TOKEN_KIND_BEFOREKEY, 0]) {
        [self beforeKey_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_AFTERKEY, 0]) {
        [self afterKey_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'namedAction'."];
    }
    [self action_]; 

    [self fireDelegateSelector:@selector(parser:didMatchNamedAction:)];
}

- (void)varProduction_ {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchVarProduction:)];
}

- (void)expr_ {
    
    [self term_]; 
    while ([self speculate:^{ [self orTerm_]; }]) {
        [self orTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)term_ {
    
    if ([self predicts:PEGKIT_TOKEN_KIND_SEMANTICPREDICATE, 0]) {
        [self semanticPredicate_]; 
    }
    [self factor_]; 
    while ([self speculate:^{ [self nextFactor_]; }]) {
        [self nextFactor_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchTerm:)];
}

- (void)orTerm_ {
    
    [self match:PEGKIT_TOKEN_KIND_PIPE discard:NO]; 
    [self term_]; 

    [self fireDelegateSelector:@selector(parser:didMatchOrTerm:)];
}

- (void)factor_ {
    
    [self phrase_]; 
    if ([self predicts:PEGKIT_TOKEN_KIND_PHRASEPLUS, PEGKIT_TOKEN_KIND_PHRASEQUESTION, PEGKIT_TOKEN_KIND_PHRASESTAR, 0]) {
        if ([self predicts:PEGKIT_TOKEN_KIND_PHRASESTAR, 0]) {
            [self phraseStar_]; 
        } else if ([self predicts:PEGKIT_TOKEN_KIND_PHRASEPLUS, 0]) {
            [self phrasePlus_]; 
        } else if ([self predicts:PEGKIT_TOKEN_KIND_PHRASEQUESTION, 0]) {
            [self phraseQuestion_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'factor'."];
        }
    }
    if ([self predicts:PEGKIT_TOKEN_KIND_ACTION, 0]) {
        [self action_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchFactor:)];
}

- (void)nextFactor_ {
    
    [self factor_]; 

    [self fireDelegateSelector:@selector(parser:didMatchNextFactor:)];
}

- (void)phrase_ {
    
    [self primaryExpr_]; 
    while ([self speculate:^{ [self predicate_]; }]) {
        [self predicate_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchPhrase:)];
}

- (void)phraseStar_ {
    
    [self match:PEGKIT_TOKEN_KIND_PHRASESTAR discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchPhraseStar:)];
}

- (void)phrasePlus_ {
    
    [self match:PEGKIT_TOKEN_KIND_PHRASEPLUS discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchPhrasePlus:)];
}

- (void)phraseQuestion_ {
    
    [self match:PEGKIT_TOKEN_KIND_PHRASEQUESTION discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchPhraseQuestion:)];
}

- (void)action_ {
    
    [self match:PEGKIT_TOKEN_KIND_ACTION discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAction:)];
}

- (void)semanticPredicate_ {
    
    [self match:PEGKIT_TOKEN_KIND_SEMANTICPREDICATE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchSemanticPredicate:)];
}

- (void)predicate_ {
    
    if ([self predicts:PEGKIT_TOKEN_KIND_AMPERSAND, 0]) {
        [self intersection_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_MINUS, 0]) {
        [self difference_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'predicate'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPredicate:)];
}

- (void)intersection_ {
    
    [self match:PEGKIT_TOKEN_KIND_AMPERSAND discard:YES]; 
    [self primaryExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchIntersection:)];
}

- (void)difference_ {
    
    [self match:PEGKIT_TOKEN_KIND_MINUS discard:YES]; 
    [self primaryExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchDifference:)];
}

- (void)primaryExpr_ {
    
    if ([self predicts:PEGKIT_TOKEN_KIND_TILDE, 0]) {
        [self negatedPrimaryExpr_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_ANY_TITLE, PEGKIT_TOKEN_KIND_CHAR_TITLE, PEGKIT_TOKEN_KIND_COMMENT_TITLE, PEGKIT_TOKEN_KIND_DELIMOPEN, PEGKIT_TOKEN_KIND_DIGIT_TITLE, PEGKIT_TOKEN_KIND_EMAIL_TITLE, PEGKIT_TOKEN_KIND_EMPTY_TITLE, PEGKIT_TOKEN_KIND_EOF_TITLE, PEGKIT_TOKEN_KIND_LETTER_TITLE, PEGKIT_TOKEN_KIND_NUMBER_TITLE, PEGKIT_TOKEN_KIND_OPEN_BRACKET, PEGKIT_TOKEN_KIND_OPEN_PAREN, PEGKIT_TOKEN_KIND_PATTERNIGNORECASE, PEGKIT_TOKEN_KIND_PATTERNNOOPTS, PEGKIT_TOKEN_KIND_QUOTEDSTRING_TITLE, PEGKIT_TOKEN_KIND_SPECIFICCHAR_TITLE, PEGKIT_TOKEN_KIND_SYMBOL_TITLE, PEGKIT_TOKEN_KIND_S_TITLE, PEGKIT_TOKEN_KIND_URL_TITLE, PEGKIT_TOKEN_KIND_WORD_TITLE, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self barePrimaryExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimaryExpr:)];
}

- (void)negatedPrimaryExpr_ {
    
    [self match:PEGKIT_TOKEN_KIND_TILDE discard:YES]; 
    [self barePrimaryExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchNegatedPrimaryExpr:)];
}

- (void)barePrimaryExpr_ {
    
    if ([self predicts:PEGKIT_TOKEN_KIND_ANY_TITLE, PEGKIT_TOKEN_KIND_CHAR_TITLE, PEGKIT_TOKEN_KIND_COMMENT_TITLE, PEGKIT_TOKEN_KIND_DELIMOPEN, PEGKIT_TOKEN_KIND_DIGIT_TITLE, PEGKIT_TOKEN_KIND_EMAIL_TITLE, PEGKIT_TOKEN_KIND_EMPTY_TITLE, PEGKIT_TOKEN_KIND_EOF_TITLE, PEGKIT_TOKEN_KIND_LETTER_TITLE, PEGKIT_TOKEN_KIND_NUMBER_TITLE, PEGKIT_TOKEN_KIND_PATTERNIGNORECASE, PEGKIT_TOKEN_KIND_PATTERNNOOPTS, PEGKIT_TOKEN_KIND_QUOTEDSTRING_TITLE, PEGKIT_TOKEN_KIND_SPECIFICCHAR_TITLE, PEGKIT_TOKEN_KIND_SYMBOL_TITLE, PEGKIT_TOKEN_KIND_S_TITLE, PEGKIT_TOKEN_KIND_URL_TITLE, PEGKIT_TOKEN_KIND_WORD_TITLE, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self atomicValue_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self subSeqExpr_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [self subTrackExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'barePrimaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBarePrimaryExpr:)];
}

- (void)subSeqExpr_ {
    
    [self match:PEGKIT_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self expr_]; 
    [self match:PEGKIT_TOKEN_KIND_CLOSE_PAREN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchSubSeqExpr:)];
}

- (void)subTrackExpr_ {
    
    [self match:PEGKIT_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    [self expr_]; 
    [self match:PEGKIT_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchSubTrackExpr:)];
}

- (void)atomicValue_ {
    
    [self parser_]; 
    if ([self predicts:PEGKIT_TOKEN_KIND_DISCARD, 0]) {
        [self discard_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAtomicValue:)];
}

- (void)parser_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self variable_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self literal_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_PATTERNIGNORECASE, PEGKIT_TOKEN_KIND_PATTERNNOOPTS, 0]) {
        [self pattern_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_DELIMOPEN, 0]) {
        [self delimitedString_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_ANY_TITLE, PEGKIT_TOKEN_KIND_CHAR_TITLE, PEGKIT_TOKEN_KIND_COMMENT_TITLE, PEGKIT_TOKEN_KIND_DIGIT_TITLE, PEGKIT_TOKEN_KIND_EMAIL_TITLE, PEGKIT_TOKEN_KIND_EMPTY_TITLE, PEGKIT_TOKEN_KIND_EOF_TITLE, PEGKIT_TOKEN_KIND_LETTER_TITLE, PEGKIT_TOKEN_KIND_NUMBER_TITLE, PEGKIT_TOKEN_KIND_QUOTEDSTRING_TITLE, PEGKIT_TOKEN_KIND_SPECIFICCHAR_TITLE, PEGKIT_TOKEN_KIND_SYMBOL_TITLE, PEGKIT_TOKEN_KIND_S_TITLE, PEGKIT_TOKEN_KIND_URL_TITLE, PEGKIT_TOKEN_KIND_WORD_TITLE, 0]) {
        [self constant_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'parser'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchParser:)];
}

- (void)discard_ {
    
    [self match:PEGKIT_TOKEN_KIND_DISCARD discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchDiscard:)];
}

- (void)pattern_ {
    
    if ([self predicts:PEGKIT_TOKEN_KIND_PATTERNNOOPTS, 0]) {
        [self patternNoOpts_]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_PATTERNIGNORECASE, 0]) {
        [self patternIgnoreCase_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'pattern'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPattern:)];
}

- (void)patternNoOpts_ {
    
    [self match:PEGKIT_TOKEN_KIND_PATTERNNOOPTS discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPatternNoOpts:)];
}

- (void)patternIgnoreCase_ {
    
    [self match:PEGKIT_TOKEN_KIND_PATTERNIGNORECASE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPatternIgnoreCase:)];
}

- (void)delimitedString_ {
    
    [self delimOpen_]; 
    [self matchQuotedString:NO]; 
    if ([self speculate:^{ [self match:PEGKIT_TOKEN_KIND_COMMA discard:YES]; [self matchQuotedString:NO]; }]) {
        [self match:PEGKIT_TOKEN_KIND_COMMA discard:YES]; 
        [self matchQuotedString:NO]; 
    }
    [self match:PEGKIT_TOKEN_KIND_CLOSE_CURLY discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchDelimitedString:)];
}

- (void)literal_ {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)constant_ {
    
    if ([self predicts:PEGKIT_TOKEN_KIND_EOF_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_EOF_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_WORD_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_WORD_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_NUMBER_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_NUMBER_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_QUOTEDSTRING_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_QUOTEDSTRING_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_SYMBOL_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_SYMBOL_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_COMMENT_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_COMMENT_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_EMPTY_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_EMPTY_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_ANY_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_ANY_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_S_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_S_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_URL_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_URL_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_EMAIL_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_EMAIL_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_DIGIT_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_DIGIT_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_LETTER_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_LETTER_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_CHAR_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_CHAR_TITLE discard:NO]; 
    } else if ([self predicts:PEGKIT_TOKEN_KIND_SPECIFICCHAR_TITLE, 0]) {
        [self match:PEGKIT_TOKEN_KIND_SPECIFICCHAR_TITLE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'constant'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchConstant:)];
}

- (void)variable_ {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchVariable:)];
}

- (void)delimOpen_ {
    
    [self match:PEGKIT_TOKEN_KIND_DELIMOPEN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDelimOpen:)];
}

@end