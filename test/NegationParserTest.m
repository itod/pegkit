#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "NegationParser.h"

@interface NegationParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) NegationParser *parser;
@end

@implementation NegationParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"negation" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"Negation";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    [_root visit:_visitor];
    
    self.parser = [[[NegationParser alloc] initWithDelegate:self] autorelease];

#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/NegationParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/NegationParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}

- (void)tearDown {
    self.factory = nil;
}

- (void)testBar {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"bar" error:&err];
    
    TDEqualObjects(TDAssembly(@"[bar]bar^"), [res description]);
}

- (void)testFoo {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"foo" error:&err];
    
    TDEqualObjects(nil, res);
}

- (void)testBarFooOpt {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"bar foo?" error:&err];

    // junk at end
    TDNil(res);
}

- (void)testBarFoo {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"bar foo" error:&err];
    
    // junk at end
    TDNil(res);
}

@end
