#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "MiniMath2Parser.h"

@interface MiniMath2ParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) MiniMath2Parser *parser;
@end

@implementation MiniMath2ParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"minimath2" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"MiniMath2";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    _visitor.enableMemoization = NO;
    _visitor.delegatePostMatchCallbacksOn = PGParserFactoryDelegateCallbacksOnNone;
    [_root visit:_visitor];
    
    self.parser = [[[MiniMath2Parser alloc] initWithDelegate:self] autorelease];

#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/MiniMath2Parser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/MiniMath2Parser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}

- (void)tearDown {
    self.factory = nil;
}

//- (void)testAddDisableActions {
//    _parser.enableActions = NO;
//    
//    NSError *err = nil;
//    PKAssembly *res = [_parser parseString:@"1+2" error:&err];
//    
//    TDEqualObjects(TDAssembly(@"[1, 2]1/+/2^"), [res description]);
//}
//
//- (void)testMultDisableActions {
//    _parser.enableActions = NO;
//    
//    NSError *err = nil;
//    PKAssembly *res = [_parser parseString:@"3*4" error:&err];
//    
//    TDEqualObjects(TDAssembly(@"[3, 4]3/*/4^"), [res description]);
//}
//
//- (void)testAddMultDisableActions {
//    _parser.enableActions = NO;
//    
//    NSError *err = nil;
//    PKAssembly *res = [_parser parseString:@"1+2*3+4" error:&err];
//    
//    TDEqualObjects(TDAssembly(@"[1, 2, 3, 4]1/+/2/*/3/+/4^"), [res description]);
//}

- (void)testOpen2Plus2Close {
    _parser.enableActions = YES;
    
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"(2+2)" error:&err];
    
    TDEqualObjects(TDAssembly(@"[4](/2/+/2/)^"), [res description]);
}

//- (void)testOpen2Plus2CloseTimes3 {
//    _parser.enableActions = YES;
//    
//    NSError *err = nil;
//    PKAssembly *res = [_parser parseString:@"(2+2)*3" error:&err];
//    
//    TDEqualObjects(TDAssembly(@"[2, 2, 3]2/+/2/*/3^"), [res description]);
//}
//
//- (void)testAddEnableActions {
//    _parser.enableActions = YES;
//    
//    NSError *err = nil;
//    PKAssembly *res = [_parser parseString:@"1+2" error:&err];
//    
//    TDEqualObjects(TDAssembly(@"[3]1/+/2^"), [res description]);
//}
//
//- (void)testMultEnableActions {
//    _parser.enableActions = YES;
//    
//    NSError *err = nil;
//    PKAssembly *res = [_parser parseString:@"3*4" error:&err];
//    
//    TDEqualObjects(TDAssembly(@"[12]3/*/4^"), [res description]);
//}
//
//- (void)testAddMultEnableActions {
//    _parser.enableActions = YES;
//    
//    NSError *err = nil;
//    PKAssembly *res = [_parser parseString:@"1+2*3+4" error:&err];
//    
//    TDEqualObjects(TDAssembly(@"[11]1/+/2/*/3/+/4^"), [res description]);
//}

@end
