#import "TDTestScaffold.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "JavaScriptParser.h"

@interface JSRecoveryTest : XCTestCase
@property (nonatomic, retain) JavaScriptParser *parser;
@property (nonatomic, retain) id mock;
@end

@implementation JSRecoveryTest

- (void)dealloc {
    self.parser = nil;
    self.mock = nil;
    [super dealloc];
}

- (void)parser:(PKParser *)p didMatchVar:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchIdentifier:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchVariable:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchVariables:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchVarVariables:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchVariablesOrExpr:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchSemi:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchVariablesOrExprStmt:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchStmt:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchFunction:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchOpenParen:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchCloseParen:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchParamListOpt:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchFunc:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchElement:(PKAssembly *)a {}
- (void)parser:(PKParser *)p didMatchProgram:(PKAssembly *)a {}

- (void)parser:(PKParser *)p didFailToMatch:(PKAssembly *)a {}

- (void)setUp {
    self.mock = [OCMockObject mockForClass:[JSRecoveryTest class]];
    
    // return YES to -respondsToSelector:
    [[[_mock stub] andReturnValue:OCMOCK_VALUE((BOOL){YES})] respondsToSelector:(SEL)OCMOCK_ANY];
}

- (void)tearDown {

}

- (void)testCorrectExpr {
    self.parser = [[[JavaScriptParser alloc] initWithDelegate:_mock] autorelease];

    NSError *err = nil;
    PKAssembly *res = nil;
    NSString *input = nil;
    
    [[_mock expect] parser:_parser didMatchVar:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchIdentifier:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchVariable:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchVariables:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchVarVariables:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchVariablesOrExpr:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchSemi:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchStmt:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchVariablesOrExprStmt:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchElement:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchProgram:OCMOCK_ANY];
    
    input = @"var foo;";
    res = [_parser parseString:input error:&err];
    TDEqualObjects(TDAssembly(@"[var, foo, ;]var/foo/;^"), [res description]);
    
    VERIFY();
}

- (void)testBorkedVarMissingSemi {
    self.parser = [[[JavaScriptParser alloc] initWithDelegate:_mock] autorelease];

    NSError *err = nil;
    PKAssembly *res = nil;
    NSString *input = nil;
    
    [[[_mock stub] andDo:^(NSInvocation *invoc) {
        PKAssembly *a = nil;
        [invoc getArgument:&a atIndex:3];
        //NSLog(@"%@", a);
        
        TDNotNil(a);
        TDEqualObjects(TDAssembly(@"[var, foo]var/foo^"), [a description]);
        
        [a pop]; // var
        [a pop]; // foo
    }] parser:_parser didFailToMatch:OCMOCK_ANY];

    [[[_mock stub] andDo:^(NSInvocation *invoc) {
          PKAssembly *a = nil;
          [invoc getArgument:&a atIndex:3];
          
          TDNotNil(a);
          TDEqualObjects(TDAssembly(@"[]var/foo^"), [a description]);
    }] parser:_parser didMatchProgram:OCMOCK_ANY];
        
    input = @"var foo";
    res = [_parser parseString:input error:&err];
    TDEqualObjects(TDAssembly(@"[]var/foo^"), [res description]);
    
    VERIFY();
}

- (void)testMissingVarIdentifier {
    self.parser = [[[JavaScriptParser alloc] initWithDelegate:_mock] autorelease];

    NSError *err = nil;
    PKAssembly *res = nil;
    NSString *input = nil;
    
    [[[_mock stub] andDo:^(NSInvocation *invoc) {
        PKAssembly *a = nil;
        [invoc getArgument:&a atIndex:3];
        //NSLog(@"%@", a);
        
        TDNotNil(a);
        TDEqualObjects(TDAssembly(@"[1, -]1/-^"), [a description]);
        
        [a pop]; // `-`
        [a pop]; // 1
    }] parser:_parser didFailToMatch:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchSemi:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchStmt:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchElement:OCMOCK_ANY];

    [[_mock expect] parser:_parser didMatchVariablesOrExpr:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchSemi:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchVariablesOrExprStmt:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchStmt:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchElement:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchProgram:OCMOCK_ANY];
    
    input = @"1-;;";
    res = [_parser parseString:input error:&err];
    TDEqualObjects(TDAssembly(@"[;, ;]1/-/;/;^"), [res description]);
    
    VERIFY();
}

- (void)testBorkedFunc1 {
    self.parser = [[[JavaScriptParser alloc] initWithDelegate:_mock] autorelease];
    _parser.preserveWhitespace = YES;

    NSError *err = nil;
    PKAssembly *res = nil;
    NSString *input = nil;
    
    [[[_mock stub] andDo:^(NSInvocation *invoc) {
        PKAssembly *a = nil;
        [invoc getArgument:&a atIndex:3];
        //NSLog(@"%@", a);
        
        TDNotNil(a);
        TDEqualObjects(TDAssembly(@"[function,  , foo, (, ), {, v]function/ /foo/(/)/{/v^"), [a description]);
        
        [a pop]; // `v`
    }] parser:_parser didFailToMatch:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchFunction:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchIdentifier:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchOpenParen:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchCloseParen:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchParamListOpt:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchFunc:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchElement:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchProgram:OCMOCK_ANY];
    
    input = @"function foo(){v}";
    res = [_parser parseString:input error:&err];
    TDEqualObjects(TDAssembly(@"[function,  , foo, (, ), {, }]function/ /foo/(/)/{/v/}^"), [res description]);
    
    VERIFY();
}

- (void)testBorkedFunc2 {
    self.parser = [[[JavaScriptParser alloc] initWithDelegate:_mock] autorelease];
    _parser.preserveWhitespace = YES;

    NSError *err = nil;
    PKAssembly *res = nil;
    NSString *input = nil;
    
    [[[_mock stub] andDo:^(NSInvocation *invoc) {
        PKAssembly *a = nil;
        [invoc getArgument:&a atIndex:3];
        //NSLog(@"%@", a);
        
        TDNotNil(a);
        TDEqualObjects(TDAssembly(@"[function,  , foo, (, ), {, \n\t , v, \n]function/ /foo/(/)/{/\n\t /v/\n^"), [a description]);
        
        [a pop]; // trailing whitespace
        [a pop]; // `v`
        [a pop]; // leading whitespace
    }] parser:_parser didFailToMatch:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchFunction:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchIdentifier:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchOpenParen:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchCloseParen:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchParamListOpt:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchFunc:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchElement:OCMOCK_ANY];
    [[_mock expect] parser:_parser didMatchProgram:OCMOCK_ANY];
    
    input = @"function foo(){\n\t v\n}";
    res = [_parser parseString:input error:&err];
    TDEqualObjects(TDAssembly(@"[function,  , foo, (, ), {, }]function/ /foo/(/)/{/\n\t /v/\n/}^"), [res description]);
    
    VERIFY();
}

@end