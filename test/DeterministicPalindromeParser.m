#import "DeterministicPalindromeParser.h"
#import <PEGKit/PEGKit.h>


@interface DeterministicPalindromeParser ()

@end

@implementation DeterministicPalindromeParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"s";
        self.tokenKindTab[@"0"] = @(DETERMINISTICPALINDROME_TOKEN_KIND_0);
        self.tokenKindTab[@"1"] = @(DETERMINISTICPALINDROME_TOKEN_KIND_1);
        self.tokenKindTab[@"2"] = @(DETERMINISTICPALINDROME_TOKEN_KIND_2);

        self.tokenKindNameTab[DETERMINISTICPALINDROME_TOKEN_KIND_0] = @"0";
        self.tokenKindNameTab[DETERMINISTICPALINDROME_TOKEN_KIND_1] = @"1";
        self.tokenKindNameTab[DETERMINISTICPALINDROME_TOKEN_KIND_2] = @"2";

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
    
    if ([self predicts:DETERMINISTICPALINDROME_TOKEN_KIND_0, 0]) {
        [self match:DETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO]; 
        [self s_]; 
        [self match:DETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO]; 
    } else if ([self predicts:DETERMINISTICPALINDROME_TOKEN_KIND_1, 0]) {
        [self match:DETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO]; 
        [self s_]; 
        [self match:DETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO]; 
    } else if ([self predicts:DETERMINISTICPALINDROME_TOKEN_KIND_2, 0]) {
        [self match:DETERMINISTICPALINDROME_TOKEN_KIND_2 discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 's'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchS:)];
}

@end