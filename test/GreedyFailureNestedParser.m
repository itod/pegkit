#import "GreedyFailureNestedParser.h"
#import <PEGKit/PEGKit.h>

#define LT(i) [self LT:(i)]
#define LA(i) [self LA:(i)]
#define LS(i) [self LS:(i)]
#define LF(i) [self LD:(i)]

#define POP()        [self.assembly pop]
#define POP_STR()    [self popString]
#define POP_TOK()    [self popToken]
#define POP_BOOL()   [self popBool]
#define POP_INT()    [self popInteger]
#define POP_DOUBLE() [self popDouble]

#define PUSH(obj)      [self.assembly push:(id)(obj)]
#define PUSH_BOOL(yn)  [self pushBool:(BOOL)(yn)]
#define PUSH_INT(i)    [self pushInteger:(NSInteger)(i)]
#define PUSH_DOUBLE(d) [self pushDouble:(double)(d)]

#define EQ(a, b) [(a) isEqual:(b)]
#define NE(a, b) (![(a) isEqual:(b)])
#define EQ_IGNORE_CASE(a, b) (NSOrderedSame == [(a) compare:(b)])

#define MATCHES(pattern, str)               ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:0                                  error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)
#define MATCHES_IGNORE_CASE(pattern, str)   ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:NSRegularExpressionCaseInsensitive error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)

#define ABOVE(fence) [self.assembly objectsAbove:(fence)]

#define LOG(obj) do { NSLog(@"%@", (obj)); } while (0);
#define PRINT(str) do { printf("%s\n", (str)); } while (0);

@interface PKParser ()
@property (nonatomic, retain) NSMutableDictionary *tokenKindTab;
@property (nonatomic, retain) NSMutableArray *tokenKindNameTab;
@property (nonatomic, retain) NSString *startRuleName;
@property (nonatomic, retain) NSString *statementTerminator;
@property (nonatomic, retain) NSString *singleLineCommentMarker;
@property (nonatomic, retain) NSString *blockStartMarker;
@property (nonatomic, retain) NSString *blockEndMarker;
@property (nonatomic, retain) NSString *braces;

- (BOOL)popBool;
- (NSInteger)popInteger;
- (double)popDouble;
- (PKToken *)popToken;
- (NSString *)popString;

- (void)pushBool:(BOOL)yn;
- (void)pushInteger:(NSInteger)i;
- (void)pushDouble:(double)d;
@end

@interface GreedyFailureNestedParser ()
@end

@implementation GreedyFailureNestedParser

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        self.startRuleName = @"structs";
        self.enableAutomaticErrorRecovery = YES;

        self.tokenKindTab[@","] = @(GREEDYFAILURENESTED_TOKEN_KIND_COMMA);
        self.tokenKindTab[@":"] = @(GREEDYFAILURENESTED_TOKEN_KIND_COLON);
        self.tokenKindTab[@"}"] = @(GREEDYFAILURENESTED_TOKEN_KIND_RCURLY);
        self.tokenKindTab[@"{"] = @(GREEDYFAILURENESTED_TOKEN_KIND_LCURLY);

        self.tokenKindNameTab[GREEDYFAILURENESTED_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[GREEDYFAILURENESTED_TOKEN_KIND_COLON] = @":";
        self.tokenKindNameTab[GREEDYFAILURENESTED_TOKEN_KIND_RCURLY] = @"}";
        self.tokenKindNameTab[GREEDYFAILURENESTED_TOKEN_KIND_LCURLY] = @"{";

    }
    return self;
}

- (void)start {
    [self tryAndRecover:TOKEN_KIND_BUILTIN_EOF block:^{
        [self structs_]; 
        [self matchEOF:YES]; 
    } completion:^{
        [self matchEOF:YES];
    }];
}

- (void)structs_ {
    
    do {
        [self structure_]; 
    } while ([self speculate:^{ [self structure_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchStructs:)];
}

- (void)structure_ {
    
    [self lcurly_]; 
    [self tryAndRecover:GREEDYFAILURENESTED_TOKEN_KIND_RCURLY block:^{ 
        [self pair_]; 
        while ([self speculate:^{ [self comma_]; [self pair_]; }]) {
            [self comma_]; 
            [self pair_]; 
        }
        [self rcurly_]; 
    } completion:^{ 
        [self rcurly_]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchStructure:)];
}

- (void)pair_ {
    
    [self tryAndRecover:GREEDYFAILURENESTED_TOKEN_KIND_COLON block:^{ 
        [self name_]; 
        [self colon_]; 
    } completion:^{ 
        [self colon_]; 
    }];
        [self value_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPair:)];
}

- (void)name_ {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchName:)];
}

- (void)value_ {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchValue:)];
}

- (void)comma_ {
    
    [self match:GREEDYFAILURENESTED_TOKEN_KIND_COMMA discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchComma:)];
}

- (void)lcurly_ {
    
    [self match:GREEDYFAILURENESTED_TOKEN_KIND_LCURLY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLcurly:)];
}

- (void)rcurly_ {
    
    [self match:GREEDYFAILURENESTED_TOKEN_KIND_RCURLY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchRcurly:)];
}

- (void)colon_ {
    
    [self match:GREEDYFAILURENESTED_TOKEN_KIND_COLON discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchColon:)];
}

@end