#if PK_PLATFORM_EMAIL_STATE
#import "TDTestScaffold.h"
#import "TDEmailStateTest.h"

@interface TDEmailStateTest : XCTestCase {
    PKEmailState *emailState;
    PKTokenizer *t;
    NSString *s;
    PKToken *tok;
}

@end

@implementation TDEmailStateTest

- (void)setUp {
    t = [[PKTokenizer alloc] init];
    emailState = t.emailState;
}


- (void)tearDown {
    [t release];
}


- (void)testToddAtGmail {
    s = @"todd@gmail.com";
    t.string = s;
    
    tok = [t nextToken];
    
    TDTrue(tok.isEmail);
    TDEqualObjects(s, tok.stringValue);
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDEqualObjects([PKToken EOFToken], tok);
}


- (void)testParenToddAtGmailParen {
    s = @"(todd@gmail.com)";
    t.string = s;
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"(");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isEmail);
    TDEqualObjects(tok.stringValue, @"todd@gmail.com");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @")");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDEqualObjects([PKToken EOFToken], tok);
}


- (void)testParenSomethingLikeToddAtGmailDotParen {
    s = @"(something like todd@gmail.com.)";
    t.string = s;
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"(");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"something");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"like");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isEmail);
    TDEqualObjects(tok.stringValue, @"todd@gmail.com");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @".");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @")");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDEqualObjects([PKToken EOFToken], tok);
}


- (void)testNSLog {
    s = @"NSLog(@\"playbackFinished. Reason: Playback Ended\");";
    t.string = s;
    
    tok = [t nextToken];
    
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"NSLog");
    TDEquals(tok.doubleValue, 0.0);

    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"(");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"@");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isQuotedString);
    TDEqualObjects(tok.stringValue, @"\"playbackFinished. Reason: Playback Ended\"");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @")");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @";");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDEqualObjects([PKToken EOFToken], tok);
}

- (void)testNSLog2 {
    s = @"NSLog(@\"playbackFinished. Reason: Playback Ended\");";
    t.string = s;
    
    tok = [t nextToken];
    
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"NSLog");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"(");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"@");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isQuotedString);
    TDEqualObjects(tok.stringValue, @"\"playbackFinished. Reason: Playback Ended\"");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @")");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @";");
    TDEquals(tok.doubleValue, 0.0);
    
    tok = [t nextToken];
    TDEqualObjects([PKToken EOFToken], tok);
}

@end
#endif