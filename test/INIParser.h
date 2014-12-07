#import <PEGKit/PKParser.h>

enum {
    INI_TOKEN_KIND_CLOSE_BRACKET = 14,
    INI_TOKEN_KIND_OPEN_BRACKET = 15,
    INI_TOKEN_KIND_EQUALS = 16,
    INI_TOKEN_KIND__R = 17,
    INI_TOKEN_KIND__N = 18,
};

@interface INIParser : PKParser

@end

