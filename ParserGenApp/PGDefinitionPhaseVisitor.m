// The MIT License (MIT)
// 
// Copyright (c) 2014 Todd Ditchendorf
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PGDefinitionPhaseVisitor.h"
#import "NSString+PEGKitAdditions.h"
#import "PGTokenKindDescriptor.h"
#import <PEGKit/PKToken.h>

@interface PGDefinitionPhaseVisitor ()
@end

@implementation PGDefinitionPhaseVisitor

- (void)dealloc {
    self.tokenKinds = nil;
    self.defaultDefNameTab = nil;
    [super dealloc];
}


- (NSString *)defaultDefNameForStringValue:(NSString *)strVal {
    NSString *defName = _defaultDefNameTab[strVal];

    if (!defName) {
        NSArray *comps = [strVal componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
        if ([[comps lastObject] length]) {
            defName = [comps componentsJoinedByString:@"_"];
            if ([defName length]) {
                _defaultDefNameTab[strVal] = strVal;
            } else {
                defName = nil;
            }
        }
    }

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
            @"!=": @"NOT_EQUAL",
            @"!==": @"DOUBLE_NOT_EQUAL",
            @"<>": @"NOT_EQUALS",
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
            @"<": @"LT_SYM",
            @">": @"GT_SYM",
            @"<=": @"LE_SYM",
            @"=<": @"EL_SYM",
            @">=": @"GE_SYM",
            @"=>": @"HASH_ROCKET",
            @"->": @"RIGHT_ARROW",
            @"<-": @"LEFT_ARROW",
            @">>": @"SHIFT_RIGHT",
            @"<<": @"SHIFT_LEFT",
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


- (void)visitRepetition:(PGRepetitionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    [self recurse:node];
}


- (void)visitNegation:(PGNegationNode *)node {
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
        simplify = PGNodeTypeAlternation == lhs.type && !lhs.actionNode;
        
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
        if ([@"S" isEqualToString:name]) {
            name = @"WHITESPACE";
        }
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
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}

@end
