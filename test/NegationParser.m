#import "NegationParser.h"
#import <PEGKit/PEGKit.h>


@interface NegationParser ()

@property (nonatomic, retain) NSMutableDictionary *s_memo;
@property (nonatomic, retain) NSMutableDictionary *foo_memo;
@end

@implementation NegationParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"s";
        self.tokenKindTab[@"foo"] = @(NEGATION_TOKEN_KIND_FOO);

        self.tokenKindNameTab[NEGATION_TOKEN_KIND_FOO] = @"foo";

        self.s_memo = [NSMutableDictionary dictionary];
        self.foo_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.s_memo = nil;
    self.foo_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_s_memo removeAllObjects];
    [_foo_memo removeAllObjects];
}

- (void)start {

    [self s_]; 
    [self matchEOF:YES]; 

}

- (void)__s {
    
    if (![self predicts:NEGATION_TOKEN_KIND_FOO, 0]) {
        [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [self raise:@"negation test failed in s"];
    }

    [self fireDelegateSelector:@selector(parser:didMatchS:)];
}

- (void)s_ {
    [self parseRule:@selector(__s) withMemo:_s_memo];
}

- (void)__foo {
    
    [self match:NEGATION_TOKEN_KIND_FOO discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchFoo:)];
}

- (void)foo_ {
    [self parseRule:@selector(__foo) withMemo:_foo_memo];
}

@end