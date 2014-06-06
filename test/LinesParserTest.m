#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "LinesParser.h"

static PGParserFactory *factory;
static PGRootNode *root;
static PGParserGenVisitor *visitor;
static LinesParser *parser;

@interface LinesParserTest : XCTestCase
@end

@implementation LinesParserTest

+ (void)setUp {
    factory = [[PGParserFactory factory] retain];
    factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:self] pathForResource:@"lines" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    root = [(id)[factory ASTFromGrammar:g error:&err] retain];
    root.grammarName = @"Lines";
    
    visitor = [[PGParserGenVisitor alloc] init];
    visitor.enableMemoization = NO;
    
    [root visit:visitor];
    
#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/LinesParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/LinesParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif

    parser = [[LinesParser alloc] initWithDelegate:nil];
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
    
    TDEqualObjects(TDAssembly(@"[foo, bar]foo/bar^"), [res description]);
}

- (void)test1 {
    NSString *s = @"foo=bar\nbaz=bat\n";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[foo, =, bar, baz, =, bat]foo/=/bar/baz/=/bat^"), [res description]);
}

- (void)testSectionHeader {
    NSString *s = @"[header here]\nfoo=bar\n\nbaz=bat\n";
    
    NSError *err = nil;
    PKAssembly *res = [parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[[, header, here, ], foo, =, bar, baz, =, bat][/header/here/]/foo/=/bar/baz/=/bat^"), [res description]);
}

@end
