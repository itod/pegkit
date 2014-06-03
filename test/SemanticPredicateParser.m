#import "SemanticPredicateParser.h"
#import <PEGKit/PEGKit.h>


@interface SemanticPredicateParser ()

@property (nonatomic, retain) NSMutableDictionary *start_memo;
@property (nonatomic, retain) NSMutableDictionary *nonReserved_memo;
@end

@implementation SemanticPredicateParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";


        self.start_memo = [NSMutableDictionary dictionary];
        self.nonReserved_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.start_memo = nil;
    self.nonReserved_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_start_memo removeAllObjects];
    [_nonReserved_memo removeAllObjects];
}

- (void)start {

    [self start_]; 
    [self matchEOF:YES]; 

}

- (void)__start {
    
    do {
        [self nonReserved_]; 
    } while ([self speculate:^{ [self nonReserved_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)start_ {
    [self parseRule:@selector(__start) withMemo:_start_memo];
}

- (void)__nonReserved {
    
    [self testAndThrow:(id)^{ return ![@[@"goto", @"const"] containsObject:LS(1)]; }]; 
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNonReserved:)];
}

- (void)nonReserved_ {
    [self parseRule:@selector(__nonReserved) withMemo:_nonReserved_memo];
}

@end