#import <PEGKit/PKParser.h>

enum {
    INI_TOKEN_KIND_CLOSE_BRACKET = 14,
    INI_TOKEN_KIND_OPEN_BRACKET,
    INI_TOKEN_KIND_EQUALS,
    INI_TOKEN_KIND__R,
    INI_TOKEN_KIND__N,
};

@interface INIParser : PKParser

@end

