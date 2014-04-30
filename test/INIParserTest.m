#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "INIParser.h"

static PGParserFactory *factory;
static PGRootNode *root;
static PGParserGenVisitor *visitor;
static INIParser *parser;

@interface INIParserTest : XCTestCase
@end

@implementation INIParserTest

+ (void)setUp {
    factory = [[PGParserFactory factory] retain];
    factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:self] pathForResource:@"ini" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    root = [(id)[factory ASTFromGrammar:g error:&err] retain];
    root.grammarName = @"INI";
    
    visitor = [[PGParserGenVisitor alloc] init];
    visitor.enableMemoization = NO;
    
    [root visit:visitor];
    
#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/INIParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/INIParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif

    parser = [[INIParser alloc] initWithDelegate:nil];
}

+ (void)tearDown {
    [factory release];
    [root release];
    [visitor release];
    [parser release];
}

- (void)test0 {
    NSString *s = @"foo=bar\n\nbaz=bat\n";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[foo, bar, baz, bat]foo/=/bar/\n/\n/baz/=/bat/\n^"), [res description]);
}

- (void)testSectionHeader {
    NSString *s = @"[header here]\rfoo=bar\n\nbaz=bat\n";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[[, header, here, foo, bar, baz, bat][/header/here/]/\r/foo/=/bar/\n/\n/baz/=/bat/\n^"), [res description]);
}

@end
