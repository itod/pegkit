#import "DeterministicPalindromeParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


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
    PKParser_weakSelfDecl;

    [PKParser_weakSelf s_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)s_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:DETERMINISTICPALINDROME_TOKEN_KIND_0, 0]) {
        [PKParser_weakSelf match:DETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO];
        [PKParser_weakSelf s_];
        [PKParser_weakSelf match:DETERMINISTICPALINDROME_TOKEN_KIND_0 discard:NO];
    } else if ([PKParser_weakSelf predicts:DETERMINISTICPALINDROME_TOKEN_KIND_1, 0]) {
        [PKParser_weakSelf match:DETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO];
        [PKParser_weakSelf s_];
        [PKParser_weakSelf match:DETERMINISTICPALINDROME_TOKEN_KIND_1 discard:NO];
    } else if ([PKParser_weakSelf predicts:DETERMINISTICPALINDROME_TOKEN_KIND_2, 0]) {
        [PKParser_weakSelf match:DETERMINISTICPALINDROME_TOKEN_KIND_2 discard:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 's'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchS:)];
}

@end