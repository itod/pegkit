#import "GrammarActionsParser.h"
#import <PEGKit/PEGKit.h>
    
#define MY_M 1


@interface GrammarActionsParser ()
    
@property (nonatomic, retain) NSString *foo;

@end

@implementation GrammarActionsParser {     
    BOOL _bar;
}
    
- (NSString *)bar {
    return @"bar";
}

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
            
    self.foo = @"hello world";
    _bar = YES;

        self.startRuleName = @"start";


    }
    return self;
}

- (void)dealloc {
        
    self.foo = nil;


    [super dealloc];
}

- (void)start {
    [self execute:^{
    
    NSAssert([self.foo isEqualToString:@"hello world"], @"");
    NSAssert([_foo isEqualToString:@"hello world"], @"");
    NSAssert(_bar, @"");
    NSAssert(MY_H, @"");
    NSAssert(MY_M, @"");
    NSAssert([[self bar] isEqualToString:@"bar"], @"");
    self.foo = @"goodbye cruel world";

    }];

    [self start_]; 
    [self matchEOF:YES]; 

    [self execute:^{
    
    NSAssert([self.foo isEqualToString:@"goodbye cruel world"], @"");
    NSAssert([_foo isEqualToString:@"goodbye cruel world"], @"");
    NSAssert(_bar, @"");
    NSAssert(MY_H, @"");
    NSAssert(MY_M, @"");
    NSAssert([[self bar] isEqualToString:@"bar"], @"");

    }];
}

- (void)start_ {
    
    do {
        [self matchWord:NO]; 
    } while ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

@end