#import "ExpressionActionsParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface ExpressionActionsParser ()

@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *orExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *orTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *andExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *andTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *relExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *relOp_memo;
@property (nonatomic, retain) NSMutableDictionary *relOpTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *callExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *argList_memo;
@property (nonatomic, retain) NSMutableDictionary *primary_memo;
@property (nonatomic, retain) NSMutableDictionary *atom_memo;
@property (nonatomic, retain) NSMutableDictionary *obj_memo;
@property (nonatomic, retain) NSMutableDictionary *id_memo;
@property (nonatomic, retain) NSMutableDictionary *member_memo;
@property (nonatomic, retain) NSMutableDictionary *literal_memo;
@property (nonatomic, retain) NSMutableDictionary *bool_memo;
@end

@implementation ExpressionActionsParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"expr";
        self.tokenKindTab[@"no"] = @(EXPRESSIONACTIONS_TOKEN_KIND_NO);
        self.tokenKindTab[@"NO"] = @(EXPRESSIONACTIONS_TOKEN_KIND_NO_UPPER);
        self.tokenKindTab[@">="] = @(EXPRESSIONACTIONS_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@","] = @(EXPRESSIONACTIONS_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"or"] = @(EXPRESSIONACTIONS_TOKEN_KIND_OR);
        self.tokenKindTab[@"<"] = @(EXPRESSIONACTIONS_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"<="] = @(EXPRESSIONACTIONS_TOKEN_KIND_LE_SYM);
        self.tokenKindTab[@"="] = @(EXPRESSIONACTIONS_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"."] = @(EXPRESSIONACTIONS_TOKEN_KIND_DOT);
        self.tokenKindTab[@">"] = @(EXPRESSIONACTIONS_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"and"] = @(EXPRESSIONACTIONS_TOKEN_KIND_AND);
        self.tokenKindTab[@"("] = @(EXPRESSIONACTIONS_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"yes"] = @(EXPRESSIONACTIONS_TOKEN_KIND_YES);
        self.tokenKindTab[@")"] = @(EXPRESSIONACTIONS_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"!="] = @(EXPRESSIONACTIONS_TOKEN_KIND_NOT_EQUAL);
        self.tokenKindTab[@"YES"] = @(EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER);

        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_NO] = @"no";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_NO_UPPER] = @"NO";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_GE_SYM] = @">=";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_LE_SYM] = @"<=";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_AND] = @"and";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_YES] = @"yes";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_NOT_EQUAL] = @"!=";
        self.tokenKindNameTab[EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER] = @"YES";

        self.expr_memo = [NSMutableDictionary dictionary];
        self.orExpr_memo = [NSMutableDictionary dictionary];
        self.orTerm_memo = [NSMutableDictionary dictionary];
        self.andExpr_memo = [NSMutableDictionary dictionary];
        self.andTerm_memo = [NSMutableDictionary dictionary];
        self.relExpr_memo = [NSMutableDictionary dictionary];
        self.relOp_memo = [NSMutableDictionary dictionary];
        self.relOpTerm_memo = [NSMutableDictionary dictionary];
        self.callExpr_memo = [NSMutableDictionary dictionary];
        self.argList_memo = [NSMutableDictionary dictionary];
        self.primary_memo = [NSMutableDictionary dictionary];
        self.atom_memo = [NSMutableDictionary dictionary];
        self.obj_memo = [NSMutableDictionary dictionary];
        self.id_memo = [NSMutableDictionary dictionary];
        self.member_memo = [NSMutableDictionary dictionary];
        self.literal_memo = [NSMutableDictionary dictionary];
        self.bool_memo = [NSMutableDictionary dictionary];
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
    self.relOpTerm_memo = nil;
    self.callExpr_memo = nil;
    self.argList_memo = nil;
    self.primary_memo = nil;
    self.atom_memo = nil;
    self.obj_memo = nil;
    self.id_memo = nil;
    self.member_memo = nil;
    self.literal_memo = nil;
    self.bool_memo = nil;

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
    [_relOpTerm_memo removeAllObjects];
    [_callExpr_memo removeAllObjects];
    [_argList_memo removeAllObjects];
    [_primary_memo removeAllObjects];
    [_atom_memo removeAllObjects];
    [_obj_memo removeAllObjects];
    [_id_memo removeAllObjects];
    [_member_memo removeAllObjects];
    [_literal_memo removeAllObjects];
    [_bool_memo removeAllObjects];
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
    [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_OR discard:YES];
    [PKParser_weakSelf andExpr_];
    [PKParser_weakSelf execute:^{
    
	BOOL rhs = POP_BOOL();
	BOOL lhs = POP_BOOL();
	PUSH_BOOL(lhs || rhs);

    }];

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
    [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_AND discard:YES];
    [PKParser_weakSelf relExpr_];
    [PKParser_weakSelf execute:^{
    
	BOOL rhs = POP_BOOL();
	BOOL lhs = POP_BOOL();
	PUSH_BOOL(lhs && rhs);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchAndTerm:)];
}

- (void)andTerm_ {
    [self parseRule:@selector(__andTerm) withMemo:_andTerm_memo];
}

- (void)__relExpr {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf callExpr_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf relOpTerm_];}]) {
        [PKParser_weakSelf relOpTerm_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelExpr:)];
}

- (void)relExpr_ {
    [self parseRule:@selector(__relExpr) withMemo:_relExpr_memo];
}

- (void)__relOp {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_LT_SYM, 0]) {
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_LT_SYM discard:NO];
    } else if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_GT_SYM, 0]) {
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_GT_SYM discard:NO];
    } else if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_EQUALS, 0]) {
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_EQUALS discard:NO];
    } else if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_NOT_EQUAL, 0]) {
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_NOT_EQUAL discard:NO];
    } else if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_LE_SYM, 0]) {
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_LE_SYM discard:NO];
    } else if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_GE_SYM, 0]) {
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_GE_SYM discard:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'relOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelOp:)];
}

- (void)relOp_ {
    [self parseRule:@selector(__relOp) withMemo:_relOp_memo];
}

- (void)__relOpTerm {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf relOp_];
    [PKParser_weakSelf callExpr_];
    [PKParser_weakSelf execute:^{
    
	NSInteger rhs = POP_INT();
	NSString  *op = POP_STR();
	NSInteger lhs = POP_INT();

	     if (EQ(op, @"<"))  PUSH_BOOL(lhs <  rhs);
	else if (EQ(op, @">"))  PUSH_BOOL(lhs >  rhs);
	else if (EQ(op, @"="))  PUSH_BOOL(lhs == rhs);
	else if (EQ(op, @"!=")) PUSH_BOOL(lhs != rhs);
	else if (EQ(op, @"<=")) PUSH_BOOL(lhs <= rhs);
	else if (EQ(op, @">=")) PUSH_BOOL(lhs >= rhs);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchRelOpTerm:)];
}

- (void)relOpTerm_ {
    [self parseRule:@selector(__relOpTerm) withMemo:_relOpTerm_memo];
}

- (void)__callExpr {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf primary_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_OPEN_PAREN discard:NO];if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf argList_];}]) {[PKParser_weakSelf argList_];}[PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_CLOSE_PAREN discard:NO];}]) {
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_OPEN_PAREN discard:NO];
        if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf argList_];}]) {
            [PKParser_weakSelf argList_];
        }
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_CLOSE_PAREN discard:NO];
    }

    [self fireDelegateSelector:@selector(parser:didMatchCallExpr:)];
}

- (void)callExpr_ {
    [self parseRule:@selector(__callExpr) withMemo:_callExpr_memo];
}

- (void)__argList {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf atom_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_COMMA discard:NO];[PKParser_weakSelf atom_];}]) {
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_COMMA discard:NO];
        [PKParser_weakSelf atom_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchArgList:)];
}

- (void)argList_ {
    [self parseRule:@selector(__argList) withMemo:_argList_memo];
}

- (void)__primary {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_NO, EXPRESSIONACTIONS_TOKEN_KIND_NO_UPPER, EXPRESSIONACTIONS_TOKEN_KIND_YES, EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf atom_];
    } else if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_OPEN_PAREN, 0]) {
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_OPEN_PAREN discard:NO];
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_CLOSE_PAREN discard:NO];
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
    } else if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_NO, EXPRESSIONACTIONS_TOKEN_KIND_NO_UPPER, EXPRESSIONACTIONS_TOKEN_KIND_YES, EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
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
    [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_DOT discard:NO];
    [PKParser_weakSelf id_];

    [self fireDelegateSelector:@selector(parser:didMatchMember:)];
}

- (void)member_ {
    [self parseRule:@selector(__member) withMemo:_member_memo];
}

- (void)__literal {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_NO, EXPRESSIONACTIONS_TOKEN_KIND_NO_UPPER, EXPRESSIONACTIONS_TOKEN_KIND_YES, EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER, 0]) {
        [self testAndThrow:(id)^{ return LA(1) != EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER; }]; 
        [PKParser_weakSelf bool_];
        [PKParser_weakSelf execute:^{
         PUSH_BOOL(EQ_IGNORE_CASE(POP_STR(), @"yes")); 
        }];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [PKParser_weakSelf matchNumber:NO];
        [PKParser_weakSelf execute:^{
         PUSH_DOUBLE(POP_DOUBLE()); 
        }];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [PKParser_weakSelf matchQuotedString:NO];
        [PKParser_weakSelf execute:^{
         PUSH(POP_STR()); 
        }];
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
    if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_YES, 0]) {
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_YES discard:NO];
    } else if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER, 0]) {
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER discard:NO];
    } else if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_NO, 0]) {
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_NO discard:NO];
    } else if ([PKParser_weakSelf predicts:EXPRESSIONACTIONS_TOKEN_KIND_NO_UPPER, 0]) {
        [self testAndThrow:(id)^{ return NE(LS(1), @"NO"); }]; 
        [PKParser_weakSelf match:EXPRESSIONACTIONS_TOKEN_KIND_NO_UPPER discard:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'bool'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBool:)];
}

- (void)bool_ {
    [self parseRule:@selector(__bool) withMemo:_bool_memo];
}

@end