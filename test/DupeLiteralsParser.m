#import "DupeLiteralsParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface DupeLiteralsParser ()

@end

@implementation DupeLiteralsParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"NONE"] = @(DUPELITERALS_TOKEN_KIND_NONE_1);
        self.tokenKindTab[@"None"] = @(DUPELITERALS_TOKEN_KIND_NONE_2);
        self.tokenKindTab[@"|"] = @(DUPELITERALS_TOKEN_KIND_PIPE);
        self.tokenKindTab[@"none"] = @(DUPELITERALS_TOKEN_KIND_NONE);
        self.tokenKindTab[@"\""] = @(DUPELITERALS_TOKEN_KIND_QUOTE);

        self.tokenKindNameTab[DUPELITERALS_TOKEN_KIND_NONE_1] = @"NONE";
        self.tokenKindNameTab[DUPELITERALS_TOKEN_KIND_NONE_2] = @"None";
        self.tokenKindNameTab[DUPELITERALS_TOKEN_KIND_PIPE] = @"|";
        self.tokenKindNameTab[DUPELITERALS_TOKEN_KIND_NONE] = @"none";
        self.tokenKindNameTab[DUPELITERALS_TOKEN_KIND_QUOTE] = @"\"";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf execute:^{
    
    PKTokenizer *t = self.tokenizer;

    [t setTokenizerState:t.symbolState from:'"' to:'"'];

    }];

    [PKParser_weakSelf start_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)start_ {
    PKParser_weakSelfDecl;
    do {
        if ([PKParser_weakSelf predicts:DUPELITERALS_TOKEN_KIND_NONE, DUPELITERALS_TOKEN_KIND_NONE_1, DUPELITERALS_TOKEN_KIND_NONE_2, 0]) {
            [PKParser_weakSelf none_];
        } else if ([PKParser_weakSelf predicts:DUPELITERALS_TOKEN_KIND_QUOTE, 0]) {
            [PKParser_weakSelf quote_];
        } else if ([PKParser_weakSelf predicts:DUPELITERALS_TOKEN_KIND_PIPE, 0]) {
            [PKParser_weakSelf block_];
        } else {
            [PKParser_weakSelf raise:@"No viable alternative found in rule 'start'."];
        }
    } while ([PKParser_weakSelf speculate:^{ if ([PKParser_weakSelf predicts:DUPELITERALS_TOKEN_KIND_NONE, DUPELITERALS_TOKEN_KIND_NONE_1, DUPELITERALS_TOKEN_KIND_NONE_2, 0]) {[PKParser_weakSelf none_];} else if ([PKParser_weakSelf predicts:DUPELITERALS_TOKEN_KIND_QUOTE, 0]) {[PKParser_weakSelf quote_];} else if ([PKParser_weakSelf predicts:DUPELITERALS_TOKEN_KIND_PIPE, 0]) {[PKParser_weakSelf block_];} else {[PKParser_weakSelf raise:@"No viable alternative found in rule 'start'."];}}]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)none_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:DUPELITERALS_TOKEN_KIND_NONE, 0]) {
        [PKParser_weakSelf match:DUPELITERALS_TOKEN_KIND_NONE discard:NO];
    } else if ([PKParser_weakSelf predicts:DUPELITERALS_TOKEN_KIND_NONE_1, 0]) {
        [PKParser_weakSelf match:DUPELITERALS_TOKEN_KIND_NONE_1 discard:NO];
    } else if ([PKParser_weakSelf predicts:DUPELITERALS_TOKEN_KIND_NONE_2, 0]) {
        [PKParser_weakSelf match:DUPELITERALS_TOKEN_KIND_NONE_2 discard:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'none'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNone:)];
}

- (void)quote_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:DUPELITERALS_TOKEN_KIND_QUOTE discard:YES];
    [PKParser_weakSelf matchWord:NO];
    [PKParser_weakSelf match:DUPELITERALS_TOKEN_KIND_QUOTE discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchQuote:)];
}

- (void)block_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:DUPELITERALS_TOKEN_KIND_PIPE discard:NO];
    [PKParser_weakSelf matchWord:NO];
    [PKParser_weakSelf match:DUPELITERALS_TOKEN_KIND_PIPE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchBlock:)];
}

@end