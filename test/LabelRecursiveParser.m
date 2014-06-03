#import "LabelRecursiveParser.h"
#import <PEGKit/PEGKit.h>


@interface LabelRecursiveParser ()

@property (nonatomic, retain) NSMutableDictionary *s_memo;
@property (nonatomic, retain) NSMutableDictionary *label_memo;
@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@end

@implementation LabelRecursiveParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"s";
        self.tokenKindTab[@"="] = @(LABELRECURSIVE_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"return"] = @(LABELRECURSIVE_TOKEN_KIND_RETURN);
        self.tokenKindTab[@":"] = @(LABELRECURSIVE_TOKEN_KIND_COLON);

        self.tokenKindNameTab[LABELRECURSIVE_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[LABELRECURSIVE_TOKEN_KIND_RETURN] = @"return";
        self.tokenKindNameTab[LABELRECURSIVE_TOKEN_KIND_COLON] = @":";

        self.s_memo = [NSMutableDictionary dictionary];
        self.label_memo = [NSMutableDictionary dictionary];
        self.expr_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.s_memo = nil;
    self.label_memo = nil;
    self.expr_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_s_memo removeAllObjects];
    [_label_memo removeAllObjects];
    [_expr_memo removeAllObjects];
}

- (void)start {

    [self s_]; 
    [self matchEOF:YES]; 

}

- (void)__s {
    
    if ([self speculate:^{ [self label_]; [self matchWord:NO]; [self match:LABELRECURSIVE_TOKEN_KIND_EQUALS discard:NO]; [self expr_]; }]) {
        [self label_]; 
        [self matchWord:NO]; 
        [self match:LABELRECURSIVE_TOKEN_KIND_EQUALS discard:NO]; 
        [self expr_]; 
    } else if ([self speculate:^{ [self label_]; [self match:LABELRECURSIVE_TOKEN_KIND_RETURN discard:NO]; [self expr_]; }]) {
        [self label_]; 
        [self match:LABELRECURSIVE_TOKEN_KIND_RETURN discard:NO]; 
        [self expr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 's'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchS:)];
}

- (void)s_ {
    [self parseRule:@selector(__s) withMemo:_s_memo];
}

- (void)__label {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self matchWord:NO]; 
        [self match:LABELRECURSIVE_TOKEN_KIND_COLON discard:NO]; 
        [self label_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchLabel:)];
}

- (void)label_ {
    [self parseRule:@selector(__label) withMemo:_label_memo];
}

- (void)__expr {
    
    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

@end