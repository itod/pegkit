#import "MiniMath2Parser.h"
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

@interface MiniMath2Parser ()
@end

@implementation MiniMath2Parser

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        self.startRuleName = @"expr";
        self.tokenKindTab[@"*"] = @(MINIMATH2_TOKEN_KIND_STAR);
        self.tokenKindTab[@"("] = @(MINIMATH2_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"+"] = @(MINIMATH2_TOKEN_KIND_PLUS);
        self.tokenKindTab[@")"] = @(MINIMATH2_TOKEN_KIND_CLOSE_PAREN);

        self.tokenKindNameTab[MINIMATH2_TOKEN_KIND_STAR] = @"*";
        self.tokenKindNameTab[MINIMATH2_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[MINIMATH2_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[MINIMATH2_TOKEN_KIND_CLOSE_PAREN] = @")";

    }
    return self;
}

- (void)start {
    [self expr_]; 
    [self matchEOF:YES]; 
}

- (void)expr_ {
    
    [self addExpr_]; 

}

- (void)addExpr_ {
    
    [self multExpr_]; 
    while ([self speculate:^{ [self match:MINIMATH2_TOKEN_KIND_PLUS discard:YES]; [self multExpr_]; }]) {
        [self match:MINIMATH2_TOKEN_KIND_PLUS discard:YES]; 
        [self multExpr_]; 
        [self execute:(id)^{
        
    PUSH_DOUBLE(POP_DOUBLE() + POP_DOUBLE());

        }];
    }

}

- (void)multExpr_ {
    
    [self primary_]; 
    while ([self speculate:^{ [self match:MINIMATH2_TOKEN_KIND_STAR discard:YES]; [self primary_]; }]) {
        [self match:MINIMATH2_TOKEN_KIND_STAR discard:YES]; 
        [self primary_]; 
        [self execute:(id)^{
         
    PUSH_DOUBLE(POP_DOUBLE() * POP_DOUBLE());

        }];
    }

}

- (void)primary_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self atom_]; 
    } else if ([self predicts:MINIMATH2_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self match:MINIMATH2_TOKEN_KIND_OPEN_PAREN discard:YES]; 
        [self expr_]; 
        [self match:MINIMATH2_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primary'."];
    }

}

- (void)atom_ {
    
    [self matchNumber:NO]; 
    [self execute:(id)^{
     
    PUSH_DOUBLE(POP_DOUBLE()); 

    }];

}

@end