#if PK_PLATFORM_TWITTER_STATE
#import "TDTestScaffold.h"

@interface TDTwitterStateTest : XCTestCase {
    PKTwitterState *twitterState;
    PKTokenizer *t;
    NSString *s;
    PKToken *tok;
}

@end

@implementation TDTwitterStateTest

- (void)setUp {
    t = [[PKTokenizer alloc] init];
    twitterState = t.twitterState;
    [t setTokenizerState:twitterState from:'@' to:'@'];
}


- (void)tearDown {
    [t release];
}


- (void)testAtiTod {
    s = @"@iTod";
    t.string = s;
    
    tok = [t nextToken];
    
    TDTrue(tok.isTwitter);
    TDEqualObjects(s, tok.stringValue);
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDEqualObjects([PKToken EOFToken], tok);
}


- (void)testPareniTodParen {
    s = @"(@iTod)";
    t.string = s;
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"(");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isTwitter);
    TDEqualObjects(tok.stringValue, @"@iTod");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @")");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDEqualObjects([PKToken EOFToken], tok);
}


- (void)testiTodAposSQuote {
    s = @"@iTod's";
    t.string = s;
    
    tok = [t nextToken];
    TDTrue(tok.isTwitter);
    TDEqualObjects(tok.stringValue, @"@iTod");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isQuotedString);
    TDEqualObjects(tok.stringValue, @"'s");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDEqualObjects([PKToken EOFToken], tok);
}


//- (void)testiTodAposS {
//    t.quoteState.allowsEOFTerminatedQuotes = NO;
//    s = @"@iTod's";
//    t.string = s;
//    
//    tok = [t nextToken];
//    TDTrue(tok.isTwitter);
//    TDEqualObjects(tok.stringValue, @"@iTod");
//    TDEquals(tok.doubleValue, 0.0);
//    
//    tok = [t nextToken];
//    TDTrue(tok.isSymbol);
//    TDEqualObjects(tok.stringValue, @"'");
//    TDEquals(tok.doubleValue, 0.0);
//    
//    tok = [t nextToken];
//    TDTrue(tok.isWord);
//    TDEqualObjects(tok.stringValue, @"s");
//    TDEquals(tok.doubleValue, 0.0);
//    
//    tok = [t nextToken];
//    TDEqualObjects([PKToken EOFToken], tok);
//}
//
//
//- (void)testParenSomethingLikeToddAtGmailDotParen {
//    s = @"(something like todd@gmail.com.)";
//    t.string = s;
//    
//    tok = [t nextToken];
//    TDTrue(tok.isSymbol);
//    TDEqualObjects(tok.stringValue, @"(");
//    TDEquals(tok.doubleValue, 0.0);
//    
//    tok = [t nextToken];
//    TDTrue(tok.isWord);
//    TDEqualObjects(tok.stringValue, @"something");
//    TDEquals(tok.doubleValue, 0.0);
//    
//    tok = [t nextToken];
//    TDTrue(tok.isWord);
//    TDEqualObjects(tok.stringValue, @"like");
//    TDEquals(tok.doubleValue, 0.0);
//    
//    tok = [t nextToken];
//    TDTrue(tok.isEmail);
//    TDEqualObjects(tok.stringValue, @"todd@gmail.com");
//    TDEquals(tok.doubleValue, 0.0);
//    
//    tok = [t nextToken];
//    TDTrue(tok.isSymbol);
//    TDEqualObjects(tok.stringValue, @".");
//    TDEquals(tok.doubleValue, 0.0);
//    
//    tok = [t nextToken];
//    TDTrue(tok.isSymbol);
//    TDEqualObjects(tok.stringValue, @")");
//    TDEquals(tok.doubleValue, 0.0);
//    
//    tok = [t nextToken];
//    TDEqualObjects([PKToken EOFToken], tok);
//}

@end
#endif
