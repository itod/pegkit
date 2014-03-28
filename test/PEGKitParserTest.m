#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "PEGKitParser.h"

@interface PEGKitParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) PEGKitParser *parser;
@end

@implementation PEGKitParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"pegkit" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"PEGKit";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    _visitor.enableMemoization = NO;
    _visitor.enableHybridDFA = YES;
    _visitor.enableAutomaticErrorRecovery = NO;
    _visitor.enableARC = NO;
    [_root visit:_visitor];
    
    self.parser = [[[PEGKitParser alloc] initWithDelegate:self] autorelease];

#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/ParserGenApp/PEGKitParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/ParserGenApp/PEGKitParser.m", getenv("PWD")] stringByExpandingTildeInPath];

    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}

- (void)tearDown {
    self.factory = nil;
}

- (void)testFoo1 {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"start=foo;foo='bar';" error:&err];
    
    TDEqualObjects(TDAssembly(@"[start, =, foo, foo, =, 'bar']start/=/foo/;/foo/=/'bar'/;^"), [res description]);
}

@end
