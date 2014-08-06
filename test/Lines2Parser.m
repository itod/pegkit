#import "Lines2Parser.h"
#import <PEGKit/PEGKit.h>


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
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;

    [t setTokenizerState:t.symbolState from:'n' to:'n'];
    [t setTokenizerState:t.symbolState from:'r' to:'r'];

    }];

    [self lines_]; 
    [self matchEOF:YES]; 

}

- (void)lines_ {
    
    do {
        [self line_]; 
    } while ([self speculate:^{ [self line_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchLines:)];
}

- (void)line_ {
    
    while ([self speculate:^{ if (![self predicts:LINES2_TOKEN_KIND__N, 0] && ![self predicts:LINES2_TOKEN_KIND__R, 0]) {[self match:TOKEN_KIND_BUILTIN_ANY discard:NO];} else {[self raise:@"negation test failed in line"];}}]) {
        if (![self predicts:LINES2_TOKEN_KIND__N, 0] && ![self predicts:LINES2_TOKEN_KIND__R, 0]) {
            [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
        } else {
            [self raise:@"negation test failed in line"];
        }
    }
    [self eol_]; 

    [self fireDelegateSelector:@selector(parser:didMatchLine:)];
}

- (void)eol_ {
    
    if ([self predicts:LINES2_TOKEN_KIND__N, 0]) {
        [self match:LINES2_TOKEN_KIND__N discard:NO]; 
    } else if ([self predicts:LINES2_TOKEN_KIND__R, 0]) {
        [self match:LINES2_TOKEN_KIND__R discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'eol'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchEol:)];
}

@end