#import "ExpressionActionsParser.h"
#import <PEGKit/PEGKit.h>


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

    [self expr_]; 
    [self matchEOF:YES]; 

}

- (void)__expr {
    
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;
    [t.symbolState add:@"!="];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];

    }];
    [self orExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__orExpr {
    
    [self andExpr_]; 
    while ([self speculate:^{ [self orTerm_]; }]) {
        [self orTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrExpr:)];
}

- (void)orExpr_ {
    [self parseRule:@selector(__orExpr) withMemo:_orExpr_memo];
}

- (void)__orTerm {
    
    [self match:EXPRESSIONACTIONS_TOKEN_KIND_OR discard:YES]; 
    [self andExpr_]; 
    [self execute:^{
    
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
    
    [self relExpr_]; 
    while ([self speculate:^{ [self andTerm_]; }]) {
        [self andTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndExpr:)];
}

- (void)andExpr_ {
    [self parseRule:@selector(__andExpr) withMemo:_andExpr_memo];
}

- (void)__andTerm {
    
    [self match:EXPRESSIONACTIONS_TOKEN_KIND_AND discard:YES]; 
    [self relExpr_]; 
    [self execute:^{
    
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
    
    [self callExpr_]; 
    while ([self speculate:^{ [self relOpTerm_]; }]) {
        [self relOpTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelExpr:)];
}

- (void)relExpr_ {
    [self parseRule:@selector(__relExpr) withMemo:_relExpr_memo];
}

- (void)__relOp {
    
    if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_LT_SYM, 0]) {
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_LT_SYM discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_GT_SYM, 0]) {
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_GT_SYM discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_EQUALS, 0]) {
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_EQUALS discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_NOT_EQUAL, 0]) {
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_NOT_EQUAL discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_LE_SYM, 0]) {
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_LE_SYM discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_GE_SYM, 0]) {
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_GE_SYM discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'relOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelOp:)];
}

- (void)relOp_ {
    [self parseRule:@selector(__relOp) withMemo:_relOp_memo];
}

- (void)__relOpTerm {
    
    [self relOp_]; 
    [self callExpr_]; 
    [self execute:^{
    
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
    
    [self primary_]; 
    if ([self speculate:^{ [self match:EXPRESSIONACTIONS_TOKEN_KIND_OPEN_PAREN discard:NO]; if ([self speculate:^{ [self argList_]; }]) {[self argList_]; }[self match:EXPRESSIONACTIONS_TOKEN_KIND_CLOSE_PAREN discard:NO]; }]) {
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_OPEN_PAREN discard:NO]; 
        if ([self speculate:^{ [self argList_]; }]) {
            [self argList_]; 
        }
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchCallExpr:)];
}

- (void)callExpr_ {
    [self parseRule:@selector(__callExpr) withMemo:_callExpr_memo];
}

- (void)__argList {
    
    [self atom_]; 
    while ([self speculate:^{ [self match:EXPRESSIONACTIONS_TOKEN_KIND_COMMA discard:NO]; [self atom_]; }]) {
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_COMMA discard:NO]; 
        [self atom_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchArgList:)];
}

- (void)argList_ {
    [self parseRule:@selector(__argList) withMemo:_argList_memo];
}

- (void)__primary {
    
    if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_NO, EXPRESSIONACTIONS_TOKEN_KIND_NO_UPPER, EXPRESSIONACTIONS_TOKEN_KIND_YES, EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self atom_]; 
    } else if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_OPEN_PAREN discard:NO]; 
        [self expr_]; 
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primary'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimary:)];
}

- (void)primary_ {
    [self parseRule:@selector(__primary) withMemo:_primary_memo];
}

- (void)__atom {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self obj_]; 
    } else if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_NO, EXPRESSIONACTIONS_TOKEN_KIND_NO_UPPER, EXPRESSIONACTIONS_TOKEN_KIND_YES, EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self literal_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'atom'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)atom_ {
    [self parseRule:@selector(__atom) withMemo:_atom_memo];
}

- (void)__obj {
    
    [self id_]; 
    while ([self speculate:^{ [self member_]; }]) {
        [self member_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchObj:)];
}

- (void)obj_ {
    [self parseRule:@selector(__obj) withMemo:_obj_memo];
}

- (void)__id {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchId:)];
}

- (void)id_ {
    [self parseRule:@selector(__id) withMemo:_id_memo];
}

- (void)__member {
    
    [self match:EXPRESSIONACTIONS_TOKEN_KIND_DOT discard:NO]; 
    [self id_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMember:)];
}

- (void)member_ {
    [self parseRule:@selector(__member) withMemo:_member_memo];
}

- (void)__literal {
    
    if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_NO, EXPRESSIONACTIONS_TOKEN_KIND_NO_UPPER, EXPRESSIONACTIONS_TOKEN_KIND_YES, EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER, 0]) {
        [self testAndThrow:(id)^{ return LA(1) != EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER; }]; 
        [self bool_]; 
        [self execute:^{
         PUSH_BOOL(EQ_IGNORE_CASE(POP_STR(), @"yes")); 
        }];
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self matchNumber:NO]; 
        [self execute:^{
         PUSH_DOUBLE(POP_DOUBLE()); 
        }];
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self matchQuotedString:NO]; 
        [self execute:^{
         PUSH(POP_STR()); 
        }];
    } else {
        [self raise:@"No viable alternative found in rule 'literal'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)literal_ {
    [self parseRule:@selector(__literal) withMemo:_literal_memo];
}

- (void)__bool {
    
    if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_YES, 0]) {
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_YES discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER, 0]) {
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_YES_UPPER discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_NO, 0]) {
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_NO discard:NO]; 
    } else if ([self predicts:EXPRESSIONACTIONS_TOKEN_KIND_NO_UPPER, 0]) {
        [self testAndThrow:(id)^{ return NE(LS(1), @"NO"); }]; 
        [self match:EXPRESSIONACTIONS_TOKEN_KIND_NO_UPPER discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'bool'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBool:)];
}

- (void)bool_ {
    [self parseRule:@selector(__bool) withMemo:_bool_memo];
}

@end