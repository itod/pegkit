#import "Negation2Parser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


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
    PKParser_weakSelfDecl;
    [PKParser_weakSelf execute:^{
    
        PKTokenizer *t = self.tokenizer;

        // symbols
        [t.symbolState add:@"{%"];
        [t.symbolState add:@"%}"];

    }];

    [PKParser_weakSelf document_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)document_ {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf any_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf any_];}]);

    [self fireDelegateSelector:@selector(parser:didMatchDocument:)];
}

- (void)any_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf tag_];}]) {
        [PKParser_weakSelf tag_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf text_];}]) {
        [PKParser_weakSelf text_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'any'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAny:)];
}

- (void)text_ {
    PKParser_weakSelfDecl;
    if (![self predicts:NEGATION2_TOKEN_KIND_TAGSTART, 0]) {
        [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [self raise:@"negation test failed in text"];
    }

    [self fireDelegateSelector:@selector(parser:didMatchText:)];
}

- (void)tag_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf tagStart_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf tagContent_];}]) {
        [PKParser_weakSelf tagContent_];
    }
    [PKParser_weakSelf tagEnd_];

    [self fireDelegateSelector:@selector(parser:didMatchTag:)];
}

- (void)tagStart_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:NEGATION2_TOKEN_KIND_TAGSTART discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchTagStart:)];
}

- (void)tagEnd_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:NEGATION2_TOKEN_KIND_TAGEND discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchTagEnd:)];
}

- (void)tagContent_ {
    PKParser_weakSelfDecl;
    if (![self predicts:NEGATION2_TOKEN_KIND_TAGEND, 0]) {
        [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [self raise:@"negation test failed in tagContent"];
    }

    [self fireDelegateSelector:@selector(parser:didMatchTagContent:)];
}

@end