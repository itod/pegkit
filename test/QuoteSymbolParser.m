#import "QuoteSymbolParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


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
    PKParser_weakSelfDecl;
    [PKParser_weakSelf execute:^{
    
    PKTokenizer *t = self.tokenizer;
	[t setTokenizerState:t.symbolState from:'"' to:'"'];
	[t setTokenizerState:t.symbolState from:'\'' to:'\''];

    }];

    [PKParser_weakSelf start_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)start_ {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf sym_];
    } while ([self predicts:QUOTESYMBOL_TOKEN_KIND_BACK, QUOTESYMBOL_TOKEN_KIND_DOUBLE, QUOTESYMBOL_TOKEN_KIND_SINGLE, 0]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)sym_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:QUOTESYMBOL_TOKEN_KIND_SINGLE, 0]) {
        [PKParser_weakSelf single_];
    } else if ([PKParser_weakSelf predicts:QUOTESYMBOL_TOKEN_KIND_DOUBLE, 0]) {
        [PKParser_weakSelf double_];
    } else if ([PKParser_weakSelf predicts:QUOTESYMBOL_TOKEN_KIND_BACK, 0]) {
        [PKParser_weakSelf back_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'sym'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchSym:)];
}

- (void)single_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:QUOTESYMBOL_TOKEN_KIND_SINGLE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchSingle:)];
}

- (void)double_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:QUOTESYMBOL_TOKEN_KIND_DOUBLE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchDouble:)];
}

- (void)back_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:QUOTESYMBOL_TOKEN_KIND_BACK discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchBack:)];
}

@end