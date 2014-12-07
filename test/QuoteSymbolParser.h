#import <PEGKit/PKParser.h>

enum {
    QUOTESYMBOL_TOKEN_KIND_SINGLE = 14,
    QUOTESYMBOL_TOKEN_KIND_DOUBLE = 15,
    QUOTESYMBOL_TOKEN_KIND_BACK = 16,
};

@interface QuoteSymbolParser : PKParser

@end

