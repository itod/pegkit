#import "DelimitedParser.h"
#import <PEGKit/PEGKit.h>


@interface DelimitedParser ()

@property (nonatomic, retain) NSMutableDictionary *start_memo;
@property (nonatomic, retain) NSMutableDictionary *s_memo;
@end

@implementation DelimitedParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"<,>"] = @(DELIMITED_TOKEN_KIND_S);

        self.tokenKindNameTab[DELIMITED_TOKEN_KIND_S] = @"<,>";

        self.start_memo = [NSMutableDictionary dictionary];
        self.s_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.start_memo = nil;
    self.s_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_start_memo removeAllObjects];
    [_s_memo removeAllObjects];
}

- (void)start {

    [self start_]; 
    [self matchEOF:YES]; 

}

- (void)__start {
    
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;

    [t.delimitState addStartMarker:@"<" endMarker:@">" allowedCharacterSet:nil];
    [t setTokenizerState:t.delimitState from:'<' to:'<'];

    }];
    [self s_]; 

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)start_ {
    [self parseRule:@selector(__start) withMemo:_start_memo];
}

- (void)__s {
    
    [self match:DELIMITED_TOKEN_KIND_S discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchS:)];
}

- (void)s_ {
    [self parseRule:@selector(__s) withMemo:_s_memo];
}

@end