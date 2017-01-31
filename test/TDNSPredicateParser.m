#import "TDNSPredicateParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface TDNSPredicateParser ()

@property (nonatomic, retain) NSMutableDictionary *start_memo;
@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *orOrTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *orTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *andAndTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *andTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *compoundExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *primaryExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *negatedPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *predicate_memo;
@property (nonatomic, retain) NSMutableDictionary *value_memo;
@property (nonatomic, retain) NSMutableDictionary *string_memo;
@property (nonatomic, retain) NSMutableDictionary *num_memo;
@property (nonatomic, retain) NSMutableDictionary *bool_memo;
@property (nonatomic, retain) NSMutableDictionary *true_memo;
@property (nonatomic, retain) NSMutableDictionary *false_memo;
@property (nonatomic, retain) NSMutableDictionary *array_memo;
@property (nonatomic, retain) NSMutableDictionary *arrayContentsOpt_memo;
@property (nonatomic, retain) NSMutableDictionary *arrayContents_memo;
@property (nonatomic, retain) NSMutableDictionary *commaValue_memo;
@property (nonatomic, retain) NSMutableDictionary *keyPath_memo;
@property (nonatomic, retain) NSMutableDictionary *comparisonPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *numComparisonPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *numComparisonValue_memo;
@property (nonatomic, retain) NSMutableDictionary *comparisonOp_memo;
@property (nonatomic, retain) NSMutableDictionary *eq_memo;
@property (nonatomic, retain) NSMutableDictionary *gt_memo;
@property (nonatomic, retain) NSMutableDictionary *lt_memo;
@property (nonatomic, retain) NSMutableDictionary *gtEq_memo;
@property (nonatomic, retain) NSMutableDictionary *ltEq_memo;
@property (nonatomic, retain) NSMutableDictionary *notEq_memo;
@property (nonatomic, retain) NSMutableDictionary *between_memo;
@property (nonatomic, retain) NSMutableDictionary *collectionComparisonPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *collectionLtPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *collectionGtPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *collectionLtEqPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *collectionGtEqPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *collectionEqPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *collectionNotEqPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *boolPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *truePredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *falsePredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *andKeyword_memo;
@property (nonatomic, retain) NSMutableDictionary *orKeyword_memo;
@property (nonatomic, retain) NSMutableDictionary *notKeyword_memo;
@property (nonatomic, retain) NSMutableDictionary *stringTestPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *stringTestOp_memo;
@property (nonatomic, retain) NSMutableDictionary *beginswith_memo;
@property (nonatomic, retain) NSMutableDictionary *contains_memo;
@property (nonatomic, retain) NSMutableDictionary *endswith_memo;
@property (nonatomic, retain) NSMutableDictionary *like_memo;
@property (nonatomic, retain) NSMutableDictionary *matches_memo;
@property (nonatomic, retain) NSMutableDictionary *collectionTestPredicate_memo;
@property (nonatomic, retain) NSMutableDictionary *collection_memo;
@property (nonatomic, retain) NSMutableDictionary *inKeyword_memo;
@property (nonatomic, retain) NSMutableDictionary *aggregateOp_memo;
@property (nonatomic, retain) NSMutableDictionary *any_memo;
@property (nonatomic, retain) NSMutableDictionary *some_memo;
@property (nonatomic, retain) NSMutableDictionary *all_memo;
@property (nonatomic, retain) NSMutableDictionary *none_memo;
@end

@implementation TDNSPredicateParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"ALL"] = @(TDNSPREDICATE_TOKEN_KIND_ALL);
        self.tokenKindTab[@"FALSEPREDICATE"] = @(TDNSPREDICATE_TOKEN_KIND_FALSEPREDICATE);
        self.tokenKindTab[@"NOT"] = @(TDNSPREDICATE_TOKEN_KIND_NOT_UPPER);
        self.tokenKindTab[@"{"] = @(TDNSPREDICATE_TOKEN_KIND_OPEN_CURLY);
        self.tokenKindTab[@"=>"] = @(TDNSPREDICATE_TOKEN_KIND_HASH_ROCKET);
        self.tokenKindTab[@">="] = @(TDNSPREDICATE_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@"&&"] = @(TDNSPREDICATE_TOKEN_KIND_DOUBLE_AMPERSAND);
        self.tokenKindTab[@"TRUEPREDICATE"] = @(TDNSPREDICATE_TOKEN_KIND_TRUEPREDICATE);
        self.tokenKindTab[@"AND"] = @(TDNSPREDICATE_TOKEN_KIND_AND_UPPER);
        self.tokenKindTab[@"}"] = @(TDNSPREDICATE_TOKEN_KIND_CLOSE_CURLY);
        self.tokenKindTab[@"true"] = @(TDNSPREDICATE_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"!="] = @(TDNSPREDICATE_TOKEN_KIND_NOT_EQUAL);
        self.tokenKindTab[@"OR"] = @(TDNSPREDICATE_TOKEN_KIND_OR_UPPER);
        self.tokenKindTab[@"!"] = @(TDNSPREDICATE_TOKEN_KIND_BANG);
        self.tokenKindTab[@"SOME"] = @(TDNSPREDICATE_TOKEN_KIND_SOME);
        self.tokenKindTab[@"IN"] = @(TDNSPREDICATE_TOKEN_KIND_INKEYWORD);
        self.tokenKindTab[@"BEGINSWITH"] = @(TDNSPREDICATE_TOKEN_KIND_BEGINSWITH);
        self.tokenKindTab[@"<"] = @(TDNSPREDICATE_TOKEN_KIND_LT);
        self.tokenKindTab[@"="] = @(TDNSPREDICATE_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"CONTAINS"] = @(TDNSPREDICATE_TOKEN_KIND_CONTAINS);
        self.tokenKindTab[@">"] = @(TDNSPREDICATE_TOKEN_KIND_GT);
        self.tokenKindTab[@"("] = @(TDNSPREDICATE_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@")"] = @(TDNSPREDICATE_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"||"] = @(TDNSPREDICATE_TOKEN_KIND_DOUBLE_PIPE);
        self.tokenKindTab[@"MATCHES"] = @(TDNSPREDICATE_TOKEN_KIND_MATCHES);
        self.tokenKindTab[@","] = @(TDNSPREDICATE_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"LIKE"] = @(TDNSPREDICATE_TOKEN_KIND_LIKE);
        self.tokenKindTab[@"ANY"] = @(TDNSPREDICATE_TOKEN_KIND_ANY);
        self.tokenKindTab[@"ENDSWITH"] = @(TDNSPREDICATE_TOKEN_KIND_ENDSWITH);
        self.tokenKindTab[@"false"] = @(TDNSPREDICATE_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"<="] = @(TDNSPREDICATE_TOKEN_KIND_LE_SYM);
        self.tokenKindTab[@"BETWEEN"] = @(TDNSPREDICATE_TOKEN_KIND_BETWEEN);
        self.tokenKindTab[@"=<"] = @(TDNSPREDICATE_TOKEN_KIND_EL_SYM);
        self.tokenKindTab[@"<>"] = @(TDNSPREDICATE_TOKEN_KIND_NOT_EQUALS);
        self.tokenKindTab[@"NONE"] = @(TDNSPREDICATE_TOKEN_KIND_NONE);
        self.tokenKindTab[@"=="] = @(TDNSPREDICATE_TOKEN_KIND_DOUBLE_EQUALS);

        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_ALL] = @"ALL";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_FALSEPREDICATE] = @"FALSEPREDICATE";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_NOT_UPPER] = @"NOT";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_OPEN_CURLY] = @"{";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_HASH_ROCKET] = @"=>";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_GE_SYM] = @">=";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_DOUBLE_AMPERSAND] = @"&&";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_TRUEPREDICATE] = @"TRUEPREDICATE";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_AND_UPPER] = @"AND";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_NOT_EQUAL] = @"!=";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_OR_UPPER] = @"OR";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_BANG] = @"!";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_SOME] = @"SOME";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_INKEYWORD] = @"IN";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_BEGINSWITH] = @"BEGINSWITH";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_LT] = @"<";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_CONTAINS] = @"CONTAINS";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_GT] = @">";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_DOUBLE_PIPE] = @"||";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_MATCHES] = @"MATCHES";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_LIKE] = @"LIKE";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_ANY] = @"ANY";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_ENDSWITH] = @"ENDSWITH";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_LE_SYM] = @"<=";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_BETWEEN] = @"BETWEEN";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_EL_SYM] = @"=<";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_NOT_EQUALS] = @"<>";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_NONE] = @"NONE";
        self.tokenKindNameTab[TDNSPREDICATE_TOKEN_KIND_DOUBLE_EQUALS] = @"==";

        self.start_memo = [NSMutableDictionary dictionary];
        self.expr_memo = [NSMutableDictionary dictionary];
        self.orOrTerm_memo = [NSMutableDictionary dictionary];
        self.orTerm_memo = [NSMutableDictionary dictionary];
        self.andAndTerm_memo = [NSMutableDictionary dictionary];
        self.andTerm_memo = [NSMutableDictionary dictionary];
        self.compoundExpr_memo = [NSMutableDictionary dictionary];
        self.primaryExpr_memo = [NSMutableDictionary dictionary];
        self.negatedPredicate_memo = [NSMutableDictionary dictionary];
        self.predicate_memo = [NSMutableDictionary dictionary];
        self.value_memo = [NSMutableDictionary dictionary];
        self.string_memo = [NSMutableDictionary dictionary];
        self.num_memo = [NSMutableDictionary dictionary];
        self.bool_memo = [NSMutableDictionary dictionary];
        self.true_memo = [NSMutableDictionary dictionary];
        self.false_memo = [NSMutableDictionary dictionary];
        self.array_memo = [NSMutableDictionary dictionary];
        self.arrayContentsOpt_memo = [NSMutableDictionary dictionary];
        self.arrayContents_memo = [NSMutableDictionary dictionary];
        self.commaValue_memo = [NSMutableDictionary dictionary];
        self.keyPath_memo = [NSMutableDictionary dictionary];
        self.comparisonPredicate_memo = [NSMutableDictionary dictionary];
        self.numComparisonPredicate_memo = [NSMutableDictionary dictionary];
        self.numComparisonValue_memo = [NSMutableDictionary dictionary];
        self.comparisonOp_memo = [NSMutableDictionary dictionary];
        self.eq_memo = [NSMutableDictionary dictionary];
        self.gt_memo = [NSMutableDictionary dictionary];
        self.lt_memo = [NSMutableDictionary dictionary];
        self.gtEq_memo = [NSMutableDictionary dictionary];
        self.ltEq_memo = [NSMutableDictionary dictionary];
        self.notEq_memo = [NSMutableDictionary dictionary];
        self.between_memo = [NSMutableDictionary dictionary];
        self.collectionComparisonPredicate_memo = [NSMutableDictionary dictionary];
        self.collectionLtPredicate_memo = [NSMutableDictionary dictionary];
        self.collectionGtPredicate_memo = [NSMutableDictionary dictionary];
        self.collectionLtEqPredicate_memo = [NSMutableDictionary dictionary];
        self.collectionGtEqPredicate_memo = [NSMutableDictionary dictionary];
        self.collectionEqPredicate_memo = [NSMutableDictionary dictionary];
        self.collectionNotEqPredicate_memo = [NSMutableDictionary dictionary];
        self.boolPredicate_memo = [NSMutableDictionary dictionary];
        self.truePredicate_memo = [NSMutableDictionary dictionary];
        self.falsePredicate_memo = [NSMutableDictionary dictionary];
        self.andKeyword_memo = [NSMutableDictionary dictionary];
        self.orKeyword_memo = [NSMutableDictionary dictionary];
        self.notKeyword_memo = [NSMutableDictionary dictionary];
        self.stringTestPredicate_memo = [NSMutableDictionary dictionary];
        self.stringTestOp_memo = [NSMutableDictionary dictionary];
        self.beginswith_memo = [NSMutableDictionary dictionary];
        self.contains_memo = [NSMutableDictionary dictionary];
        self.endswith_memo = [NSMutableDictionary dictionary];
        self.like_memo = [NSMutableDictionary dictionary];
        self.matches_memo = [NSMutableDictionary dictionary];
        self.collectionTestPredicate_memo = [NSMutableDictionary dictionary];
        self.collection_memo = [NSMutableDictionary dictionary];
        self.inKeyword_memo = [NSMutableDictionary dictionary];
        self.aggregateOp_memo = [NSMutableDictionary dictionary];
        self.any_memo = [NSMutableDictionary dictionary];
        self.some_memo = [NSMutableDictionary dictionary];
        self.all_memo = [NSMutableDictionary dictionary];
        self.none_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.start_memo = nil;
    self.expr_memo = nil;
    self.orOrTerm_memo = nil;
    self.orTerm_memo = nil;
    self.andAndTerm_memo = nil;
    self.andTerm_memo = nil;
    self.compoundExpr_memo = nil;
    self.primaryExpr_memo = nil;
    self.negatedPredicate_memo = nil;
    self.predicate_memo = nil;
    self.value_memo = nil;
    self.string_memo = nil;
    self.num_memo = nil;
    self.bool_memo = nil;
    self.true_memo = nil;
    self.false_memo = nil;
    self.array_memo = nil;
    self.arrayContentsOpt_memo = nil;
    self.arrayContents_memo = nil;
    self.commaValue_memo = nil;
    self.keyPath_memo = nil;
    self.comparisonPredicate_memo = nil;
    self.numComparisonPredicate_memo = nil;
    self.numComparisonValue_memo = nil;
    self.comparisonOp_memo = nil;
    self.eq_memo = nil;
    self.gt_memo = nil;
    self.lt_memo = nil;
    self.gtEq_memo = nil;
    self.ltEq_memo = nil;
    self.notEq_memo = nil;
    self.between_memo = nil;
    self.collectionComparisonPredicate_memo = nil;
    self.collectionLtPredicate_memo = nil;
    self.collectionGtPredicate_memo = nil;
    self.collectionLtEqPredicate_memo = nil;
    self.collectionGtEqPredicate_memo = nil;
    self.collectionEqPredicate_memo = nil;
    self.collectionNotEqPredicate_memo = nil;
    self.boolPredicate_memo = nil;
    self.truePredicate_memo = nil;
    self.falsePredicate_memo = nil;
    self.andKeyword_memo = nil;
    self.orKeyword_memo = nil;
    self.notKeyword_memo = nil;
    self.stringTestPredicate_memo = nil;
    self.stringTestOp_memo = nil;
    self.beginswith_memo = nil;
    self.contains_memo = nil;
    self.endswith_memo = nil;
    self.like_memo = nil;
    self.matches_memo = nil;
    self.collectionTestPredicate_memo = nil;
    self.collection_memo = nil;
    self.inKeyword_memo = nil;
    self.aggregateOp_memo = nil;
    self.any_memo = nil;
    self.some_memo = nil;
    self.all_memo = nil;
    self.none_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_start_memo removeAllObjects];
    [_expr_memo removeAllObjects];
    [_orOrTerm_memo removeAllObjects];
    [_orTerm_memo removeAllObjects];
    [_andAndTerm_memo removeAllObjects];
    [_andTerm_memo removeAllObjects];
    [_compoundExpr_memo removeAllObjects];
    [_primaryExpr_memo removeAllObjects];
    [_negatedPredicate_memo removeAllObjects];
    [_predicate_memo removeAllObjects];
    [_value_memo removeAllObjects];
    [_string_memo removeAllObjects];
    [_num_memo removeAllObjects];
    [_bool_memo removeAllObjects];
    [_true_memo removeAllObjects];
    [_false_memo removeAllObjects];
    [_array_memo removeAllObjects];
    [_arrayContentsOpt_memo removeAllObjects];
    [_arrayContents_memo removeAllObjects];
    [_commaValue_memo removeAllObjects];
    [_keyPath_memo removeAllObjects];
    [_comparisonPredicate_memo removeAllObjects];
    [_numComparisonPredicate_memo removeAllObjects];
    [_numComparisonValue_memo removeAllObjects];
    [_comparisonOp_memo removeAllObjects];
    [_eq_memo removeAllObjects];
    [_gt_memo removeAllObjects];
    [_lt_memo removeAllObjects];
    [_gtEq_memo removeAllObjects];
    [_ltEq_memo removeAllObjects];
    [_notEq_memo removeAllObjects];
    [_between_memo removeAllObjects];
    [_collectionComparisonPredicate_memo removeAllObjects];
    [_collectionLtPredicate_memo removeAllObjects];
    [_collectionGtPredicate_memo removeAllObjects];
    [_collectionLtEqPredicate_memo removeAllObjects];
    [_collectionGtEqPredicate_memo removeAllObjects];
    [_collectionEqPredicate_memo removeAllObjects];
    [_collectionNotEqPredicate_memo removeAllObjects];
    [_boolPredicate_memo removeAllObjects];
    [_truePredicate_memo removeAllObjects];
    [_falsePredicate_memo removeAllObjects];
    [_andKeyword_memo removeAllObjects];
    [_orKeyword_memo removeAllObjects];
    [_notKeyword_memo removeAllObjects];
    [_stringTestPredicate_memo removeAllObjects];
    [_stringTestOp_memo removeAllObjects];
    [_beginswith_memo removeAllObjects];
    [_contains_memo removeAllObjects];
    [_endswith_memo removeAllObjects];
    [_like_memo removeAllObjects];
    [_matches_memo removeAllObjects];
    [_collectionTestPredicate_memo removeAllObjects];
    [_collection_memo removeAllObjects];
    [_inKeyword_memo removeAllObjects];
    [_aggregateOp_memo removeAllObjects];
    [_any_memo removeAllObjects];
    [_some_memo removeAllObjects];
    [_all_memo removeAllObjects];
    [_none_memo removeAllObjects];
}

- (void)start {
    PKParser_weakSelfDecl;

    [PKParser_weakSelf start_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)__start {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf execute:^{
    
	PKTokenizer *t = self.tokenizer;
	[t setTokenizerState:t.wordState from:'#' to:'#'];
	[t.wordState setWordChars:YES from:'.' to:'.'];
	[t.wordState setWordChars:YES from:'[' to:'['];
	[t.wordState setWordChars:YES from:']' to:']'];

	[t.symbolState add:@"=="];
	[t.symbolState add:@">="];
	[t.symbolState add:@"=>"];
	[t.symbolState add:@"<="];
	[t.symbolState add:@"=<"];
	[t.symbolState add:@"!="];
	[t.symbolState add:@"<>"];
	[t.symbolState add:@"&&"];
	[t.symbolState add:@"||"];
 
    }];
    do {
        [PKParser_weakSelf expr_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf expr_];}]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)start_ {
    [self parseRule:@selector(__start) withMemo:_start_memo];
}

- (void)__expr {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf orTerm_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf orOrTerm_];}]) {
        [PKParser_weakSelf orOrTerm_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__orOrTerm {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf orKeyword_];
    [PKParser_weakSelf orTerm_];

    [self fireDelegateSelector:@selector(parser:didMatchOrOrTerm:)];
}

- (void)orOrTerm_ {
    [self parseRule:@selector(__orOrTerm) withMemo:_orOrTerm_memo];
}

- (void)__orTerm {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf andTerm_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf andAndTerm_];}]) {
        [PKParser_weakSelf andAndTerm_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrTerm:)];
}

- (void)orTerm_ {
    [self parseRule:@selector(__orTerm) withMemo:_orTerm_memo];
}

- (void)__andAndTerm {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf andKeyword_];
    [PKParser_weakSelf andTerm_];

    [self fireDelegateSelector:@selector(parser:didMatchAndAndTerm:)];
}

- (void)andAndTerm_ {
    [self parseRule:@selector(__andAndTerm) withMemo:_andAndTerm_memo];
}

- (void)__andTerm {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_ALL, TDNSPREDICATE_TOKEN_KIND_ANY, TDNSPREDICATE_TOKEN_KIND_BANG, TDNSPREDICATE_TOKEN_KIND_FALSE, TDNSPREDICATE_TOKEN_KIND_FALSEPREDICATE, TDNSPREDICATE_TOKEN_KIND_NONE, TDNSPREDICATE_TOKEN_KIND_NOT_UPPER, TDNSPREDICATE_TOKEN_KIND_OPEN_CURLY, TDNSPREDICATE_TOKEN_KIND_SOME, TDNSPREDICATE_TOKEN_KIND_TRUE, TDNSPREDICATE_TOKEN_KIND_TRUEPREDICATE, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf primaryExpr_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_OPEN_PAREN, 0]) {
        [PKParser_weakSelf compoundExpr_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'andTerm'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndTerm:)];
}

- (void)andTerm_ {
    [self parseRule:@selector(__andTerm) withMemo:_andTerm_memo];
}

- (void)__compoundExpr {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_OPEN_PAREN discard:YES];
    [PKParser_weakSelf expr_];
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_CLOSE_PAREN discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchCompoundExpr:)];
}

- (void)compoundExpr_ {
    [self parseRule:@selector(__compoundExpr) withMemo:_compoundExpr_memo];
}

- (void)__primaryExpr {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_ALL, TDNSPREDICATE_TOKEN_KIND_ANY, TDNSPREDICATE_TOKEN_KIND_FALSE, TDNSPREDICATE_TOKEN_KIND_FALSEPREDICATE, TDNSPREDICATE_TOKEN_KIND_NONE, TDNSPREDICATE_TOKEN_KIND_OPEN_CURLY, TDNSPREDICATE_TOKEN_KIND_SOME, TDNSPREDICATE_TOKEN_KIND_TRUE, TDNSPREDICATE_TOKEN_KIND_TRUEPREDICATE, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf predicate_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_BANG, TDNSPREDICATE_TOKEN_KIND_NOT_UPPER, 0]) {
        [PKParser_weakSelf negatedPredicate_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'primaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimaryExpr:)];
}

- (void)primaryExpr_ {
    [self parseRule:@selector(__primaryExpr) withMemo:_primaryExpr_memo];
}

- (void)__negatedPredicate {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf notKeyword_];
    [PKParser_weakSelf predicate_];

    [self fireDelegateSelector:@selector(parser:didMatchNegatedPredicate:)];
}

- (void)negatedPredicate_ {
    [self parseRule:@selector(__negatedPredicate) withMemo:_negatedPredicate_memo];
}

- (void)__predicate {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf collectionTestPredicate_];}]) {
        [PKParser_weakSelf collectionTestPredicate_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf boolPredicate_];}]) {
        [PKParser_weakSelf boolPredicate_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf comparisonPredicate_];}]) {
        [PKParser_weakSelf comparisonPredicate_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf stringTestPredicate_];}]) {
        [PKParser_weakSelf stringTestPredicate_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'predicate'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPredicate:)];
}

- (void)predicate_ {
    [self parseRule:@selector(__predicate) withMemo:_predicate_memo];
}

- (void)__value {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf keyPath_];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [PKParser_weakSelf string_];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [PKParser_weakSelf num_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_FALSE, TDNSPREDICATE_TOKEN_KIND_TRUE, 0]) {
        [PKParser_weakSelf bool_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_OPEN_CURLY, 0]) {
        [PKParser_weakSelf array_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'value'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchValue:)];
}

- (void)value_ {
    [self parseRule:@selector(__value) withMemo:_value_memo];
}

- (void)__string {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchQuotedString:NO];

    [self fireDelegateSelector:@selector(parser:didMatchString:)];
}

- (void)string_ {
    [self parseRule:@selector(__string) withMemo:_string_memo];
}

- (void)__num {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchNumber:NO];

    [self fireDelegateSelector:@selector(parser:didMatchNum:)];
}

- (void)num_ {
    [self parseRule:@selector(__num) withMemo:_num_memo];
}

- (void)__bool {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_TRUE, 0]) {
        [PKParser_weakSelf true_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_FALSE, 0]) {
        [PKParser_weakSelf false_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'bool'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBool:)];
}

- (void)bool_ {
    [self parseRule:@selector(__bool) withMemo:_bool_memo];
}

- (void)__true {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_TRUE discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchTrue:)];
}

- (void)true_ {
    [self parseRule:@selector(__true) withMemo:_true_memo];
}

- (void)__false {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_FALSE discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchFalse:)];
}

- (void)false_ {
    [self parseRule:@selector(__false) withMemo:_false_memo];
}

- (void)__array {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_OPEN_CURLY discard:NO];
    [PKParser_weakSelf arrayContentsOpt_];
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_CLOSE_CURLY discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchArray:)];
}

- (void)array_ {
    [self parseRule:@selector(__array) withMemo:_array_memo];
}

- (void)__arrayContentsOpt {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_FALSE, TDNSPREDICATE_TOKEN_KIND_OPEN_CURLY, TDNSPREDICATE_TOKEN_KIND_TRUE, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf arrayContents_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchArrayContentsOpt:)];
}

- (void)arrayContentsOpt_ {
    [self parseRule:@selector(__arrayContentsOpt) withMemo:_arrayContentsOpt_memo];
}

- (void)__arrayContents {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf value_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf commaValue_];}]) {
        [PKParser_weakSelf commaValue_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchArrayContents:)];
}

- (void)arrayContents_ {
    [self parseRule:@selector(__arrayContents) withMemo:_arrayContents_memo];
}

- (void)__commaValue {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_COMMA discard:YES];
    [PKParser_weakSelf value_];

    [self fireDelegateSelector:@selector(parser:didMatchCommaValue:)];
}

- (void)commaValue_ {
    [self parseRule:@selector(__commaValue) withMemo:_commaValue_memo];
}

- (void)__keyPath {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchWord:NO];

    [self fireDelegateSelector:@selector(parser:didMatchKeyPath:)];
}

- (void)keyPath_ {
    [self parseRule:@selector(__keyPath) withMemo:_keyPath_memo];
}

- (void)__comparisonPredicate {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf numComparisonPredicate_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_ALL, TDNSPREDICATE_TOKEN_KIND_ANY, TDNSPREDICATE_TOKEN_KIND_NONE, TDNSPREDICATE_TOKEN_KIND_SOME, 0]) {
        [PKParser_weakSelf collectionComparisonPredicate_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'comparisonPredicate'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchComparisonPredicate:)];
}

- (void)comparisonPredicate_ {
    [self parseRule:@selector(__comparisonPredicate) withMemo:_comparisonPredicate_memo];
}

- (void)__numComparisonPredicate {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf numComparisonValue_];
    [PKParser_weakSelf comparisonOp_];
    [PKParser_weakSelf numComparisonValue_];

    [self fireDelegateSelector:@selector(parser:didMatchNumComparisonPredicate:)];
}

- (void)numComparisonPredicate_ {
    [self parseRule:@selector(__numComparisonPredicate) withMemo:_numComparisonPredicate_memo];
}

- (void)__numComparisonValue {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf keyPath_];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [PKParser_weakSelf num_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'numComparisonValue'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNumComparisonValue:)];
}

- (void)numComparisonValue_ {
    [self parseRule:@selector(__numComparisonValue) withMemo:_numComparisonValue_memo];
}

- (void)__comparisonOp {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_DOUBLE_EQUALS, TDNSPREDICATE_TOKEN_KIND_EQUALS, 0]) {
        [PKParser_weakSelf eq_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_GT, 0]) {
        [PKParser_weakSelf gt_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_LT, 0]) {
        [PKParser_weakSelf lt_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_GE_SYM, TDNSPREDICATE_TOKEN_KIND_HASH_ROCKET, 0]) {
        [PKParser_weakSelf gtEq_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_EL_SYM, TDNSPREDICATE_TOKEN_KIND_LE_SYM, 0]) {
        [PKParser_weakSelf ltEq_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_NOT_EQUAL, TDNSPREDICATE_TOKEN_KIND_NOT_EQUALS, 0]) {
        [PKParser_weakSelf notEq_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_BETWEEN, 0]) {
        [PKParser_weakSelf between_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'comparisonOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchComparisonOp:)];
}

- (void)comparisonOp_ {
    [self parseRule:@selector(__comparisonOp) withMemo:_comparisonOp_memo];
}

- (void)__eq {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_EQUALS, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_EQUALS discard:NO];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_DOUBLE_EQUALS, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_DOUBLE_EQUALS discard:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'eq'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)eq_ {
    [self parseRule:@selector(__eq) withMemo:_eq_memo];
}

- (void)__gt {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_GT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchGt:)];
}

- (void)gt_ {
    [self parseRule:@selector(__gt) withMemo:_gt_memo];
}

- (void)__lt {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_LT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchLt:)];
}

- (void)lt_ {
    [self parseRule:@selector(__lt) withMemo:_lt_memo];
}

- (void)__gtEq {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_GE_SYM, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_GE_SYM discard:NO];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_HASH_ROCKET, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_HASH_ROCKET discard:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'gtEq'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchGtEq:)];
}

- (void)gtEq_ {
    [self parseRule:@selector(__gtEq) withMemo:_gtEq_memo];
}

- (void)__ltEq {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_LE_SYM, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_LE_SYM discard:NO];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_EL_SYM, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_EL_SYM discard:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'ltEq'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLtEq:)];
}

- (void)ltEq_ {
    [self parseRule:@selector(__ltEq) withMemo:_ltEq_memo];
}

- (void)__notEq {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_NOT_EQUAL, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_NOT_EQUAL discard:NO];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_NOT_EQUALS, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_NOT_EQUALS discard:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'notEq'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNotEq:)];
}

- (void)notEq_ {
    [self parseRule:@selector(__notEq) withMemo:_notEq_memo];
}

- (void)__between {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_BETWEEN discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchBetween:)];
}

- (void)between_ {
    [self parseRule:@selector(__between) withMemo:_between_memo];
}

- (void)__collectionComparisonPredicate {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf collectionLtPredicate_];}]) {
        [PKParser_weakSelf collectionLtPredicate_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf collectionGtPredicate_];}]) {
        [PKParser_weakSelf collectionGtPredicate_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf collectionLtEqPredicate_];}]) {
        [PKParser_weakSelf collectionLtEqPredicate_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf collectionGtEqPredicate_];}]) {
        [PKParser_weakSelf collectionGtEqPredicate_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf collectionEqPredicate_];}]) {
        [PKParser_weakSelf collectionEqPredicate_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf collectionNotEqPredicate_];}]) {
        [PKParser_weakSelf collectionNotEqPredicate_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'collectionComparisonPredicate'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchCollectionComparisonPredicate:)];
}

- (void)collectionComparisonPredicate_ {
    [self parseRule:@selector(__collectionComparisonPredicate) withMemo:_collectionComparisonPredicate_memo];
}

- (void)__collectionLtPredicate {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf aggregateOp_];
    [PKParser_weakSelf collection_];
    [PKParser_weakSelf lt_];
    [PKParser_weakSelf value_];

    [self fireDelegateSelector:@selector(parser:didMatchCollectionLtPredicate:)];
}

- (void)collectionLtPredicate_ {
    [self parseRule:@selector(__collectionLtPredicate) withMemo:_collectionLtPredicate_memo];
}

- (void)__collectionGtPredicate {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf aggregateOp_];
    [PKParser_weakSelf collection_];
    [PKParser_weakSelf gt_];
    [PKParser_weakSelf value_];

    [self fireDelegateSelector:@selector(parser:didMatchCollectionGtPredicate:)];
}

- (void)collectionGtPredicate_ {
    [self parseRule:@selector(__collectionGtPredicate) withMemo:_collectionGtPredicate_memo];
}

- (void)__collectionLtEqPredicate {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf aggregateOp_];
    [PKParser_weakSelf collection_];
    [PKParser_weakSelf ltEq_];
    [PKParser_weakSelf value_];

    [self fireDelegateSelector:@selector(parser:didMatchCollectionLtEqPredicate:)];
}

- (void)collectionLtEqPredicate_ {
    [self parseRule:@selector(__collectionLtEqPredicate) withMemo:_collectionLtEqPredicate_memo];
}

- (void)__collectionGtEqPredicate {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf aggregateOp_];
    [PKParser_weakSelf collection_];
    [PKParser_weakSelf gtEq_];
    [PKParser_weakSelf value_];

    [self fireDelegateSelector:@selector(parser:didMatchCollectionGtEqPredicate:)];
}

- (void)collectionGtEqPredicate_ {
    [self parseRule:@selector(__collectionGtEqPredicate) withMemo:_collectionGtEqPredicate_memo];
}

- (void)__collectionEqPredicate {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf aggregateOp_];
    [PKParser_weakSelf collection_];
    [PKParser_weakSelf eq_];
    [PKParser_weakSelf value_];

    [self fireDelegateSelector:@selector(parser:didMatchCollectionEqPredicate:)];
}

- (void)collectionEqPredicate_ {
    [self parseRule:@selector(__collectionEqPredicate) withMemo:_collectionEqPredicate_memo];
}

- (void)__collectionNotEqPredicate {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf aggregateOp_];
    [PKParser_weakSelf collection_];
    [PKParser_weakSelf notEq_];
    [PKParser_weakSelf value_];

    [self fireDelegateSelector:@selector(parser:didMatchCollectionNotEqPredicate:)];
}

- (void)collectionNotEqPredicate_ {
    [self parseRule:@selector(__collectionNotEqPredicate) withMemo:_collectionNotEqPredicate_memo];
}

- (void)__boolPredicate {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_TRUEPREDICATE, 0]) {
        [PKParser_weakSelf truePredicate_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_FALSEPREDICATE, 0]) {
        [PKParser_weakSelf falsePredicate_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'boolPredicate'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBoolPredicate:)];
}

- (void)boolPredicate_ {
    [self parseRule:@selector(__boolPredicate) withMemo:_boolPredicate_memo];
}

- (void)__truePredicate {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_TRUEPREDICATE discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchTruePredicate:)];
}

- (void)truePredicate_ {
    [self parseRule:@selector(__truePredicate) withMemo:_truePredicate_memo];
}

- (void)__falsePredicate {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_FALSEPREDICATE discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchFalsePredicate:)];
}

- (void)falsePredicate_ {
    [self parseRule:@selector(__falsePredicate) withMemo:_falsePredicate_memo];
}

- (void)__andKeyword {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_AND_UPPER, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_AND_UPPER discard:YES];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_DOUBLE_AMPERSAND, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_DOUBLE_AMPERSAND discard:YES];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'andKeyword'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndKeyword:)];
}

- (void)andKeyword_ {
    [self parseRule:@selector(__andKeyword) withMemo:_andKeyword_memo];
}

- (void)__orKeyword {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_OR_UPPER, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_OR_UPPER discard:YES];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_DOUBLE_PIPE, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_DOUBLE_PIPE discard:YES];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'orKeyword'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrKeyword:)];
}

- (void)orKeyword_ {
    [self parseRule:@selector(__orKeyword) withMemo:_orKeyword_memo];
}

- (void)__notKeyword {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_NOT_UPPER, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_NOT_UPPER discard:YES];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_BANG, 0]) {
        [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_BANG discard:YES];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'notKeyword'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNotKeyword:)];
}

- (void)notKeyword_ {
    [self parseRule:@selector(__notKeyword) withMemo:_notKeyword_memo];
}

- (void)__stringTestPredicate {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf string_];
    [PKParser_weakSelf stringTestOp_];
    [PKParser_weakSelf value_];

    [self fireDelegateSelector:@selector(parser:didMatchStringTestPredicate:)];
}

- (void)stringTestPredicate_ {
    [self parseRule:@selector(__stringTestPredicate) withMemo:_stringTestPredicate_memo];
}

- (void)__stringTestOp {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_BEGINSWITH, 0]) {
        [PKParser_weakSelf beginswith_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_CONTAINS, 0]) {
        [PKParser_weakSelf contains_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_ENDSWITH, 0]) {
        [PKParser_weakSelf endswith_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_LIKE, 0]) {
        [PKParser_weakSelf like_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_MATCHES, 0]) {
        [PKParser_weakSelf matches_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'stringTestOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStringTestOp:)];
}

- (void)stringTestOp_ {
    [self parseRule:@selector(__stringTestOp) withMemo:_stringTestOp_memo];
}

- (void)__beginswith {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_BEGINSWITH discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchBeginswith:)];
}

- (void)beginswith_ {
    [self parseRule:@selector(__beginswith) withMemo:_beginswith_memo];
}

- (void)__contains {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_CONTAINS discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchContains:)];
}

- (void)contains_ {
    [self parseRule:@selector(__contains) withMemo:_contains_memo];
}

- (void)__endswith {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_ENDSWITH discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchEndswith:)];
}

- (void)endswith_ {
    [self parseRule:@selector(__endswith) withMemo:_endswith_memo];
}

- (void)__like {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_LIKE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchLike:)];
}

- (void)like_ {
    [self parseRule:@selector(__like) withMemo:_like_memo];
}

- (void)__matches {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_MATCHES discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchMatches:)];
}

- (void)matches_ {
    [self parseRule:@selector(__matches) withMemo:_matches_memo];
}

- (void)__collectionTestPredicate {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf value_];
    [PKParser_weakSelf inKeyword_];
    [PKParser_weakSelf collection_];

    [self fireDelegateSelector:@selector(parser:didMatchCollectionTestPredicate:)];
}

- (void)collectionTestPredicate_ {
    [self parseRule:@selector(__collectionTestPredicate) withMemo:_collectionTestPredicate_memo];
}

- (void)__collection {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf keyPath_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_OPEN_CURLY, 0]) {
        [PKParser_weakSelf array_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'collection'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchCollection:)];
}

- (void)collection_ {
    [self parseRule:@selector(__collection) withMemo:_collection_memo];
}

- (void)__inKeyword {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_INKEYWORD discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchInKeyword:)];
}

- (void)inKeyword_ {
    [self parseRule:@selector(__inKeyword) withMemo:_inKeyword_memo];
}

- (void)__aggregateOp {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_ANY, 0]) {
        [PKParser_weakSelf any_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_SOME, 0]) {
        [PKParser_weakSelf some_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_ALL, 0]) {
        [PKParser_weakSelf all_];
    } else if ([PKParser_weakSelf predicts:TDNSPREDICATE_TOKEN_KIND_NONE, 0]) {
        [PKParser_weakSelf none_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'aggregateOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAggregateOp:)];
}

- (void)aggregateOp_ {
    [self parseRule:@selector(__aggregateOp) withMemo:_aggregateOp_memo];
}

- (void)__any {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_ANY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchAny:)];
}

- (void)any_ {
    [self parseRule:@selector(__any) withMemo:_any_memo];
}

- (void)__some {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_SOME discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchSome:)];
}

- (void)some_ {
    [self parseRule:@selector(__some) withMemo:_some_memo];
}

- (void)__all {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_ALL discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchAll:)];
}

- (void)all_ {
    [self parseRule:@selector(__all) withMemo:_all_memo];
}

- (void)__none {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:TDNSPREDICATE_TOKEN_KIND_NONE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchNone:)];
}

- (void)none_ {
    [self parseRule:@selector(__none) withMemo:_none_memo];
}

@end