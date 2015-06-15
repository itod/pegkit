#import "MiniMath2Parser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


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
    PKParser_weakSelfDecl;

    [PKParser_weakSelf expr_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)expr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf addExpr_];

}

- (void)addExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf multExpr_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:MINIMATH2_TOKEN_KIND_PLUS discard:YES];[PKParser_weakSelf multExpr_];}]) {
        [PKParser_weakSelf match:MINIMATH2_TOKEN_KIND_PLUS discard:YES];
        [PKParser_weakSelf multExpr_];
        [PKParser_weakSelf execute:^{
        
    PUSH_DOUBLE(POP_DOUBLE() + POP_DOUBLE());

        }];
    }

}

- (void)multExpr_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf primary_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:MINIMATH2_TOKEN_KIND_STAR discard:YES];[PKParser_weakSelf primary_];}]) {
        [PKParser_weakSelf match:MINIMATH2_TOKEN_KIND_STAR discard:YES];
        [PKParser_weakSelf primary_];
        [PKParser_weakSelf execute:^{
         
    PUSH_DOUBLE(POP_DOUBLE() * POP_DOUBLE());

        }];
    }

}

- (void)primary_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [PKParser_weakSelf atom_];
    } else if ([PKParser_weakSelf predicts:MINIMATH2_TOKEN_KIND_OPEN_PAREN, 0]) {
        [PKParser_weakSelf match:MINIMATH2_TOKEN_KIND_OPEN_PAREN discard:YES];
        [PKParser_weakSelf expr_];
        [PKParser_weakSelf match:MINIMATH2_TOKEN_KIND_CLOSE_PAREN discard:YES];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'primary'."];
    }

}

- (void)atom_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchNumber:NO];
    [PKParser_weakSelf execute:^{
     
    PUSH_DOUBLE(POP_DOUBLE()); 

    }];

}

@end