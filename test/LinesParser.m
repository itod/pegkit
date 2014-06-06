#import "LinesParser.h"
#import <PEGKit/PEGKit.h>


@interface LinesParser ()

@end

@implementation LinesParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"lines";


    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;

    // whitespace
    self.silentlyConsumesWhitespace = NO;
    t.whitespaceState.reportsWhitespaceTokens = YES;

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
    
    while ([self speculate:^{ if (![self speculate:^{ [self eol_]; }]) {[self match:TOKEN_KIND_BUILTIN_ANY discard:NO];} else {[self raise:@"negation test failed in line"];}}]) {
        if (![self speculate:^{ [self eol_]; }]) {
            [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
        } else {
            [self raise:@"negation test failed in line"];
        }
    }
    [self eol_]; 

    [self fireDelegateSelector:@selector(parser:didMatchLine:)];
}

- (void)eol_ {
    
    [self testAndThrow:(id)^{ return EQ(@"\n", LS(1)); }]; 
    [self matchWhitespace:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchEol:)];
}

@end