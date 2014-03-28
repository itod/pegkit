#import "TDTestScaffold.h"

@interface TDQuoteStateTest : XCTestCase {
    PKQuoteState *quoteState;
    PKTokenizer *t;
    PKReader *r;
    NSString *s;
}

@end

@implementation TDQuoteStateTest

- (void)setUp {
    t = [PKTokenizer tokenizer];
    quoteState = t.quoteState;
}


- (void)tearDown {
}


- (void)testQuotedString {
    s = @"'stuff'";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDEqualObjects(s, tok.stringValue);
}


- (void)testQuotedStringEscaped {
    s = @"'it\\'s'";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDEqualObjects(s, tok.stringValue);
}


- (void)testQuotedStringEscaped2 {
    s = @"'it\\'s'";
    t.string = s;
    quoteState.usesCSVStyleEscaping = YES;
    
    PKToken *tok = [t nextToken];
    TDEqualObjects(@"'it\\'", tok.stringValue);
    
    tok = [t nextToken];
    TDEqualObjects(@"s'", tok.stringValue);
    TDTrue(tok.isWord);
    
    tok = [t nextToken];
    TDEquals([PKToken EOFToken], tok);
}


- (void)testQuotedStringEscapedDouble {
    s = @"'it''s'";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDEqualObjects(@"'it'", tok.stringValue);

    tok = [t nextToken];
    TDEqualObjects(@"'s'", tok.stringValue);

    tok = [t nextToken];
    TDEquals([PKToken EOFToken], tok);
}


- (void)testQuotedStringEscapedDouble2 {
    s = @"'it''s'";
    t.string = s;
    quoteState.usesCSVStyleEscaping = YES;
    
    PKToken *tok = [t nextToken];
    TDEqualObjects(s, tok.stringValue);
    
    tok = [t nextToken];
    TDEquals([PKToken EOFToken], tok);
}


- (void)testQuotedStringEscapedDouble3 {
    s = @"'it''s' cool";
    t.string = s;
    quoteState.usesCSVStyleEscaping = YES;
    
    PKToken *tok = [t nextToken];
    TDEqualObjects(@"'it''s'", tok.stringValue);
    
    tok = [t nextToken];
    TDEqualObjects(@"cool", tok.stringValue);
    
    tok = [t nextToken];
    TDEquals([PKToken EOFToken], tok);
}


- (void)testQuotedStringEscapedDouble4 {
    s = @"'it''s'cool";
    t.string = s;
    quoteState.usesCSVStyleEscaping = YES;
    
    PKToken *tok = [t nextToken];
    TDEqualObjects(@"'it''s'", tok.stringValue);
    
    tok = [t nextToken];
    TDEqualObjects(@"cool", tok.stringValue);
    
    tok = [t nextToken];
    TDEquals([PKToken EOFToken], tok);
}


- (void)testLiteralBackslashInQuotedString {
    s = @"'\\'";
    t.string = s;
    
    PKToken *tok = [t nextToken];
    TDEqualObjects(@"'\\'", tok.stringValue);
    TDTrue(tok.isQuotedString);
}


- (void)testLiteralBackslashInQuotedString2 {
    s = @"' \\'";
    t.string = s;
    
    PKToken *tok = [t nextToken];
    TDEqualObjects(@"' \\'", tok.stringValue);
    TDTrue(tok.isQuotedString);
}


- (void)testLiteralBackslashInQuotedString3 {
    s = @"\"\\\"";
    t.string = s;
    
    PKToken *tok = [t nextToken];
    TDEqualObjects(@"\"\\\"", tok.stringValue);
    TDTrue(tok.isQuotedString);
}


- (void)testLiteralBackslashInQuotedString4 {
    s = @"'\'";
    t.string = s;
    t.quoteState.usesCSVStyleEscaping = YES;
    
    PKToken *tok = [t nextToken];
    TDEqualObjects(@"'\'", tok.stringValue);
    TDTrue(tok.isQuotedString);
}


- (void)testQuotedStringEOFTerminated {
    s = @"'stuff";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDEqualObjects(s, tok.stringValue);
}


- (void)testQuotedStringRepairEOFTerminated {
    s = @"'stuff";
    t.string = s;
    quoteState.balancesEOFTerminatedQuotes = YES;
    PKToken *tok = [t nextToken];
    TDEqualObjects(@"'stuff'", tok.stringValue);
}


- (void)testQuotedStringPlus {
    s = @"'a quote here' more";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDEqualObjects(@"'a quote here'", tok.stringValue);
}


- (void)test14CharQuotedString {
    s = @"'123456789abcef'";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDEqualObjects(s, tok.stringValue);
    TDTrue(tok.isQuotedString);
}


- (void)test15CharQuotedString {
    s = @"'123456789abcefg'";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDEqualObjects(s, tok.stringValue);
    TDTrue(tok.isQuotedString);
}


- (void)test16CharQuotedString {
    s = @"'123456789abcefgh'";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDEqualObjects(s, tok.stringValue);
    TDTrue(tok.isQuotedString);
}


- (void)test31CharQuotedString {
    s = @"'123456789abcefgh123456789abcefg'";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDEqualObjects(s, tok.stringValue);
    TDTrue(tok.isQuotedString);
}


- (void)test32CharQuotedString {
    s = @"'123456789abcefgh123456789abcefgh'";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDEqualObjects(s, tok.stringValue);
    TDTrue(tok.isQuotedString);
}

@end
