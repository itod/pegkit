#import "DotQuestionParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface DotQuestionParser ()

@property (nonatomic, retain) NSMutableDictionary *start_memo;
@property (nonatomic, retain) NSMutableDictionary *a_memo;
@end

@implementation DotQuestionParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"a"] = @(DOTQUESTION_TOKEN_KIND_A);

        self.tokenKindNameTab[DOTQUESTION_TOKEN_KIND_A] = @"a";

        self.start_memo = [NSMutableDictionary dictionary];
        self.a_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.start_memo = nil;
    self.a_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_start_memo removeAllObjects];
    [_a_memo removeAllObjects];
}

- (void)start {
    PKParser_weakSelfDecl;

    [PKParser_weakSelf start_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)__start {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf a_];
    if ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]) {
        [PKParser_weakSelf matchAny:NO];
    }
    [PKParser_weakSelf a_];

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)start_ {
    [self parseRule:@selector(__start) withMemo:_start_memo];
}

- (void)__a {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:DOTQUESTION_TOKEN_KIND_A discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchA:)];
}

- (void)a_ {
    [self parseRule:@selector(__a) withMemo:_a_memo];
}

@end