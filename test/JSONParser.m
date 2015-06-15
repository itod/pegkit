#import "JSONParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


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
    PKParser_weakSelfDecl;

    [PKParser_weakSelf start_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)start_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf execute:^{
    
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
    if ([PKParser_weakSelf predicts:JSON_TOKEN_KIND_OPENBRACKET, 0]) {
        [PKParser_weakSelf array_];
    } else if ([PKParser_weakSelf predicts:JSON_TOKEN_KIND_OPENCURLY, 0]) {
        [PKParser_weakSelf object_];
    }
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [PKParser_weakSelf comment_];
    }

}

- (void)object_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf openCurly_];
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [PKParser_weakSelf comment_];
    }
    [PKParser_weakSelf objectContent_];
    [PKParser_weakSelf closeCurly_];

}

- (void)objectContent_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [PKParser_weakSelf actualObject_];
    }

}

- (void)actualObject_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf property_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf commaProperty_];}]) {
        [PKParser_weakSelf commaProperty_];
    }

}

- (void)property_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf propertyName_];
    [PKParser_weakSelf colon_];
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [PKParser_weakSelf comment_];
    }
    [PKParser_weakSelf value_];

}

- (void)commaProperty_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf comma_];
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [PKParser_weakSelf comment_];
    }
    [PKParser_weakSelf property_];

}

- (void)propertyName_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchQuotedString:NO];

    [self fireDelegateSelector:@selector(parser:didMatchPropertyName:)];
}

- (void)array_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf openBracket_];
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [PKParser_weakSelf comment_];
    }
    [PKParser_weakSelf arrayContent_];
    [PKParser_weakSelf closeBracket_];

}

- (void)arrayContent_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JSON_TOKEN_KIND_FALSE, JSON_TOKEN_KIND_NULLLITERAL, JSON_TOKEN_KIND_OPENBRACKET, JSON_TOKEN_KIND_OPENCURLY, JSON_TOKEN_KIND_TRUE, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [PKParser_weakSelf actualArray_];
    }

}

- (void)actualArray_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf value_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf commaValue_];}]) {
        [PKParser_weakSelf commaValue_];
    }

}

- (void)commaValue_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf comma_];
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [PKParser_weakSelf comment_];
    }
    [PKParser_weakSelf value_];

}

- (void)value_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:JSON_TOKEN_KIND_NULLLITERAL, 0]) {
        [PKParser_weakSelf nullLiteral_];
    } else if ([PKParser_weakSelf predicts:JSON_TOKEN_KIND_TRUE, 0]) {
        [PKParser_weakSelf true_];
    } else if ([PKParser_weakSelf predicts:JSON_TOKEN_KIND_FALSE, 0]) {
        [PKParser_weakSelf false_];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [PKParser_weakSelf number_];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [PKParser_weakSelf string_];
    } else if ([PKParser_weakSelf predicts:JSON_TOKEN_KIND_OPENBRACKET, 0]) {
        [PKParser_weakSelf array_];
    } else if ([PKParser_weakSelf predicts:JSON_TOKEN_KIND_OPENCURLY, 0]) {
        [PKParser_weakSelf object_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'value'."];
    }
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [PKParser_weakSelf comment_];
    }

}

- (void)comment_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchComment:NO];

    [self fireDelegateSelector:@selector(parser:didMatchComment:)];
}

- (void)string_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchQuotedString:NO];

    [self fireDelegateSelector:@selector(parser:didMatchString:)];
}

- (void)number_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchNumber:NO];

    [self fireDelegateSelector:@selector(parser:didMatchNumber:)];
}

- (void)nullLiteral_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JSON_TOKEN_KIND_NULLLITERAL discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchNullLiteral:)];
}

- (void)true_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JSON_TOKEN_KIND_TRUE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchTrue:)];
}

- (void)false_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JSON_TOKEN_KIND_FALSE discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchFalse:)];
}

- (void)openCurly_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JSON_TOKEN_KIND_OPENCURLY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchOpenCurly:)];
}

- (void)closeCurly_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JSON_TOKEN_KIND_CLOSECURLY discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchCloseCurly:)];
}

- (void)openBracket_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JSON_TOKEN_KIND_OPENBRACKET discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchOpenBracket:)];
}

- (void)closeBracket_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JSON_TOKEN_KIND_CLOSEBRACKET discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchCloseBracket:)];
}

- (void)comma_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JSON_TOKEN_KIND_COMMA discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchComma:)];
}

- (void)colon_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:JSON_TOKEN_KIND_COLON discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchColon:)];
}

@end