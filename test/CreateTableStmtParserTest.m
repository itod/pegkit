
//
//  CreateTableStmtParserTest.m
//  JavaScript
//
//  Created by Todd Ditchendorf on 3/27/13.
//
//

#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "CreateTableStmtParser.h"

@interface CreateTableStmtParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) CreateTableStmtParser *parser;
@property (nonatomic, retain) id mock;
@end

@implementation CreateTableStmtParserTest

- (void)parser:(PKParser *)p didFailToMatch:(PKAssembly *)a {}

- (void)parser:(PKParser *)p didMatchLcurly:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchRcurly:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchName:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchColon:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchValue:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchComma:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchStructure:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchStructs:(PKAssembly *)a {}

- (void)dealloc {
    self.factory = nil;
    self.root = nil;
    self.visitor = nil;
    self.parser = nil;
    self.mock = nil;
    [super dealloc];
}


- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"create_table_stmt" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"CreateTableStmt";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    _visitor.enableMemoization = NO;
    
    [_root visit:_visitor];
    
#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/CreateTableStmtParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/CreateTableStmtParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif

    self.mock = [OCMockObject mockForClass:[CreateTableStmtParserTest class]];

    self.parser = [[[CreateTableStmtParser alloc] initWithDelegate:_mock] autorelease];
    _parser.enableAutomaticErrorRecovery = YES;
    
    // return YES to -respondsToSelector:
    [[[_mock stub] andReturnValue:OCMOCK_VALUE((BOOL){YES})] respondsToSelector:(SEL)OCMOCK_ANY];
}

- (void)tearDown {
    self.factory = nil;
}


- (void)testCompleteStruct {
    NSString *s = @"CREATE TABLE 'foo';";
    
    NSError *err = nil;
    [_parser parseString:s error:&err];
    TDNil(err);
    
}


//- (void)testCompleteStruct {
//    
//    [[_mock expect] parser:_parser didMatchLcurly:OCMOCK_ANY];
//    [[_mock expect] parser:_parser didMatchName:OCMOCK_ANY];
//    [[_mock expect] parser:_parser didMatchColon:OCMOCK_ANY];
//    [[_mock expect] parser:_parser didMatchValue:OCMOCK_ANY];
//    [[_mock expect] parser:_parser didMatchRcurly:OCMOCK_ANY];
//    [[_mock expect] parser:_parser didMatchStructure:OCMOCK_ANY];
//    [[_mock expect] parser:_parser didMatchStructs:OCMOCK_ANY];
//
//    [[[_mock stub] andDo:^(NSInvocation *invoc) {
//        PKAssembly *a = nil;
//        [invoc getArgument:&a atIndex:3];
//        //NSLog(@"%@", a);
//        
//        TDTrue(0); // should never reach
//        
//    }] parser:_parser didFailToMatch:OCMOCK_ANY];
//
//    NSError *err = nil;
//    PKAssembly *res = [_parser parseString:@"{'foo':bar}" error:&err];
//    TDEqualObjects(TDAssembly(@"[{, 'foo', :, bar, }]{/'foo'/:/bar/}^"), [res description]);
//    
//    VERIFY();
//}

@end
