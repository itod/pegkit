#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "MiniMathParser.h"

@interface MiniMathParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) MiniMathParser *parser;
@end

@implementation MiniMathParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"minimath" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"MiniMath";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    [_root visit:_visitor];
    
    self.parser = [[[MiniMathParser alloc] initWithDelegate:self] autorelease];

#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/MiniMathParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/MiniMathParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}

- (void)tearDown {
    self.factory = nil;
}

- (void)testAddDisableActions {
    _parser.enableActions = NO;
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"1+2" error:&err];
    
    TDEqualObjects(TDAssembly(@"[1, 2]1/+/2^"), [res description]);
}

- (void)testMultDisableActions {
    _parser.enableActions = NO;
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"3*4" error:&err];
    
    TDEqualObjects(TDAssembly(@"[3, 4]3/*/4^"), [res description]);
}

- (void)testAddMultDisableActions {
    _parser.enableActions = NO;
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"1+2*3+4" error:&err];
    
    TDEqualObjects(TDAssembly(@"[1, 2, 3, 4]1/+/2/*/3/+/4^"), [res description]);
}

- (void)testAddMultPowDisableActions {
    _parser.enableActions = NO;
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"1+2*3^5+4" error:&err];
    
    TDEqualObjects(TDAssembly(@"[1, 2, 3, 5, 4]1/+/2/*/3/^/5/+/4^"), [res description]);
}

- (void)testAddEnableActions {
    _parser.enableActions = YES;
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"1+2" error:&err];
    
    TDEqualObjects(TDAssembly(@"[3]1/+/2^"), [res description]);
}

- (void)testMultEnableActions {
    _parser.enableActions = YES;
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"3*4" error:&err];
    
    TDEqualObjects(TDAssembly(@"[12]3/*/4^"), [res description]);
}

- (void)testAddMultEnableActions {
    _parser.enableActions = YES;
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"1+2*3+4" error:&err];
    
    TDEqualObjects(TDAssembly(@"[11]1/+/2/*/3/+/4^"), [res description]);
}

- (void)testPowEnableActions {
    _parser.enableActions = YES;
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"3^3" error:&err];
    
    TDEqualObjects(TDAssembly(@"[27]3/^/3^"), [res description]);
}

- (void)testAddMultPowEnableActions {
    _parser.enableActions = YES;
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"1+2*3^5+4" error:&err];
    
    TDEqualObjects(TDAssembly(@"[491]1/+/2/*/3/^/5/+/4^"), [res description]);
}

@end
