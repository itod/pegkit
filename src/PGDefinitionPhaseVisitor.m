//
//  PKDefinitionPhaseVisitor.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/4/12.
//
//

#import "PGDefinitionPhaseVisitor.h"
#import "NSString+PEGKitAdditions.h"
#import "PGTokenKindDescriptor.h"
#import <PEGKit/PKToken.h>

@interface PGDefinitionPhaseVisitor ()
@end

@implementation PGDefinitionPhaseVisitor

- (void)dealloc {
    self.assembler = nil;
    self.preassembler = nil;
    self.tokenKinds = nil;
    self.defaultDefNameTab = nil;
    [super dealloc];
}


- (NSString *)defaultDefNameForStringValue:(NSString *)strVal {
    NSString *defName = _defaultDefNameTab[strVal];
    // not sure if we want this
    if (!defName) {
        NSArray *comps = [strVal componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
        defName = [comps componentsJoinedByString:@"_"];
        if ([defName length]) {
            _defaultDefNameTab[strVal] = strVal;
        } else {
            defName = nil;
        }
    }
    // end
    if (!defName) {
        defName = [@(_fallbackDefNameCounter++) stringValue];
        _defaultDefNameTab[strVal] = defName;
    }
    return defName;
}


- (void)visitRoot:(PGRootNode *)node {
    NSParameterAssert(node);
    NSAssert(self.symbolTable, @"");
    
    if (_collectTokenKinds) {
        [PGTokenKindDescriptor clearCache];
        self.tokenKinds = [NSMutableDictionary dictionary];
        self.fallbackDefNameCounter = 1;
        self.defaultDefNameTab = [[@{
            @"~": @"TILDE",
            @"`": @"BACKTICK",
            @"!": @"BANG",
            @"@": @"AT",
            @"#": @"POUND",
            @"$": @"DOLLAR",
            @"%": @"PERCENT",
            @"^": @"CARET",
            @"^=": @"XOR_EQUALS",
            @"&": @"AMPERSAND",
            @"&=": @"AND_EQUALS",
            @"&&": @"DOUBLE_AMPERSAND",
            @"*": @"STAR",
            @"*=": @"TIMES_EQUALS",
            @"(": @"OPEN_PAREN",
            @")": @"CLOSE_PAREN",
            @"-": @"MINUS",
            @"--": @"MINUS_MINUS",
            @"-=": @"MINUS_EQUALS",
            @"_": @"UNDERSCORE",
            @"+": @"PLUS",
            @"++": @"PLUS_PLUS",
            @"+=": @"PLUS_EQUALS",
            @"=": @"EQUALS",
            @"==": @"DOUBLE_EQUALS",
            @"===": @"TRIPLE_EQUALS",
            @":=": @"ASSIGN",
            @"!=": @"NE",
            @"!==": @"DOUBLE_NE",
            @"<>": @"NOT_EQUAL",
            @"{": @"OPEN_CURLY",
            @"}": @"CLOSE_CURLY",
            @"[": @"OPEN_BRACKET",
            @"]": @"CLOSE_BRACKET",
            @"|": @"PIPE",
            @"|=": @"OR_EQUALS",
            @"||": @"DOUBLE_PIPE",
            @"\\": @"BACK_SLASH",
            @"\\=": @"DIV_EQUALS",
            @"/": @"FORWARD_SLASH",
            @"//": @"DOUBLE_SLASH",
            @":": @"COLON",
            @"::": @"DOUBLE_COLON",
            @";": @"SEMI_COLON",
            @"\"": @"QUOTE",
            @"'": @"APOSTROPHE",
            @"<": @"LT",
            @">": @"GT",
            @"<=": @"LE",
            @"=<": @"EL",
            @">=": @"GE",
            @"=>": @"HASH_ROCKET",
            @"->": @"RIGHT_ARROW",
            @"<-": @"LEFT_ARROW",
            @",": @"COMMA",
            @".": @"DOT",
            @"..": @"DOT_DOT",
            @"?": @"QUESTION",
            @"true": @"TRUE",
            @"false": @"FALSE",
            @"TRUE": @"TRUE_UPPER",
            @"FALSE": @"FALSE_UPPER",
            @"yes": @"YES",
            @"no": @"NO",
            @"YES": @"YES_UPPER",
            @"NO": @"NO_UPPER",
            @"or": @"OR",
            @"and": @"AND",
            @"not": @"NOT",
            @"xor": @"XOR",
            @"OR": @"OR_UPPER",
            @"AND": @"AND_UPPER",
            @"NOT": @"NOT_UPPER",
            @"XOR": @"XOR_UPPER",
            @"NULL": @"NULL_UPPER",
            @"null": @"NULL",
            @"Nil": @"NIL_TITLE",
            @"nil": @"NIL",
            @"id": @"ID",
            @"new": @"NEW",
            @"delete": @"DELETE",
            @"undefined": @"UNDEFINED",
            @"var": @"VAR",
            @"function": @"FUNCTION",
            @"instanceof": @"INSTANCEOF",
            @"typeof": @"TYPEOF",
            @"def": @"DEF",
            @"if": @"IF",
            @"else": @"ELSE",
            @"elif": @"ELIF",
            @"elseif": @"ELSEIF",
            @"return": @"RETURN",
            @"case": @"CASE",
            @"break": @"BREAK",
            @"switch": @"SWITCH",
            @"default": @"DEFAULT",
            @"while": @"WHILE",
            @"do": @"DO",
            @"for": @"FOR",
            @"in": @"IN",
            @"static": @"STATIC",
            @"extern": @"EXTERN",
            @"inline": @"INLINE",
            @"auto": @"AUTO",
            @"struct": @"STRUCT",
            @"class": @"CLASS",
            @"extends": @"EXTENDS",
            @"self": @"SELF",
            @"super": @"SUPER",
            @"this": @"THIS",
            @"void": @"VOID",
            @"int": @"INT",
            @"unsigned": @"UNSIGNED",
            @"long": @"LONG",
            @"short": @"SHORT",
            @"BOOL": @"BOOL_UPPER",
            @"bool": @"BOOL",
            @"float": @"FLOAT",
            @"double": @"DOUBLE",
            @"goto": @"GOTO",
            @"try": @"TRY",
            @"catch": @"CATCH",
            @"finally": @"FINALLY",
            @"throw": @"THROW",
            @"throws": @"THROWS",
            @"assert": @"ASSERT",
            @"start": @"START",
            
            @"EOF" : @"EOF_TITLE",
            @"Word" : @"WORD_TITLE",
            @"LowercaseWord" : @"UPPERCASEWORD_TITLE",
            @"UppercaseWord" : @"LOWERCASEWORD_TITLE",
            @"Number" : @"NUMBER_TITLE",
            @"QuotedString" : @"QUOTEDSTRING_TITLE",
            @"Symbol" : @"SYMBOL_TITLE",
            @"Comment" : @"COMMENT_TITLE",
            @"Empty" : @"EMPTY_TITLE",
            @"Any" : @"ANY_TITLE",
            @"S" : @"S_TITLE",
            @"URL" : @"URL_TITLE",
            @"Email" : @"EMAIL_TITLE",
            @"Digit" : @"DIGIT_TITLE",
            @"Letter" : @"LETTER_TITLE",
            @"Char" : @"CHAR_TITLE",
            @"SpecificChar": @"SPECIFICCHAR_TITLE",
        } mutableCopy] autorelease];
    }
    
    [self recurse:node];

    if (_collectTokenKinds) {
        node.tokenKinds = [[[_tokenKinds allValues] mutableCopy] autorelease];
        self.tokenKinds = nil;
    }

    self.symbolTable = nil;
}


- (void)visitDefinition:(PGDefinitionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);

    // find only child node (which represents this parser's type)
    NSAssert(1 == [node.children count], @"");
    
    // set name
    NSString *name = node.token.stringValue;

    // define in symbol table
    if (![self.symbolTable count]) {
        self.symbolTable[@"$$"] = name;
    }

    for (PGBaseNode *child in node.children) {
        if (_collectTokenKinds) {
            child.defName = name;
        }
        [child visit:self];
    }
}


- (void)visitReference:(PGReferenceNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);

}


- (void)visitComposite:(PGCompositeNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    [self recurse:node];
}


- (void)visitCollection:(PGCollectionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    [self recurse:node];
}


- (void)visitAlternation:(PGAlternationNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);

    NSAssert(2 == [node.children count], @"");
    
    BOOL simplify = NO;
    
    do {
        PGBaseNode *lhs = node.children[0];
        simplify = PGNodeTypeAlternation == lhs.type;
        
        // nested Alts should always be on the lhs. never on rhs.
        NSAssert(PGNodeTypeAlternation != [(PGBaseNode *)node.children[1] type], @"");
        
        if (simplify) {
            [node replaceChild:lhs withChildren:lhs.children];
        }
    } while (simplify);

    [self recurse:node];
}


- (void)visitOptional:(PGOptionalNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);

    [self recurse:node];
}


- (void)visitMultiple:(PGMultipleNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);

    [self recurse:node];
}


- (void)visitConstant:(PGConstantNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);

    if (_collectTokenKinds) {
        NSAssert(_tokenKinds, @"");
        
        NSString *name = node.token.stringValue;
        name = [NSString stringWithFormat:@"TOKEN_KIND_BUILTIN_%@", [name uppercaseString]];
        NSAssert([name length], @"");

        PGTokenKindDescriptor *kind = [PGTokenKindDescriptor descriptorWithStringValue:name name:name]; // yes, use name for both
        
        //_tokenKinds[name] = kind; do not add constants here.
        node.tokenKind = kind;
    }

}


- (void)visitLiteral:(PGLiteralNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
 
    if (_collectTokenKinds) {
        NSAssert(_tokenKinds, @"");
        
        NSString *strVal = [node.token.stringValue stringByTrimmingQuotes];

        NSString *name = nil;
        
        PGTokenKindDescriptor *desc = _tokenKinds[strVal];
        if (desc) {
            name = desc.name;
        }
        if (!name) {
            NSString *defName = node.defName;
            if (!defName) {
                defName = [self defaultDefNameForStringValue:strVal];
            }
            name = [NSString stringWithFormat:@"TOKEN_KIND_%@", [defName uppercaseString]];
        }
        
        NSAssert([name length], @"");
        PGTokenKindDescriptor *kind = [PGTokenKindDescriptor descriptorWithStringValue:strVal name:name];
        
        _tokenKinds[strVal] = kind;
        node.tokenKind = kind;
    }
}


- (void)visitDelimited:(PGDelimitedNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    if (_collectTokenKinds) {
        NSAssert(_tokenKinds, @"");
        
        NSString *strVal = [NSString stringWithFormat:@"%@,%@", node.startMarker, node.endMarker];
        
        NSString *name = nil;
        
        PGTokenKindDescriptor *desc = _tokenKinds[strVal];
        if (desc) {
            name = desc.name;
        }
        if (!name) {
            NSString *defName = node.defName;
            if (!defName) {
                defName = [self defaultDefNameForStringValue:strVal];
            }
            name = [NSString stringWithFormat:@"TOKEN_KIND_%@", [defName uppercaseString]];
        }
        
        NSAssert([name length], @"");
        PGTokenKindDescriptor *kind = [PGTokenKindDescriptor descriptorWithStringValue:strVal name:name];
        
        _tokenKinds[strVal] = kind;
        node.tokenKind = kind;
    }
}


- (void)visitPattern:(PGPatternNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitAction:(PGActionNode *)node {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


//#pragma mark -
//#pragma mark Assemblers
//
//- (void)setAssemblerForParser:(PKCompositeParser *)p callbackName:(NSString *)callbackName {
//    NSString *parserName = p.name;
//    NSString *selName = callbackName;
//    
//    BOOL setOnAll = (_assemblerSettingBehavior == PGParserFactoryAssemblerSettingBehaviorAll);
//    
//    if (setOnAll) {
//        // continue
//    } else {
//        BOOL setOnExplicit = (_assemblerSettingBehavior == PGParserFactoryAssemblerSettingBehaviorExplicit);
//        if (setOnExplicit && selName) {
//            // continue
//        } else {
//            BOOL isTerminal = [p isKindOfClass:[PKTerminal class]];
//            if (!isTerminal && !setOnExplicit) return;
//            
//            BOOL setOnTerminals = (_assemblerSettingBehavior == PGParserFactoryAssemblerSettingBehaviorTerminals);
//            if (setOnTerminals && isTerminal) {
//                // continue
//            } else {
//                return;
//            }
//        }
//    }
//    
//    if (!selName) {
//        selName = [self defaultAssemblerSelectorNameForParserName:parserName];
//    }
//    
//    if (selName) {
//        SEL sel = NSSelectorFromString(selName);
//        if (_assembler && [_assembler respondsToSelector:sel]) {
//            [p setAssembler:_assembler selector:sel];
//        }
//        if (_preassembler && [_preassembler respondsToSelector:sel]) {
//            NSString *selName = [self defaultPreassemblerSelectorNameForParserName:parserName];
//            [p setPreassembler:_preassembler selector:NSSelectorFromString(selName)];
//        }
//    }
//}
//
//
//- (NSString *)defaultAssemblerSelectorNameForParserName:(NSString *)parserName {
//    return [self defaultAssemblerSelectorNameForParserName:parserName pre:NO];
//}
//
//
//- (NSString *)defaultPreassemblerSelectorNameForParserName:(NSString *)parserName {
//    return [self defaultAssemblerSelectorNameForParserName:parserName pre:YES];
//}
//
//
//- (NSString *)defaultAssemblerSelectorNameForParserName:(NSString *)parserName pre:(BOOL)isPre {
//    NSString *prefix = nil;
//    if ([parserName hasPrefix:@"@"]) {
//        return nil;
//    } else {
//        prefix = isPre ? @"parser:willMatch" :  @"parser:didMatch";
//    }
//    return [NSString stringWithFormat:@"%@%C%@:", prefix, (unichar)toupper([parserName characterAtIndex:0]), [parserName substringFromIndex:1]];
//}

@end
