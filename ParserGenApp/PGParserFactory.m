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

#import "PGParserFactory.h"
#import <PEGKit/PEGKit.h>

#import "PEGKitParser.h"
#import "NSString+PEGKitAdditions.h"
#import "NSArray+PEGKitAdditions.h"

#import "PGBaseNode.h"
#import "PGRootNode.h"
#import "PGDefinitionNode.h"
#import "PGReferenceNode.h"
#import "PGConstantNode.h"
#import "PGLiteralNode.h"
#import "PGDelimitedNode.h"
#import "PGPatternNode.h"
#import "PGCompositeNode.h"
#import "PGCollectionNode.h"
#import "PGAlternationNode.h"
#import "PGOptionalNode.h"
#import "PGMultipleNode.h"
#import "PGActionNode.h"

#import "PGDefinitionPhaseVisitor.h"

@interface PKParser (PGParserFactoryAdditionsFriend)
- (id)parseWithTokenizer:(PKTokenizer *)t error:(NSError **)outError;
@end

@interface PGParserFactory ()
//- (NSDictionary *)symbolTableFromGrammar:(NSString *)g error:(NSError **)outError;

- (PKTokenizer *)tokenizerForParsingGrammar;

- (void)parser:(PKParser *)p didMatchRule:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchCallback:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchSubSeqExpr:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchSubTrackExpr:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchVarProduction:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchAction:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchFactor:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchSemanticPredicate:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchIntersection:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchDifference:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchPattern:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchDiscard:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchLiteral:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchVariable:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchConstant:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchSpecificConstant:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchDelimitedString:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchPhraseStar:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchPhrasePlus:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchPhraseQuestion:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchOrTerm:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchNegatedPrimaryExpr:(PKAssembly *)a;

@property (nonatomic, retain) PEGKitParser *grammarParser;
@property (nonatomic, retain) NSMutableDictionary *directiveTab;

@property (nonatomic, retain) PGRootNode *rootNode;
@property (nonatomic, assign) BOOL wantsCharacters;
@property (nonatomic, retain) PKToken *equals;
@property (nonatomic, retain) PKToken *curly;
@property (nonatomic, retain) PKToken *paren;
@property (nonatomic, retain) PKToken *square;

@property (nonatomic, retain) PKToken *rootToken;
@property (nonatomic, retain) PKToken *defToken;
@property (nonatomic, retain) PKToken *refToken;
@property (nonatomic, retain) PKToken *seqToken;
@property (nonatomic, retain) PKToken *orToken;
@property (nonatomic, retain) PKToken *trackToken;
@property (nonatomic, retain) PKToken *diffToken;
@property (nonatomic, retain) PKToken *intToken;
@property (nonatomic, retain) PKToken *optToken;
@property (nonatomic, retain) PKToken *multiToken;
@property (nonatomic, retain) PKToken *repToken;
@property (nonatomic, retain) PKToken *cardToken;
@property (nonatomic, retain) PKToken *negToken;
@property (nonatomic, retain) PKToken *litToken;
@property (nonatomic, retain) PKToken *delimToken;
@property (nonatomic, retain) PKToken *predicateToken;
@end

@implementation PGParserFactory

+ (PGParserFactory *)factory {
    return [[[PGParserFactory alloc] init] autorelease];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.grammarParser = [[[PEGKitParser alloc] initWithDelegate:self] autorelease];
        
        self.equals     = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"=" doubleValue:0.0];
        self.curly      = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"{" doubleValue:0.0];
        self.paren      = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
        self.square     = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"[" doubleValue:0.0];

        self.rootToken  = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"ROOT" doubleValue:0.0];
        self.defToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"$" doubleValue:0.0];
        self.refToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"#" doubleValue:0.0];
        self.seqToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"." doubleValue:0.0];
        self.orToken    = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"|" doubleValue:0.0];
        self.trackToken = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"[" doubleValue:0.0];
        self.diffToken  = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"-" doubleValue:0.0];
        self.intToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"&" doubleValue:0.0];
        self.optToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"?" doubleValue:0.0];
        self.multiToken = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"+" doubleValue:0.0];
        self.repToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"*" doubleValue:0.0];
        self.cardToken  = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"{" doubleValue:0.0];
        self.negToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"~" doubleValue:0.0];
        self.litToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"'" doubleValue:0.0];
        self.delimToken = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"%{" doubleValue:0.0];
        self.predicateToken = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"}?" doubleValue:0.0];
        
        self.delegatePostMatchCallbacksOn = PGParserFactoryDelegateCallbacksOnAll;
    }
    return self;
}


- (void)dealloc {
    self.grammarParser = nil;
    self.directiveTab = nil;
    self.rootNode = nil;
    self.equals = nil;
    self.curly = nil;
    self.paren = nil;
    self.square = nil;
    self.rootToken = nil;
    self.defToken = nil;
    self.refToken = nil;
    self.seqToken = nil;
    self.orToken = nil;
    self.diffToken = nil;
    self.intToken = nil;
    self.optToken = nil;
    self.multiToken = nil;
    self.repToken = nil;
    self.cardToken = nil;
    self.negToken = nil;
    self.litToken = nil;
    self.delimToken = nil;
    self.predicateToken = nil;
    [super dealloc];
}


- (PKAST *)ASTFromGrammar:(NSString *)g error:(NSError **)outError {
    NSMutableDictionary *symTab = [NSMutableDictionary dictionary];
    return [self ASTFromGrammar:g symbolTable:symTab error:outError];
}


- (PKAST *)ASTFromGrammar:(NSString *)g symbolTable:(NSMutableDictionary *)symTab error:(NSError **)outError {
    self.directiveTab = [NSMutableDictionary dictionary];
    self.rootNode = [PGRootNode nodeWithToken:_rootToken];
    
    PKTokenizer *t = [self tokenizerForParsingGrammar];
    t.string = g;

    [_grammarParser parseWithTokenizer:t error:outError];
//    _grammarParser.parser.tokenizer = t;
//    [_grammarParser.parser parse:g error:outError];
        
    PGDefinitionPhaseVisitor *defv = [[[PGDefinitionPhaseVisitor alloc] init] autorelease];
    defv.symbolTable = symTab;
    defv.delegatePostMatchCallbacksOn = self.delegatePostMatchCallbacksOn;
    defv.collectTokenKinds = self.collectTokenKinds;
    [_rootNode visit:defv];

    _rootNode.startMethodName = symTab[@"$$"];
    NSAssert(_rootNode.startMethodName, @"");
    
    return _rootNode;
}


#pragma mark -
#pragma mark Private

- (PKTokenizer *)tokenizerForParsingGrammar {
    PKTokenizer *t = [PKTokenizer tokenizer];
    
    [t.symbolState add:@"%{"];

    // add support for tokenizer directives like @commentState.fallbackState
    [t.wordState setWordChars:YES from:'.' to:'.'];
    [t.wordState setWordChars:NO from:'-' to:'-'];
    
    // setup comments
    [t setTokenizerState:t.commentState from:'/' to:'/'];
    [t.commentState addSingleLineStartMarker:@"//"];
    [t.commentState addMultiLineStartMarker:@"/*" endMarker:@"*/"];
    
//    // comment state should fallback to delimit state to match regex delimited strings
//    t.commentState.fallbackState = t.delimitState;
//    
//    // regex delimited strings
//    NSCharacterSet *cs = [[NSCharacterSet newlineCharacterSet] invertedSet];
//    [t.delimitState addStartMarker:@"/" endMarker:@"/" allowedCharacterSet:cs];
//    [t.delimitState addStartMarker:@"/" endMarker:@"/i" allowedCharacterSet:cs];

    // action and predicate delimited strings
    t.delimitState.allowsNestedMarkers = YES;
    [t setTokenizerState:t.delimitState from:'{' to:'{'];
    [t.delimitState addStartMarker:@"{" endMarker:@"}" allowedCharacterSet:nil];
    [t.delimitState addStartMarker:@"{" endMarker:@"}?" allowedCharacterSet:nil];
    [t.delimitState setFallbackState:t.symbolState from:'{' to:'{'];

    return t;
}


- (void)parser:(PKParser *)p didMatchVarProduction:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);

    PKToken *tok = [a pop];
    NSAssert(tok, @"");
    NSAssert([tok isKindOfClass:[PKToken class]], @"");
    NSAssert(tok.isWord, @"");
    
    NSAssert([tok.stringValue length], @"");
    //NSAssert(islower([tok.stringValue characterAtIndex:0]), @"");

    PGDefinitionNode *node = [PGDefinitionNode nodeWithToken:tok];
    [a push:node];
}


- (void)parser:(PKParser *)p didMatchRule:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    NSArray *nodes = [a objectsAbove:_equals];
    NSAssert([nodes count], @"");

    [a pop]; // '='
    
    PGDefinitionNode *defNode = [a pop];
    NSAssert([defNode isKindOfClass:[PGDefinitionNode class]], @"");
        
    PGBaseNode *node = nil;
    
    if (1 == [nodes count]) {
        node = [nodes lastObject];
    } else {
        PGCollectionNode *seqNode = [PGCollectionNode nodeWithToken:_seqToken];
        for (PGBaseNode *child in [nodes reverseObjectEnumerator]) {
            NSAssert([child isKindOfClass:[PGBaseNode class]], @"");
            [seqNode addChild:child];
        }
        node = seqNode;
    }
    
    [defNode addChild:node];

    [_rootNode addChild:defNode];
}


- (void)parser:(PKParser *)p didMatchSubTrackExpr:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    NSArray *nodes = [a objectsAbove:_square];
    NSAssert([nodes count], @"");
    [a pop]; // pop '['
    
    PGCollectionNode *trackNode = [PGCollectionNode nodeWithToken:_trackToken];

    if ([nodes count] > 1) {
        for (PGBaseNode *child in [nodes reverseObjectEnumerator]) {
            NSAssert([child isKindOfClass:[PGBaseNode class]], @"");
            [trackNode addChild:child];
        }
    } else if ([nodes count]) {
        PGBaseNode *node = [nodes lastObject];
        if (_seqToken == node.token) {
            PGCollectionNode *seqNode = (PGCollectionNode *)node;
            NSAssert([seqNode isKindOfClass:[PGCollectionNode class]], @"");

            for (PGBaseNode *child in seqNode.children) {
                [trackNode addChild:child];
            }
        } else {
            [trackNode addChild:node];
        }
        
    }
    [a push:trackNode];
}


- (void)parser:(PKParser *)p didMatchSubSeqExpr:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    NSArray *nodes = [a objectsAbove:_paren];
    NSAssert([nodes count], @"");
    [a pop]; // pop '('
    
    PGBaseNode *node = nil;
    
    if (1 == [nodes count]) {
        node = [nodes lastObject];
    } else {
        PGCollectionNode *seqNode = [PGCollectionNode nodeWithToken:_seqToken];
        for (PGBaseNode *child in [nodes reverseObjectEnumerator]) {
            NSAssert([child isKindOfClass:[PGBaseNode class]], @"");
            [seqNode addChild:child];
        }
        node = seqNode;
    }
    
    [a push:node];
}


- (void)parser:(PKParser *)p didMatchCallback:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    PKToken *selNameTok2 = [a pop];
    PKToken *selNameTok1 = [a pop];
    NSString *selName = [NSString stringWithFormat:@"%@:%@:", selNameTok1.stringValue, selNameTok2.stringValue];
    
    PGDefinitionNode *defNode = [a pop];
    NSAssert([defNode isKindOfClass:[PGDefinitionNode class]] ,@"");
    
    defNode.callbackName = selName;
    [a push:defNode];
}


- (void)parser:(PKParser *)p didMatchPattern:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    PKToken *tok = [a pop]; // opts (as Number*) or %{'/', '/'}
    NSAssert([tok isMemberOfClass:[PKToken class]], @"");
    NSAssert(tok.isDelimitedString, @"");
    
    NSString *s = tok.stringValue;
    NSAssert([s length] > 2, @"");
    
    NSAssert([s hasPrefix:@"/"], @"");
    //NSAssert([s hasSuffix:@"/"], @"");
    
    NSString *optStr = nil;
    
    NSUInteger len = [s length];
    NSRange r = [s rangeOfString:@"/" options:NSBackwardsSearch];
    NSAssert(r.length, @"");
    NSAssert(len > 2, @"");
    
    if (r.location < len - 1) {
        NSUInteger loc = r.location + 1;
        r = NSMakeRange(loc, len - loc);
        optStr = [s substringWithRange:r];
        s = [s substringWithRange:NSMakeRange(0, loc)];
    }
    s = [s stringByTrimmingQuotes];

    PGPatternNode *patNode = [PGPatternNode nodeWithToken:tok];
    patNode.string = s;

    [a push:patNode];
}


- (void)parser:(PKParser *)p didMatchDiscard:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);

    PGBaseNode *node = [a pop];
    NSAssert([node isKindOfClass:[PGBaseNode class]], @"");
    node.discard = YES;
    [a push:node];
}


- (void)parser:(PKParser *)p didMatchLiteral:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    PKToken *tok = [a pop];

    PGLiteralNode *litNode = nil;
    
    NSAssert(tok.isQuotedString, @"");
    NSAssert([tok.stringValue length], @"");
    litNode = [PGLiteralNode nodeWithToken:tok];
    litNode.wantsCharacters = _wantsCharacters;

    [a push:litNode];
}


- (void)parser:(PKParser *)p didMatchVariable:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    // parser:didMatchVariable: [start, =, foo]start/=/foo^;/foo/=/Word/;

    PKToken *tok = [a pop];
    NSAssert(tok, @"");
    NSAssert([tok isKindOfClass:[PKToken class]], @"");
    NSAssert(tok.isWord, @"");
    
    NSAssert([tok.stringValue length], @"");
    BOOL isLower = islower([tok.stringValue characterAtIndex:0]);
    if (!isLower) {
        [NSException raise:@"" format:@"Unknown builtin rule '%@' on line %lu", tok.stringValue, tok.lineNumber];
    }
    NSAssert(isLower, @"");

    PGReferenceNode *node = [PGReferenceNode nodeWithToken:tok];
    [a push:node];
}


- (void)parser:(PKParser *)p didMatchConstant:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    PKToken *tok = [a pop];
    
    PGConstantNode *node = [PGConstantNode nodeWithToken:tok];
    [a push:node];
}


- (void)parser:(PKParser *)p didMatchSpecificConstant:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    PKToken *quoteTok = [a pop];
    NSString *literal = [quoteTok.stringValue stringByTrimmingQuotes];
    
    PKToken *classTok = [a pop]; // pop 'Symbol'
    
    PGConstantNode *constNode = [PGConstantNode nodeWithToken:classTok];
    constNode.literal = literal;
    
    [a push:constNode];
}


- (void)parser:(PKParser *)p didMatchDelimitedString:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    NSArray *toks = [a objectsAbove:_delimToken];
    [a pop]; // discard '%{' fence
    
    NSAssert([toks count] > 0 && [toks count] < 3, @"");
    NSString *start = [[[toks lastObject] stringValue] stringByTrimmingQuotes];
    NSString *end = nil;
    if ([toks count] > 1) {
        end = [[[toks objectAtIndex:0] stringValue] stringByTrimmingQuotes];
    }

    PGDelimitedNode *delimNode = [PGDelimitedNode nodeWithToken:_delimToken];
    delimNode.startMarker = start;
    delimNode.endMarker = end;
    
    [a push:delimNode];
}


- (void)parser:(PKParser *)p didMatchDifference:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    PGBaseNode *minusNode = [a pop];
    PGBaseNode *subNode = [a pop];
    NSAssert([minusNode isKindOfClass:[PGBaseNode class]], @"");
    NSAssert([subNode isKindOfClass:[PGBaseNode class]], @"");
    
    PGCompositeNode *diffNode = [PGCompositeNode nodeWithToken:_diffToken];
    [diffNode addChild:subNode];
    [diffNode addChild:minusNode];
    
    [a push:diffNode];
}


- (void)parser:(PKParser *)p didMatchAction:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    PKToken *sourceTok = [a pop];
    NSAssert(sourceTok.isDelimitedString, @"");
    
    id obj = [a pop];
    PGBaseNode *ownerNode = nil;
    
    NSString *key = nil;
    
    // find owner node (different for pre and post actions)
    if ([obj isEqual:_equals]) {
        // pre action
        key = @"actionNode";
        
        PKToken *eqTok = (PKToken *)obj;
        NSAssert([eqTok isKindOfClass:[PKToken class]], @"");
        ownerNode = [a pop];
        
        [a push:ownerNode];
        [a push:eqTok]; // put '=' back
    } else if ([obj isKindOfClass:[PGBaseNode class]]) {
        // post action
        key = @"actionNode";

        ownerNode = (PGBaseNode *)obj;
        NSAssert([ownerNode isKindOfClass:[PGBaseNode class]], @"");
        
        [a push:ownerNode];
    } else if ([obj isKindOfClass:[PKToken class]]) {
        // before codeBlock. obj is 'before' or 'after'. discard.
        PKToken *tok = (PKToken *)obj;
        key = tok.stringValue;
        ownerNode = [a pop];
        
        if (ownerNode) {
            [a push:ownerNode];
        }
    }
    
    NSUInteger len = [sourceTok.stringValue length];
    NSAssert(len > 1, @"");
    
    NSString *source = nil;
    if (2 == len) {
        source = @"";
    } else {
        source = [sourceTok.stringValue substringWithRange:NSMakeRange(1, len - 2)];
    }
    
    PGActionNode *actNode = [PGActionNode nodeWithToken:_curly];
    actNode.source = source;
    
    if (ownerNode) {
        [ownerNode setValue:actNode forKey:key];
    } else {
        NSAssert(_rootNode.grammarActions, @"");
        NSAssert([key length], @"");
        _rootNode.grammarActions[key] = actNode;
    }
}


- (void)parser:(PKParser *)p didMatchFactor:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    id possibleNode = [a pop];
    if ([possibleNode isKindOfClass:[PGBaseNode class]]) {
        PGBaseNode *node = (PGBaseNode *)possibleNode;
        
        id possiblePred = [a pop];
        if ([possiblePred isKindOfClass:[PGActionNode class]]) {
            PGActionNode *predNode = (PGActionNode *)possiblePred;
            //NSLog(@"%@", predNode.source);
            node.semanticPredicateNode = predNode;
        } else {
            [a push:possiblePred];
        }
    }
    [a push:possibleNode];
}


- (void)parser:(PKParser *)p didMatchSemanticPredicate:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    PKToken *sourceTok = [a pop];
    NSAssert(sourceTok.isDelimitedString, @"");
    
    NSUInteger len = [sourceTok.stringValue length];
    NSAssert(len > 2, @"");
    
    NSString *source = nil;
    if (3 == len) {
        source = @"";
    } else {
        source = [sourceTok.stringValue substringWithRange:NSMakeRange(1, len - 3)];
    }
    
    PGActionNode *predNode = [PGActionNode nodeWithToken:_predicateToken];
    predNode.source = source;
    
    [a push:predNode];
}


- (void)parser:(PKParser *)p didMatchIntersection:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    PGBaseNode *predicateNode = [a pop];
    PGBaseNode *subNode = [a pop];
    NSAssert([predicateNode isKindOfClass:[PGBaseNode class]], @"");
    NSAssert([subNode isKindOfClass:[PGBaseNode class]], @"");
    
    PGCollectionNode *interNode = [PGCollectionNode nodeWithToken:_intToken];
    [interNode addChild:subNode];
    [interNode addChild:predicateNode];
    
    [a push:interNode];
}


- (void)parser:(PKParser *)p didMatchPhraseStar:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    PGBaseNode *subNode = [a pop];
    NSAssert([subNode isKindOfClass:[PGBaseNode class]], @"");
    
    PGCompositeNode *repNode = [PGRepetitionNode nodeWithToken:_repToken];
    [repNode addChild:subNode];
    
    [a push:repNode];
}


- (void)parser:(PKParser *)p didMatchPhrasePlus:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    PGBaseNode *subNode = [a pop];
    NSAssert([subNode isKindOfClass:[PGBaseNode class]], @"");
    
    PGMultipleNode *multiNode = [PGMultipleNode nodeWithToken:_multiToken];
    [multiNode addChild:subNode];
    
    [a push:multiNode];
}


- (void)parser:(PKParser *)p didMatchPhraseQuestion:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    PGBaseNode *subNode = [a pop];
    NSAssert([subNode isKindOfClass:[PGBaseNode class]], @"");
    
    PGOptionalNode *optNode = [PGOptionalNode nodeWithToken:_optToken];
    [optNode addChild:subNode];
    
    [a push:optNode];
}


- (void)parser:(PKParser *)p didMatchNegatedPrimaryExpr:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);

    PGBaseNode *subNode = [a pop];
    NSAssert([subNode isKindOfClass:[PGBaseNode class]], @"");
    
    PGCompositeNode *negNode = [PGNegationNode nodeWithToken:_negToken];
    [negNode addChild:subNode];
    
    [a push:negNode];
}


- (NSMutableArray *)objectsAbove:(PKToken *)tokA or:(PKToken *)tokB in:(PKAssembly *)a {
    NSMutableArray *result = [NSMutableArray array];
    
    while (![a isStackEmpty]) {
        id obj = [a pop];
        if ([obj isEqual:tokA] || [obj isEqual:tokB]) {
            [a push:obj];
            break;
        }
        [result addObject:obj];
    }
    
    return result;
}


- (void)parser:(PKParser *)p didMatchOrTerm:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);

    NSMutableArray *rhsNodes = [[[a objectsAbove:_orToken] mutableCopy] autorelease];
    
    PKToken *orTok = [a pop]; // pop '|'
    NSAssert([orTok isKindOfClass:[PKToken class]], @"");
    NSAssert(orTok.isSymbol, @"");
    NSAssert([orTok.stringValue isEqualToString:@"|"], @"");

    PGAlternationNode *orNode = [PGAlternationNode nodeWithToken:orTok];
    
    PGBaseNode *left = nil;

    NSMutableArray *lhsNodes = [self objectsAbove:_paren or:_equals in:a];
    if (1 == [lhsNodes count]) {
        left = [lhsNodes lastObject];
    } else {
        PGCollectionNode *seqNode = [PGCollectionNode nodeWithToken:_seqToken];
        for (PGBaseNode *child in [lhsNodes reverseObjectEnumerator]) {
            NSAssert([child isKindOfClass:[PGBaseNode class]], @"");
            [seqNode addChild:child];
        }
        left = seqNode;
    }
    [orNode addChild:left];

    PGBaseNode *right = nil;

    if (1 == [rhsNodes count]) {
        right = [rhsNodes lastObject];
    } else {
        PGCollectionNode *seqNode = [PGCollectionNode nodeWithToken:_seqToken];
        for (PGBaseNode *child in [rhsNodes reverseObjectEnumerator]) {
            NSAssert([child isKindOfClass:[PGBaseNode class]], @"");
            [seqNode addChild:child];
        }
        right = seqNode;
    }
    [orNode addChild:right];

    [a push:orNode];
}

@end
