#import "INIParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


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

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"sections";
        self.tokenKindTab[@"]"] = @(INI_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"["] = @(INI_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@"="] = @(INI_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"\r"] = @(INI_TOKEN_KIND__R);
        self.tokenKindTab[@"\n"] = @(INI_TOKEN_KIND__N);

        self.tokenKindNameTab[INI_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[INI_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[INI_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[INI_TOKEN_KIND__R] = @"\r";
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
    PKParser_weakSelfDecl;
    [PKParser_weakSelf execute:^{
    
    self.sections = [NSMutableDictionary dictionary];
    self.currentSectionName = @"[[Default]]";
    _sections[_currentSectionName] = [NSMutableDictionary dictionary];
    
    PKTokenizer *t = self.tokenizer;
    
    [t setTokenizerState:t.symbolState from:'\n' to:'\n'];
    [t setTokenizerState:t.symbolState from:'\r' to:'\r'];

    [t.commentState addSingleLineStartMarker:@";"];

    }];

    [PKParser_weakSelf sections_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)sections_ {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf section_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf section_];}]);

    [self fireDelegateSelector:@selector(parser:didMatchSections:)];
}

- (void)section_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf header_];}]) {
        [PKParser_weakSelf header_];
    }
    do {
        [PKParser_weakSelf keyVal_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf keyVal_];}]);

    [self fireDelegateSelector:@selector(parser:didMatchSection:)];
}

- (void)header_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:INI_TOKEN_KIND_OPEN_BRACKET discard:NO];
    do {
        if (![self predicts:INI_TOKEN_KIND_CLOSE_BRACKET, 0]) {
            [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
        } else {
            [self raise:@"negation test failed in header"];
        }
    } while ([PKParser_weakSelf speculate:^{ if (![self predicts:INI_TOKEN_KIND_CLOSE_BRACKET, 0]) {[self match:TOKEN_KIND_BUILTIN_ANY discard:NO];} else {[self raise:@"negation test failed in header"];}}]);
    [PKParser_weakSelf match:INI_TOKEN_KIND_CLOSE_BRACKET discard:YES];
    [PKParser_weakSelf nl_];

    [self fireDelegateSelector:@selector(parser:didMatchHeader:)];
}

- (void)keyVal_ {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf key_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf key_];}]);
    [PKParser_weakSelf match:INI_TOKEN_KIND_EQUALS discard:YES];
    do {
        [PKParser_weakSelf val_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf val_];}]);
    [PKParser_weakSelf nl_];

    [self fireDelegateSelector:@selector(parser:didMatchKeyVal:)];
}

- (void)key_ {
    PKParser_weakSelfDecl;
    if (![self predicts:INI_TOKEN_KIND_EQUALS, 0]) {
        [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [self raise:@"negation test failed in key"];
    }

    [self fireDelegateSelector:@selector(parser:didMatchKey:)];
}

- (void)val_ {
    PKParser_weakSelfDecl;
    if (![PKParser_weakSelf speculate:^{ [PKParser_weakSelf nl_];}]) {
        [PKParser_weakSelf match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [PKParser_weakSelf raise:@"negation test failed in val"];
    }

    [self fireDelegateSelector:@selector(parser:didMatchVal:)];
}

- (void)nl_ {
    PKParser_weakSelfDecl;
    do {
        if ([PKParser_weakSelf predicts:INI_TOKEN_KIND__N, 0]) {
            [PKParser_weakSelf match:INI_TOKEN_KIND__N discard:YES];
        } else if ([PKParser_weakSelf predicts:INI_TOKEN_KIND__R, 0]) {
            [PKParser_weakSelf match:INI_TOKEN_KIND__R discard:YES];
        } else {
            [PKParser_weakSelf raise:@"No viable alternative found in rule 'nl'."];
        }
    } while ([self predicts:INI_TOKEN_KIND__N, INI_TOKEN_KIND__R, 0]);

    [self fireDelegateSelector:@selector(parser:didMatchNl:)];
}

@end