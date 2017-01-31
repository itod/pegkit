#import "ExpressionParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface ExpressionParser ()

@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *orExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *orTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *andExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *andTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *relExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *relOp_memo;
@property (nonatomic, retain) NSMutableDictionary *callExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *argList_memo;
@property (nonatomic, retain) NSMutableDictionary *primary_memo;
@property (nonatomic, retain) NSMutableDictionary *atom_memo;
@property (nonatomic, retain) NSMutableDictionary *obj_memo;
@property (nonatomic, retain) NSMutableDictionary *id_memo;
@property (nonatomic, retain) NSMutableDictionary *member_memo;
@property (nonatomic, retain) NSMutableDictionary *literal_memo;
@property (nonatomic, retain) NSMutableDictionary *bool_memo;
@property (nonatomic, retain) NSMutableDictionary *lt_memo;
@property (nonatomic, retain) NSMutableDictionary *gt_memo;
@property (nonatomic, retain) NSMutableDictionary *eq_memo;
@property (nonatomic, retain) NSMutableDictionary *ne_memo;
@property (nonatomic, retain) NSMutableDictionary *le_memo;
@property (nonatomic, retain) NSMutableDictionary *ge_memo;
@property (nonatomic, retain) NSMutableDictionary *openParen_memo;
@property (nonatomic, retain) NSMutableDictionary *closeParen_memo;
@property (nonatomic, retain) NSMutableDictionary *yes_memo;
@property (nonatomic, retain) NSMutableDictionary *no_memo;
@property (nonatomic, retain) NSMutableDictionary *dot_memo;
@property (nonatomic, retain) NSMutableDictionary *comma_memo;
@property (nonatomic, retain) NSMutableDictionary *or_memo;
@property (nonatomic, retain) NSMutableDictionary *and_memo;
@end

@implementation ExpressionParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"expr";
        self.tokenKindTab[@">="] = @(EXPRESSION_TOKEN_KIND_GE);
        self.tokenKindTab[@","] = @(EXPRESSION_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"or"] = @(EXPRESSION_TOKEN_KIND_OR);
        self.tokenKindTab[@"<"] = @(EXPRESSION_TOKEN_KIND_LT);
        self.tokenKindTab[@"<="] = @(EXPRESSION_TOKEN_KIND_LE);
        self.tokenKindTab[@"="] = @(EXPRESSION_TOKEN_KIND_EQ);
        self.tokenKindTab[@"."] = @(EXPRESSION_TOKEN_KIND_DOT);
        self.tokenKindTab[@">"] = @(EXPRESSION_TOKEN_KIND_GT);
        self.tokenKindTab[@"("] = @(EXPRESSION_TOKEN_KIND_OPENPAREN);
        self.tokenKindTab[@"yes"] = @(EXPRESSION_TOKEN_KIND_YES);
        self.tokenKindTab[@"no"] = @(EXPRESSION_TOKEN_KIND_NO);
        self.tokenKindTab[@")"] = @(EXPRESSION_TOKEN_KIND_CLOSEPAREN);
        self.tokenKindTab[@"!="] = @(EXPRESSION_TOKEN_KIND_NE);
        self.tokenKindTab[@"and"] = @(EXPRESSION_TOKEN_KIND_AND);

        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_GE] = @">=";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_LT] = @"<";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_LE] = @"<=";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_EQ] = @"=";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_GT] = @">";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_OPENPAREN] = @"(";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_YES] = @"yes";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_NO] = @"no";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_CLOSEPAREN] = @")";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_NE] = @"!=";
        self.tokenKindNameTab[EXPRESSION_TOKEN_KIND_AND] = @"and";

        self.expr_memo = [NSMutableDictionary dictionary];
        self.orExpr_memo = [NSMutableDictionary dictionary];
        self.orTerm_memo = [NSMutableDictionary dictionary];
        self.andExpr_memo = [NSMutableDictionary dictionary];
        self.andTerm_memo = [NSMutableDictionary dictionary];
        self.relExpr_memo = [NSMutableDictionary dictionary];
        self.relOp_memo = [NSMutableDictionary dictionary];
        self.callExpr_memo = [NSMutableDictionary dictionary];
        self.argList_memo = [NSMutableDictionary dictionary];
        self.primary_memo = [NSMutableDictionary dictionary];
        self.atom_memo = [NSMutableDictionary dictionary];
        self.obj_memo = [NSMutableDictionary dictionary];
        self.id_memo = [NSMutableDictionary dictionary];
        self.member_memo = [NSMutableDictionary dictionary];
        self.literal_memo = [NSMutableDictionary dictionary];
        self.bool_memo = [NSMutableDictionary dictionary];
        self.lt_memo = [NSMutableDictionary dictionary];
        self.gt_memo = [NSMutableDictionary dictionary];
        self.eq_memo = [NSMutableDictionary dictionary];
        self.ne_memo = [NSMutableDictionary dictionary];
        self.le_memo = [NSMutableDictionary dictionary];
        self.ge_memo = [NSMutableDictionary dictionary];
        self.openParen_memo = [NSMutableDictionary dictionary];
        self.closeParen_memo = [NSMutableDictionary dictionary];
        self.yes_memo = [NSMutableDictionary dictionary];
        self.no_memo = [NSMutableDictionary dictionary];
        self.dot_memo = [NSMutableDictionary dictionary];
        self.comma_memo = [NSMutableDictionary dictionary];
        self.or_memo = [NSMutableDictionary dictionary];
        self.and_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.expr_memo = nil;
    self.orExpr_memo = nil;
    self.orTerm_memo = nil;
    self.andExpr_memo = nil;
    self.andTerm_memo = nil;
    self.relExpr_memo = nil;
    self.relOp_memo = nil;
    self.callExpr_memo = nil;
    self.argList_memo = nil;
    self.primary_memo = nil;
    self.atom_memo = nil;
    self.obj_memo = nil;
    self.id_memo = nil;
    self.member_memo = nil;
    self.literal_memo = nil;
    self.bool_memo = nil;
    self.lt_memo = nil;
    self.gt_memo = nil;
    self.eq_memo = nil;
    self.ne_memo = nil;
    self.le_memo = nil;
    self.ge_memo = nil;
    self.openParen_memo = nil;
    self.closeParen_memo = nil;
    self.yes_memo = nil;
    self.no_memo = nil;
    self.dot_memo = nil;
    self.comma_memo = nil;
    self.or_memo = nil;
    self.and_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_expr_memo removeAllObjects];
    [_orExpr_memo removeAllObjects];
    [_orTerm_memo removeAllObjects];
    [_andExpr_memo removeAllObjects];
    [_andTerm_memo removeAllObjects];
    [_relExpr_memo removeAllObjects];
    [_relOp_memo removeAllObjects];
    [_callExpr_memo removeAllObjects];
    [_argList_memo removeAllObjects];
    [_primary_memo removeAllObjects];
    [_atom_memo removeAllObjects];
    [_obj_memo removeAllObjects];
    [_id_memo removeAllObjects];
    [_member_memo removeAllObjects];
    [_literal_memo removeAllObjects];
    [_bool_memo removeAllObjects];
    [_lt_memo removeAllObjects];
    [_gt_memo removeAllObjects];
    [_eq_memo removeAllObjects];
    [_ne_memo removeAllObjects];
    [_le_memo removeAllObjects];
    [_ge_memo removeAllObjects];
    [_openParen_memo removeAllObjects];
    [_closeParen_memo removeAllObjects];
    [_yes_memo removeAllObjects];
    [_no_memo removeAllObjects];
    [_dot_memo removeAllObjects];
    [_comma_memo removeAllObjects];
    [_or_memo removeAllObjects];
    [_and_memo removeAllObjects];
}

- (void)start {
    PKParser_weakSelfDecl;

    [PKParser_weakSelf expr_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)__expr {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf execute:^{
    
    PKTokenizer *t = self.tokenizer;
    [t.symbolState add:@"!="];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];

    }];
    [PKParser_weakSelf orExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__orExpr {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf andExpr_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf orTerm_];}]) {
        [PKParser_weakSelf orTerm_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrExpr:)];
}

- (void)orExpr_ {
    [self parseRule:@selector(__orExpr) withMemo:_orExpr_memo];
}

- (void)__orTerm {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf or_];
    [PKParser_weakSelf andExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchOrTerm:)];
}

- (void)orTerm_ {
    [self parseRule:@selector(__orTerm) withMemo:_orTerm_memo];
}

- (void)__andExpr {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf relExpr_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf andTerm_];}]) {
        [PKParser_weakSelf andTerm_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndExpr:)];
}

- (void)andExpr_ {
    [self parseRule:@selector(__andExpr) withMemo:_andExpr_memo];
}

- (void)__andTerm {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf and_];
    [PKParser_weakSelf relExpr_];

    [self fireDelegateSelector:@selector(parser:didMatchAndTerm:)];
}

- (void)andTerm_ {
    [self parseRule:@selector(__andTerm) withMemo:_andTerm_memo];
}

- (void)__relExpr {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf callExpr_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf relOp_];[PKParser_weakSelf callExpr_];}]) {
        [PKParser_weakSelf relOp_];
        [PKParser_weakSelf callExpr_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelExpr:)];
}

- (void)relExpr_ {
    [self parseRule:@selector(__relExpr) withMemo:_relExpr_memo];
}

- (void)__relOp {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:EXPRESSION_TOKEN_KIND_LT, 0]) {
        [PKParser_weakSelf lt_];
    } else if ([PKParser_weakSelf predicts:EXPRESSION_TOKEN_KIND_GT, 0]) {
        [PKParser_weakSelf gt_];
    } else if ([PKParser_weakSelf predicts:EXPRESSION_TOKEN_KIND_EQ, 0]) {
        [PKParser_weakSelf eq_];
    } else if ([PKParser_weakSelf predicts:EXPRESSION_TOKEN_KIND_NE, 0]) {
        [PKParser_weakSelf ne_];
    } else if ([PKParser_weakSelf predicts:EXPRESSION_TOKEN_KIND_LE, 0]) {
        [PKParser_weakSelf le_];
    } else if ([PKParser_weakSelf predicts:EXPRESSION_TOKEN_KIND_GE, 0]) {
        [PKParser_weakSelf ge_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'relOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelOp:)];
}

- (void)relOp_ {
    [self parseRule:@selector(__relOp) withMemo:_relOp_memo];
}

- (void)__callExpr {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf primary_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf openParen_];if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf argList_];}]) {[PKParser_weakSelf argList_];}[PKParser_weakSelf closeParen_];}]) {
        [PKParser_weakSelf openParen_];
        if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf argList_];}]) {
            [PKParser_weakSelf argList_];
        }
        [PKParser_weakSelf closeParen_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchCallExpr:)];
}

- (void)callExpr_ {
    [self parseRule:@selector(__callExpr) withMemo:_callExpr_memo];
}

- (void)__argList {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf atom_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf comma_];[PKParser_weakSelf atom_];}]) {
        [PKParser_weakSelf comma_];
        [PKParser_weakSelf atom_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchArgList:)];
}

- (void)argList_ {
    [self parseRule:@selector(__argList) withMemo:_argList_memo];
}

- (void)__primary {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:EXPRESSION_TOKEN_KIND_NO, EXPRESSION_TOKEN_KIND_YES, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf atom_];
    } else if ([PKParser_weakSelf predicts:EXPRESSION_TOKEN_KIND_OPENPAREN, 0]) {
        [PKParser_weakSelf openParen_];
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf closeParen_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'primary'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimary:)];
}

- (void)primary_ {
    [self parseRule:@selector(__primary) withMemo:_primary_memo];
}

- (void)__atom {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf obj_];
    } else if ([PKParser_weakSelf predicts:EXPRESSION_TOKEN_KIND_NO, EXPRESSION_TOKEN_KIND_YES, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [PKParser_weakSelf literal_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'atom'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)atom_ {
    [self parseRule:@selector(__atom) withMemo:_atom_memo];
}

- (void)__obj {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf id_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf member_];}]) {
        [PKParser_weakSelf member_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchObj:)];
}

- (void)obj_ {
    [self parseRule:@selector(__obj) withMemo:_obj_memo];
}

- (void)__id {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchWord:NO];

    [self fireDelegateSelector:@selector(parser:didMatchId:)];
}

- (void)id_ {
    [self parseRule:@selector(__id) withMemo:_id_memo];
}

- (void)__member {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf dot_];
    [PKParser_weakSelf id_];

    [self fireDelegateSelector:@selector(parser:didMatchMember:)];
}

- (void)member_ {
    [self parseRule:@selector(__member) withMemo:_member_memo];
}

- (void)__literal {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [PKParser_weakSelf matchQuotedString:NO];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [PKParser_weakSelf matchNumber:NO];
    } else if ([PKParser_weakSelf predicts:EXPRESSION_TOKEN_KIND_NO, EXPRESSION_TOKEN_KIND_YES, 0]) {
        [PKParser_weakSelf bool_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'literal'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)literal_ {
    [self parseRule:@selector(__literal) withMemo:_literal_memo];
}

- (void)__bool {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:EXPRESSION_TOKEN_KIND_YES, 0]) {
        [PKParser_weakSelf yes_];
    } else if ([PKParser_weakSelf predicts:EXPRESSION_TOKEN_KIND_NO, 0]) {
        [PKParser_weakSelf no_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'bool'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBool:)];
}

- (void)bool_ {
    [self parseRule:@selector(__bool) withMemo:_bool_memo];
}

- (void)__lt {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_LT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchLt:)];
}

- (void)lt_ {
    [self parseRule:@selector(__lt) withMemo:_lt_memo];
}

- (void)__gt {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_GT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchGt:)];
}

- (void)gt_ {
    [self parseRule:@selector(__gt) withMemo:_gt_memo];
}

- (void)__eq {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_EQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)eq_ {
    [self parseRule:@selector(__eq) withMemo:_eq_memo];
}

- (void)__ne {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_NE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchNe:)];
}

- (void)ne_ {
    [self parseRule:@selector(__ne) withMemo:_ne_memo];
}

- (void)__le {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_LE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchLe:)];
}

- (void)le_ {
    [self parseRule:@selector(__le) withMemo:_le_memo];
}

- (void)__ge {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_GE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchGe:)];
}

- (void)ge_ {
    [self parseRule:@selector(__ge) withMemo:_ge_memo];
}

- (void)__openParen {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_OPENPAREN discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchOpenParen:)];
}

- (void)openParen_ {
    [self parseRule:@selector(__openParen) withMemo:_openParen_memo];
}

- (void)__closeParen {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_CLOSEPAREN discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchCloseParen:)];
}

- (void)closeParen_ {
    [self parseRule:@selector(__closeParen) withMemo:_closeParen_memo];
}

- (void)__yes {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_YES discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchYes:)];
}

- (void)yes_ {
    [self parseRule:@selector(__yes) withMemo:_yes_memo];
}

- (void)__no {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_NO discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchNo:)];
}

- (void)no_ {
    [self parseRule:@selector(__no) withMemo:_no_memo];
}

- (void)__dot {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_DOT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchDot:)];
}

- (void)dot_ {
    [self parseRule:@selector(__dot) withMemo:_dot_memo];
}

- (void)__comma {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_COMMA discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchComma:)];
}

- (void)comma_ {
    [self parseRule:@selector(__comma) withMemo:_comma_memo];
}

- (void)__or {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_OR discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchOr:)];
}

- (void)or_ {
    [self parseRule:@selector(__or) withMemo:_or_memo];
}

- (void)__and {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:EXPRESSION_TOKEN_KIND_AND discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchAnd:)];
}

- (void)and_ {
    [self parseRule:@selector(__and) withMemo:_and_memo];
}

@end