#import "MiniMathParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface MiniMathParser ()

@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *mult_memo;
@property (nonatomic, retain) NSMutableDictionary *pow_memo;
@property (nonatomic, retain) NSMutableDictionary *atom_memo;
@end

@implementation MiniMathParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"expr";
        self.tokenKindTab[@"+"] = @(MINIMATH_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"*"] = @(MINIMATH_TOKEN_KIND_STAR);
        self.tokenKindTab[@"^"] = @(MINIMATH_TOKEN_KIND_CARET);

        self.tokenKindNameTab[MINIMATH_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[MINIMATH_TOKEN_KIND_STAR] = @"*";
        self.tokenKindNameTab[MINIMATH_TOKEN_KIND_CARET] = @"^";

        self.expr_memo = [NSMutableDictionary dictionary];
        self.mult_memo = [NSMutableDictionary dictionary];
        self.pow_memo = [NSMutableDictionary dictionary];
        self.atom_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.expr_memo = nil;
    self.mult_memo = nil;
    self.pow_memo = nil;
    self.atom_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_expr_memo removeAllObjects];
    [_mult_memo removeAllObjects];
    [_pow_memo removeAllObjects];
    [_atom_memo removeAllObjects];
}

- (void)start {
    PKParser_weakSelfDecl;

    [PKParser_weakSelf expr_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)__expr {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf mult_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:MINIMATH_TOKEN_KIND_PLUS discard:YES];[PKParser_weakSelf mult_];}]) {
        [PKParser_weakSelf match:MINIMATH_TOKEN_KIND_PLUS discard:YES];
        [PKParser_weakSelf mult_];
        [PKParser_weakSelf execute:^{
         PUSH_DOUBLE(POP_DOUBLE()+POP_DOUBLE()); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__mult {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf pow_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:MINIMATH_TOKEN_KIND_STAR discard:YES];[PKParser_weakSelf pow_];}]) {
        [PKParser_weakSelf match:MINIMATH_TOKEN_KIND_STAR discard:YES];
        [PKParser_weakSelf pow_];
        [PKParser_weakSelf execute:^{
         PUSH_DOUBLE(POP_DOUBLE()*POP_DOUBLE()); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMult:)];
}

- (void)mult_ {
    [self parseRule:@selector(__mult) withMemo:_mult_memo];
}

- (void)__pow {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf atom_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:MINIMATH_TOKEN_KIND_CARET discard:YES];[PKParser_weakSelf pow_];}]) {
        [PKParser_weakSelf match:MINIMATH_TOKEN_KIND_CARET discard:YES];
        [PKParser_weakSelf pow_];
        [PKParser_weakSelf execute:^{
         
		double exp = POP_DOUBLE();
		double base = POP_DOUBLE();
		double result = base;
	    for (NSUInteger i = 1; i < exp; i++) 
			result *= base;
		PUSH_DOUBLE(result); 
	
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPow:)];
}

- (void)pow_ {
    [self parseRule:@selector(__pow) withMemo:_pow_memo];
}

- (void)__atom {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchNumber:NO];
    [PKParser_weakSelf execute:^{
    PUSH_DOUBLE(POP_DOUBLE());
    }];

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)atom_ {
    [self parseRule:@selector(__atom) withMemo:_atom_memo];
}

@end