#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "SemanticPredicateParser.h"

@interface SemanticPredicateParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) SemanticPredicateParser *parser;
@end

@implementation SemanticPredicateParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"semantic_predicate" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"SemanticPredicate";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    [_root visit:_visitor];
    
    self.parser = [[[SemanticPredicateParser alloc] initWithDelegate:self] autorelease];

#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/SemanticPredicateParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/SemanticPredicateParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}

- (void)tearDown {
    self.factory = nil;
}

- (void)testConst {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"const" error:&err];
    
    //TDEqualObjects(TDAssembly(@"[a, C, a]a/C/a^"), [res description]);
    TDNil(res);
}

- (void)testFoo {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo" error:&err];
    
    TDEqualObjects(TDAssembly(@"[foo]foo^"), [res description]);
}

- (void)testFooBar {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo bar" error:&err];
    
    TDEqualObjects(TDAssembly(@"[foo, bar]foo/bar^"), [res description]);
}

- (void)testFooBarConst {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo bar const" error:&err];
    
    TDNil(res);
}

- (void)testFooGotoBar {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo goto bar" error:&err];
    
    TDNil(res);
}

@end
