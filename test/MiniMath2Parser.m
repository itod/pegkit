#import "MiniMath2Parser.h"
#import <PEGKit/PEGKit.h>


@interface MiniMath2Parser ()

@end

@implementation MiniMath2Parser { }

- (instancetype)initWithDelegate:(id)d {
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

- (void)dealloc {
    

    [super dealloc];
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
        [self execute:^{
        
    PUSH_DOUBLE(POP_DOUBLE() + POP_DOUBLE());

        }];
    }

}

- (void)multExpr_ {
    
    [self primary_]; 
    while ([self speculate:^{ [self match:MINIMATH2_TOKEN_KIND_STAR discard:YES]; [self primary_]; }]) {
        [self match:MINIMATH2_TOKEN_KIND_STAR discard:YES]; 
        [self primary_]; 
        [self execute:^{
         
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
    [self execute:^{
     
    PUSH_DOUBLE(POP_DOUBLE()); 

    }];

}

@end