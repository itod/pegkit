#import "CrockfordParser.h"
#import <PEGKit/PEGKit.h>


@interface CrockfordParser ()

@end

@implementation CrockfordParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"program";
        self.enableAutomaticErrorRecovery = YES;

        self.tokenKindTab[@"{"] = @(CROCKFORD_TOKEN_KIND_OPEN_CURLY);
        self.tokenKindTab[@">="] = @(CROCKFORD_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@"&&"] = @(CROCKFORD_TOKEN_KIND_DOUBLE_AMPERSAND);
        self.tokenKindTab[@"for"] = @(CROCKFORD_TOKEN_KIND_FOR);
        self.tokenKindTab[@"break"] = @(CROCKFORD_TOKEN_KIND_BREAK);
        self.tokenKindTab[@"}"] = @(CROCKFORD_TOKEN_KIND_CLOSE_CURLY);
        self.tokenKindTab[@"return"] = @(CROCKFORD_TOKEN_KIND_RETURN);
        self.tokenKindTab[@"+="] = @(CROCKFORD_TOKEN_KIND_PLUS_EQUALS);
        self.tokenKindTab[@"function"] = @(CROCKFORD_TOKEN_KIND_FUNCTION);
        self.tokenKindTab[@"if"] = @(CROCKFORD_TOKEN_KIND_IF);
        self.tokenKindTab[@"new"] = @(CROCKFORD_TOKEN_KIND_NEW);
        self.tokenKindTab[@"else"] = @(CROCKFORD_TOKEN_KIND_ELSE);
        self.tokenKindTab[@"!"] = @(CROCKFORD_TOKEN_KIND_BANG);
        self.tokenKindTab[@"finally"] = @(CROCKFORD_TOKEN_KIND_FINALLY);
        self.tokenKindTab[@":"] = @(CROCKFORD_TOKEN_KIND_COLON);
        self.tokenKindTab[@"catch"] = @(CROCKFORD_TOKEN_KIND_CATCH);
        self.tokenKindTab[@";"] = @(CROCKFORD_TOKEN_KIND_SEMI_COLON);
        self.tokenKindTab[@"do"] = @(CROCKFORD_TOKEN_KIND_DO);
        self.tokenKindTab[@"!=="] = @(CROCKFORD_TOKEN_KIND_DOUBLE_NOT_EQUAL);
        self.tokenKindTab[@"<"] = @(CROCKFORD_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"-="] = @(CROCKFORD_TOKEN_KIND_MINUS_EQUALS);
        self.tokenKindTab[@"%"] = @(CROCKFORD_TOKEN_KIND_PERCENT);
        self.tokenKindTab[@"="] = @(CROCKFORD_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"throw"] = @(CROCKFORD_TOKEN_KIND_THROW);
        self.tokenKindTab[@"try"] = @(CROCKFORD_TOKEN_KIND_TRY);
        self.tokenKindTab[@">"] = @(CROCKFORD_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"/,/"] = @(CROCKFORD_TOKEN_KIND_REGEXBODY);
        self.tokenKindTab[@"typeof"] = @(CROCKFORD_TOKEN_KIND_TYPEOF);
        self.tokenKindTab[@"("] = @(CROCKFORD_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"while"] = @(CROCKFORD_TOKEN_KIND_WHILE);
        self.tokenKindTab[@"var"] = @(CROCKFORD_TOKEN_KIND_VAR);
        self.tokenKindTab[@")"] = @(CROCKFORD_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"*"] = @(CROCKFORD_TOKEN_KIND_STAR);
        self.tokenKindTab[@"||"] = @(CROCKFORD_TOKEN_KIND_DOUBLE_PIPE);
        self.tokenKindTab[@"+"] = @(CROCKFORD_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"["] = @(CROCKFORD_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@","] = @(CROCKFORD_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"delete"] = @(CROCKFORD_TOKEN_KIND_DELETE);
        self.tokenKindTab[@"switch"] = @(CROCKFORD_TOKEN_KIND_SWITCH);
        self.tokenKindTab[@"-"] = @(CROCKFORD_TOKEN_KIND_MINUS);
        self.tokenKindTab[@"in"] = @(CROCKFORD_TOKEN_KIND_IN);
        self.tokenKindTab[@"==="] = @(CROCKFORD_TOKEN_KIND_TRIPLE_EQUALS);
        self.tokenKindTab[@"]"] = @(CROCKFORD_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"."] = @(CROCKFORD_TOKEN_KIND_DOT);
        self.tokenKindTab[@"default"] = @(CROCKFORD_TOKEN_KIND_DEFAULT);
        self.tokenKindTab[@"/"] = @(CROCKFORD_TOKEN_KIND_FORWARD_SLASH);
        self.tokenKindTab[@"case"] = @(CROCKFORD_TOKEN_KIND_CASE);
        self.tokenKindTab[@"<="] = @(CROCKFORD_TOKEN_KIND_LE_SYM);

        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_OPEN_CURLY] = @"{";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_GE_SYM] = @">=";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_DOUBLE_AMPERSAND] = @"&&";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_FOR] = @"for";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_BREAK] = @"break";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_RETURN] = @"return";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_PLUS_EQUALS] = @"+=";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_FUNCTION] = @"function";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_IF] = @"if";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_NEW] = @"new";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_ELSE] = @"else";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_BANG] = @"!";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_FINALLY] = @"finally";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_COLON] = @":";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_CATCH] = @"catch";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_SEMI_COLON] = @";";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_DO] = @"do";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_DOUBLE_NOT_EQUAL] = @"!==";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_MINUS_EQUALS] = @"-=";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_PERCENT] = @"%";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_THROW] = @"throw";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_TRY] = @"try";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_REGEXBODY] = @"/,/";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_TYPEOF] = @"typeof";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_WHILE] = @"while";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_VAR] = @"var";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_STAR] = @"*";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_DOUBLE_PIPE] = @"||";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_DELETE] = @"delete";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_SWITCH] = @"switch";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_IN] = @"in";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_TRIPLE_EQUALS] = @"===";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_DEFAULT] = @"default";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_FORWARD_SLASH] = @"/";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_CASE] = @"case";
        self.tokenKindNameTab[CROCKFORD_TOKEN_KIND_LE_SYM] = @"<=";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {

        [self tryAndRecover:TOKEN_KIND_BUILTIN_EOF block:^{
            [self program_]; 
            [self matchEOF:YES]; 
        } completion:^{
            [self matchEOF:YES];
        }];

}

- (void)program_ {
    
    [self execute:^{
    
        PKTokenizer *t = self.tokenizer;
        
        // whitespace
/*		self.silentlyConsumesWhitespace = YES;
		t.whitespaceState.reportsWhitespaceTokens = YES;
		self.assembly.preservesWhitespaceTokens = YES;
*/
        [t.symbolState add:@"||"];
        [t.symbolState add:@"&&"];
        [t.symbolState add:@"!="];
        [t.symbolState add:@"!=="];
        [t.symbolState add:@"=="];
        [t.symbolState add:@"==="];
        [t.symbolState add:@"<="];
        [t.symbolState add:@">="];
        [t.symbolState add:@"++"];
        [t.symbolState add:@"--"];
        [t.symbolState add:@"+="];
        [t.symbolState add:@"-="];
        [t.symbolState add:@"*="];
        [t.symbolState add:@"/="];
        [t.symbolState add:@"%="];
        [t.symbolState add:@"<<"];
        [t.symbolState add:@">>"];
        [t.symbolState add:@">>>"];
        [t.symbolState add:@"<<="];
        [t.symbolState add:@">>="];
        [t.symbolState add:@">>>="];
        [t.symbolState add:@"&="];
        [t.symbolState add:@"^="];
        [t.symbolState add:@"|="];

        // setup comments
        t.commentState.reportsCommentTokens = YES;
        [t setTokenizerState:t.commentState from:'/' to:'/'];
        [t.commentState addSingleLineStartMarker:@"//"];
        [t.commentState addMultiLineStartMarker:@"/*" endMarker:@"*/"];
        
        // comment state should fallback to delimit state to match regex delimited strings
        t.commentState.fallbackState = t.delimitState;
        
        // regex delimited strings
        NSCharacterSet *cs = [[NSCharacterSet newlineCharacterSet] invertedSet];
        [t.delimitState addStartMarker:@"/" endMarker:@"/" allowedCharacterSet:cs];

    }];
    [self stmts_]; 

    [self fireDelegateSelector:@selector(parser:didMatchProgram:)];
}

- (void)arrayLiteral_ {
    
    [self match:CROCKFORD_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_BRACKET block:^{ 
        if ([self speculate:^{ [self expr_]; while ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self expr_]; }]) {[self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self expr_]; }}]) {
            [self expr_]; 
            while ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self expr_]; }]) {
                [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; 
                [self expr_]; 
            }
        }
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_BRACKET discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_BRACKET discard:NO]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchArrayLiteral:)];
}

- (void)block_ {
    
    [self match:CROCKFORD_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_CURLY block:^{ 
        if ([self speculate:^{ [self stmts_]; }]) {
            [self stmts_]; 
        }
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchBlock:)];
}

- (void)breakStmt_ {
    
    [self match:CROCKFORD_TOKEN_KIND_BREAK discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
        if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
            [self name_]; 
        }
        [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchBreakStmt:)];
}

- (void)caseClause_ {
    
    do {
        [self match:CROCKFORD_TOKEN_KIND_CASE discard:NO]; 
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ 
            [self expr_]; 
            [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; 
        } completion:^{ 
            [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; 
        }];
    } while ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_CASE discard:NO]; [self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ [self expr_]; [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; } completion:^{ [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; }];}]);
    [self stmts_]; 

    [self fireDelegateSelector:@selector(parser:didMatchCaseClause:)];
}

- (void)disruptiveStmt_ {
    
    if ([self predicts:CROCKFORD_TOKEN_KIND_BREAK, 0]) {
        [self breakStmt_]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_RETURN, 0]) {
        [self returnStmt_]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_THROW, 0]) {
        [self throwStmt_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'disruptiveStmt'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchDisruptiveStmt:)];
}

- (void)doStmt_ {
    
    [self match:CROCKFORD_TOKEN_KIND_DO discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_WHILE block:^{ 
        [self block_]; 
        [self match:CROCKFORD_TOKEN_KIND_WHILE discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_WHILE discard:NO]; 
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_PAREN block:^{ 
        [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        [self expr_]; 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
        [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchDoStmt:)];
}

- (void)escapedChar_ {
    
    [self matchSymbol:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchEscapedChar:)];
}

- (void)exponent_ {
    
    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchExponent:)];
}

- (void)expr_ {
    
    if ([self predicts:CROCKFORD_TOKEN_KIND_FUNCTION, CROCKFORD_TOKEN_KIND_OPEN_BRACKET, CROCKFORD_TOKEN_KIND_OPEN_CURLY, CROCKFORD_TOKEN_KIND_REGEXBODY, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self literal_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self name_]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
            [self expr_]; 
            [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
        } completion:^{ 
            [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
        }];
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_BANG, CROCKFORD_TOKEN_KIND_TYPEOF, 0]) {
        [self prefixOp_]; 
        [self expr_]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_NEW, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_NEW discard:NO]; 
        [self expr_]; 
        [self invocation_]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_DELETE, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_DELETE discard:NO]; 
        [self expr_]; 
        [self refinement_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'expr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)exprStmt_ {
    
    if ([self speculate:^{ do {[self tryAndRecover:CROCKFORD_TOKEN_KIND_EQUALS block:^{ [self name_]; while ([self speculate:^{ [self refinement_]; }]) {[self refinement_]; }[self match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO]; } completion:^{ [self match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO]; }];} while ([self speculate:^{ [self tryAndRecover:CROCKFORD_TOKEN_KIND_EQUALS block:^{ [self name_]; while ([self speculate:^{ [self refinement_]; }]) {[self refinement_]; }[self match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO]; } completion:^{ [self match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO]; }];}]);[self expr_]; }]) {
        do {
            [self tryAndRecover:CROCKFORD_TOKEN_KIND_EQUALS block:^{ 
                [self name_]; 
                while ([self speculate:^{ [self refinement_]; }]) {
                    [self refinement_]; 
                }
                [self match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO]; 
            } completion:^{ 
                [self match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO]; 
            }];
        } while ([self speculate:^{ [self tryAndRecover:CROCKFORD_TOKEN_KIND_EQUALS block:^{ [self name_]; while ([self speculate:^{ [self refinement_]; }]) {[self refinement_]; }[self match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO]; } completion:^{ [self match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO]; }];}]);
        [self expr_]; 
    } else if ([self speculate:^{ [self name_]; while ([self speculate:^{ [self refinement_]; }]) {[self refinement_]; }if ([self predicts:CROCKFORD_TOKEN_KIND_PLUS_EQUALS, 0]) {[self match:CROCKFORD_TOKEN_KIND_PLUS_EQUALS discard:NO]; } else if ([self predicts:CROCKFORD_TOKEN_KIND_MINUS_EQUALS, 0]) {[self match:CROCKFORD_TOKEN_KIND_MINUS_EQUALS discard:NO]; } else {[self raise:@"No viable alternative found in rule 'exprStmt'."];}[self expr_]; }]) {
        [self name_]; 
        while ([self speculate:^{ [self refinement_]; }]) {
            [self refinement_]; 
        }
        if ([self predicts:CROCKFORD_TOKEN_KIND_PLUS_EQUALS, 0]) {
            [self match:CROCKFORD_TOKEN_KIND_PLUS_EQUALS discard:NO]; 
        } else if ([self predicts:CROCKFORD_TOKEN_KIND_MINUS_EQUALS, 0]) {
            [self match:CROCKFORD_TOKEN_KIND_MINUS_EQUALS discard:NO]; 
        } else {
            [self raise:@"No viable alternative found in rule 'exprStmt'."];
        }
        [self expr_]; 
    } else if ([self speculate:^{ [self name_]; while ([self speculate:^{ [self refinement_]; }]) {[self refinement_]; }do {[self invocation_]; } while ([self speculate:^{ [self invocation_]; }]);}]) {
        [self name_]; 
        while ([self speculate:^{ [self refinement_]; }]) {
            [self refinement_]; 
        }
        do {
            [self invocation_]; 
        } while ([self speculate:^{ [self invocation_]; }]);
    } else if ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_DELETE discard:NO]; [self expr_]; [self refinement_]; }]) {
        [self match:CROCKFORD_TOKEN_KIND_DELETE discard:NO]; 
        [self expr_]; 
        [self refinement_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'exprStmt'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExprStmt:)];
}

- (void)forStmt_ {
    
    if ([self predicts:CROCKFORD_TOKEN_KIND_FOR, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_FOR discard:NO]; 
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_PAREN block:^{ 
            [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
        } completion:^{ 
            [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
        }];
            [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
                if ([self speculate:^{ [self exprStmt_]; }]) {
                    [self exprStmt_]; 
                }
                [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
            } completion:^{ 
                [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
            }];
            [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
                if ([self speculate:^{ [self expr_]; }]) {
                    [self expr_]; 
                }
                [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
            } completion:^{ 
                [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
            }];
                if ([self speculate:^{ [self exprStmt_]; }]) {
                    [self exprStmt_]; 
                }
            } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
                    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
                    [self tryAndRecover:CROCKFORD_TOKEN_KIND_IN block:^{ 
                        [self name_]; 
                        [self match:CROCKFORD_TOKEN_KIND_IN discard:NO]; 
                    } completion:^{ 
                        [self match:CROCKFORD_TOKEN_KIND_IN discard:NO]; 
                    }];
                        [self expr_]; 
                        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
                    } completion:^{ 
                        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
                    }];
                        [self block_]; 
                    } else {
                        [self raise:@"No viable alternative found in rule 'forStmt'."];
                    }

    [self fireDelegateSelector:@selector(parser:didMatchForStmt:)];
}

- (void)fraction_ {
    
    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchFraction:)];
}

- (void)function_ {
    
    [self match:CROCKFORD_TOKEN_KIND_FUNCTION discard:NO]; 
    [self name_]; 
    [self parameters_]; 
    [self functionBody_]; 

    [self fireDelegateSelector:@selector(parser:didMatchFunction:)];
}

- (void)functionBody_ {
    
    [self match:CROCKFORD_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_CURLY block:^{ 
        [self stmts_]; 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchFunctionBody:)];
}

- (void)functionLiteral_ {
    
    [self match:CROCKFORD_TOKEN_KIND_FUNCTION discard:NO]; 
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self name_]; 
    }
    [self parameters_]; 
    [self functionBody_]; 

    [self fireDelegateSelector:@selector(parser:didMatchFunctionLiteral:)];
}

- (void)ifStmt_ {
    
    [self match:CROCKFORD_TOKEN_KIND_IF discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_PAREN block:^{ 
        [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        [self expr_]; 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    }];
        [self block_]; 
        if ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_ELSE discard:NO]; if ([self speculate:^{ [self ifStmt_]; }]) {[self ifStmt_]; }[self block_]; }]) {
            [self match:CROCKFORD_TOKEN_KIND_ELSE discard:NO]; 
            if ([self speculate:^{ [self ifStmt_]; }]) {
                [self ifStmt_]; 
            }
            [self block_]; 
        }

    [self fireDelegateSelector:@selector(parser:didMatchIfStmt:)];
}

- (void)infixOp_ {
    
    if ([self predicts:CROCKFORD_TOKEN_KIND_STAR, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_STAR discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_FORWARD_SLASH, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_FORWARD_SLASH discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_PERCENT, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_PERCENT discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_PLUS, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_PLUS discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_MINUS, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_MINUS discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_GE_SYM, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_GE_SYM discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_LE_SYM, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_LE_SYM discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_GT_SYM, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_GT_SYM discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_LT_SYM, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_LT_SYM discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_TRIPLE_EQUALS, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_TRIPLE_EQUALS discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_DOUBLE_NOT_EQUAL, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_DOUBLE_NOT_EQUAL discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_DOUBLE_PIPE, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_DOUBLE_PIPE discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_DOUBLE_AMPERSAND, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_DOUBLE_AMPERSAND discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'infixOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchInfixOp:)];
}

- (void)integer_ {
    
    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchInteger:)];
}

- (void)invocation_ {
    
    [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        if ([self speculate:^{ [self expr_]; while ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self expr_]; }]) {[self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self expr_]; }}]) {
            [self expr_]; 
            while ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self expr_]; }]) {
                [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; 
                [self expr_]; 
            }
        }
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchInvocation:)];
}

- (void)literal_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self numberLiteral_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self stringLiteral_]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_OPEN_CURLY, 0]) {
        [self objectLiteral_]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [self arrayLiteral_]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_FUNCTION, 0]) {
        [self functionLiteral_]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_REGEXBODY, 0]) {
        [self regexLiteral_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'literal'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)name_ {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchName:)];
}

- (void)numberLiteral_ {
    
    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNumberLiteral:)];
}

- (void)objectLiteral_ {
    
    [self match:CROCKFORD_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_CURLY block:^{ 
        if ([self speculate:^{ [self nameValPair_]; while ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self nameValPair_]; }]) {[self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self nameValPair_]; }}]) {
            [self nameValPair_]; 
            while ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self nameValPair_]; }]) {
                [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; 
                [self nameValPair_]; 
            }
        }
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchObjectLiteral:)];
}

- (void)nameValPair_ {
    
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ 
        if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
            [self name_]; 
        } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
            [self stringLiteral_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'nameValPair'."];
        }
        [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; 
    }];
        [self expr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchNameValPair:)];
}

- (void)parameters_ {
    
    [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        if ([self speculate:^{ [self name_]; while ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self name_]; }]) {[self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self name_]; }}]) {
            [self name_]; 
            while ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self name_]; }]) {
                [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; 
                [self name_]; 
            }
        }
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchParameters:)];
}

- (void)prefixOp_ {
    
    if ([self predicts:CROCKFORD_TOKEN_KIND_TYPEOF, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_TYPEOF discard:NO]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_BANG, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_BANG discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'prefixOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrefixOp:)];
}

- (void)refinement_ {
    
    if ([self predicts:CROCKFORD_TOKEN_KIND_DOT, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_DOT discard:NO]; 
        [self name_]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [self match:CROCKFORD_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_BRACKET block:^{ 
            [self expr_]; 
            [self match:CROCKFORD_TOKEN_KIND_CLOSE_BRACKET discard:NO]; 
        } completion:^{ 
            [self match:CROCKFORD_TOKEN_KIND_CLOSE_BRACKET discard:NO]; 
        }];
    } else {
        [self raise:@"No viable alternative found in rule 'refinement'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRefinement:)];
}

- (void)regexLiteral_ {
    
    [self regexBody_]; 
    if ([self speculate:^{ [self regexMods_]; }]) {
        [self regexMods_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchRegexLiteral:)];
}

- (void)regexBody_ {
    
    [self match:CROCKFORD_TOKEN_KIND_REGEXBODY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchRegexBody:)];
}

- (void)regexMods_ {
    
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(@"[imxs]+", LS(1)); }]; 
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchRegexMods:)];
}

- (void)returnStmt_ {
    
    [self match:CROCKFORD_TOKEN_KIND_RETURN discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
        if ([self speculate:^{ [self expr_]; }]) {
            [self expr_]; 
        }
        [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchReturnStmt:)];
}

- (void)stmts_ {
    
    while ([self speculate:^{ [self stmt_]; }]) {
        [self stmt_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchStmts:)];
}

- (void)stmt_ {
    
    if ([self predicts:CROCKFORD_TOKEN_KIND_VAR, 0]) {
        [self varStmt_]; 
    } else if ([self predicts:CROCKFORD_TOKEN_KIND_FUNCTION, 0]) {
        [self function_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self nonFunction_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'stmt'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStmt:)];
}

- (void)nonFunction_ {
    
    if ([self speculate:^{ [self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ [self name_]; [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; } completion:^{ [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; }];}]) {
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ 
            [self name_]; 
            [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; 
        } completion:^{ 
            [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; 
        }];
    }
    if ([self speculate:^{ [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ [self exprStmt_]; [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; } completion:^{ [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; }];}]) {
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
            [self exprStmt_]; 
            [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
        } completion:^{ 
            [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
        }];
    } else if ([self speculate:^{ [self disruptiveStmt_]; }]) {
        [self disruptiveStmt_]; 
    } else if ([self speculate:^{ [self tryStmt_]; }]) {
        [self tryStmt_]; 
    } else if ([self speculate:^{ [self ifStmt_]; }]) {
        [self ifStmt_]; 
    } else if ([self speculate:^{ [self switchStmt_]; }]) {
        [self switchStmt_]; 
    } else if ([self speculate:^{ [self whileStmt_]; }]) {
        [self whileStmt_]; 
    } else if ([self speculate:^{ [self forStmt_]; }]) {
        [self forStmt_]; 
    } else if ([self speculate:^{ [self doStmt_]; }]) {
        [self doStmt_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'nonFunction'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNonFunction:)];
}

- (void)stringLiteral_ {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchStringLiteral:)];
}

- (void)switchStmt_ {
    
    [self match:CROCKFORD_TOKEN_KIND_SWITCH discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_PAREN block:^{ 
        [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        [self expr_]; 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_CURLY block:^{ 
        [self match:CROCKFORD_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    }];
            [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_CURLY block:^{ 
        do {
            [self caseClause_]; 
            if ([self speculate:^{ [self disruptiveStmt_]; }]) {
                [self disruptiveStmt_]; 
            }
        } while ([self speculate:^{ [self caseClause_]; if ([self speculate:^{ [self disruptiveStmt_]; }]) {[self disruptiveStmt_]; }}]);
                if ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_DEFAULT discard:NO]; [self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; } completion:^{ [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; }];[self stmts_]; }]) {
                [self match:CROCKFORD_TOKEN_KIND_DEFAULT discard:NO]; 
                [self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ 
                    [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; 
                } completion:^{ 
                    [self match:CROCKFORD_TOKEN_KIND_COLON discard:NO]; 
                }];
                    [self stmts_]; 
                }
                [self match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO]; 
            } completion:^{ 
                [self match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO]; 
            }];

    [self fireDelegateSelector:@selector(parser:didMatchSwitchStmt:)];
}

- (void)throwStmt_ {
    
    [self match:CROCKFORD_TOKEN_KIND_THROW discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
        [self expr_]; 
        [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchThrowStmt:)];
}

- (void)tryStmt_ {
    
    [self match:CROCKFORD_TOKEN_KIND_TRY discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CATCH block:^{ 
        [self block_]; 
        [self match:CROCKFORD_TOKEN_KIND_CATCH discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_CATCH discard:NO]; 
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_PAREN block:^{ 
        [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        [self name_]; 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    }];
        [self block_]; 
        if ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_FINALLY discard:NO]; [self block_]; }]) {
            [self match:CROCKFORD_TOKEN_KIND_FINALLY discard:NO]; 
            [self block_]; 
        }

    [self fireDelegateSelector:@selector(parser:didMatchTryStmt:)];
}

- (void)varStmt_ {
    
    while ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_VAR discard:NO]; [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ [self nameExprPair_]; while ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self nameExprPair_]; }]) {[self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self nameExprPair_]; }[self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; } completion:^{ [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; }];}]) {
        [self match:CROCKFORD_TOKEN_KIND_VAR discard:NO]; 
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
            [self nameExprPair_]; 
            while ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; [self nameExprPair_]; }]) {
                [self match:CROCKFORD_TOKEN_KIND_COMMA discard:NO]; 
                [self nameExprPair_]; 
            }
            [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
        } completion:^{ 
            [self match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO]; 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchVarStmt:)];
}

- (void)nameExprPair_ {
    
    [self name_]; 
    if ([self speculate:^{ [self match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO]; [self expr_]; }]) {
        [self match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO]; 
        [self expr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchNameExprPair:)];
}

- (void)whileStmt_ {
    
    [self match:CROCKFORD_TOKEN_KIND_WHILE discard:NO]; 
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_PAREN block:^{ 
        [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        [self expr_]; 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    } completion:^{ 
        [self match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    }];
        [self block_]; 

    [self fireDelegateSelector:@selector(parser:didMatchWhileStmt:)];
}

@end