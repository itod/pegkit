#import "OptionalParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface OptionalParser ()

@property (nonatomic, retain) NSMutableDictionary *s_memo;
@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *foo_memo;
@property (nonatomic, retain) NSMutableDictionary *bar_memo;
@end

@implementation OptionalParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"s";
        self.tokenKindTab[@"foo"] = @(OPTIONAL_TOKEN_KIND_FOO);
        self.tokenKindTab[@"bar"] = @(OPTIONAL_TOKEN_KIND_BAR);

        self.tokenKindNameTab[OPTIONAL_TOKEN_KIND_FOO] = @"foo";
        self.tokenKindNameTab[OPTIONAL_TOKEN_KIND_BAR] = @"bar";

        self.s_memo = [NSMutableDictionary dictionary];
        self.expr_memo = [NSMutableDictionary dictionary];
        self.foo_memo = [NSMutableDictionary dictionary];
        self.bar_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.s_memo = nil;
    self.expr_memo = nil;
    self.foo_memo = nil;
    self.bar_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_s_memo removeAllObjects];
    [_expr_memo removeAllObjects];
    [_foo_memo removeAllObjects];
    [_bar_memo removeAllObjects];
}

- (void)start {
    PKParser_weakSelfDecl;

    [PKParser_weakSelf s_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)__s {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf expr_];}]) {
        [PKParser_weakSelf expr_];
    }
    [PKParser_weakSelf foo_];
    [PKParser_weakSelf bar_];

    [self fireDelegateSelector:@selector(parser:didMatchS:)];
}

- (void)s_ {
    [self parseRule:@selector(__s) withMemo:_s_memo];
}

- (void)__expr {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf foo_];
    [PKParser_weakSelf bar_];
    [PKParser_weakSelf bar_];

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__foo {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:OPTIONAL_TOKEN_KIND_FOO discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchFoo:)];
}

- (void)foo_ {
    [self parseRule:@selector(__foo) withMemo:_foo_memo];
}

- (void)__bar {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:OPTIONAL_TOKEN_KIND_BAR discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchBar:)];
}

- (void)bar_ {
    [self parseRule:@selector(__bar) withMemo:_bar_memo];
}

@end