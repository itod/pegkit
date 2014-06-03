#import "NondeterministicPalindromeParser.h"
#import <PEGKit/PEGKit.h>


@interface NondeterministicPalindromeParser ()

@end

@implementation NondeterministicPalindromeParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"s";
        self.tokenKindTab[@"0"] = @(NONDETERMINISTICPALINDROME_TOKEN_KIND_0);
        self.tokenKindTab[@"1"] = @(NONDETERMINISTICPALINDROME_TOKEN_KIND_1);

        self.tokenKindNameTab[NONDETERMINISTICPALINDROME_TOKEN_KIND_0] = @"0";
        self.tokenKindNameTab[NONDETERMINISTICPALINDROME_TOKEN_KIND_1] = @"1";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {

    [self s_]; 
    [self matchEOF:YES]; 

}

- (void)s_ {
    
    if ([self speculate:^{ [self match:NONDETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO]; [self s_]; [self match:NONDETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO]; }]) {
        [self match:NONDETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO]; 
        [self s_]; 
        [self match:NONDETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO]; 
    } else if ([self speculate:^{ [self match:NONDETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO]; [self s_]; [self match:NONDETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO]; }]) {
        [self match:NONDETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO]; 
        [self s_]; 
        [self match:NONDETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO]; 
    } else if ([self speculate:^{ [self match:NONDETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO]; }]) {
        [self match:NONDETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO]; 
    } else if ([self speculate:^{ [self match:NONDETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO]; }]) {
        [self match:NONDETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 's'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchS:)];
}

@end