#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "ExpressionParser.h"

@interface ExpressionParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@end

@implementation ExpressionParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"expression" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"Expression";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    [_root visit:_visitor];
    
#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/ExpressionParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/ExpressionParser.m", getenv("PWD")] stringByExpandingTildeInPath];
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
    ExpressionParser *p = [[[ExpressionParser alloc] initWithDelegate:self] autorelease];
    
    PKAssembly *res = [p parseString:@"foo.bar('hello') or bar" error:nil];
    
    TDEqualObjects(TDAssembly(@"[foo, ., bar, (, 'hello', or, bar]foo/./bar/(/'hello'/)/or/bar^"), [res description]);
}


- (void)parser:(PKParser *)p didMatchArgList:(PKAssembly *)a {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, a);
    
}

@end
