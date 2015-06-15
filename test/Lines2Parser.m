#import "Lines2Parser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface Lines2Parser ()

@end

@implementation Lines2Parser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"lines";
        self.tokenKindTab[@"\r"] = @(LINES2_TOKEN_KIND__R);
        self.tokenKindTab[@"\n"] = @(LINES2_TOKEN_KIND__N);

        self.tokenKindNameTab[LINES2_TOKEN_KIND__R] = @"\r";
        self.tokenKindNameTab[LINES2_TOKEN_KIND__N] = @"\n";

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

    [t.whitespaceState setWhitespaceChars:NO from:'\n' to:'\n'];
    [t.whitespaceState setWhitespaceChars:NO from:'\r' to:'\r'];
    [t setTokenizerState:t.symbolState from:'\n' to:'\n'];
    [t setTokenizerState:t.symbolState from:'\r' to:'\r'];

    }];

    [PKParser_weakSelf lines_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)lines_ {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf line_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf line_];}]);

    [self fireDelegateSelector:@selector(parser:didMatchLines:)];
}

- (void)line_ {
    PKParser_weakSelfDecl;
    while ([PKParser_weakSelf speculate:^{ if (![self predicts:LINES2_TOKEN_KIND__N, 0] && ![self predicts:LINES2_TOKEN_KIND__R, 0]) {[self match:TOKEN_KIND_BUILTIN_ANY discard:NO];} else {[self raise:@"negation test failed in line"];}}]) {
        if (![self predicts:LINES2_TOKEN_KIND__N, 0] && ![self predicts:LINES2_TOKEN_KIND__R, 0]) {
            [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
        } else {
            [self raise:@"negation test failed in line"];
        }
    }
    do {
        [PKParser_weakSelf eol_];
    } while ([self predicts:LINES2_TOKEN_KIND__N, LINES2_TOKEN_KIND__R, 0]);

    [self fireDelegateSelector:@selector(parser:didMatchLine:)];
}

- (void)eol_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:LINES2_TOKEN_KIND__N, 0]) {
        [PKParser_weakSelf match:LINES2_TOKEN_KIND__N discard:YES];
    } else if ([PKParser_weakSelf predicts:LINES2_TOKEN_KIND__R, 0]) {
        [PKParser_weakSelf match:LINES2_TOKEN_KIND__R discard:YES];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'eol'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchEol:)];
}

@end