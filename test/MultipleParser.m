#import "MultipleParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface MultipleParser ()

@property (nonatomic, retain) NSMutableDictionary *s_memo;
@property (nonatomic, retain) NSMutableDictionary *ab_memo;
@property (nonatomic, retain) NSMutableDictionary *a_memo;
@property (nonatomic, retain) NSMutableDictionary *b_memo;
@end

@implementation MultipleParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"s";
        self.tokenKindTab[@"a"] = @(MULTIPLE_TOKEN_KIND_A);
        self.tokenKindTab[@"b"] = @(MULTIPLE_TOKEN_KIND_B);

        self.tokenKindNameTab[MULTIPLE_TOKEN_KIND_A] = @"a";
        self.tokenKindNameTab[MULTIPLE_TOKEN_KIND_B] = @"b";

        self.s_memo = [NSMutableDictionary dictionary];
        self.ab_memo = [NSMutableDictionary dictionary];
        self.a_memo = [NSMutableDictionary dictionary];
        self.b_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.s_memo = nil;
    self.ab_memo = nil;
    self.a_memo = nil;
    self.b_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_s_memo removeAllObjects];
    [_ab_memo removeAllObjects];
    [_a_memo removeAllObjects];
    [_b_memo removeAllObjects];
}

- (void)start {
    PKParser_weakSelfDecl;

    [PKParser_weakSelf s_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)__s {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf ab_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf ab_];}]);
    [PKParser_weakSelf a_];

    [self fireDelegateSelector:@selector(parser:didMatchS:)];
}

- (void)s_ {
    [self parseRule:@selector(__s) withMemo:_s_memo];
}

- (void)__ab {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf a_];
    [PKParser_weakSelf b_];

    [self fireDelegateSelector:@selector(parser:didMatchAb:)];
}

- (void)ab_ {
    [self parseRule:@selector(__ab) withMemo:_ab_memo];
}

- (void)__a {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:MULTIPLE_TOKEN_KIND_A discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchA:)];
}

- (void)a_ {
    [self parseRule:@selector(__a) withMemo:_a_memo];
}

- (void)__b {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:MULTIPLE_TOKEN_KIND_B discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchB:)];
}

- (void)b_ {
    [self parseRule:@selector(__b) withMemo:_b_memo];
}

@end