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

    self.parser = [[[CreateTableStmtParser alloc] initWithDelegate:_mock] autorelease];
}

- (void)tearDown {
    self.factory = nil;
}


- (void)testNoTempNoIfExists {
    NSString *s = @"CREATE TABLE 'foo';";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[0, 0, foo]CREATE/TABLE/'foo'/;^"), [res description]);
}


- (void)testNoTemp {
    NSString *s = @"CREATE TABLE IF NOT EXISTS 'foo';";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[0, 1, foo]CREATE/TABLE/IF/NOT/EXISTS/'foo'/;^"), [res description]);
}


- (void)testTemp {
    NSString *s = @"CREATE TEMP TABLE IF NOT EXISTS 'foo';";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[1, 1, foo]CREATE/TEMP/TABLE/IF/NOT/EXISTS/'foo'/;^"), [res description]);
}


- (void)testTempNoIfExists {
    NSString *s = @"CREATE TEMP TABLE 'foo';";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[1, 0, foo]CREATE/TEMP/TABLE/'foo'/;^"), [res description]);
}


- (void)testTemporary {
    NSString *s = @"CREATE TEMPORARY TABLE IF NOT EXISTS 'foo';";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[1, 1, foo]CREATE/TEMPORARY/TABLE/IF/NOT/EXISTS/'foo'/;^"), [res description]);
}


- (void)testTemporaryNoIfExists {
    NSString *s = @"CREATE TEMPORARY TABLE 'foo';";
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:s error:&err];
    TDNil(err);
    
    TDEqualObjects(TDAssembly(@"[1, 0, foo]CREATE/TEMPORARY/TABLE/'foo'/;^"), [res description]);
}

@end
