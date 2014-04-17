#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "NondeterministicPalindromeParser.h"

@interface NondeterministicPalindromeParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) NondeterministicPalindromeParser *parser;
@end

@implementation NondeterministicPalindromeParserTest

- (void)dealloc {
    self.factory = nil;
    self.root = nil;
    self.visitor = nil;
    self.parser = nil;
    [super dealloc];
}


- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"nondeterministic_palindromes" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"NondeterministicPalindrome";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    _visitor.enableMemoization = NO;
    
    [_root visit:_visitor];
    
#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/NondeterministicPalindromeParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/NondeterministicPalindromeParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif

    self.parser = [[[NondeterministicPalindromeParser alloc] initWithDelegate:nil] autorelease];
}

- (void)tearDown {
    self.factory = nil;
}

- (void)test0 {
    NSString *s = @"0";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[0]0^"), [res description]);
}

- (void)test1 {
    NSString *s = @"1";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[1]1^"), [res description]);
}

- (void)test000 {
    NSString *s = @"0 0 0";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[0, 0, 0]0/0/0^"), [res description]);
}

- (void)test111 {
    NSString *s = @"1 1 1";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[1, 1, 1]1/1/1^"), [res description]);
}

@end
