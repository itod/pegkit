#import "GrammarActionsParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>
    
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
    PKParser_weakSelfDecl;
    [PKParser_weakSelf execute:^{
    
    NSAssert([self.foo isEqualToString:@"hello world"], @"");
    NSAssert([_foo isEqualToString:@"hello world"], @"");
    NSAssert(_bar, @"");
    NSAssert(MY_H, @"");
    NSAssert(MY_M, @"");
    NSAssert([[self bar] isEqualToString:@"bar"], @"");
    self.foo = @"goodbye cruel world";

    }];

    [PKParser_weakSelf start_];
    [PKParser_weakSelf matchEOF:YES];

    [PKParser_weakSelf execute:^{
    
    NSAssert([self.foo isEqualToString:@"goodbye cruel world"], @"");
    NSAssert([_foo isEqualToString:@"goodbye cruel world"], @"");
    NSAssert(_bar, @"");
    NSAssert(MY_H, @"");
    NSAssert(MY_M, @"");
    NSAssert([[self bar] isEqualToString:@"bar"], @"");

    }];
}

- (void)start_ {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf matchWord:NO];
    } while ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

@end