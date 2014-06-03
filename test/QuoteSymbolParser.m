#import "QuoteSymbolParser.h"
#import <PEGKit/PEGKit.h>


@interface QuoteSymbolParser ()

@end

@implementation QuoteSymbolParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"'"] = @(QUOTESYMBOL_TOKEN_KIND_SINGLE);
        self.tokenKindTab[@"\""] = @(QUOTESYMBOL_TOKEN_KIND_DOUBLE);
        self.tokenKindTab[@"\\"] = @(QUOTESYMBOL_TOKEN_KIND_BACK);

        self.tokenKindNameTab[QUOTESYMBOL_TOKEN_KIND_SINGLE] = @"'";
        self.tokenKindNameTab[QUOTESYMBOL_TOKEN_KIND_DOUBLE] = @"\"";
        self.tokenKindNameTab[QUOTESYMBOL_TOKEN_KIND_BACK] = @"\\";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;
	[t setTokenizerState:t.symbolState from:'"' to:'"'];
	[t setTokenizerState:t.symbolState from:'\'' to:'\''];

    }];

    [self start_]; 
    [self matchEOF:YES]; 

}

- (void)start_ {
    
    do {
        [self sym_]; 
    } while ([self predicts:QUOTESYMBOL_TOKEN_KIND_BACK, QUOTESYMBOL_TOKEN_KIND_DOUBLE, QUOTESYMBOL_TOKEN_KIND_SINGLE, 0]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)sym_ {
    
    if ([self predicts:QUOTESYMBOL_TOKEN_KIND_SINGLE, 0]) {
        [self single_]; 
    } else if ([self predicts:QUOTESYMBOL_TOKEN_KIND_DOUBLE, 0]) {
        [self double_]; 
    } else if ([self predicts:QUOTESYMBOL_TOKEN_KIND_BACK, 0]) {
        [self back_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'sym'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchSym:)];
}

- (void)single_ {
    
    [self match:QUOTESYMBOL_TOKEN_KIND_SINGLE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchSingle:)];
}

- (void)double_ {
    
    [self match:QUOTESYMBOL_TOKEN_KIND_DOUBLE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDouble:)];
}

- (void)back_ {
    
    [self match:QUOTESYMBOL_TOKEN_KIND_BACK discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchBack:)];
}

@end