#import "MiniMathParser.h"
#import <PEGKit/PEGKit.h>

#define LT(i) [self LT:(i)]
#define LA(i) [self LA:(i)]
#define LS(i) [self LS:(i)]
#define LF(i) [self LD:(i)]

#define POP()        [self.assembly pop]
#define POP_STR()    [self popString]
#define POP_TOK()    [self popToken]
#define POP_BOOL()   [self popBool]
#define POP_INT()    [self popInteger]
#define POP_DOUBLE() [self popDouble]

#define PUSH(obj)      [self.assembly push:(id)(obj)]
#define PUSH_BOOL(yn)  [self pushBool:(BOOL)(yn)]
#define PUSH_INT(i)    [self pushInteger:(NSInteger)(i)]
#define PUSH_DOUBLE(d) [self pushDouble:(double)(d)]

#define EQ(a, b) [(a) isEqual:(b)]
#define NE(a, b) (![(a) isEqual:(b)])
#define EQ_IGNORE_CASE(a, b) (NSOrderedSame == [(a) compare:(b)])

#define MATCHES(pattern, str)               ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:0                                  error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)
#define MATCHES_IGNORE_CASE(pattern, str)   ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:NSRegularExpressionCaseInsensitive error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)

#define ABOVE(fence) [self.assembly objectsAbove:(fence)]

#define LOG(obj) do { NSLog(@"%@", (obj)); } while (0);
#define PRINT(str) do { printf("%s\n", (str)); } while (0);

@interface PKParser ()
@property (nonatomic, retain) NSMutableDictionary *tokenKindTab;
@property (nonatomic, retain) NSMutableArray *tokenKindNameTab;
@property (nonatomic, retain) NSString *startRuleName;
@property (nonatomic, retain) NSString *statementTerminator;
@property (nonatomic, retain) NSString *singleLineCommentMarker;
@property (nonatomic, retain) NSString *blockStartMarker;
@property (nonatomic, retain) NSString *blockEndMarker;
@property (nonatomic, retain) NSString *braces;

- (BOOL)popBool;
- (NSInteger)popInteger;
- (double)popDouble;
- (PKToken *)popToken;
- (NSString *)popString;

- (void)pushBool:(BOOL)yn;
- (void)pushInteger:(NSInteger)i;
- (void)pushDouble:(double)d;
@end

@interface MiniMathParser ()
@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *mult_memo;
@property (nonatomic, retain) NSMutableDictionary *pow_memo;
@property (nonatomic, retain) NSMutableDictionary *atom_memo;
@end

@implementation MiniMathParser

- (id)initWithDelegate:(id)d {
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

- (void)_clearMemo {
    [_expr_memo removeAllObjects];
    [_mult_memo removeAllObjects];
    [_pow_memo removeAllObjects];
    [_atom_memo removeAllObjects];
}

- (void)start {
    [self expr_]; 
    [self matchEOF:YES]; 
}

- (void)__expr {
    
    [self mult_]; 
    while ([self speculate:^{ [self match:MINIMATH_TOKEN_KIND_PLUS discard:YES]; [self mult_]; }]) {
        [self match:MINIMATH_TOKEN_KIND_PLUS discard:YES]; 
        [self mult_]; 
        [self execute:(id)^{
         PUSH_DOUBLE(POP_DOUBLE()+POP_DOUBLE()); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__mult {
    
    [self pow_]; 
    while ([self speculate:^{ [self match:MINIMATH_TOKEN_KIND_STAR discard:YES]; [self pow_]; }]) {
        [self match:MINIMATH_TOKEN_KIND_STAR discard:YES]; 
        [self pow_]; 
        [self execute:(id)^{
         PUSH_DOUBLE(POP_DOUBLE()*POP_DOUBLE()); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMult:)];
}

- (void)mult_ {
    [self parseRule:@selector(__mult) withMemo:_mult_memo];
}

- (void)__pow {
    
    [self atom_]; 
    if ([self speculate:^{ [self match:MINIMATH_TOKEN_KIND_CARET discard:YES]; [self pow_]; }]) {
        [self match:MINIMATH_TOKEN_KIND_CARET discard:YES]; 
        [self pow_]; 
        [self execute:(id)^{
         
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
    
    [self matchNumber:NO]; 
    [self execute:(id)^{
    PUSH_DOUBLE(POP_DOUBLE());
    }];

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)atom_ {
    [self parseRule:@selector(__atom) withMemo:_atom_memo];
}

@end