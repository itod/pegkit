#import "DupeLiteralsParser.h"
#import <PEGKit/PEGKit.h>


@interface DupeLiteralsParser ()

@end

@implementation DupeLiteralsParser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"none"] = @(DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE);
        self.tokenKindTab[@"none"] = @(DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE);
        self.tokenKindTab[@"?("] = @(DUPELITERALS_TOKEN_KIND_WEIRD);
        self.tokenKindTab[@"none"] = @(DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE);

        self.tokenKindNameTab[DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE] = @"none";
        self.tokenKindNameTab[DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE] = @"none";
        self.tokenKindNameTab[DUPELITERALS_TOKEN_KIND_WEIRD] = @"?(";
        self.tokenKindNameTab[DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE] = @"none";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;
	[t.symbolState add:@"?("];

    }];

    [self start_]; 
    [self matchEOF:YES]; 

}

- (void)start_ {
    
    do {
        if ([self predicts:DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE, 0]) {
            [self none_]; 
        } else if ([self predicts:DUPELITERALS_TOKEN_KIND_WEIRD, 0]) {
            [self weird_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'start'."];
        }
    } while ([self predicts:DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE, DUPELITERALS_TOKEN_KIND_WEIRD, 0]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)none_ {
    
    if ([self speculate:^{ [self match:DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE discard:NO]; }]) {
        [self match:DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE discard:NO]; 
    } else if ([self speculate:^{ [self match:DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE discard:NO]; }]) {
        [self match:DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE discard:NO]; 
    } else if ([self speculate:^{ [self match:DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE discard:NO]; }]) {
        [self match:DUPELITERALS_DUPELITERALS_DUPELITERALS_TOKEN_KIND_NONE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'none'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNone:)];
}

- (void)weird_ {
    
    [self match:DUPELITERALS_TOKEN_KIND_WEIRD discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchWeird:)];
}

@end