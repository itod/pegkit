#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "DeterministicPalindromeParser.h"

@interface DeterministicPalindromeParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) DeterministicPalindromeParser *parser;
@end

@implementation DeterministicPalindromeParserTest

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
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"deterministic_palindromes" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"DeterministicPalindrome";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    _visitor.enableMemoization = NO;
    
    [_root visit:_visitor];
    
#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/DeterministicPalindromeParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/DeterministicPalindromeParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif

    self.parser = [[[DeterministicPalindromeParser alloc] initWithDelegate:nil] autorelease];
}

- (void)tearDown {
    self.factory = nil;
}

- (void)test2 {
    NSString *s = @"2";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[2]2^"), [res description]);
}

- (void)test020 {
    NSString *s = @"0 2 0";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[0, 2, 0]0/2/0^"), [res description]);
}

- (void)test021 {
    NSString *s = @"0 2 1";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNotNil(err);
    TDNil(res);
}

- (void)test121 {
    NSString *s = @"1 2 1";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[1, 2, 1]1/2/1^"), [res description]);
}

- (void)test120 {
    NSString *s = @"1 2 0";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNotNil(err);
    TDNil(res);
}

- (void)test10201 {
    NSString *s = @"1 0 2 0 1";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[1, 0, 2, 0, 1]1/0/2/0/1^"), [res description]);
}

- (void)test01210 {
    NSString *s = @"0 1 2 1 0";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[0, 1, 2, 1, 0]0/1/2/1/0^"), [res description]);
}

- (void)test00200 {
    NSString *s = @"0 0 2 0 0";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[0, 0, 2, 0, 0]0/0/2/0/0^"), [res description]);
}

- (void)test11211 {
    NSString *s = @"1 1 2 1 1";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[1, 1, 2, 1, 1]1/1/2/1/1^"), [res description]);
}

- (void)test11210 {
    NSString *s = @"1 1 2 1 0";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNotNil(err);
    TDNil(res);
}

@end
