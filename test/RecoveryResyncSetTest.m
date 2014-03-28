#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "ElementAssignParser.h"

@interface RecoveryResyncSetTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) ElementAssignParser *parser;
@end

@implementation RecoveryResyncSetTest

- (void)setUp {
    self.parser = [[[ElementAssignParser alloc] initWithDelegate:self] autorelease];
}

- (void)tearDown {
    self.factory = nil;
}

//- (void)testCorrectExpr {
//    NSError *err = nil;
//    PKAssembly *res = nil;
//    NSString *input = nil;
//    
//    input = @"[3];";
//    res = [_parser parseString:input error:&err];
//    TDEqualObjects(TDAssembly(@"[[, 3, ;][/3/]/;^"), [res description]);
//}
//
//- (void)testMissingElement {
//    NSError *err = nil;
//    PKAssembly *res = nil;
//    NSString *input = nil;
//    
//    _parser.enableAutomaticErrorRecovery = YES;
//    
//    input = @"[];";
//    res = [_parser parseString:input error:&err];
//    TDEqualObjects(TDAssembly(@"[[, ;][/]/;^"), [res description]);
//}
//
//- (void)testMissingRbracketInAssign {
//    NSError *err = nil;
//    PKAssembly *res = nil;
//    NSString *input = nil;
//    
//    _parser.enableAutomaticErrorRecovery = YES;
//    
//    // not sure if this uses single token insertion or resync ??
//    
//    input = @"[=[2].";
//    res = [_parser parseString:input error:&err];
//    TDEqualObjects(TDAssembly(@"[[, =, [, 2, .][/=/[/2/]/.^"), [res description]);
//}
//
//- (void)testMissingLbracketInAssign {
//    NSError *err = nil;
//    PKAssembly *res = nil;
//    NSString *input = nil;
//    
//    _parser.enableAutomaticErrorRecovery = YES;
//    
//    input = @"1]=[2].";
//    res = [_parser parseString:input error:&err];
//    TDEqualObjects(TDAssembly(@"[1, ], =, [, 2, .]1/]/=/[/2/]/.^"), [res description]);
//}
//
//- (void)testJunkBeforeSemi {
//    NSError *err = nil;
//    PKAssembly *res = nil;
//    NSString *input = nil;
//    
//    _parser.enableAutomaticErrorRecovery = YES;
//    
//    input = @"[1]foobar baz bat ;";
//    res = [_parser parseString:input error:&err];
//    TDEqualObjects(TDAssembly(@"[[, 1, foobar, baz, bat, ;][/1/]/foobar/baz/bat/;^"), [res description]);
//}
//
//- (void)testJunkBeforeSemi2 {
//    NSError *err = nil;
//    PKAssembly *res = nil;
//    NSString *input = nil;
//    
//    _parser.enableAutomaticErrorRecovery = YES;
//    
//    input = @"[1]foobar baz ;[2];";
//    res = [_parser parseString:input error:&err];
//    TDEqualObjects(TDAssembly(@"[[, 1, foobar, baz, ;, [, 2, ;][/1/]/foobar/baz/;/[/2/]/;^"), [res description]);
//}


- (void)parser:(PKParser *)p didMatchStat:(PKAssembly *)a {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, a);
    [a push:@"flag"];
}
- (void)testStatments {
    NSError *err = nil;
    PKAssembly *res = nil;
    NSString *input = nil;
    
    _parser.enableAutomaticErrorRecovery = YES;
    
    input = @"[1];[2";
    res = [_parser parseString:input error:&err];
    TDEqualObjects(TDAssembly(@"[[, 1, ;, flag, [, 2][/1/]/;/[/2^"), [res description]);
    
//    input = @"[1];[2;[3];";
//    res = [_parser parseString:input error:&err];
//    TDEqualObjects(TDAssembly(@"[[, 1, ;, flag, [, 2, ;, flag, [, 3, ;, flag][/1/]/;/[/2/;/[/3/]/;^"), [res description]);
//    
//    input = @"[1];[2,;[3];";
//    res = [_parser parseString:input error:&err];
//    TDEqualObjects(TDAssembly(@"[[, 1, ;, flag, [, 2, ,, ;, flag, [, 3, ;, flag][/1/]/;/[/2/,/;/[/3/]/;^"), [res description]);
//    
//    input = @"[1];[;[3];";
//    res = [_parser parseString:input error:&err];
//    TDEqualObjects(TDAssembly(@"[[, 1, ;, flag, [, ;, flag, [, 3, ;, flag][/1/]/;/[/;/[/3/]/;^"), [res description]);
//    
//    input = @"[1];;[3];";
//    res = [_parser parseString:input error:&err];
//    TDEqualObjects(TDAssembly(@"[[, 1, ;, flag, ;, flag, [, 3, ;, flag][/1/]/;/;/[/3/]/;^"), [res description]);
}

@end
