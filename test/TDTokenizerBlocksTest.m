#import "TDTestScaffold.h"

@interface TDTokenizerBlocksTest : XCTestCase {
    PKTokenizer *t;
    NSString *s;
}

@end

@implementation TDTokenizerBlocksTest

- (void)setUp {
}


- (void)tearDown {
}


- (void)testBlastOff {
    s = @"\"It's 123 blast-off!\", she said, // watch out!\n"
    @"and <= 3 'ticks' later /* wince */, it's blast-off!";
    t = [PKTokenizer tokenizerWithString:s];
    
//    NSLog(@"\n\n starting!!! \n\n");

    [t enumerateTokensUsingBlock:^(PKToken *tok, BOOL *stop) {
//        NSLog(@"(%@)", tok.stringValue);
    }];
                                         
    
//    NSLog(@"\n\n done!!! \n\n");
}

@end
