#import "JavaScriptParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface JavaScriptParser ()

@end

@implementation JavaScriptParser { }
    
- (void)setPreserveWhitespace:(BOOL)yn {
    _preserveWhitespace = yn;
    self.silentlyConsumesWhitespace = YES;
    self.tokenizer.whitespaceState.reportsWhitespaceTokens = YES;
    self.assembly.preservesWhitespaceTokens = YES;
}

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"program";
        self.enableAutomaticErrorRecovery = YES;

        self.tokenKindTab[@"|"] = @(JAVASCRIPT_TOKEN_KIND_PIPE);
        self.tokenKindTab[@"!="] = @(JAVASCRIPT_TOKEN_KIND_NE);
        self.tokenKindTab[@"("] = @(JAVASCRIPT_TOKEN_KIND_OPENPAREN);
        self.tokenKindTab[@"}"] = @(JAVASCRIPT_TOKEN_KIND_CLOSECURLY);
        self.tokenKindTab[@"return"] = @(JAVASCRIPT_TOKEN_KIND_RETURN);
        self.tokenKindTab[@"~"] = @(JAVASCRIPT_TOKEN_KIND_TILDE);
        self.tokenKindTab[@")"] = @(JAVASCRIPT_TOKEN_KIND_CLOSEPAREN);
        self.tokenKindTab[@"*"] = @(JAVASCRIPT_TOKEN_KIND_TIMES);
        self.tokenKindTab[@"delete"] = @(JAVASCRIPT_TOKEN_KIND_DELETE);
        self.tokenKindTab[@"!=="] = @(JAVASCRIPT_TOKEN_KIND_ISNOT);
        self.tokenKindTab[@"+"] = @(JAVASCRIPT_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"*="] = @(JAVASCRIPT_TOKEN_KIND_TIMESEQ);
        self.tokenKindTab[@"instanceof"] = @(JAVASCRIPT_TOKEN_KIND_INSTANCEOF);
        self.tokenKindTab[@","] = @(JAVASCRIPT_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"<<="] = @(JAVASCRIPT_TOKEN_KIND_SHIFTLEFTEQ);
        self.tokenKindTab[@"if"] = @(JAVASCRIPT_TOKEN_KIND_IF);
        self.tokenKindTab[@"-"] = @(JAVASCRIPT_TOKEN_KIND_MINUS);
        self.tokenKindTab[@"null"] = @(JAVASCRIPT_TOKEN_KIND_NULL);
        self.tokenKindTab[@"false"] = @(JAVASCRIPT_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"."] = @(JAVASCRIPT_TOKEN_KIND_DOT);
        self.tokenKindTab[@"<<"] = @(JAVASCRIPT_TOKEN_KIND_SHIFTLEFT);
        self.tokenKindTab[@"/"] = @(JAVASCRIPT_TOKEN_KIND_DIV);
        self.tokenKindTab[@"+="] = @(JAVASCRIPT_TOKEN_KIND_PLUSEQ);
        self.tokenKindTab[@"<="] = @(JAVASCRIPT_TOKEN_KIND_LE);
        self.tokenKindTab[@"^="] = @(JAVASCRIPT_TOKEN_KIND_XOREQ);
        self.tokenKindTab[@"["] = @(JAVASCRIPT_TOKEN_KIND_OPENBRACKET);
        self.tokenKindTab[@"undefined"] = @(JAVASCRIPT_TOKEN_KIND_UNDEFINED);
        self.tokenKindTab[@"typeof"] = @(JAVASCRIPT_TOKEN_KIND_TYPEOF);
        self.tokenKindTab[@"||"] = @(JAVASCRIPT_TOKEN_KIND_OR);
        self.tokenKindTab[@"function"] = @(JAVASCRIPT_TOKEN_KIND_FUNCTION);
        self.tokenKindTab[@"]"] = @(JAVASCRIPT_TOKEN_KIND_CLOSEBRACKET);
        self.tokenKindTab[@"^"] = @(JAVASCRIPT_TOKEN_KIND_CARET);
        self.tokenKindTab[@"=="] = @(JAVASCRIPT_TOKEN_KIND_EQ);
        self.tokenKindTab[@"continue"] = @(JAVASCRIPT_TOKEN_KIND_CONTINUE);
        self.tokenKindTab[@"break"] = @(JAVASCRIPT_TOKEN_KIND_BREAK);
        self.tokenKindTab[@"-="] = @(JAVASCRIPT_TOKEN_KIND_MINUSEQ);
        self.tokenKindTab[@">="] = @(JAVASCRIPT_TOKEN_KIND_GE);
        self.tokenKindTab[@":"] = @(JAVASCRIPT_TOKEN_KIND_COLON);
        self.tokenKindTab[@"in"] = @(JAVASCRIPT_TOKEN_KIND_IN);
        self.tokenKindTab[@";"] = @(JAVASCRIPT_TOKEN_KIND_SEMI);
        self.tokenKindTab[@"for"] = @(JAVASCRIPT_TOKEN_KIND_FOR);
        self.tokenKindTab[@"++"] = @(JAVASCRIPT_TOKEN_KIND_PLUSPLUS);
        self.tokenKindTab[@"<"] = @(JAVASCRIPT_TOKEN_KIND_LT);
        self.tokenKindTab[@"%="] = @(JAVASCRIPT_TOKEN_KIND_MODEQ);
        self.tokenKindTab[@">>"] = @(JAVASCRIPT_TOKEN_KIND_SHIFTRIGHT);
        self.tokenKindTab[@"="] = @(JAVASCRIPT_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@">"] = @(JAVASCRIPT_TOKEN_KIND_GT);
        self.tokenKindTab[@"void"] = @(JAVASCRIPT_TOKEN_KIND_VOID);
        self.tokenKindTab[@"?"] = @(JAVASCRIPT_TOKEN_KIND_QUESTION);
        self.tokenKindTab[@"while"] = @(JAVASCRIPT_TOKEN_KIND_WHILE);
        self.tokenKindTab[@"&="] = @(JAVASCRIPT_TOKEN_KIND_ANDEQ);
        self.tokenKindTab[@">>>="] = @(JAVASCRIPT_TOKEN_KIND_SHIFTRIGHTEXTEQ);
        self.tokenKindTab[@"else"] = @(JAVASCRIPT_TOKEN_KIND_ELSE);
        self.tokenKindTab[@"/="] = @(JAVASCRIPT_TOKEN_KIND_DIVEQ);
        self.tokenKindTab[@"&&"] = @(JAVASCRIPT_TOKEN_KIND_AND);
        self.tokenKindTab[@"var"] = @(JAVASCRIPT_TOKEN_KIND_VAR);
        self.tokenKindTab[@"|="] = @(JAVASCRIPT_TOKEN_KIND_OREQ);
        self.tokenKindTab[@">>="] = @(JAVASCRIPT_TOKEN_KIND_SHIFTRIGHTEQ);
        self.tokenKindTab[@"--"] = @(JAVASCRIPT_TOKEN_KIND_MINUSMINUS);
        self.tokenKindTab[@"new"] = @(JAVASCRIPT_TOKEN_KIND_KEYWORDNEW);
        self.tokenKindTab[@"!"] = @(JAVASCRIPT_TOKEN_KIND_NOT);
        self.tokenKindTab[@">>>"] = @(JAVASCRIPT_TOKEN_KIND_SHIFTRIGHTEXT);
        self.tokenKindTab[@"true"] = @(JAVASCRIPT_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"this"] = @(JAVASCRIPT_TOKEN_KIND_THIS);
        self.tokenKindTab[@"with"] = @(JAVASCRIPT_TOKEN_KIND_WITH);
        self.tokenKindTab[@"==="] = @(JAVASCRIPT_TOKEN_KIND_IS);
        self.tokenKindTab[@"%"] = @(JAVASCRIPT_TOKEN_KIND_MOD);
        self.tokenKindTab[@"&"] = @(JAVASCRIPT_TOKEN_KIND_AMP);
        self.tokenKindTab[@"{"] = @(JAVASCRIPT_TOKEN_KIND_OPENCURLY);

        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_PIPE] = @"|";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_NE] = @"!=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_OPENPAREN] = @"(";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_CLOSECURLY] = @"}";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_RETURN] = @"return";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_TILDE] = @"~";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_CLOSEPAREN] = @")";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_TIMES] = @"*";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_DELETE] = @"delete";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_ISNOT] = @"!==";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_TIMESEQ] = @"*=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_INSTANCEOF] = @"instanceof";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_SHIFTLEFTEQ] = @"<<=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_IF] = @"if";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_NULL] = @"null";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_SHIFTLEFT] = @"<<";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_DIV] = @"/";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_PLUSEQ] = @"+=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_LE] = @"<=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_XOREQ] = @"^=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_OPENBRACKET] = @"[";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_UNDEFINED] = @"undefined";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_TYPEOF] = @"typeof";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_OR] = @"||";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_FUNCTION] = @"function";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_CLOSEBRACKET] = @"]";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_CARET] = @"^";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_EQ] = @"==";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_CONTINUE] = @"continue";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_BREAK] = @"break";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_MINUSEQ] = @"-=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_GE] = @">=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_COLON] = @":";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_IN] = @"in";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_SEMI] = @";";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_FOR] = @"for";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_PLUSPLUS] = @"++";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_LT] = @"<";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_MODEQ] = @"%=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_SHIFTRIGHT] = @">>";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_GT] = @">";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_VOID] = @"void";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_QUESTION] = @"?";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_WHILE] = @"while";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_ANDEQ] = @"&=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_SHIFTRIGHTEXTEQ] = @">>>=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_ELSE] = @"else";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_DIVEQ] = @"/=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_AND] = @"&&";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_VAR] = @"var";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_OREQ] = @"|=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_SHIFTRIGHTEQ] = @">>=";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_MINUSMINUS] = @"--";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_KEYWORDNEW] = @"new";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_NOT] = @"!";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_SHIFTRIGHTEXT] = @">>>";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_THIS] = @"this";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_WITH] = @"with";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_IS] = @"===";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_MOD] = @"%";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_AMP] = @"&";
        self.tokenKindNameTab[JAVASCRIPT_TOKEN_KIND_OPENCURLY] = @"{";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf execute:^{
    
        PKTokenizer *t = self.tokenizer;

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

        t.commentState.reportsCommentTokens = YES;
        
        [t setTokenizerState:t.commentState from:'/' to:'/'];
        [t.commentState addSingleLineStartMarker:@"//"];
        [t.commentState addMultiLineStartMarker:@"/*" endMarker:@"*/"];

    }];

    [self tryAndRecover:TOKEN_KIND_BUILTIN_EOF block:^{
        [PKParser_weakSelf program_];
        [PKParser_weakSelf matchEOF:YES];
    } completion:^{
        [self matchEOF:YES];
    }];

}

- (void)program_ {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf element_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf element_];}]);

    [self fireDelegateSelector:@selector(parser:didMatchProgram:)];
}

- (void)if_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_IF discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchIf:)];
}

- (void)else_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_ELSE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchElse:)];
}

- (void)while_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_WHILE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchWhile:)];
}

- (void)for_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_FOR discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchFor:)];
}

- (void)in_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_IN discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchIn:)];
}

- (void)break_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_BREAK discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchBreak:)];
}

- (void)continue_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_CONTINUE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchContinue:)];
}

- (void)with_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_WITH discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchWith:)];
}

- (void)return_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_RETURN discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchReturn:)];
}

- (void)var_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_VAR discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchVar:)];
}

- (void)delete_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_DELETE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchDelete:)];
}

- (void)keywordNew_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_KEYWORDNEW discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchKeywordNew:)];
}

- (void)this_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_THIS discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchThis:)];
}

- (void)false_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_FALSE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchFalse:)];
}

- (void)true_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_TRUE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchTrue:)];
}

- (void)null_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_NULL discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchNull:)];
}

- (void)undefined_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_UNDEFINED discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchUndefined:)];
}

- (void)void_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_VOID discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchVoid:)];
}

- (void)typeof_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_TYPEOF discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchTypeof:)];
}

- (void)instanceof_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_INSTANCEOF discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchInstanceof:)];
}

- (void)function_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_FUNCTION discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchFunction:)];
}

- (void)openCurly_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_OPENCURLY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchOpenCurly:)];
}

- (void)closeCurly_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_CLOSECURLY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchCloseCurly:)];
}

- (void)openParen_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_OPENPAREN discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchOpenParen:)];
}

- (void)closeParen_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_CLOSEPAREN discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchCloseParen:)];
}

- (void)openBracket_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_OPENBRACKET discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchOpenBracket:)];
}

- (void)closeBracket_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_CLOSEBRACKET discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchCloseBracket:)];
}

- (void)comma_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_COMMA discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchComma:)];
}

- (void)dot_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_DOT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchDot:)];
}

- (void)semi_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_SEMI discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchSemi:)];
}

- (void)colon_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_COLON discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchColon:)];
}

- (void)equals_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_EQUALS discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchEquals:)];
}

- (void)not_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_NOT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchNot:)];
}

- (void)lt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_LT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchLt:)];
}

- (void)gt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_GT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchGt:)];
}

- (void)amp_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_AMP discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchAmp:)];
}

- (void)pipe_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_PIPE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchPipe:)];
}

- (void)caret_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_CARET discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchCaret:)];
}

- (void)tilde_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_TILDE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchTilde:)];
}

- (void)question_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_QUESTION discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchQuestion:)];
}

- (void)plus_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_PLUS discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchPlus:)];
}

- (void)minus_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_MINUS discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchMinus:)];
}

- (void)times_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_TIMES discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchTimes:)];
}

- (void)div_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_DIV discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchDiv:)];
}

- (void)mod_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_MOD discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchMod:)];
}

- (void)or_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_OR discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchOr:)];
}

- (void)and_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_AND discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchAnd:)];
}

- (void)ne_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_NE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchNe:)];
}

- (void)isnot_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_ISNOT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchIsnot:)];
}

- (void)eq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_EQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)is_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_IS discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchIs:)];
}

- (void)le_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_LE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchLe:)];
}

- (void)ge_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_GE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchGe:)];
}

- (void)plusPlus_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_PLUSPLUS discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchPlusPlus:)];
}

- (void)minusMinus_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_MINUSMINUS discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchMinusMinus:)];
}

- (void)plusEq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_PLUSEQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchPlusEq:)];
}

- (void)minusEq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_MINUSEQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchMinusEq:)];
}

- (void)timesEq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_TIMESEQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchTimesEq:)];
}

- (void)divEq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_DIVEQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchDivEq:)];
}

- (void)modEq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_MODEQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchModEq:)];
}

- (void)shiftLeft_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_SHIFTLEFT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchShiftLeft:)];
}

- (void)shiftRight_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_SHIFTRIGHT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchShiftRight:)];
}

- (void)shiftRightExt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_SHIFTRIGHTEXT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchShiftRightExt:)];
}

- (void)shiftLeftEq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_SHIFTLEFTEQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchShiftLeftEq:)];
}

- (void)shiftRightEq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_SHIFTRIGHTEQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchShiftRightEq:)];
}

- (void)shiftRightExtEq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_SHIFTRIGHTEXTEQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchShiftRightExtEq:)];
}

- (void)andEq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_ANDEQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchAndEq:)];
}

- (void)xorEq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_XOREQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchXorEq:)];
}

- (void)orEq_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JAVASCRIPT_TOKEN_KIND_OREQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchOrEq:)];
}

- (void)assignmentOperator_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_EQUALS, 0]) {
        [PKParser_weakSelf equals_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_PLUSEQ, 0]) {
        [PKParser_weakSelf plusEq_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_MINUSEQ, 0]) {
        [PKParser_weakSelf minusEq_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_TIMESEQ, 0]) {
        [PKParser_weakSelf timesEq_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_DIVEQ, 0]) {
        [PKParser_weakSelf divEq_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_MODEQ, 0]) {
        [PKParser_weakSelf modEq_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_SHIFTLEFTEQ, 0]) {
        [PKParser_weakSelf shiftLeftEq_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_SHIFTRIGHTEQ, 0]) {
        [PKParser_weakSelf shiftRightEq_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_SHIFTRIGHTEXTEQ, 0]) {
        [PKParser_weakSelf shiftRightExtEq_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_ANDEQ, 0]) {
        [PKParser_weakSelf andEq_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_XOREQ, 0]) {
        [PKParser_weakSelf xorEq_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_OREQ, 0]) {
        [PKParser_weakSelf orEq_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'assignmentOperator'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAssignmentOperator:)];
}

- (void)relationalOperator_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_LT, 0]) {
        [PKParser_weakSelf lt_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_GT, 0]) {
        [PKParser_weakSelf gt_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_GE, 0]) {
        [PKParser_weakSelf ge_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_LE, 0]) {
        [PKParser_weakSelf le_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_INSTANCEOF, 0]) {
        [PKParser_weakSelf instanceof_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'relationalOperator'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelationalOperator:)];
}

- (void)equalityOperator_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_EQ, 0]) {
        [PKParser_weakSelf eq_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_NE, 0]) {
        [PKParser_weakSelf ne_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_IS, 0]) {
        [PKParser_weakSelf is_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_ISNOT, 0]) {
        [PKParser_weakSelf isnot_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'equalityOperator'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchEqualityOperator:)];
}

- (void)shiftOperator_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_SHIFTLEFT, 0]) {
        [PKParser_weakSelf shiftLeft_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_SHIFTRIGHT, 0]) {
        [PKParser_weakSelf shiftRight_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_SHIFTRIGHTEXT, 0]) {
        [PKParser_weakSelf shiftRightExt_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'shiftOperator'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchShiftOperator:)];
}

- (void)incrementOperator_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_PLUSPLUS, 0]) {
        [PKParser_weakSelf plusPlus_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_MINUSMINUS, 0]) {
        [PKParser_weakSelf minusMinus_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'incrementOperator'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchIncrementOperator:)];
}

- (void)unaryOperator_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_TILDE, 0]) {
        [PKParser_weakSelf tilde_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_DELETE, 0]) {
        [PKParser_weakSelf delete_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_TYPEOF, 0]) {
        [PKParser_weakSelf typeof_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_VOID, 0]) {
        [PKParser_weakSelf void_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'unaryOperator'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnaryOperator:)];
}

- (void)multiplicativeOperator_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_TIMES, 0]) {
        [PKParser_weakSelf times_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_DIV, 0]) {
        [PKParser_weakSelf div_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_MOD, 0]) {
        [PKParser_weakSelf mod_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'multiplicativeOperator'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMultiplicativeOperator:)];
}

- (void)element_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_FUNCTION, 0]) {
        [PKParser_weakSelf func_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_BREAK, JAVASCRIPT_TOKEN_KIND_CONTINUE, JAVASCRIPT_TOKEN_KIND_DELETE, JAVASCRIPT_TOKEN_KIND_FALSE, JAVASCRIPT_TOKEN_KIND_FOR, JAVASCRIPT_TOKEN_KIND_IF, JAVASCRIPT_TOKEN_KIND_KEYWORDNEW, JAVASCRIPT_TOKEN_KIND_MINUS, JAVASCRIPT_TOKEN_KIND_MINUSMINUS, JAVASCRIPT_TOKEN_KIND_NULL, JAVASCRIPT_TOKEN_KIND_OPENCURLY, JAVASCRIPT_TOKEN_KIND_OPENPAREN, JAVASCRIPT_TOKEN_KIND_PLUSPLUS, JAVASCRIPT_TOKEN_KIND_RETURN, JAVASCRIPT_TOKEN_KIND_SEMI, JAVASCRIPT_TOKEN_KIND_THIS, JAVASCRIPT_TOKEN_KIND_TILDE, JAVASCRIPT_TOKEN_KIND_TRUE, JAVASCRIPT_TOKEN_KIND_TYPEOF, JAVASCRIPT_TOKEN_KIND_UNDEFINED, JAVASCRIPT_TOKEN_KIND_VAR, JAVASCRIPT_TOKEN_KIND_VOID, JAVASCRIPT_TOKEN_KIND_WHILE, JAVASCRIPT_TOKEN_KIND_WITH, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf stmt_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'element'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchElement:)];
}

- (void)func_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf function_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_OPENPAREN block:^{ 
        [PKParser_weakSelf identifier_];
        [PKParser_weakSelf openParen_];
    } completion:^{ 
        [PKParser_weakSelf openParen_];
    }];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_CLOSEPAREN block:^{ 
        [PKParser_weakSelf paramListOpt_];
        [PKParser_weakSelf closeParen_];
    } completion:^{ 
        [PKParser_weakSelf closeParen_];
    }];
        [PKParser_weakSelf compoundStmt_];

    [self fireDelegateSelector:@selector(parser:didMatchFunc:)];
}

- (void)paramListOpt_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf paramList_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchParamListOpt:)];
}

- (void)paramList_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf identifier_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf commaIdentifier_];}]) {
        [PKParser_weakSelf commaIdentifier_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchParamList:)];
}

- (void)commaIdentifier_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf comma_];
    [PKParser_weakSelf identifier_];

    [self fireDelegateSelector:@selector(parser:didMatchCommaIdentifier:)];
}

- (void)compoundStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf openCurly_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_CLOSECURLY block:^{ 
        [PKParser_weakSelf stmts_];
        [PKParser_weakSelf closeCurly_];
    } completion:^{ 
        [PKParser_weakSelf closeCurly_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchCompoundStmt:)];
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
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf semi_];}]) {
        [PKParser_weakSelf semi_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf ifStmt_];}]) {
        [PKParser_weakSelf ifStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf ifElseStmt_];}]) {
        [PKParser_weakSelf ifElseStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf whileStmt_];}]) {
        [PKParser_weakSelf whileStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf forParenStmt_];}]) {
        [PKParser_weakSelf forParenStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf forBeginStmt_];}]) {
        [PKParser_weakSelf forBeginStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf forInStmt_];}]) {
        [PKParser_weakSelf forInStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf breakStmt_];}]) {
        [PKParser_weakSelf breakStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf continueStmt_];}]) {
        [PKParser_weakSelf continueStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf withStmt_];}]) {
        [PKParser_weakSelf withStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf returnStmt_];}]) {
        [PKParser_weakSelf returnStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf compoundStmt_];}]) {
        [PKParser_weakSelf compoundStmt_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf variablesOrExprStmt_];}]) {
        [PKParser_weakSelf variablesOrExprStmt_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'stmt'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStmt:)];
}

- (void)ifStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf if_];
    [PKParser_weakSelf condition_];
    [PKParser_weakSelf stmt_];

    [self fireDelegateSelector:@selector(parser:didMatchIfStmt:)];
}

- (void)ifElseStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf if_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_ELSE block:^{ 
        [PKParser_weakSelf condition_];
        [PKParser_weakSelf stmt_];
        [PKParser_weakSelf else_];
    } completion:^{ 
        [PKParser_weakSelf else_];
    }];
        [PKParser_weakSelf stmt_];

    [self fireDelegateSelector:@selector(parser:didMatchIfElseStmt:)];
}

- (void)whileStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf while_];
    [PKParser_weakSelf condition_];
    [PKParser_weakSelf stmt_];

    [self fireDelegateSelector:@selector(parser:didMatchWhileStmt:)];
}

- (void)forParenStmt_ {
    PKParser_weakSelfDecl;
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_SEMI block:^{ 
        [PKParser_weakSelf forParen_];
        [PKParser_weakSelf semi_];
    } completion:^{ 
        [PKParser_weakSelf semi_];
    }];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_SEMI block:^{ 
        [PKParser_weakSelf exprOpt_];
        [PKParser_weakSelf semi_];
    } completion:^{ 
        [PKParser_weakSelf semi_];
    }];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_CLOSEPAREN block:^{ 
        [PKParser_weakSelf exprOpt_];
        [PKParser_weakSelf closeParen_];
    } completion:^{ 
        [PKParser_weakSelf closeParen_];
    }];
        [PKParser_weakSelf stmt_];

    [self fireDelegateSelector:@selector(parser:didMatchForParenStmt:)];
}

- (void)forBeginStmt_ {
    PKParser_weakSelfDecl;
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_SEMI block:^{ 
        [PKParser_weakSelf forBegin_];
        [PKParser_weakSelf semi_];
    } completion:^{ 
        [PKParser_weakSelf semi_];
    }];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_SEMI block:^{ 
        [PKParser_weakSelf exprOpt_];
        [PKParser_weakSelf semi_];
    } completion:^{ 
        [PKParser_weakSelf semi_];
    }];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_CLOSEPAREN block:^{ 
        [PKParser_weakSelf exprOpt_];
        [PKParser_weakSelf closeParen_];
    } completion:^{ 
        [PKParser_weakSelf closeParen_];
    }];
        [PKParser_weakSelf stmt_];

    [self fireDelegateSelector:@selector(parser:didMatchForBeginStmt:)];
}

- (void)forInStmt_ {
    PKParser_weakSelfDecl;
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_IN block:^{ 
        [PKParser_weakSelf forBegin_];
        [PKParser_weakSelf in_];
    } completion:^{ 
        [PKParser_weakSelf in_];
    }];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_CLOSEPAREN block:^{ 
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf closeParen_];
    } completion:^{ 
        [PKParser_weakSelf closeParen_];
    }];
        [PKParser_weakSelf stmt_];

    [self fireDelegateSelector:@selector(parser:didMatchForInStmt:)];
}

- (void)breakStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf break_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_SEMI block:^{ 
        [PKParser_weakSelf semi_];
    } completion:^{ 
        [PKParser_weakSelf semi_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchBreakStmt:)];
}

- (void)continueStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf continue_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_SEMI block:^{ 
        [PKParser_weakSelf semi_];
    } completion:^{ 
        [PKParser_weakSelf semi_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchContinueStmt:)];
}

- (void)withStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf with_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_OPENPAREN block:^{ 
        [PKParser_weakSelf openParen_];
    } completion:^{ 
        [PKParser_weakSelf openParen_];
    }];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_CLOSEPAREN block:^{ 
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf closeParen_];
    } completion:^{ 
        [PKParser_weakSelf closeParen_];
    }];
        [PKParser_weakSelf stmt_];

    [self fireDelegateSelector:@selector(parser:didMatchWithStmt:)];
}

- (void)returnStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf return_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_SEMI block:^{ 
        [PKParser_weakSelf exprOpt_];
        [PKParser_weakSelf semi_];
    } completion:^{ 
        [PKParser_weakSelf semi_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchReturnStmt:)];
}

- (void)variablesOrExprStmt_ {
    PKParser_weakSelfDecl;
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_SEMI block:^{ 
        [PKParser_weakSelf variablesOrExpr_];
        [PKParser_weakSelf semi_];
    } completion:^{ 
        [PKParser_weakSelf semi_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchVariablesOrExprStmt:)];
}

- (void)condition_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf openParen_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_CLOSEPAREN block:^{ 
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf closeParen_];
    } completion:^{ 
        [PKParser_weakSelf closeParen_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchCondition:)];
}

- (void)forParen_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf for_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_OPENPAREN block:^{ 
        [PKParser_weakSelf openParen_];
    } completion:^{ 
        [PKParser_weakSelf openParen_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchForParen:)];
}

- (void)forBegin_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf forParen_];
    [PKParser_weakSelf variablesOrExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchForBegin:)];
}

- (void)variablesOrExpr_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_VAR, 0]) {
        [PKParser_weakSelf varVariables_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_DELETE, JAVASCRIPT_TOKEN_KIND_FALSE, JAVASCRIPT_TOKEN_KIND_KEYWORDNEW, JAVASCRIPT_TOKEN_KIND_MINUS, JAVASCRIPT_TOKEN_KIND_MINUSMINUS, JAVASCRIPT_TOKEN_KIND_NULL, JAVASCRIPT_TOKEN_KIND_OPENPAREN, JAVASCRIPT_TOKEN_KIND_PLUSPLUS, JAVASCRIPT_TOKEN_KIND_THIS, JAVASCRIPT_TOKEN_KIND_TILDE, JAVASCRIPT_TOKEN_KIND_TRUE, JAVASCRIPT_TOKEN_KIND_TYPEOF, JAVASCRIPT_TOKEN_KIND_UNDEFINED, JAVASCRIPT_TOKEN_KIND_VOID, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf expr_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'variablesOrExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchVariablesOrExpr:)];
}

- (void)varVariables_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf var_];
    [PKParser_weakSelf variables_];

    [self fireDelegateSelector:@selector(parser:didMatchVarVariables:)];
}

- (void)variables_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf variable_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf commaVariable_];}]) {
        [PKParser_weakSelf commaVariable_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchVariables:)];
}

- (void)commaVariable_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf comma_];
    [PKParser_weakSelf variable_];

    [self fireDelegateSelector:@selector(parser:didMatchCommaVariable:)];
}

- (void)variable_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf identifier_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf assignment_];}]) {
        [PKParser_weakSelf assignment_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchVariable:)];
}

- (void)assignment_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf equals_];
    [PKParser_weakSelf assignmentExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchAssignment:)];
}

- (void)exprOpt_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_DELETE, JAVASCRIPT_TOKEN_KIND_FALSE, JAVASCRIPT_TOKEN_KIND_KEYWORDNEW, JAVASCRIPT_TOKEN_KIND_MINUS, JAVASCRIPT_TOKEN_KIND_MINUSMINUS, JAVASCRIPT_TOKEN_KIND_NULL, JAVASCRIPT_TOKEN_KIND_OPENPAREN, JAVASCRIPT_TOKEN_KIND_PLUSPLUS, JAVASCRIPT_TOKEN_KIND_THIS, JAVASCRIPT_TOKEN_KIND_TILDE, JAVASCRIPT_TOKEN_KIND_TRUE, JAVASCRIPT_TOKEN_KIND_TYPEOF, JAVASCRIPT_TOKEN_KIND_UNDEFINED, JAVASCRIPT_TOKEN_KIND_VOID, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf expr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExprOpt:)];
}

- (void)expr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf assignmentExpr_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf commaExpr_];}]) {
        [PKParser_weakSelf commaExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)commaExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf comma_];
    [PKParser_weakSelf expr_];

    [self fireDelegateSelector:@selector(parser:didMatchCommaExpr:)];
}

- (void)assignmentExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf conditionalExpr_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf extraAssignment_];}]) {
        [PKParser_weakSelf extraAssignment_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAssignmentExpr:)];
}

- (void)extraAssignment_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf assignmentOperator_];
    [PKParser_weakSelf assignmentExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchExtraAssignment:)];
}

- (void)conditionalExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf orExpr_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf ternaryExpr_];}]) {
        [PKParser_weakSelf ternaryExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchConditionalExpr:)];
}

- (void)ternaryExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf question_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_COLON block:^{ 
        [PKParser_weakSelf assignmentExpr_];
        [PKParser_weakSelf colon_];
    } completion:^{ 
        [PKParser_weakSelf colon_];
    }];
        [PKParser_weakSelf assignmentExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchTernaryExpr:)];
}

- (void)orExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf andExpr_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf orAndExpr_];}]) {
        [PKParser_weakSelf orAndExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrExpr:)];
}

- (void)orAndExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf or_];
    [PKParser_weakSelf andExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchOrAndExpr:)];
}

- (void)andExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf bitwiseOrExpr_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf andAndExpr_];}]) {
        [PKParser_weakSelf andAndExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndExpr:)];
}

- (void)andAndExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf and_];
    [PKParser_weakSelf andExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchAndAndExpr:)];
}

- (void)bitwiseOrExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf bitwiseXorExpr_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf pipeBitwiseOrExpr_];}]) {
        [PKParser_weakSelf pipeBitwiseOrExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBitwiseOrExpr:)];
}

- (void)pipeBitwiseOrExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf pipe_];
    [PKParser_weakSelf bitwiseOrExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchPipeBitwiseOrExpr:)];
}

- (void)bitwiseXorExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf bitwiseAndExpr_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf caretBitwiseXorExpr_];}]) {
        [PKParser_weakSelf caretBitwiseXorExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBitwiseXorExpr:)];
}

- (void)caretBitwiseXorExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf caret_];
    [PKParser_weakSelf bitwiseXorExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchCaretBitwiseXorExpr:)];
}

- (void)bitwiseAndExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf equalityExpr_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf ampBitwiseAndExpression_];}]) {
        [PKParser_weakSelf ampBitwiseAndExpression_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBitwiseAndExpr:)];
}

- (void)ampBitwiseAndExpression_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf amp_];
    [PKParser_weakSelf bitwiseAndExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchAmpBitwiseAndExpression:)];
}

- (void)equalityExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf relationalExpr_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf equalityOpEqualityExpr_];}]) {
        [PKParser_weakSelf equalityOpEqualityExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchEqualityExpr:)];
}

- (void)equalityOpEqualityExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf equalityOperator_];
    [PKParser_weakSelf equalityExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchEqualityOpEqualityExpr:)];
}

- (void)relationalExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf shiftExpr_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf relationalOperator_];[PKParser_weakSelf shiftExpr_];}]) {
        [PKParser_weakSelf relationalOperator_];
        [PKParser_weakSelf shiftExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelationalExpr:)];
}

- (void)shiftExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf additiveExpr_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf shiftOpShiftExpr_];}]) {
        [PKParser_weakSelf shiftOpShiftExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchShiftExpr:)];
}

- (void)shiftOpShiftExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf shiftOperator_];
    [PKParser_weakSelf shiftExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchShiftOpShiftExpr:)];
}

- (void)additiveExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf multiplicativeExpr_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf plusOrMinusExpr_];}]) {
        [PKParser_weakSelf plusOrMinusExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAdditiveExpr:)];
}

- (void)plusOrMinusExpr_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_PLUS, 0]) {
        [PKParser_weakSelf plusExpr_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_MINUS, 0]) {
        [PKParser_weakSelf minusExpr_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'plusOrMinusExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPlusOrMinusExpr:)];
}

- (void)plusExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf plus_];
    [PKParser_weakSelf additiveExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchPlusExpr:)];
}

- (void)minusExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf minus_];
    [PKParser_weakSelf additiveExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchMinusExpr:)];
}

- (void)multiplicativeExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf unaryExpr_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf multiplicativeOperator_];[PKParser_weakSelf multiplicativeExpr_];}]) {
        [PKParser_weakSelf multiplicativeOperator_];
        [PKParser_weakSelf multiplicativeExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMultiplicativeExpr:)];
}

- (void)unaryExpr_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf memberExpr_];}]) {
        [PKParser_weakSelf memberExpr_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf unaryExpr1_];}]) {
        [PKParser_weakSelf unaryExpr1_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf unaryExpr2_];}]) {
        [PKParser_weakSelf unaryExpr2_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf unaryExpr3_];}]) {
        [PKParser_weakSelf unaryExpr3_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf unaryExpr4_];}]) {
        [PKParser_weakSelf unaryExpr4_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf unaryExpr6_];}]) {
        [PKParser_weakSelf unaryExpr6_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'unaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr:)];
}

- (void)unaryExpr1_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf unaryOperator_];
    [PKParser_weakSelf unaryExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr1:)];
}

- (void)unaryExpr2_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf minus_];
    [PKParser_weakSelf unaryExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr2:)];
}

- (void)unaryExpr3_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf incrementOperator_];
    [PKParser_weakSelf memberExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr3:)];
}

- (void)unaryExpr4_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf memberExpr_];
    [PKParser_weakSelf incrementOperator_];

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr4:)];
}

- (void)callNewExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf keywordNew_];
    [PKParser_weakSelf constructor_];

    [self fireDelegateSelector:@selector(parser:didMatchCallNewExpr:)];
}

- (void)unaryExpr6_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf delete_];
    [PKParser_weakSelf memberExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr6:)];
}

- (void)constructor_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf this_];[self tryAndRecover:JAVASCRIPT_TOKEN_KIND_DOT block:^{ [PKParser_weakSelf dot_];} completion:^{ [PKParser_weakSelf dot_];}];}]) {
        [PKParser_weakSelf this_];
        [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_DOT block:^{ 
            [PKParser_weakSelf dot_];
        } completion:^{ 
            [PKParser_weakSelf dot_];
        }];
    }
    [PKParser_weakSelf constructorCall_];

    [self fireDelegateSelector:@selector(parser:didMatchConstructor:)];
}

- (void)constructorCall_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf identifier_];
    if ([PKParser_weakSelf speculate:^{ if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_OPENPAREN, 0]) {[PKParser_weakSelf parenArgListParen_];} else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_DOT, 0]) {[PKParser_weakSelf dot_];[PKParser_weakSelf constructorCall_];} else {[PKParser_weakSelf raise:@"No viable alternative found in rule 'constructorCall'."];}}]) {
        if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_OPENPAREN, 0]) {
            [PKParser_weakSelf parenArgListParen_];
        } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_DOT, 0]) {
            [PKParser_weakSelf dot_];
            [PKParser_weakSelf constructorCall_];
        } else {
            [PKParser_weakSelf raise:@"No viable alternative found in rule 'constructorCall'."];
        }
    }

    [self fireDelegateSelector:@selector(parser:didMatchConstructorCall:)];
}

- (void)parenArgListParen_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf openParen_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_CLOSEPAREN block:^{ 
        [PKParser_weakSelf argListOpt_];
        [PKParser_weakSelf closeParen_];
    } completion:^{ 
        [PKParser_weakSelf closeParen_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchParenArgListParen:)];
}

- (void)memberExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf primaryExpr_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf dotBracketOrParenExpr_];}]) {
        [PKParser_weakSelf dotBracketOrParenExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMemberExpr:)];
}

- (void)dotBracketOrParenExpr_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_DOT, 0]) {
        [PKParser_weakSelf dotMemberExpr_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_OPENBRACKET, 0]) {
        [PKParser_weakSelf bracketMemberExpr_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_OPENPAREN, 0]) {
        [PKParser_weakSelf parenMemberExpr_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'dotBracketOrParenExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchDotBracketOrParenExpr:)];
}

- (void)dotMemberExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf dot_];
    [PKParser_weakSelf memberExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchDotMemberExpr:)];
}

- (void)bracketMemberExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf openBracket_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_CLOSEBRACKET block:^{ 
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf closeBracket_];
    } completion:^{ 
        [PKParser_weakSelf closeBracket_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchBracketMemberExpr:)];
}

- (void)parenMemberExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf openParen_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_CLOSEPAREN block:^{ 
        [PKParser_weakSelf argListOpt_];
        [PKParser_weakSelf closeParen_];
    } completion:^{ 
        [PKParser_weakSelf closeParen_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchParenMemberExpr:)];
}

- (void)argListOpt_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf argList_];}]) {
        [PKParser_weakSelf argList_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchArgListOpt:)];
}

- (void)argList_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf assignmentExpr_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf commaAssignmentExpr_];}]) {
        [PKParser_weakSelf commaAssignmentExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchArgList:)];
}

- (void)commaAssignmentExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf comma_];
    [PKParser_weakSelf assignmentExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchCommaAssignmentExpr:)];
}

- (void)primaryExpr_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_KEYWORDNEW, 0]) {
        [PKParser_weakSelf callNewExpr_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_OPENPAREN, 0]) {
        [PKParser_weakSelf parenExprParen_];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf identifier_];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [PKParser_weakSelf numLiteral_];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [PKParser_weakSelf stringLiteral_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_FALSE, 0]) {
        [PKParser_weakSelf false_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_TRUE, 0]) {
        [PKParser_weakSelf true_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_NULL, 0]) {
        [PKParser_weakSelf null_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_UNDEFINED, 0]) {
        [PKParser_weakSelf undefined_];
    } else if ([PKParser_weakSelf predicts:JAVASCRIPT_TOKEN_KIND_THIS, 0]) {
        [PKParser_weakSelf this_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'primaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimaryExpr:)];
}

- (void)parenExprParen_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf openParen_];
    [self tryAndRecover:JAVASCRIPT_TOKEN_KIND_CLOSEPAREN block:^{ 
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf closeParen_];
    } completion:^{ 
        [PKParser_weakSelf closeParen_];
    }];

    [self fireDelegateSelector:@selector(parser:didMatchParenExprParen:)];
}

- (void)identifier_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchWord:NO];

    [self fireDelegateSelector:@selector(parser:didMatchIdentifier:)];
}

- (void)numLiteral_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchNumber:NO];

    [self fireDelegateSelector:@selector(parser:didMatchNumLiteral:)];
}

- (void)stringLiteral_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchQuotedString:NO];

    [self fireDelegateSelector:@selector(parser:didMatchStringLiteral:)];
}

@end