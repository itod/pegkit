#import "AltParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface AltParser ()

@property (nonatomic, retain) NSMutableDictionary *start_memo;
@property (nonatomic, retain) NSMutableDictionary *s_memo;
@property (nonatomic, retain) NSMutableDictionary *a_memo;
@property (nonatomic, retain) NSMutableDictionary *b_memo;
@property (nonatomic, retain) NSMutableDictionary *foo_memo;
@property (nonatomic, retain) NSMutableDictionary *bar_memo;
@property (nonatomic, retain) NSMutableDictionary *baz_memo;
@end

@implementation AltParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"foo"] = @(ALT_TOKEN_KIND_FOO);
        self.tokenKindTab[@"bar"] = @(ALT_TOKEN_KIND_BAR);
        self.tokenKindTab[@"baz"] = @(ALT_TOKEN_KIND_BAZ);

        self.tokenKindNameTab[ALT_TOKEN_KIND_FOO] = @"foo";
        self.tokenKindNameTab[ALT_TOKEN_KIND_BAR] = @"bar";
        self.tokenKindNameTab[ALT_TOKEN_KIND_BAZ] = @"baz";

        self.start_memo = [NSMutableDictionary dictionary];
        self.s_memo = [NSMutableDictionary dictionary];
        self.a_memo = [NSMutableDictionary dictionary];
        self.b_memo = [NSMutableDictionary dictionary];
        self.foo_memo = [NSMutableDictionary dictionary];
        self.bar_memo = [NSMutableDictionary dictionary];
        self.baz_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.start_memo = nil;
    self.s_memo = nil;
    self.a_memo = nil;
    self.b_memo = nil;
    self.foo_memo = nil;
    self.bar_memo = nil;
    self.baz_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_start_memo removeAllObjects];
    [_s_memo removeAllObjects];
    [_a_memo removeAllObjects];
    [_b_memo removeAllObjects];
    [_foo_memo removeAllObjects];
    [_bar_memo removeAllObjects];
    [_baz_memo removeAllObjects];
}

- (void)start {
    PKParser_weakSelfDecl;

    [PKParser_weakSelf start_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)__start {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf s_];

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)start_ {
    [self parseRule:@selector(__start) withMemo:_start_memo];
}

- (void)__s {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf a_];}]) {
        [PKParser_weakSelf a_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf b_];}]) {
        [PKParser_weakSelf b_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 's'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchS:)];
}

- (void)s_ {
    [self parseRule:@selector(__s) withMemo:_s_memo];
}

- (void)__a {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf foo_];
    [PKParser_weakSelf baz_];

    [self fireDelegateSelector:@selector(parser:didMatchA:)];
}

- (void)a_ {
    [self parseRule:@selector(__a) withMemo:_a_memo];
}

- (void)__b {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf a_];}]) {
        [PKParser_weakSelf a_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf foo_];[PKParser_weakSelf bar_];}]) {
        [PKParser_weakSelf foo_];
        [PKParser_weakSelf bar_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'b'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchB:)];
}

- (void)b_ {
    [self parseRule:@selector(__b) withMemo:_b_memo];
}

- (void)__foo {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:ALT_TOKEN_KIND_FOO discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchFoo:)];
}

- (void)foo_ {
    [self parseRule:@selector(__foo) withMemo:_foo_memo];
}

- (void)__bar {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:ALT_TOKEN_KIND_BAR discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchBar:)];
}

- (void)bar_ {
    [self parseRule:@selector(__bar) withMemo:_bar_memo];
}

- (void)__baz {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:ALT_TOKEN_KIND_BAZ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchBaz:)];
}

- (void)baz_ {
    [self parseRule:@selector(__baz) withMemo:_baz_memo];
}

@end