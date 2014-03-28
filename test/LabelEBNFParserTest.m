#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "LabelEBNFParser.h"

@interface LabelEBNFParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) LabelEBNFParser *parser;
@end

@implementation LabelEBNFParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"label_ebnf" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"LabelEBNF";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    [_root visit:_visitor];
    
    self.parser = [[[LabelEBNFParser alloc] initWithDelegate:self] autorelease];

#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/LabelEBNFParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/LabelEBNFParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}

- (void)tearDown {
    self.factory = nil;
}

- (void)testAlt1 {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo: bar = 1" error:&err];
    
    TDEqualObjects(TDAssembly(@"[foo, :, bar, =, 1]foo/:/bar/=/1^"), [res description]);
}

- (void)testAlt2 {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo: return 1" error:&err];
    
    TDEqualObjects(TDAssembly(@"[foo, :, return, 1]foo/:/return/1^"), [res description]);
}

- (void)testAlt2Rep {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo: bar: return 1" error:&err];
    
    TDEqualObjects(TDAssembly(@"[foo, :, bar, :, return, 1]foo/:/bar/:/return/1^"), [res description]);
}

- (void)testAlt2RepRep {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo: bar: baz: return 1" error:&err];
    
    TDEqualObjects(TDAssembly(@"[foo, :, bar, :, baz, :, return, 1]foo/:/bar/:/baz/:/return/1^"), [res description]);
}

@end
