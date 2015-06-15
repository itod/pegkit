#import "HTMLParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface HTMLParser ()

@property (nonatomic, retain) NSMutableDictionary *start_memo;
@property (nonatomic, retain) NSMutableDictionary *anything_memo;
@property (nonatomic, retain) NSMutableDictionary *scriptElement_memo;
@property (nonatomic, retain) NSMutableDictionary *scriptStartTag_memo;
@property (nonatomic, retain) NSMutableDictionary *scriptEndTag_memo;
@property (nonatomic, retain) NSMutableDictionary *scriptTagName_memo;
@property (nonatomic, retain) NSMutableDictionary *scriptElementContent_memo;
@property (nonatomic, retain) NSMutableDictionary *styleElement_memo;
@property (nonatomic, retain) NSMutableDictionary *styleStartTag_memo;
@property (nonatomic, retain) NSMutableDictionary *styleEndTag_memo;
@property (nonatomic, retain) NSMutableDictionary *styleTagName_memo;
@property (nonatomic, retain) NSMutableDictionary *styleElementContent_memo;
@property (nonatomic, retain) NSMutableDictionary *procInstr_memo;
@property (nonatomic, retain) NSMutableDictionary *doctype_memo;
@property (nonatomic, retain) NSMutableDictionary *text_memo;
@property (nonatomic, retain) NSMutableDictionary *tag_memo;
@property (nonatomic, retain) NSMutableDictionary *emptyTag_memo;
@property (nonatomic, retain) NSMutableDictionary *startTag_memo;
@property (nonatomic, retain) NSMutableDictionary *endTag_memo;
@property (nonatomic, retain) NSMutableDictionary *tagName_memo;
@property (nonatomic, retain) NSMutableDictionary *attr_memo;
@property (nonatomic, retain) NSMutableDictionary *attrName_memo;
@property (nonatomic, retain) NSMutableDictionary *attrValue_memo;
@property (nonatomic, retain) NSMutableDictionary *eq_memo;
@property (nonatomic, retain) NSMutableDictionary *lt_memo;
@property (nonatomic, retain) NSMutableDictionary *gt_memo;
@property (nonatomic, retain) NSMutableDictionary *fwdSlash_memo;
@property (nonatomic, retain) NSMutableDictionary *comment_memo;
@end

@implementation HTMLParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.tokenKindTab[@"script"] = @(HTML_TOKEN_KIND_SCRIPTTAGNAME);
        self.tokenKindTab[@"style"] = @(HTML_TOKEN_KIND_STYLETAGNAME);
        self.tokenKindTab[@"<!DOCTYPE,>"] = @(HTML_TOKEN_KIND_DOCTYPE);
        self.tokenKindTab[@"<"] = @(HTML_TOKEN_KIND_LT);
        self.tokenKindTab[@"<?,?>"] = @(HTML_TOKEN_KIND_PROCINSTR);
        self.tokenKindTab[@"="] = @(HTML_TOKEN_KIND_EQ);
        self.tokenKindTab[@"/"] = @(HTML_TOKEN_KIND_FWDSLASH);
        self.tokenKindTab[@">"] = @(HTML_TOKEN_KIND_GT);

        self.tokenKindNameTab[HTML_TOKEN_KIND_SCRIPTTAGNAME] = @"script";
        self.tokenKindNameTab[HTML_TOKEN_KIND_STYLETAGNAME] = @"style";
        self.tokenKindNameTab[HTML_TOKEN_KIND_DOCTYPE] = @"<!DOCTYPE,>";
        self.tokenKindNameTab[HTML_TOKEN_KIND_LT] = @"<";
        self.tokenKindNameTab[HTML_TOKEN_KIND_PROCINSTR] = @"<?,?>";
        self.tokenKindNameTab[HTML_TOKEN_KIND_EQ] = @"=";
        self.tokenKindNameTab[HTML_TOKEN_KIND_FWDSLASH] = @"/";
        self.tokenKindNameTab[HTML_TOKEN_KIND_GT] = @">";

        self.start_memo = [NSMutableDictionary dictionary];
        self.anything_memo = [NSMutableDictionary dictionary];
        self.scriptElement_memo = [NSMutableDictionary dictionary];
        self.scriptStartTag_memo = [NSMutableDictionary dictionary];
        self.scriptEndTag_memo = [NSMutableDictionary dictionary];
        self.scriptTagName_memo = [NSMutableDictionary dictionary];
        self.scriptElementContent_memo = [NSMutableDictionary dictionary];
        self.styleElement_memo = [NSMutableDictionary dictionary];
        self.styleStartTag_memo = [NSMutableDictionary dictionary];
        self.styleEndTag_memo = [NSMutableDictionary dictionary];
        self.styleTagName_memo = [NSMutableDictionary dictionary];
        self.styleElementContent_memo = [NSMutableDictionary dictionary];
        self.procInstr_memo = [NSMutableDictionary dictionary];
        self.doctype_memo = [NSMutableDictionary dictionary];
        self.text_memo = [NSMutableDictionary dictionary];
        self.tag_memo = [NSMutableDictionary dictionary];
        self.emptyTag_memo = [NSMutableDictionary dictionary];
        self.startTag_memo = [NSMutableDictionary dictionary];
        self.endTag_memo = [NSMutableDictionary dictionary];
        self.tagName_memo = [NSMutableDictionary dictionary];
        self.attr_memo = [NSMutableDictionary dictionary];
        self.attrName_memo = [NSMutableDictionary dictionary];
        self.attrValue_memo = [NSMutableDictionary dictionary];
        self.eq_memo = [NSMutableDictionary dictionary];
        self.lt_memo = [NSMutableDictionary dictionary];
        self.gt_memo = [NSMutableDictionary dictionary];
        self.fwdSlash_memo = [NSMutableDictionary dictionary];
        self.comment_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.start_memo = nil;
    self.anything_memo = nil;
    self.scriptElement_memo = nil;
    self.scriptStartTag_memo = nil;
    self.scriptEndTag_memo = nil;
    self.scriptTagName_memo = nil;
    self.scriptElementContent_memo = nil;
    self.styleElement_memo = nil;
    self.styleStartTag_memo = nil;
    self.styleEndTag_memo = nil;
    self.styleTagName_memo = nil;
    self.styleElementContent_memo = nil;
    self.procInstr_memo = nil;
    self.doctype_memo = nil;
    self.text_memo = nil;
    self.tag_memo = nil;
    self.emptyTag_memo = nil;
    self.startTag_memo = nil;
    self.endTag_memo = nil;
    self.tagName_memo = nil;
    self.attr_memo = nil;
    self.attrName_memo = nil;
    self.attrValue_memo = nil;
    self.eq_memo = nil;
    self.lt_memo = nil;
    self.gt_memo = nil;
    self.fwdSlash_memo = nil;
    self.comment_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_start_memo removeAllObjects];
    [_anything_memo removeAllObjects];
    [_scriptElement_memo removeAllObjects];
    [_scriptStartTag_memo removeAllObjects];
    [_scriptEndTag_memo removeAllObjects];
    [_scriptTagName_memo removeAllObjects];
    [_scriptElementContent_memo removeAllObjects];
    [_styleElement_memo removeAllObjects];
    [_styleStartTag_memo removeAllObjects];
    [_styleEndTag_memo removeAllObjects];
    [_styleTagName_memo removeAllObjects];
    [_styleElementContent_memo removeAllObjects];
    [_procInstr_memo removeAllObjects];
    [_doctype_memo removeAllObjects];
    [_text_memo removeAllObjects];
    [_tag_memo removeAllObjects];
    [_emptyTag_memo removeAllObjects];
    [_startTag_memo removeAllObjects];
    [_endTag_memo removeAllObjects];
    [_tagName_memo removeAllObjects];
    [_attr_memo removeAllObjects];
    [_attrName_memo removeAllObjects];
    [_attrValue_memo removeAllObjects];
    [_eq_memo removeAllObjects];
    [_lt_memo removeAllObjects];
    [_gt_memo removeAllObjects];
    [_fwdSlash_memo removeAllObjects];
    [_comment_memo removeAllObjects];
}

- (void)start {
    PKParser_weakSelfDecl;

    [PKParser_weakSelf start_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)__start {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf execute:^{
    
    PKTokenizer *t = self.tokenizer;

    // whitespace
//    self.silentlyConsumesWhitespace = YES;
//    t.whitespaceState.reportsWhitespaceTokens = YES;
//    self.assembly.preservesWhitespaceTokens = YES;

    // symbols
    [t.symbolState add:@"<!--"];
    [t.symbolState add:@"-->"];
    [t.symbolState add:@"<?"];
    [t.symbolState add:@"?>"];

	// comments	
    [t setTokenizerState:t.commentState from:'<' to:'<'];
    [t.commentState addMultiLineStartMarker:@"<!--" endMarker:@"-->"];
    [t.commentState setFallbackState:t.delimitState from:'<' to:'<'];
	t.commentState.reportsCommentTokens = YES;

	// pi
	[t.delimitState addStartMarker:@"<?" endMarker:@"?>" allowedCharacterSet:nil];
	
	// doctype
	[t.delimitState addStartMarker:@"<!DOCTYPE" endMarker:@">" allowedCharacterSet:nil];
	
    [t.delimitState setFallbackState:t.symbolState from:'<' to:'<'];

    }];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf anything_];}]) {
        [PKParser_weakSelf anything_];
    }

}

- (void)start_ {
    [self parseRule:@selector(__start) withMemo:_start_memo];
}

- (void)__anything {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf scriptElement_];}]) {
        [PKParser_weakSelf scriptElement_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf styleElement_];}]) {
        [PKParser_weakSelf styleElement_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf tag_];}]) {
        [PKParser_weakSelf tag_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf procInstr_];}]) {
        [PKParser_weakSelf procInstr_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf comment_];}]) {
        [PKParser_weakSelf comment_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf doctype_];}]) {
        [PKParser_weakSelf doctype_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf text_];}]) {
        [PKParser_weakSelf text_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'anything'."];
    }

}

- (void)anything_ {
    [self parseRule:@selector(__anything) withMemo:_anything_memo];
}

- (void)__scriptElement {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf scriptStartTag_];
    [PKParser_weakSelf scriptElementContent_];
    [PKParser_weakSelf scriptEndTag_];

}

- (void)scriptElement_ {
    [self parseRule:@selector(__scriptElement) withMemo:_scriptElement_memo];
}

- (void)__scriptStartTag {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf lt_];
    [PKParser_weakSelf scriptTagName_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf attr_];}]) {
        [PKParser_weakSelf attr_];
    }
    [PKParser_weakSelf gt_];

}

- (void)scriptStartTag_ {
    [self parseRule:@selector(__scriptStartTag) withMemo:_scriptStartTag_memo];
}

- (void)__scriptEndTag {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf lt_];
    [PKParser_weakSelf fwdSlash_];
    [PKParser_weakSelf scriptTagName_];
    [PKParser_weakSelf gt_];

}

- (void)scriptEndTag_ {
    [self parseRule:@selector(__scriptEndTag) withMemo:_scriptEndTag_memo];
}

- (void)__scriptTagName {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:HTML_TOKEN_KIND_SCRIPTTAGNAME discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchScriptTagName:)];
}

- (void)scriptTagName_ {
    [self parseRule:@selector(__scriptTagName) withMemo:_scriptTagName_memo];
}

- (void)__scriptElementContent {
    PKParser_weakSelfDecl;
    if (![PKParser_weakSelf speculate:^{ [PKParser_weakSelf scriptEndTag_];}]) {
        [PKParser_weakSelf match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [PKParser_weakSelf raise:@"negation test failed in scriptElementContent"];
    }

}

- (void)scriptElementContent_ {
    [self parseRule:@selector(__scriptElementContent) withMemo:_scriptElementContent_memo];
}

- (void)__styleElement {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf styleStartTag_];
    [PKParser_weakSelf styleElementContent_];
    [PKParser_weakSelf styleEndTag_];

}

- (void)styleElement_ {
    [self parseRule:@selector(__styleElement) withMemo:_styleElement_memo];
}

- (void)__styleStartTag {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf lt_];
    [PKParser_weakSelf styleTagName_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf attr_];}]) {
        [PKParser_weakSelf attr_];
    }
    [PKParser_weakSelf gt_];

}

- (void)styleStartTag_ {
    [self parseRule:@selector(__styleStartTag) withMemo:_styleStartTag_memo];
}

- (void)__styleEndTag {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf lt_];
    [PKParser_weakSelf fwdSlash_];
    [PKParser_weakSelf styleTagName_];
    [PKParser_weakSelf gt_];

}

- (void)styleEndTag_ {
    [self parseRule:@selector(__styleEndTag) withMemo:_styleEndTag_memo];
}

- (void)__styleTagName {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:HTML_TOKEN_KIND_STYLETAGNAME discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchStyleTagName:)];
}

- (void)styleTagName_ {
    [self parseRule:@selector(__styleTagName) withMemo:_styleTagName_memo];
}

- (void)__styleElementContent {
    PKParser_weakSelfDecl;
    if (![PKParser_weakSelf speculate:^{ [PKParser_weakSelf styleEndTag_];}]) {
        [PKParser_weakSelf match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [PKParser_weakSelf raise:@"negation test failed in styleElementContent"];
    }

}

- (void)styleElementContent_ {
    [self parseRule:@selector(__styleElementContent) withMemo:_styleElementContent_memo];
}

- (void)__procInstr {
    PKParser_weakSelfDecl;
    [self match:HTML_TOKEN_KIND_PROCINSTR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchProcInstr:)];
}

- (void)procInstr_ {
    [self parseRule:@selector(__procInstr) withMemo:_procInstr_memo];
}

- (void)__doctype {
    PKParser_weakSelfDecl;
    [self match:HTML_TOKEN_KIND_DOCTYPE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDoctype:)];
}

- (void)doctype_ {
    [self parseRule:@selector(__doctype) withMemo:_doctype_memo];
}

- (void)__text {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchAny:NO];

    [self fireDelegateSelector:@selector(parser:didMatchText:)];
}

- (void)text_ {
    [self parseRule:@selector(__text) withMemo:_text_memo];
}

- (void)__tag {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf emptyTag_];}]) {
        [PKParser_weakSelf emptyTag_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf startTag_];}]) {
        [PKParser_weakSelf startTag_];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf endTag_];}]) {
        [PKParser_weakSelf endTag_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'tag'."];
    }

}

- (void)tag_ {
    [self parseRule:@selector(__tag) withMemo:_tag_memo];
}

- (void)__emptyTag {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf lt_];
    [PKParser_weakSelf tagName_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf attr_];}]) {
        [PKParser_weakSelf attr_];
    }
    [PKParser_weakSelf fwdSlash_];
    [PKParser_weakSelf gt_];

}

- (void)emptyTag_ {
    [self parseRule:@selector(__emptyTag) withMemo:_emptyTag_memo];
}

- (void)__startTag {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf lt_];
    [PKParser_weakSelf tagName_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf attr_];}]) {
        [PKParser_weakSelf attr_];
    }
    [PKParser_weakSelf gt_];

}

- (void)startTag_ {
    [self parseRule:@selector(__startTag) withMemo:_startTag_memo];
}

- (void)__endTag {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf lt_];
    [PKParser_weakSelf fwdSlash_];
    [PKParser_weakSelf tagName_];
    [PKParser_weakSelf gt_];

}

- (void)endTag_ {
    [self parseRule:@selector(__endTag) withMemo:_endTag_memo];
}

- (void)__tagName {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchWord:NO];

    [self fireDelegateSelector:@selector(parser:didMatchTagName:)];
}

- (void)tagName_ {
    [self parseRule:@selector(__tagName) withMemo:_tagName_memo];
}

- (void)__attr {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf attrName_];
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf eq_];if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {[PKParser_weakSelf attrValue_];}}]) {
        [PKParser_weakSelf eq_];
        if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
            [PKParser_weakSelf attrValue_];
        }
    }

}

- (void)attr_ {
    [self parseRule:@selector(__attr) withMemo:_attr_memo];
}

- (void)__attrName {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchWord:NO];

    [self fireDelegateSelector:@selector(parser:didMatchAttrName:)];
}

- (void)attrName_ {
    [self parseRule:@selector(__attrName) withMemo:_attrName_memo];
}

- (void)__attrValue {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf matchWord:NO];
    } else if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [PKParser_weakSelf matchQuotedString:NO];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'attrValue'."];
    }

}

- (void)attrValue_ {
    [self parseRule:@selector(__attrValue) withMemo:_attrValue_memo];
}

- (void)__eq {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:HTML_TOKEN_KIND_EQ discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)eq_ {
    [self parseRule:@selector(__eq) withMemo:_eq_memo];
}

- (void)__lt {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:HTML_TOKEN_KIND_LT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchLt:)];
}

- (void)lt_ {
    [self parseRule:@selector(__lt) withMemo:_lt_memo];
}

- (void)__gt {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:HTML_TOKEN_KIND_GT discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchGt:)];
}

- (void)gt_ {
    [self parseRule:@selector(__gt) withMemo:_gt_memo];
}

- (void)__fwdSlash {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:HTML_TOKEN_KIND_FWDSLASH discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchFwdSlash:)];
}

- (void)fwdSlash_ {
    [self parseRule:@selector(__fwdSlash) withMemo:_fwdSlash_memo];
}

- (void)__comment {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchComment:NO];

    [self fireDelegateSelector:@selector(parser:didMatchComment:)];
}

- (void)comment_ {
    [self parseRule:@selector(__comment) withMemo:_comment_memo];
}

@end