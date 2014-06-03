#import "JSONParser.h"
#import <PEGKit/PEGKit.h>


@interface JSONParser ()

@end

@implementation JSONParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"false"] = @(JSON_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"}"] = @(JSON_TOKEN_KIND_CLOSECURLY);
        self.tokenKindTab[@"["] = @(JSON_TOKEN_KIND_OPENBRACKET);
        self.tokenKindTab[@"null"] = @(JSON_TOKEN_KIND_NULLLITERAL);
        self.tokenKindTab[@","] = @(JSON_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"true"] = @(JSON_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"]"] = @(JSON_TOKEN_KIND_CLOSEBRACKET);
        self.tokenKindTab[@"{"] = @(JSON_TOKEN_KIND_OPENCURLY);
        self.tokenKindTab[@":"] = @(JSON_TOKEN_KIND_COLON);

        self.tokenKindNameTab[JSON_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[JSON_TOKEN_KIND_CLOSECURLY] = @"}";
        self.tokenKindNameTab[JSON_TOKEN_KIND_OPENBRACKET] = @"[";
        self.tokenKindNameTab[JSON_TOKEN_KIND_NULLLITERAL] = @"null";
        self.tokenKindNameTab[JSON_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[JSON_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[JSON_TOKEN_KIND_CLOSEBRACKET] = @"]";
        self.tokenKindNameTab[JSON_TOKEN_KIND_OPENCURLY] = @"{";
        self.tokenKindNameTab[JSON_TOKEN_KIND_COLON] = @":";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {

    [self start_]; 
    [self matchEOF:YES]; 

}

- (void)start_ {
    
    [self execute:^{
    
	PKTokenizer *t = self.tokenizer;
	
    // whitespace
    self.silentlyConsumesWhitespace = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    self.assembly.preservesWhitespaceTokens = YES;

    // comments
	t.commentState.reportsCommentTokens = YES;
	[t setTokenizerState:t.commentState from:'/' to:'/'];
	[t.commentState addSingleLineStartMarker:@"//"];
	[t.commentState addMultiLineStartMarker:@"/*" endMarker:@"*/"];

    }];
    if ([self predicts:JSON_TOKEN_KIND_OPENBRACKET, 0]) {
        [self array_]; 
    } else if ([self predicts:JSON_TOKEN_KIND_OPENCURLY, 0]) {
        [self object_]; 
    }
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [self comment_]; 
    }

}

- (void)object_ {
    
    [self openCurly_]; 
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [self comment_]; 
    }
    [self objectContent_]; 
    [self closeCurly_]; 

}

- (void)objectContent_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self actualObject_]; 
    }

}

- (void)actualObject_ {
    
    [self property_]; 
    while ([self speculate:^{ [self commaProperty_]; }]) {
        [self commaProperty_]; 
    }

}

- (void)property_ {
    
    [self propertyName_]; 
    [self colon_]; 
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [self comment_]; 
    }
    [self value_]; 

}

- (void)commaProperty_ {
    
    [self comma_]; 
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [self comment_]; 
    }
    [self property_]; 

}

- (void)propertyName_ {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPropertyName:)];
}

- (void)array_ {
    
    [self openBracket_]; 
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [self comment_]; 
    }
    [self arrayContent_]; 
    [self closeBracket_]; 

}

- (void)arrayContent_ {
    
    if ([self predicts:JSON_TOKEN_KIND_FALSE, JSON_TOKEN_KIND_NULLLITERAL, JSON_TOKEN_KIND_OPENBRACKET, JSON_TOKEN_KIND_OPENCURLY, JSON_TOKEN_KIND_TRUE, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self actualArray_]; 
    }

}

- (void)actualArray_ {
    
    [self value_]; 
    while ([self speculate:^{ [self commaValue_]; }]) {
        [self commaValue_]; 
    }

}

- (void)commaValue_ {
    
    [self comma_]; 
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [self comment_]; 
    }
    [self value_]; 

}

- (void)value_ {
    
    if ([self predicts:JSON_TOKEN_KIND_NULLLITERAL, 0]) {
        [self nullLiteral_]; 
    } else if ([self predicts:JSON_TOKEN_KIND_TRUE, 0]) {
        [self true_]; 
    } else if ([self predicts:JSON_TOKEN_KIND_FALSE, 0]) {
        [self false_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self number_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self string_]; 
    } else if ([self predicts:JSON_TOKEN_KIND_OPENBRACKET, 0]) {
        [self array_]; 
    } else if ([self predicts:JSON_TOKEN_KIND_OPENCURLY, 0]) {
        [self object_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'value'."];
    }
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [self comment_]; 
    }

}

- (void)comment_ {
    
    [self matchComment:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchComment:)];
}

- (void)string_ {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchString:)];
}

- (void)number_ {
    
    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNumber:)];
}

- (void)nullLiteral_ {
    
    [self match:JSON_TOKEN_KIND_NULLLITERAL discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNullLiteral:)];
}

- (void)true_ {
    
    [self match:JSON_TOKEN_KIND_TRUE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchTrue:)];
}

- (void)false_ {
    
    [self match:JSON_TOKEN_KIND_FALSE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchFalse:)];
}

- (void)openCurly_ {
    
    [self match:JSON_TOKEN_KIND_OPENCURLY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchOpenCurly:)];
}

- (void)closeCurly_ {
    
    [self match:JSON_TOKEN_KIND_CLOSECURLY discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchCloseCurly:)];
}

- (void)openBracket_ {
    
    [self match:JSON_TOKEN_KIND_OPENBRACKET discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchOpenBracket:)];
}

- (void)closeBracket_ {
    
    [self match:JSON_TOKEN_KIND_CLOSEBRACKET discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchCloseBracket:)];
}

- (void)comma_ {
    
    [self match:JSON_TOKEN_KIND_COMMA discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchComma:)];
}

- (void)colon_ {
    
    [self match:JSON_TOKEN_KIND_COLON discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchColon:)];
}

@end