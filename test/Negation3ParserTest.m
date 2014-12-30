#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "Negation3Parser.h"

static PGParserFactory *factory;
static PGRootNode *root;
static PGParserGenVisitor *visitor;
static Negation3Parser *parser;

@interface Negation3ParserTest : XCTestCase
@end

@implementation Negation3ParserTest

+ (void)setUp {
    factory = [[PGParserFactory factory] retain];
    factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:self] pathForResource:@"negation3" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    root = [(id)[factory ASTFromGrammar:g error:&err] retain];
    root.grammarName = @"Negation3";
    
    visitor = [[PGParserGenVisitor alloc] init];
    visitor.enableMemoization = NO;
    
    [root visit:visitor];
    
#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/Negation3Parser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/Negation3Parser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif

    parser = [[Negation3Parser alloc] initWithDelegate:nil];
}

+ (void)tearDown {
    [factory release];
    [root release];
    [visitor release];
    [parser release];
}

- (void)test0 {
    NSString *s = @"{%foo%}";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[{%, foo, %}]{%/foo/%}^"), [res description]);
}

- (void)test1 {
    NSString *s = @"{%foo bar%}";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[{%, foo, bar, %}]{%/foo/bar/%}^"), [res description]);
}

- (void)test2 {
    NSString *s = @"{%foo%} text here {%/foo%}";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[{%, foo, %}, text, here, {%, /, foo, %}]{%/foo/%}/text/here/{%///foo/%}^"), [res description]);
}

- (void)test3 {
    NSString *s = @"{%foo%} text {%/foo%} here";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[{%, foo, %}, text, {%, /, foo, %}, here]{%/foo/%}/text/{%///foo/%}/here^"), [res description]);
}

@end
