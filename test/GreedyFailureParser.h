#import <PEGKit/PKParser.h>

enum {
    GREEDYFAILURE_TOKEN_KIND_LCURLY = 14,
    GREEDYFAILURE_TOKEN_KIND_RCURLY = 15,
    GREEDYFAILURE_TOKEN_KIND_COLON = 16,
};

@interface GreedyFailureParser : PKParser

@end

