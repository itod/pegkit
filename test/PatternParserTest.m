#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "PatternParser.h"

@interface PatternParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) PatternParser *parser;
@end

@implementation PatternParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"pattern" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"Pattern";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    [_root visit:_visitor];
    
    self.parser = [[[PatternParser alloc] initWithDelegate:self] autorelease];

//#if TD_EMIT
//    path = [[NSString stringWithFormat:@"%s/test/PatternParser.h", getenv("PWD")] stringByExpandingTildeInPath];
//    err = nil;
//    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
//        NSLog(@"%@", err);
//    }
//
//    path = [[NSString stringWithFormat:@"%s/test/PatternParser.m", getenv("PWD")] stringByExpandingTildeInPath];
//    err = nil;
//    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
//        NSLog(@"%@", err);
//    }
//#endif
}

- (void)tearDown {
    self.factory = nil;
}

- (void)testFoo1 {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo" error:&err];
    
    TDEqualObjects(TDAssembly(@"[foo]foo^"), [res description]);
}

@end
