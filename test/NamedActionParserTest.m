#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "NamedActionParser.h"

@interface NamedActionParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) NamedActionParser *parser;
@end

@implementation NamedActionParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"named_action" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"NamedAction";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    [_root visit:_visitor];
    
    self.parser = [[[NamedActionParser alloc] initWithDelegate:self] autorelease];

#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/NamedActionParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/NamedActionParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}

- (void)tearDown {
    self.factory = nil;
}

- (void)testAB {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"a b" error:&err];
    
    TDEqualObjects(TDAssembly(@"[foo, a, bar, b]a/b^"), [res description]);
}

@end
