#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "MultipleParser.h"

@interface MultipleParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) MultipleParser *parser;
@end

@implementation MultipleParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"multiple" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"Multiple";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    [_root visit:_visitor];
    
    self.parser = [[[MultipleParser alloc] initWithDelegate:self] autorelease];

#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/MultipleParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/MultipleParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}

- (void)tearDown {
    self.factory = nil;
}

- (void)testABA {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"a b a" error:&err];
    
    TDEqualObjects(TDAssembly(@"[a, b, a]a/b/a^"), [res description]);
}

- (void)testABA2 {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"a b a b a" error:&err];
    
    TDEqualObjects(TDAssembly(@"[a, b, a, b, a]a/b/a/b/a^"), [res description]);
}

- (void)testABA3 {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"a b a b a b a" error:&err];
    
    TDEqualObjects(TDAssembly(@"[a, b, a, b, a, b, a]a/b/a/b/a/b/a^"), [res description]);
}

@end
