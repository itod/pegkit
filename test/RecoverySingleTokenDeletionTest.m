#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "ElementAssignParser.h"

@interface RecoverySingleTokenDeletionTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) ElementAssignParser *parser;
@end

@implementation RecoverySingleTokenDeletionTest

- (void)setUp {
    self.parser = [[[ElementAssignParser alloc] initWithDelegate:self] autorelease];
}

- (void)tearDown {
    self.factory = nil;
}

- (void)testCorrectExpr {
    NSError *err = nil;
    PKAssembly *res = nil;
    NSString *input = nil;
    
    input = @"[3];[2];";
    res = [_parser parseString:input error:&err];
    TDEqualObjects(TDAssembly(@"[[, 3, ;, [, 2, ;][/3/]/;/[/2/]/;^"), [res description]);
}

- (void)testExtraBracket {
    NSError *err = nil;
    PKAssembly *res = nil;
    NSString *input = nil;
    
    _parser.enableAutomaticErrorRecovery = NO;
    
    input = @"[3]];";
    res = [_parser parseString:input error:&err];
    TDNotNil(err);
    TDNil(res);
}

- (void)testExtraBracketWithRecovery {
    NSError *err = nil;
    PKAssembly *res = nil;
    NSString *input = nil;
    
    _parser.enableAutomaticErrorRecovery = YES;
    
    input = @"[3]];";
    res = [_parser parseString:input error:&err];
    TDEqualObjects(TDAssembly(@"[[, 3, ], ;][/3/]/]/;^"), [res description]);
}

@end
