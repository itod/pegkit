#import "INIParser.h"
#import <PEGKit/PEGKit.h>


@interface INIParser ()
    
@property (nonatomic, retain) NSString *currentSectionName;
@property (nonatomic, retain) NSMutableDictionary *sections;

@end

@implementation INIParser { }
    
- (NSMutableDictionary *)tabForSection:(NSString *)sectionName {
    ASSERT(_sections);
    NSMutableDictionary *tab = _sections[sectionName];
    if (!tab) {
        tab = [NSMutableDictionary dictionary];
        _sections[sectionName] = tab;
    }
    return tab;
}

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"sections";
        self.tokenKindTab[@"]"] = @(INI_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"["] = @(INI_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@"="] = @(INI_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"\n"] = @(INI_TOKEN_KIND__N);

        self.tokenKindNameTab[INI_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[INI_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[INI_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[INI_TOKEN_KIND__N] = @"\n";

    }
    return self;
}

- (void)dealloc {
        
    self.currentSectionName = nil;
    self.sections = nil;


    [super dealloc];
}

- (void)start {
    [self execute:^{
    
    self.sections = [NSMutableDictionary dictionary];
    self.currentSectionName = @"[[Default]]";
    _sections[_currentSectionName] = [NSMutableDictionary dictionary];
    
    PKTokenizer *t = self.tokenizer;
    
    [t setTokenizerState:t.symbolState from:'\n' to:'\n'];

    [t.commentState addSingleLineStartMarker:@";"];

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
    [self match:INI_TOKEN_KIND__N discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchHeader:)];
}

- (void)keyVal_ {
    
    do {
        [self key_]; 
    } while ([self speculate:^{ [self key_]; }]);
    [self match:INI_TOKEN_KIND_EQUALS discard:YES]; 
    do {
        [self val_]; 
    } while ([self speculate:^{ [self val_]; }]);
    [self match:INI_TOKEN_KIND__N discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchKeyVal:)];
}

- (void)key_ {
    
    if (![self predicts:INI_TOKEN_KIND_EQUALS, 0]) {
        [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [self raise:@"negation test failed in key"];
    }

    [self fireDelegateSelector:@selector(parser:didMatchKey:)];
}

- (void)val_ {
    
    if (![self predicts:INI_TOKEN_KIND__N, 0]) {
        [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [self raise:@"negation test failed in val"];
    }

    [self fireDelegateSelector:@selector(parser:didMatchVal:)];
}

@end