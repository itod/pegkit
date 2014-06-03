#import "DreadedParser.h"
#import <PEGKit/PEGKit.h>


@interface DreadedParser ()

@property (nonatomic, retain) NSMutableDictionary *s_memo;
@property (nonatomic, retain) NSMutableDictionary *a_memo;
@property (nonatomic, retain) NSMutableDictionary *b_memo;
@end

@implementation DreadedParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"s";
        self.tokenKindTab[@"a"] = @(DREADED_TOKEN_KIND_A);
        self.tokenKindTab[@"b"] = @(DREADED_TOKEN_KIND_B);

        self.tokenKindNameTab[DREADED_TOKEN_KIND_A] = @"a";
        self.tokenKindNameTab[DREADED_TOKEN_KIND_B] = @"b";

        self.s_memo = [NSMutableDictionary dictionary];
        self.a_memo = [NSMutableDictionary dictionary];
        self.b_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.s_memo = nil;
    self.a_memo = nil;
    self.b_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_s_memo removeAllObjects];
    [_a_memo removeAllObjects];
    [_b_memo removeAllObjects];
}

- (void)start {

    [self s_]; 
    [self matchEOF:YES]; 

}

- (void)__s {
    
    if ([self speculate:^{ [self a_]; }]) {
        [self a_]; 
    } else if ([self speculate:^{ [self a_]; [self b_]; }]) {
        [self a_]; 
        [self b_]; 
    } else {
        [self raise:@"No viable alternative found in rule 's'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchS:)];
}

- (void)s_ {
    [self parseRule:@selector(__s) withMemo:_s_memo];
}

- (void)__a {
    
    [self match:DREADED_TOKEN_KIND_A discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchA:)];
}

- (void)a_ {
    [self parseRule:@selector(__a) withMemo:_a_memo];
}

- (void)__b {
    
    [self match:DREADED_TOKEN_KIND_B discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchB:)];
}

- (void)b_ {
    [self parseRule:@selector(__b) withMemo:_b_memo];
}

@end