#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "NondeterministicPalindromeParser.h"

static PGParserFactory *factory;
static PGRootNode *root;
static PGParserGenVisitor *visitor;
static NondeterministicPalindromeParser *parser;

@interface NondeterministicPalindromeParserTest : XCTestCase
@end

@implementation NondeterministicPalindromeParserTest

+ (void)setUp {
    factory = [[PGParserFactory factory] retain];
    factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:self] pathForResource:@"nondeterministic_palindromes" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    root = [(id)[factory ASTFromGrammar:g error:&err] retain];
    root.grammarName = @"NondeterministicPalindrome";
    
    visitor = [[PGParserGenVisitor alloc] init];
    visitor.enableMemoization = NO;
    
    [root visit:visitor];
    
#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/NondeterministicPalindromeParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/NondeterministicPalindromeParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif

    parser = [[NondeterministicPalindromeParser alloc] initWithDelegate:nil];
}

+ (void)tearDown {
    [factory release];
    [root release];
    [visitor release];
    [parser release];
}

- (void)test0 {
    NSString *s = @"0";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[0]0^"), [res description]);
}

- (void)test1 {
    NSString *s = @"1";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[1]1^"), [res description]);
}

- (void)test000 {
    NSString *s = @"0 0 0";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[0, 0, 0]0/0/0^"), [res description]);
}

- (void)test111 {
    NSString *s = @"1 1 1";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[1, 1, 1]1/1/1^"), [res description]);
}

- (void)test110 {
    NSString *s = @"1 1 0";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNotNil(err);
    TDNil(res);
}

- (void)test101 {
    NSString *s = @"1 0 1";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[1, 0, 1]1/0/1^"), [res description]);
}

- (void)test010 {
    NSString *s = @"0 1 0";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[0, 1, 0]0/1/0^"), [res description]);
}

- (void)test011010110 {
    NSString *s = @"0 1 1 0 1 0 1 1 0";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNotNil(err);
    TDNil(res);
}

@end
