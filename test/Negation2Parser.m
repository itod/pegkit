#import "Negation2Parser.h"
#import <PEGKit/PEGKit.h>


@interface Negation2Parser ()

@end

@implementation Negation2Parser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"document";
        self.tokenKindTab[@"{%"] = @(NEGATION2_TOKEN_KIND_TAGSTART);
        self.tokenKindTab[@"%}"] = @(NEGATION2_TOKEN_KIND_TAGEND);

        self.tokenKindNameTab[NEGATION2_TOKEN_KIND_TAGSTART] = @"{%";
        self.tokenKindNameTab[NEGATION2_TOKEN_KIND_TAGEND] = @"%}";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    [self execute:^{
    
        PKTokenizer *t = self.tokenizer;

        // symbols
        [t.symbolState add:@"{%"];
        [t.symbolState add:@"%}"];

    }];

    [self document_]; 
    [self matchEOF:YES]; 

}

- (void)document_ {
    
    do {
        [self any_]; 
    } while ([self speculate:^{ [self any_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchDocument:)];
}

- (void)any_ {
    
    if ([self speculate:^{ [self tag_]; }]) {
        [self tag_]; 
    } else if ([self speculate:^{ [self text_]; }]) {
        [self text_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'any'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAny:)];
}

- (void)text_ {
    
    if (![self predicts:NEGATION2_TOKEN_KIND_TAGSTART, 0]) {
        [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [self raise:@"negation test failed in text"];
    }

    [self fireDelegateSelector:@selector(parser:didMatchText:)];
}

- (void)tag_ {
    
    [self tagStart_]; 
    while ([self speculate:^{ [self tagContent_]; }]) {
        [self tagContent_]; 
    }
    [self tagEnd_]; 

    [self fireDelegateSelector:@selector(parser:didMatchTag:)];
}

- (void)tagStart_ {
    
    [self match:NEGATION2_TOKEN_KIND_TAGSTART discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchTagStart:)];
}

- (void)tagEnd_ {
    
    [self match:NEGATION2_TOKEN_KIND_TAGEND discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchTagEnd:)];
}

- (void)tagContent_ {
    
    if (![self predicts:NEGATION2_TOKEN_KIND_TAGEND, 0]) {
        [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [self raise:@"negation test failed in tagContent"];
    }

    [self fireDelegateSelector:@selector(parser:didMatchTagContent:)];
}

@end