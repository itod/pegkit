#import "DupeLiteralsParser.h"
#import <PEGKit/PEGKit.h>


@interface DupeLiteralsParser ()

@end

@implementation DupeLiteralsParser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"NONE"] = @(DUPELITERALS_TOKEN_KIND_NONE_1);
        self.tokenKindTab[@"None"] = @(DUPELITERALS_TOKEN_KIND_NONE_2);
        self.tokenKindTab[@"?("] = @(DUPELITERALS_TOKEN_KIND_1);
        self.tokenKindTab[@"none"] = @(DUPELITERALS_TOKEN_KIND_NONE);
        self.tokenKindTab[@"):"] = @(DUPELITERALS_TOKEN_KIND_2);

        self.tokenKindNameTab[DUPELITERALS_TOKEN_KIND_NONE_1] = @"NONE";
        self.tokenKindNameTab[DUPELITERALS_TOKEN_KIND_NONE_2] = @"None";
        self.tokenKindNameTab[DUPELITERALS_TOKEN_KIND_1] = @"?(";
        self.tokenKindNameTab[DUPELITERALS_TOKEN_KIND_NONE] = @"none";
        self.tokenKindNameTab[DUPELITERALS_TOKEN_KIND_2] = @"):";

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
        if ([self predicts:DUPELITERALS_TOKEN_KIND_NONE, DUPELITERALS_TOKEN_KIND_NONE_1, DUPELITERALS_TOKEN_KIND_NONE_2, 0]) {
            [self none_]; 
        } else if ([self predicts:DUPELITERALS_TOKEN_KIND_1, DUPELITERALS_TOKEN_KIND_2, 0]) {
            [self weird_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'start'."];
        }
    } while ([self predicts:DUPELITERALS_TOKEN_KIND_1, DUPELITERALS_TOKEN_KIND_2, DUPELITERALS_TOKEN_KIND_NONE, DUPELITERALS_TOKEN_KIND_NONE_1, DUPELITERALS_TOKEN_KIND_NONE_2, 0]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)none_ {
    
    if ([self predicts:DUPELITERALS_TOKEN_KIND_NONE, 0]) {
        [self match:DUPELITERALS_TOKEN_KIND_NONE discard:NO]; 
    } else if ([self predicts:DUPELITERALS_TOKEN_KIND_NONE_1, 0]) {
        [self match:DUPELITERALS_TOKEN_KIND_NONE_1 discard:NO]; 
    } else if ([self predicts:DUPELITERALS_TOKEN_KIND_NONE_2, 0]) {
        [self match:DUPELITERALS_TOKEN_KIND_NONE_2 discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'none'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNone:)];
}

- (void)weird_ {
    
    if ([self predicts:DUPELITERALS_TOKEN_KIND_1, 0]) {
        [self match:DUPELITERALS_TOKEN_KIND_1 discard:NO]; 
    } else if ([self predicts:DUPELITERALS_TOKEN_KIND_2, 0]) {
        [self match:DUPELITERALS_TOKEN_KIND_2 discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'weird'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchWeird:)];
}

@end