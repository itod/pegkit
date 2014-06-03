#import "GreedParser.h"
#import <PEGKit/PEGKit.h>


@interface GreedParser ()

@property (nonatomic, retain) NSMutableDictionary *start_memo;
@property (nonatomic, retain) NSMutableDictionary *a_memo;
@property (nonatomic, retain) NSMutableDictionary *b_memo;
@end

@implementation GreedParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"a"] = @(GREED_TOKEN_KIND_A);
        self.tokenKindTab[@"b"] = @(GREED_TOKEN_KIND_B);

        self.tokenKindNameTab[GREED_TOKEN_KIND_A] = @"a";
        self.tokenKindNameTab[GREED_TOKEN_KIND_B] = @"b";

        self.start_memo = [NSMutableDictionary dictionary];
        self.a_memo = [NSMutableDictionary dictionary];
        self.b_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.start_memo = nil;
    self.a_memo = nil;
    self.b_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_start_memo removeAllObjects];
    [_a_memo removeAllObjects];
    [_b_memo removeAllObjects];
}

- (void)start {

    [self start_]; 
    [self matchEOF:YES]; 

}

- (void)__start {
    
    if ([self predicts:GREED_TOKEN_KIND_A, 0]) {
        [self a_]; 
        while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]) {
            [self matchAny:NO]; 
        }
        [self a_]; 
    } else if ([self predicts:GREED_TOKEN_KIND_B, 0]) {
        [self b_]; 
        do {
            [self matchAny:NO]; 
        } while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]);
        [self b_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'start'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)start_ {
    [self parseRule:@selector(__start) withMemo:_start_memo];
}

- (void)__a {
    
    [self match:GREED_TOKEN_KIND_A discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchA:)];
}

- (void)a_ {
    [self parseRule:@selector(__a) withMemo:_a_memo];
}

- (void)__b {
    
    [self match:GREED_TOKEN_KIND_B discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchB:)];
}

- (void)b_ {
    [self parseRule:@selector(__b) withMemo:_b_memo];
}

@end