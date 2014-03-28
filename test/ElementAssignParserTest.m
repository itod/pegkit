#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "ElementAssignParser.h"

@interface ElementAssignParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@end

@implementation ElementAssignParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"elementsAssign" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"ElementAssign";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    _visitor.enableMemoization = NO;
    _visitor.enableAutomaticErrorRecovery = YES;
    
    [_root visit:_visitor];
    
#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/ElementAssignParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/ElementAssignParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}


- (void)tearDown {
    self.factory = nil;
}


//- (void)testFoo {
//    ElementAssignParser *p = [[[ElementAssignParser alloc] initWithDelegate:self] autorelease];
//    
//    PKAssembly *res = [p parse:@"[1, [2,3],4]" error:nil];
//    
//    TDEqualObjects(TDAssembly(@"[[, 1, [, 2, 3, 4][/1/,/[/2/,/3/]/,/4/]^"), [res description]);
//}


- (void)parser:(PKParser *)p didMatchList:(PKAssembly *)a {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, a);
    
    TDTrue([[a description] isEqualToString:TDAssembly(@"[[, 1][/1/]^")] ||
           [[a description] isEqualToString:TDAssembly(@"[[, 1, =, [, 2][/1/]/=/[/2/]^")]);
}



- (void)testAssign {
    ElementAssignParser *p = [[[ElementAssignParser alloc] initWithDelegate:self] autorelease];
    
    PKAssembly *res = [p parseString:@"[1]=[2]." error:nil];
    
    TDEqualObjects(TDAssembly(@"[[, 1, =, [, 2, .][/1/]/=/[/2/]/.^"), [res description]);
    
    res = [p parseString:@"[1];" error:nil];
    
    TDEqualObjects(TDAssembly(@"[[, 1, ;][/1/]/;^"), [res description]);

}



@end
