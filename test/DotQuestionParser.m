#import "DotQuestionParser.h"
#import <PEGKit/PEGKit.h>


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

    [self start_]; 
    [self matchEOF:YES]; 

}

- (void)__start {
    
    [self a_]; 
    if ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]) {
        [self matchAny:NO]; 
    }
    [self a_]; 

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)start_ {
    [self parseRule:@selector(__start) withMemo:_start_memo];
}

- (void)__a {
    
    [self match:DOTQUESTION_TOKEN_KIND_A discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchA:)];
}

- (void)a_ {
    [self parseRule:@selector(__a) withMemo:_a_memo];
}

@end