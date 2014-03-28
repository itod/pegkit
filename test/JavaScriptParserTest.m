#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "JavaScriptParser.h"

@interface JavaScriptParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) JavaScriptParser *parser;
@end

@implementation JavaScriptParserTest {
    BOOL flag;
}

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"javascript" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"JavaScript";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    _visitor.delegatePostMatchCallbacksOn = PGParserFactoryDelegateCallbacksOnAll;
    _visitor.enableAutomaticErrorRecovery = YES;
    _visitor.enableMemoization = NO;
    
    [_root visit:_visitor];
    
    self.parser = [[[JavaScriptParser alloc] initWithDelegate:self] autorelease];

#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/JavaScriptParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/JavaScriptParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}

- (void)tearDown {
    self.factory = nil;
}


- (void)parser:(PKParser *)p didMatchVarVariables:(PKAssembly *)a {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, a);
    flag = YES;
}
- (void)testVarFooEqBar {
    _parser.enableAutomaticErrorRecovery = YES;
    
    NSError *err = nil;
    flag = NO;
    PKAssembly *res = [_parser parseString:@"var foo = 'bar';" error:&err];
    TDEqualObjects(TDAssembly(@"[var, foo, =, 'bar', ;]var/foo/=/'bar'/;^"), [res description]);
    TDEquals(YES, flag);
}

- (void)testDocWriteNewDate {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"document.write(new Date().toUTCString());" error:&err];
    TDEqualObjects(TDAssembly(@"[document, ., write, (, new, Date, (, ), ., toUTCString, (, ), ), ;]document/./write/(/new/Date/(/)/./toUTCString/(/)/)/;^"), [res description]);
}

- (void)testDocWriteNewDateWithParen {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"document.write((new Date()).toUTCString());" error:&err];
    TDEqualObjects(TDAssembly(@"[document, ., write, (, (, new, Date, (, ), ), ., toUTCString, (, ), ), ;]document/./write/(/(/new/Date/(/)/)/./toUTCString/(/)/)/;^"), [res description]);
}

- (void)testDocWriteDate {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"document.write(foo.toUTCString());" error:&err];
    TDEqualObjects(TDAssembly(@"[document, ., write, (, foo, ., toUTCString, (, ), ), ;]document/./write/(/foo/./toUTCString/(/)/)/;^"), [res description]);
}

- (void)testGmailUserscriptShort {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"window.fluid.dockBadge = ''; setTimeout(updateDockBadge, 1000); setTimeout(updateDockBadge, 3000); setInterval(updateDockBadge, 5000);" error:&err];
    TDEqualObjects(TDAssembly(@"[window, ., fluid, ., dockBadge, =, '', ;, setTimeout, (, updateDockBadge, ,, 1000, ), ;, setTimeout, (, updateDockBadge, ,, 3000, ), ;, setInterval, (, updateDockBadge, ,, 5000, ), ;]window/./fluid/./dockBadge/=/''/;/setTimeout/(/updateDockBadge/,/1000/)/;/setTimeout/(/updateDockBadge/,/3000/)/;/setInterval/(/updateDockBadge/,/5000/)/;^"), [res description]);
}

@end
