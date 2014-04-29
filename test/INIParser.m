#import "INIParser.h"
#import <PEGKit/PEGKit.h>


@interface INIParser ()

@end

@implementation INIParser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"sections";
        self.tokenKindTab[@"]"] = @(INI_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"["] = @(INI_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@"="] = @(INI_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@";"] = @(INI_TOKEN_KIND_SEMI_COLON);

        self.tokenKindNameTab[INI_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[INI_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[INI_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[INI_TOKEN_KIND_SEMI_COLON] = @";";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;
    [t setTokenizerState:t.symbolState from:';' to:';'];

    }];

    [self sections_]; 
    [self matchEOF:YES]; 

}

- (void)sections_ {
    
    do {
        [self section_]; 
    } while ([self speculate:^{ [self section_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchSections:)];
}

- (void)section_ {
    
    if ([self speculate:^{ [self header_]; }]) {
        [self header_]; 
    }
    do {
        [self keyVal_]; 
    } while ([self speculate:^{ [self keyVal_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchSection:)];
}

- (void)header_ {
    
    [self match:INI_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    do {
        [self matchWord:NO]; 
    } while ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]);
    [self match:INI_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 
    [self match:INI_TOKEN_KIND_SEMI_COLON discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchHeader:)];
}

- (void)keyVal_ {
    
    [self key_]; 
    [self match:INI_TOKEN_KIND_EQUALS discard:YES]; 
    do {
        [self val_]; 
    } while ([self speculate:^{ [self val_]; }]);
    [self match:INI_TOKEN_KIND_SEMI_COLON discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchKeyVal:)];
}

- (void)key_ {
    
    [self testAndThrow:(id)^{ return NE(LS(1), @";"); }]; 
    [self matchAny:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchKey:)];
}

- (void)val_ {
    
    [self testAndThrow:(id)^{ return NE(LS(1), @";"); }]; 
    [self matchAny:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchVal:)];
}

@end