#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "Lines2Parser.h"

static PGParserFactory *factory;
static PGRootNode *root;
static PGParserGenVisitor *visitor;
static Lines2Parser *parser;

@interface Lines2ParserTest : XCTestCase
@end

@implementation Lines2ParserTest

+ (void)setUp {
    factory = [[PGParserFactory factory] retain];
    factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:self] pathForResource:@"lines2" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    root = [(id)[factory ASTFromGrammar:g error:&err] retain];
    root.grammarName = @"Lines2";
    
    visitor = [[PGParserGenVisitor alloc] init];
    visitor.enableMemoization = NO;
    
    [root visit:visitor];
    
#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/Lines2Parser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/Lines2Parser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif

    parser = [[Lines2Parser alloc] initWithDelegate:nil];
}

+ (void)tearDown {
    [factory release];
    [root release];
    [visitor release];
    [parser release];
}

- (void)test0 {
    NSString *s = @"foo\nbar\n";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[foo, bar]foo/\n/bar/\n^"), [res description]);
}

- (void)test1 {
    NSString *s = @"foo=bar\nbaz=bat\n";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[foo, =, bar, baz, =, bat]foo/=/bar/\n/baz/=/bat/\n^"), [res description]);
}

- (void)testSectionHeader {
    NSString *s = @"[header here]\nfoo=bar\n\nbaz=bat\n";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[[, header, here, ], foo, =, bar, baz, =, bat][/header/here/]/\n/foo/=/bar/\n/\n/baz/=/bat/\n^"), [res description]);
}

@end
