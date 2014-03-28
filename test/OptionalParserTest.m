#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "OptionalParser.h"

@interface OptionalParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) OptionalParser *parser;
@end

@implementation OptionalParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"optional" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"Optional";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    [_root visit:_visitor];
    
    self.parser = [[[OptionalParser alloc] initWithDelegate:self] autorelease];

#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/OptionalParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/OptionalParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}

- (void)tearDown {
    self.factory = nil;
}

- (void)testFoo {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo bar" error:&err];
    
    TDEqualObjects(TDAssembly(@"[foo, bar]foo/bar^"), [res description]);
}

- (void)testFoo2 {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo bar bar foo bar" error:&err];
    
    TDEqualObjects(TDAssembly(@"[foo, bar, bar, foo, bar]foo/bar/bar/foo/bar^"), [res description]);
}

- (void)testFoo3 {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo bar bar foo bar bar foo bar" error:&err];

    // junk at end
    TDNil(res);
}

- (void)testIncompleteSequence {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo bar bar foo" error:&err];
    
    TDNil(res);
    //TDEqualObjects(TDAssembly(@"[foo, bar, bar, foo]foo/bar/bar/foo^"), [res description]);
}

@end
