#import <PEGKit/PKParser.h>

enum {
    QUOTESYMBOL_TOKEN_KIND_SINGLE = 14,
    QUOTESYMBOL_TOKEN_KIND_DOUBLE,
    QUOTESYMBOL_TOKEN_KIND_BACK,
};

@interface QuoteSymbolParser : PKParser

@end

