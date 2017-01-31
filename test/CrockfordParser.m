#import "CrockfordParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


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
    PKParser_weakSelfDecl;

        [self tryAndRecover:TOKEN_KIND_BUILTIN_EOF block:^{
            [PKParser_weakSelf program_];
            [PKParser_weakSelf matchEOF:YES];
        } completion:^{
            [self matchEOF:YES];
        }];

}

- (void)program_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf execute:^{
    
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
    [PKParser_weakSelf stmts_];

    [self fireDelegateSelector:@selector(parser:didMatchProgram:)];
}

- (void)arrayLiteral_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_BRACKET discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_BRACKET block:^{ 
        if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf expr_];while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf expr_];}]) {[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf expr_];}}]) {
            [PKParser_weakSelf expr_];
            while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf expr_];}]) {
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];
                [PKParser_weakSelf expr_];
            }
        }
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_BRACKET discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_BRACKET discard:NO];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchArrayLiteral:)];
}

- (void)block_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_CURLY discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_CURLY block:^{ 
        if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf stmts_];}]) {
            [PKParser_weakSelf stmts_];
        }
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchBlock:)];
}

- (void)breakStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_BREAK discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
        if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
            [PKParser_weakSelf name_];
        }
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchBreakStmt:)];
}

- (void)caseClause_ {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CASE discard:NO];
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ 
            [PKParser_weakSelf expr_];
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];
        } completion:^{ 
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];
        }];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CASE discard:NO];[self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ [PKParser_weakSelf expr_];[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];} completion:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];}];}]);
    [PKParser_weakSelf stmts_];

    [self fireDelegateSelector:@selector(parser:didMatchCaseClause:)];
}

- (void)disruptiveStmt_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_BREAK, 0]) {
        [PKParser_weakSelf breakStmt_];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_RETURN, 0]) {
        [PKParser_weakSelf returnStmt_];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_THROW, 0]) {
        [PKParser_weakSelf throwStmt_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'disruptiveStmt'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchDisruptiveStmt:)];
}

- (void)doStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_DO discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_WHILE block:^{ 
        [PKParser_weakSelf block_];
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_WHILE discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_WHILE discard:NO];
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_PAREN block:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchDoStmt:)];
}

- (void)escapedChar_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchSymbol:NO];

    [self fireDelegateSelector:@selector(parser:didMatchEscapedChar:)];
}

- (void)exponent_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchNumber:NO];

    [self fireDelegateSelector:@selector(parser:didMatchExponent:)];
}

- (void)expr_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_FUNCTION, CROCKFORD_TOKEN_KIND_OPEN_BRACKET, CROCKFORD_TOKEN_KIND_OPEN_CURLY, CROCKFORD_TOKEN_KIND_REGEXBODY, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [PKParser_weakSelf literal_];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf name_];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_OPEN_PAREN, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
            [PKParser_weakSelf expr_];
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
        } completion:^{ 
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
        }];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_BANG, CROCKFORD_TOKEN_KIND_TYPEOF, 0]) {
        [PKParser_weakSelf prefixOp_];
        [PKParser_weakSelf expr_];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_NEW, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_NEW discard:NO];
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf invocation_];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_DELETE, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_DELETE discard:NO];
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf refinement_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'expr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)exprStmt_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ do {[self tryAndRecover:CROCKFORD_TOKEN_KIND_EQUALS block:^{ [PKParser_weakSelf name_];while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf refinement_];}]) {[PKParser_weakSelf refinement_];}[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO];} completion:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO];}];} while ([PKParser_weakSelf speculate:^{ [self tryAndRecover:CROCKFORD_TOKEN_KIND_EQUALS block:^{ [PKParser_weakSelf name_];while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf refinement_];}]) {[PKParser_weakSelf refinement_];}[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO];} completion:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO];}];}]);[PKParser_weakSelf expr_];}]) {
        do {
            [self tryAndRecover:CROCKFORD_TOKEN_KIND_EQUALS block:^{ 
                [PKParser_weakSelf name_];
                while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf refinement_];}]) {
                    [PKParser_weakSelf refinement_];
                }
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO];
            } completion:^{ 
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO];
            }];
        } while ([PKParser_weakSelf speculate:^{ [self tryAndRecover:CROCKFORD_TOKEN_KIND_EQUALS block:^{ [PKParser_weakSelf name_];while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf refinement_];}]) {[PKParser_weakSelf refinement_];}[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO];} completion:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO];}];}]);
        [PKParser_weakSelf expr_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf name_];while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf refinement_];}]) {[PKParser_weakSelf refinement_];}if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_PLUS_EQUALS, 0]) {[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_PLUS_EQUALS discard:NO];} else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_MINUS_EQUALS, 0]) {[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_MINUS_EQUALS discard:NO];} else {[PKParser_weakSelf raise:@"No viable alternative found in rule 'exprStmt'."];}[PKParser_weakSelf expr_];}]) {
        [PKParser_weakSelf name_];
        while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf refinement_];}]) {
            [PKParser_weakSelf refinement_];
        }
        if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_PLUS_EQUALS, 0]) {
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_PLUS_EQUALS discard:NO];
        } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_MINUS_EQUALS, 0]) {
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_MINUS_EQUALS discard:NO];
        } else {
            [PKParser_weakSelf raise:@"No viable alternative found in rule 'exprStmt'."];
        }
        [PKParser_weakSelf expr_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf name_];while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf refinement_];}]) {[PKParser_weakSelf refinement_];}do {[PKParser_weakSelf invocation_];} while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf invocation_];}]);}]) {
        [PKParser_weakSelf name_];
        while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf refinement_];}]) {
            [PKParser_weakSelf refinement_];
        }
        do {
            [PKParser_weakSelf invocation_];
        } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf invocation_];}]);
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_DELETE discard:NO];[PKParser_weakSelf expr_];[PKParser_weakSelf refinement_];}]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_DELETE discard:NO];
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf refinement_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'exprStmt'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExprStmt:)];
}

- (void)forStmt_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_FOR, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_FOR discard:NO];
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_PAREN block:^{ 
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
        } completion:^{ 
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
        }];
            [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
                if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf exprStmt_];}]) {
                    [PKParser_weakSelf exprStmt_];
                }
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
            } completion:^{ 
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
            }];
            [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
                if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf expr_];}]) {
                    [PKParser_weakSelf expr_];
                }
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
            } completion:^{ 
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
            }];
                if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf exprStmt_];}]) {
                    [PKParser_weakSelf exprStmt_];
                }
            } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
                    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
                    [self tryAndRecover:CROCKFORD_TOKEN_KIND_IN block:^{ 
                        [PKParser_weakSelf name_];
                        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_IN discard:NO];
                    } completion:^{ 
                        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_IN discard:NO];
                    }];
                        [PKParser_weakSelf expr_];
                        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
                    } completion:^{ 
                        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
                    }];
                        [PKParser_weakSelf block_];
                    } else {
                        [PKParser_weakSelf raise:@"No viable alternative found in rule 'forStmt'."];
                    }

    [self fireDelegateSelector:@selector(parser:didMatchForStmt:)];
}

- (void)fraction_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchNumber:NO];

    [self fireDelegateSelector:@selector(parser:didMatchFraction:)];
}

- (void)function_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_FUNCTION discard:NO];
    [PKParser_weakSelf name_];
    [PKParser_weakSelf parameters_];
    [PKParser_weakSelf functionBody_];

    [self fireDelegateSelector:@selector(parser:didMatchFunction:)];
}

- (void)functionBody_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_CURLY discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_CURLY block:^{ 
        [PKParser_weakSelf stmts_];
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchFunctionBody:)];
}

- (void)functionLiteral_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_FUNCTION discard:NO];
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf name_];
    }
    [PKParser_weakSelf parameters_];
    [PKParser_weakSelf functionBody_];

    [self fireDelegateSelector:@selector(parser:didMatchFunctionLiteral:)];
}

- (void)ifStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_IF discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_PAREN block:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    }];
        [PKParser_weakSelf block_];
        if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_ELSE discard:NO];if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf ifStmt_];}]) {[PKParser_weakSelf ifStmt_];}[PKParser_weakSelf block_];}]) {
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_ELSE discard:NO];
            if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf ifStmt_];}]) {
                [PKParser_weakSelf ifStmt_];
            }
            [PKParser_weakSelf block_];
        }

    [self fireDelegateSelector:@selector(parser:didMatchIfStmt:)];
}

- (void)infixOp_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_STAR, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_STAR discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_FORWARD_SLASH, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_FORWARD_SLASH discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_PERCENT, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_PERCENT discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_PLUS, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_PLUS discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_MINUS, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_MINUS discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_GE_SYM, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_GE_SYM discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_LE_SYM, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_LE_SYM discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_GT_SYM, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_GT_SYM discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_LT_SYM, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_LT_SYM discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_TRIPLE_EQUALS, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_TRIPLE_EQUALS discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_DOUBLE_NOT_EQUAL, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_DOUBLE_NOT_EQUAL discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_DOUBLE_PIPE, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_DOUBLE_PIPE discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_DOUBLE_AMPERSAND, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_DOUBLE_AMPERSAND discard:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'infixOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchInfixOp:)];
}

- (void)integer_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchNumber:NO];

    [self fireDelegateSelector:@selector(parser:didMatchInteger:)];
}

- (void)invocation_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf expr_];while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf expr_];}]) {[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf expr_];}}]) {
            [PKParser_weakSelf expr_];
            while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf expr_];}]) {
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];
                [PKParser_weakSelf expr_];
            }
        }
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchInvocation:)];
}

- (void)literal_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [PKParser_weakSelf numberLiteral_];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [PKParser_weakSelf stringLiteral_];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_OPEN_CURLY, 0]) {
        [PKParser_weakSelf objectLiteral_];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [PKParser_weakSelf arrayLiteral_];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_FUNCTION, 0]) {
        [PKParser_weakSelf functionLiteral_];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_REGEXBODY, 0]) {
        [PKParser_weakSelf regexLiteral_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'literal'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)name_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchWord:NO];

    [self fireDelegateSelector:@selector(parser:didMatchName:)];
}

- (void)numberLiteral_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchNumber:NO];

    [self fireDelegateSelector:@selector(parser:didMatchNumberLiteral:)];
}

- (void)objectLiteral_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_CURLY discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_CURLY block:^{ 
        if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf nameValPair_];while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf nameValPair_];}]) {[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf nameValPair_];}}]) {
            [PKParser_weakSelf nameValPair_];
            while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf nameValPair_];}]) {
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];
                [PKParser_weakSelf nameValPair_];
            }
        }
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchObjectLiteral:)];
}

- (void)nameValPair_ {
    PKParser_weakSelfDecl;
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ 
        if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
            [PKParser_weakSelf name_];
        } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
            [PKParser_weakSelf stringLiteral_];
        } else {
            [PKParser_weakSelf raise:@"No viable alternative found in rule 'nameValPair'."];
        }
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];
    }];
        [PKParser_weakSelf expr_];

    [self fireDelegateSelector:@selector(parser:didMatchNameValPair:)];
}

- (void)parameters_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf name_];while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf name_];}]) {[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf name_];}}]) {
            [PKParser_weakSelf name_];
            while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf name_];}]) {
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];
                [PKParser_weakSelf name_];
            }
        }
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchParameters:)];
}

- (void)prefixOp_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_TYPEOF, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_TYPEOF discard:NO];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_BANG, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_BANG discard:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'prefixOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrefixOp:)];
}

- (void)refinement_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_DOT, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_DOT discard:NO];
        [PKParser_weakSelf name_];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_BRACKET discard:NO];
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_BRACKET block:^{ 
            [PKParser_weakSelf expr_];
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_BRACKET discard:NO];
        } completion:^{ 
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_BRACKET discard:NO];
        }];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'refinement'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRefinement:)];
}

- (void)regexLiteral_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf regexBody_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf regexMods_];}]) {
        [PKParser_weakSelf regexMods_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRegexLiteral:)];
}

- (void)regexBody_ {
    PKParser_weakSelfDecl;
    [self match:CROCKFORD_TOKEN_KIND_REGEXBODY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchRegexBody:)];
}

- (void)regexMods_ {
    PKParser_weakSelfDecl;
    [self testAndThrow:(id)^{ return MATCHES_IGNORE_CASE(@"[imxs]+", LS(1)); }]; 
    [PKParser_weakSelf matchWord:NO];

    [self fireDelegateSelector:@selector(parser:didMatchRegexMods:)];
}

- (void)returnStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_RETURN discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
        if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf expr_];}]) {
            [PKParser_weakSelf expr_];
        }
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchReturnStmt:)];
}

- (void)stmts_ {
    PKParser_weakSelfDecl;
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf stmt_];}]) {
        [PKParser_weakSelf stmt_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStmts:)];
}

- (void)stmt_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_VAR, 0]) {
        [PKParser_weakSelf varStmt_];
    } else if ([PKParser_weakSelf predicts:CROCKFORD_TOKEN_KIND_FUNCTION, 0]) {
        [PKParser_weakSelf function_];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf nonFunction_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'stmt'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStmt:)];
}

- (void)nonFunction_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ [PKParser_weakSelf name_];[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];} completion:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];}];}]) {
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ 
            [PKParser_weakSelf name_];
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];
        } completion:^{ 
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];
        }];
    }
    if ([PKParser_weakSelf speculate:^{ [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ [PKParser_weakSelf exprStmt_];[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];} completion:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];}];}]) {
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
            [PKParser_weakSelf exprStmt_];
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
        } completion:^{ 
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
        }];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf disruptiveStmt_];}]) {
        [PKParser_weakSelf disruptiveStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf tryStmt_];}]) {
        [PKParser_weakSelf tryStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf ifStmt_];}]) {
        [PKParser_weakSelf ifStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf switchStmt_];}]) {
        [PKParser_weakSelf switchStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf whileStmt_];}]) {
        [PKParser_weakSelf whileStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf forStmt_];}]) {
        [PKParser_weakSelf forStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf doStmt_];}]) {
        [PKParser_weakSelf doStmt_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'nonFunction'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNonFunction:)];
}

- (void)stringLiteral_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchQuotedString:NO];

    [self fireDelegateSelector:@selector(parser:didMatchStringLiteral:)];
}

- (void)switchStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SWITCH discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_PAREN block:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_CURLY block:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_CURLY discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_CURLY discard:NO];
    }];
            [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_CURLY block:^{ 
        do {
            [PKParser_weakSelf caseClause_];
            if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf disruptiveStmt_];}]) {
                [PKParser_weakSelf disruptiveStmt_];
            }
        } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf caseClause_];if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf disruptiveStmt_];}]) {[PKParser_weakSelf disruptiveStmt_];}}]);
                if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_DEFAULT discard:NO];[self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];} completion:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];}];[PKParser_weakSelf stmts_];}]) {
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_DEFAULT discard:NO];
                [self tryAndRecover:CROCKFORD_TOKEN_KIND_COLON block:^{ 
                    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];
                } completion:^{ 
                    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COLON discard:NO];
                }];
                    [PKParser_weakSelf stmts_];
                }
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO];
            } completion:^{ 
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_CURLY discard:NO];
            }];

    [self fireDelegateSelector:@selector(parser:didMatchSwitchStmt:)];
}

- (void)throwStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_THROW discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchThrowStmt:)];
}

- (void)tryStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_TRY discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CATCH block:^{ 
        [PKParser_weakSelf block_];
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CATCH discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CATCH discard:NO];
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_PAREN block:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        [PKParser_weakSelf name_];
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    }];
        [PKParser_weakSelf block_];
        if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_FINALLY discard:NO];[PKParser_weakSelf block_];}]) {
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_FINALLY discard:NO];
            [PKParser_weakSelf block_];
        }

    [self fireDelegateSelector:@selector(parser:didMatchTryStmt:)];
}

- (void)varStmt_ {
    PKParser_weakSelfDecl;
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_VAR discard:NO];[self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ [PKParser_weakSelf nameExprPair_];while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf nameExprPair_];}]) {[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf nameExprPair_];}[PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];} completion:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];}];}]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_VAR discard:NO];
        [self tryAndRecover:CROCKFORD_TOKEN_KIND_SEMI_COLON block:^{ 
            [PKParser_weakSelf nameExprPair_];
            while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf nameExprPair_];}]) {
                [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_COMMA discard:NO];
                [PKParser_weakSelf nameExprPair_];
            }
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
        } completion:^{ 
            [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_SEMI_COLON discard:NO];
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchVarStmt:)];
}

- (void)nameExprPair_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf name_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO];[PKParser_weakSelf expr_];}]) {
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_EQUALS discard:NO];
        [PKParser_weakSelf expr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNameExprPair:)];
}

- (void)whileStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_WHILE discard:NO];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_OPEN_PAREN block:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_OPEN_PAREN discard:NO];
    }];
    [self tryAndRecover:CROCKFORD_TOKEN_KIND_CLOSE_PAREN block:^{ 
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    } completion:^{ 
        [PKParser_weakSelf match:CROCKFORD_TOKEN_KIND_CLOSE_PAREN discard:NO];
    }];
        [PKParser_weakSelf block_];

    [self fireDelegateSelector:@selector(parser:didMatchWhileStmt:)];
}

@end