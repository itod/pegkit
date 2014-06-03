#import "MethodsFactoredParser.h"
#import <PEGKit/PEGKit.h>


@interface MethodsFactoredParser ()

@property (nonatomic, retain) NSMutableDictionary *start_memo;
@property (nonatomic, retain) NSMutableDictionary *method_memo;
@property (nonatomic, retain) NSMutableDictionary *type_memo;
@property (nonatomic, retain) NSMutableDictionary *args_memo;
@property (nonatomic, retain) NSMutableDictionary *arg_memo;
@end

@implementation MethodsFactoredParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"int"] = @(METHODSFACTORED_TOKEN_KIND_INT);
        self.tokenKindTab[@"}"] = @(METHODSFACTORED_TOKEN_KIND_CLOSE_CURLY);
        self.tokenKindTab[@","] = @(METHODSFACTORED_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"void"] = @(METHODSFACTORED_TOKEN_KIND_VOID);
        self.tokenKindTab[@"("] = @(METHODSFACTORED_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"{"] = @(METHODSFACTORED_TOKEN_KIND_OPEN_CURLY);
        self.tokenKindTab[@")"] = @(METHODSFACTORED_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@";"] = @(METHODSFACTORED_TOKEN_KIND_SEMI_COLON);

        self.tokenKindNameTab[METHODSFACTORED_TOKEN_KIND_INT] = @"int";
        self.tokenKindNameTab[METHODSFACTORED_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self.tokenKindNameTab[METHODSFACTORED_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[METHODSFACTORED_TOKEN_KIND_VOID] = @"void";
        self.tokenKindNameTab[METHODSFACTORED_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[METHODSFACTORED_TOKEN_KIND_OPEN_CURLY] = @"{";
        self.tokenKindNameTab[METHODSFACTORED_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[METHODSFACTORED_TOKEN_KIND_SEMI_COLON] = @";";

        self.start_memo = [NSMutableDictionary dictionary];
        self.method_memo = [NSMutableDictionary dictionary];
        self.type_memo = [NSMutableDictionary dictionary];
        self.args_memo = [NSMutableDictionary dictionary];
        self.arg_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.start_memo = nil;
    self.method_memo = nil;
    self.type_memo = nil;
    self.args_memo = nil;
    self.arg_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_start_memo removeAllObjects];
    [_method_memo removeAllObjects];
    [_type_memo removeAllObjects];
    [_args_memo removeAllObjects];
    [_arg_memo removeAllObjects];
}

- (void)start {

    [self start_]; 
    [self matchEOF:YES]; 

}

- (void)__start {
    
    do {
        [self method_]; 
    } while ([self speculate:^{ [self method_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)start_ {
    [self parseRule:@selector(__start) withMemo:_start_memo];
}

- (void)__method {
    
    [self type_]; 
    [self matchWord:NO]; 
    [self match:METHODSFACTORED_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self args_]; 
    [self match:METHODSFACTORED_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    if ([self predicts:METHODSFACTORED_TOKEN_KIND_SEMI_COLON, 0]) {
        [self match:METHODSFACTORED_TOKEN_KIND_SEMI_COLON discard:NO]; 
    } else if ([self predicts:METHODSFACTORED_TOKEN_KIND_OPEN_CURLY, 0]) {
        [self match:METHODSFACTORED_TOKEN_KIND_OPEN_CURLY discard:NO]; 
        [self match:METHODSFACTORED_TOKEN_KIND_CLOSE_CURLY discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'method'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMethod:)];
}

- (void)method_ {
    [self parseRule:@selector(__method) withMemo:_method_memo];
}

- (void)__type {
    
    if ([self predicts:METHODSFACTORED_TOKEN_KIND_VOID, 0]) {
        [self match:METHODSFACTORED_TOKEN_KIND_VOID discard:NO]; 
    } else if ([self predicts:METHODSFACTORED_TOKEN_KIND_INT, 0]) {
        [self match:METHODSFACTORED_TOKEN_KIND_INT discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'type'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchType:)];
}

- (void)type_ {
    [self parseRule:@selector(__type) withMemo:_type_memo];
}

- (void)__args {
    
    if ([self predicts:METHODSFACTORED_TOKEN_KIND_INT, 0]) {
        [self arg_]; 
        while ([self speculate:^{ [self match:METHODSFACTORED_TOKEN_KIND_COMMA discard:NO]; [self arg_]; }]) {
            [self match:METHODSFACTORED_TOKEN_KIND_COMMA discard:NO]; 
            [self arg_]; 
        }
    }

    [self fireDelegateSelector:@selector(parser:didMatchArgs:)];
}

- (void)args_ {
    [self parseRule:@selector(__args) withMemo:_args_memo];
}

- (void)__arg {
    
    [self match:METHODSFACTORED_TOKEN_KIND_INT discard:NO]; 
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchArg:)];
}

- (void)arg_ {
    [self parseRule:@selector(__arg) withMemo:_arg_memo];
}

@end