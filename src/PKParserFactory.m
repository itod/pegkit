//
//  PKParserFactory.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 12/12/08.
//  Copyright 2009 Todd Ditchendorf All rights reserved.
//

#import "PKParserFactory.h"
#import "PKAssembly.h"

#import "PKTokenizer.h"
#import "PKWordState.h"
#import "PKNumberState.h"
#import "PKQuoteState.h"
#import "PKSymbolState.h"
#import "PKWhitespaceState.h"
#import "PKDelimitState.h"
#import "PKCommentState.h"

#import "ParseKitParser.h"
#import "NSString+ParseKitAdditions.h"
#import "NSArray+ParseKitAdditions.h"

#import "PKBaseNode.h"
#import "PKRootNode.h"
#import "PKDefinitionNode.h"
#import "PKReferenceNode.h"
#import "PKConstantNode.h"
#import "PKLiteralNode.h"
#import "PKDelimitedNode.h"
#import "PKPatternNode.h"
#import "PKCompositeNode.h"
#import "PKCollectionNode.h"
#import "PKAlternationNode.h"
#import "PKOptionalNode.h"
#import "PKMultipleNode.h"
#import "PKActionNode.h"

#import "PKDefinitionPhaseVisitor.h"
#import "PKResolutionPhaseVisitor.h"

@interface PEGParser (PKParserFactoryAdditionsFriend)
- (id)parseWithTokenizer:(PKTokenizer *)t assembler:(id)a error:(NSError **)outError;
@end

@interface PKParserFactory ()
- (NSDictionary *)symbolTableFromGrammar:(NSString *)g error:(NSError **)outError;

- (PKTokenizer *)tokenizerForParsingGrammar;

- (void)parser:(PKParser *)p didMatchTokenizerDirective:(PKAssembly *)a;
- (void)parser:(PKParser *)p didMatchDecl:(PKAssembly *)a;
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

//@property (nonatomic, retain) PKGrammarParser *grammarParser;
@property (nonatomic, retain) ParseKitParser *grammarParser;
@property (nonatomic, assign) id assembler;
@property (nonatomic, assign) id preassembler;

@property (nonatomic, retain) NSMutableDictionary *directiveTab;

@property (nonatomic, retain) PKRootNode *rootNode;
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

@implementation PKParserFactory

+ (PKParserFactory *)factory {
    return [[[PKParserFactory alloc] init] autorelease];
}


- (id)init {
    self = [super init];
    if (self) {
//        self.grammarParser = [[[PKGrammarParser alloc] initWithAssembler:self] autorelease];
        self.grammarParser = [[[ParseKitParser alloc] init] autorelease];
        
        self.equals     = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"=" floatValue:0.0];
        self.curly      = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"{" floatValue:0.0];
        self.paren      = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" floatValue:0.0];
        self.square     = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"[" floatValue:0.0];

        self.rootToken  = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"ROOT" floatValue:0.0];
        self.defToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"$" floatValue:0.0];
        self.refToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"#" floatValue:0.0];
        self.seqToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"." floatValue:0.0];
        self.orToken    = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"|" floatValue:0.0];
        self.trackToken = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"[" floatValue:0.0];
        self.diffToken  = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"-" floatValue:0.0];
        self.intToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"&" floatValue:0.0];
        self.optToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"?" floatValue:0.0];
        self.multiToken = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"+" floatValue:0.0];
        self.repToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"*" floatValue:0.0];
        self.cardToken  = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"{" floatValue:0.0];
        self.negToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"~" floatValue:0.0];
        self.litToken   = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"'" floatValue:0.0];
        self.delimToken = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"%{" floatValue:0.0];
        self.predicateToken = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"}?" floatValue:0.0];
        
        self.assemblerSettingBehavior = PKParserFactoryAssemblerSettingBehaviorAll;
    }
    return self;
}


- (void)dealloc {
    self.grammarParser = nil;
    self.assembler = nil;
    self.preassembler = nil;
    
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


- (NSDictionary *)symbolTableFromGrammar:(NSString *)g error:(NSError **)outError {
    NSMutableDictionary *symTab = [NSMutableDictionary dictionary];
    [self ASTFromGrammar:g symbolTable:symTab error:outError];

    //NSLog(@"rootNode %@", rootNode);

    PKResolutionPhaseVisitor *resv = [[[PKResolutionPhaseVisitor alloc] init] autorelease];
    resv.symbolTable = symTab;
    [rootNode visit:resv];

    return [[symTab copy] autorelease];
}


- (PKAST *)ASTFromGrammar:(NSString *)g error:(NSError **)outError {
    NSMutableDictionary *symTab = [NSMutableDictionary dictionary];
    return [self ASTFromGrammar:g symbolTable:symTab error:outError];
}


- (PKAST *)ASTFromGrammar:(NSString *)g symbolTable:(NSMutableDictionary *)symTab error:(NSError **)outError {
    self.directiveTab = [NSMutableDictionary dictionary];
    self.rootNode = [PKRootNode nodeWithToken:rootToken];
    
    PKTokenizer *t = [self tokenizerForParsingGrammar];
    t.string = g;

    [grammarParser parseWithTokenizer:t assembler:self error:outError];
//    grammarParser.parser.tokenizer = t;
//    [grammarParser.parser parse:g error:outError];
        
    PKDefinitionPhaseVisitor *defv = [[[PKDefinitionPhaseVisitor alloc] init] autorelease];
    defv.symbolTable = symTab;
    defv.assembler = self.assembler;
    defv.preassembler = self.preassembler;
    defv.assemblerSettingBehavior = self.assemblerSettingBehavior;
    defv.collectTokenKinds = self.collectTokenKinds;
    [rootNode visit:defv];

    rootNode.startMethodName = symTab[@"$$"];
    NSAssert(rootNode.startMethodName, @"");
    
    return rootNode;
}


#pragma mark -
#pragma mark Private

- (PKTokenizer *)tokenizerForParsingGrammar {
    PKTokenizer *t = [PKTokenizer tokenizer];
    
    [t.symbolState add:@"%{"];
    [t.symbolState add:@"/i"];
    [t.symbolState add:@"}?"];

    // add support for tokenizer directives like @commentState.fallbackState
    [t.wordState setWordChars:YES from:'.' to:'.'];
    [t.wordState setWordChars:NO from:'-' to:'-'];
    
    // setup comments
    [t setTokenizerState:t.commentState from:'/' to:'/'];
    [t.commentState addSingleLineStartMarker:@"//"];
    [t.commentState addMultiLineStartMarker:@"/*" endMarker:@"*/"];
    
    // comment state should fallback to delimit state to match regex delimited strings
    t.commentState.fallbackState = t.delimitState;
    
    // regex delimited strings
    NSCharacterSet *cs = [[NSCharacterSet newlineCharacterSet] invertedSet];
    [t.delimitState addStartMarker:@"/" endMarker:@"/" allowedCharacterSet:cs];
    [t.delimitState addStartMarker:@"/" endMarker:@"/i" allowedCharacterSet:cs];

    // action and predicate delimited strings
    [t setTokenizerState:t.delimitState from:'{' to:'{'];
    [t.delimitState addStartMarker:@"{" endMarker:@"}" allowedCharacterSet:nil];
    [t.delimitState addStartMarker:@"{" endMarker:@"}?" allowedCharacterSet:nil];
    [t.delimitState setFallbackState:t.symbolState from:'{' to:'{'];

    return t;
}


- (void)parser:(PKParser *)p didMatchTokenizerDirective:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    NSArray *argToks = [[a objectsAbove:equals] reversedArray];
    [a pop]; // discard '='
    
    PKToken *nameTok = [a pop];
    NSAssert(nameTok, @"");
    NSAssert([nameTok isKindOfClass:[PKToken class]], @"");
    NSAssert(nameTok.isWord, @"");
    
    NSString *prodName = [NSString stringWithFormat:@"@%@", nameTok.stringValue];
    NSMutableArray *allToks = directiveTab[prodName];
    if (!allToks) {
        allToks = [NSMutableArray arrayWithCapacity:[argToks count]];
    }
    [allToks addObjectsFromArray:argToks];
    directiveTab[prodName] = allToks;
}


- (void)parser:(PKParser *)p didMatchVarProduction:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);

    PKToken *tok = [a pop];
    NSAssert(tok, @"");
    NSAssert([tok isKindOfClass:[PKToken class]], @"");
    NSAssert(tok.isWord, @"");
    
    NSAssert([tok.stringValue length], @"");
    //NSAssert(islower([tok.stringValue characterAtIndex:0]), @"");

    PKDefinitionNode *node = [PKDefinitionNode nodeWithToken:tok];
    [a push:node];
}


- (void)parser:(PKParser *)p didMatchDecl:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    NSArray *nodes = [a objectsAbove:equals];
    NSAssert([nodes count], @"");

    [a pop]; // '='
    
    PKDefinitionNode *defNode = [a pop];
    NSAssert([defNode isKindOfClass:[PKDefinitionNode class]], @"");
        
    PKBaseNode *node = nil;
    
    if (1 == [nodes count]) {
        node = [nodes lastObject];
    } else {
        PKCollectionNode *seqNode = [PKCollectionNode nodeWithToken:seqToken];
        for (PKBaseNode *child in [nodes reverseObjectEnumerator]) {
            NSAssert([child isKindOfClass:[PKBaseNode class]], @"");
            [seqNode addChild:child];
        }
        node = seqNode;
    }
    
    [defNode addChild:node];

    [self.rootNode addChild:defNode];
}


- (void)parser:(PKParser *)p didMatchSubTrackExpr:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    NSArray *nodes = [a objectsAbove:square];
    NSAssert([nodes count], @"");
    [a pop]; // pop '['
    
    PKCollectionNode *trackNode = [PKCollectionNode nodeWithToken:trackToken];

    if ([nodes count] > 1) {
        for (PKBaseNode *child in [nodes reverseObjectEnumerator]) {
            NSAssert([child isKindOfClass:[PKBaseNode class]], @"");
            [trackNode addChild:child];
        }
    } else if ([nodes count]) {
        PKBaseNode *node = [nodes lastObject];
        if (seqToken == node.token) {
            PKCollectionNode *seqNode = (PKCollectionNode *)node;
            NSAssert([seqNode isKindOfClass:[PKCollectionNode class]], @"");

            for (PKBaseNode *child in seqNode.children) {
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
    
    NSArray *nodes = [a objectsAbove:paren];
    NSAssert([nodes count], @"");
    [a pop]; // pop '('
    
    PKBaseNode *node = nil;
    
    if (1 == [nodes count]) {
        node = [nodes lastObject];
    } else {
        PKCollectionNode *seqNode = [PKCollectionNode nodeWithToken:seqToken];
        for (PKBaseNode *child in [nodes reverseObjectEnumerator]) {
            NSAssert([child isKindOfClass:[PKBaseNode class]], @"");
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
    
    PKDefinitionNode *defNode = [a pop];
    NSAssert([defNode isKindOfClass:[PKDefinitionNode class]] ,@"");
    
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
    
    PKPatternOptions opts = PKPatternOptionsNone;
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
        
        if (NSNotFound != [optStr rangeOfString:@"i"].location) {
            opts |= PKPatternOptionsIgnoreCase;
        }
        if (NSNotFound != [optStr rangeOfString:@"m"].location) {
            opts |= PKPatternOptionsMultiline;
        }
        if (NSNotFound != [optStr rangeOfString:@"x"].location) {
            opts |= PKPatternOptionsComments;
        }
        if (NSNotFound != [optStr rangeOfString:@"s"].location) {
            opts |= PKPatternOptionsDotAll;
        }
        if (NSNotFound != [optStr rangeOfString:@"w"].location) {
            opts |= PKPatternOptionsUnicodeWordBoundaries;
        }
    }
    s = [s stringByTrimmingQuotes];

    PKPatternNode *patNode = [PKPatternNode nodeWithToken:tok];
    patNode.string = s;
    patNode.options = opts;

    [a push:patNode];
}


- (void)parser:(PKParser *)p didMatchDiscard:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);

    PKBaseNode *node = [a pop];
    NSAssert([node isKindOfClass:[PKBaseNode class]], @"");
    node.discard = YES;
    [a push:node];
}


- (void)parser:(PKParser *)p didMatchLiteral:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    PKToken *tok = [a pop];

    PKLiteralNode *litNode = nil;
    
    NSAssert(tok.isQuotedString, @"");
    NSAssert([tok.stringValue length], @"");
    litNode = [PKLiteralNode nodeWithToken:tok];
    litNode.wantsCharacters = self.wantsCharacters;

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
    NSAssert(islower([tok.stringValue characterAtIndex:0]), @"");

    PKReferenceNode *node = [PKReferenceNode nodeWithToken:tok];
    [a push:node];
}


- (void)parser:(PKParser *)p didMatchConstant:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    PKToken *tok = [a pop];
    
    PKConstantNode *node = [PKConstantNode nodeWithToken:tok];
    [a push:node];
}


- (void)parser:(PKParser *)p didMatchSpecificConstant:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    PKToken *quoteTok = [a pop];
    NSString *literal = [quoteTok.stringValue stringByTrimmingQuotes];
    
    PKToken *classTok = [a pop]; // pop 'Symbol'
    
    PKConstantNode *constNode = [PKConstantNode nodeWithToken:classTok];
    constNode.literal = literal;
    
    [a push:constNode];
}


- (void)parser:(PKParser *)p didMatchDelimitedString:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    NSArray *toks = [a objectsAbove:delimToken];
    [a pop]; // discard '%{' fence
    
    NSAssert([toks count] > 0 && [toks count] < 3, @"");
    NSString *start = [[[toks lastObject] stringValue] stringByTrimmingQuotes];
    NSString *end = nil;
    if ([toks count] > 1) {
        end = [[[toks objectAtIndex:0] stringValue] stringByTrimmingQuotes];
    }

    PKDelimitedNode *delimNode = [PKDelimitedNode nodeWithToken:delimToken];
    delimNode.startMarker = start;
    delimNode.endMarker = end;
    
    [a push:delimNode];
}


- (void)parser:(PKParser *)p didMatchDifference:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    PKBaseNode *minusNode = [a pop];
    PKBaseNode *subNode = [a pop];
    NSAssert([minusNode isKindOfClass:[PKBaseNode class]], @"");
    NSAssert([subNode isKindOfClass:[PKBaseNode class]], @"");
    
    PKCompositeNode *diffNode = [PKCompositeNode nodeWithToken:diffToken];
    [diffNode addChild:subNode];
    [diffNode addChild:minusNode];
    
    [a push:diffNode];
}


- (void)parser:(PKParser *)p didMatchAction:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    PKToken *sourceTok = [a pop];
    NSAssert(sourceTok.isDelimitedString, @"");
    
    id obj = [a pop];
    PKBaseNode *ownerNode = nil;
    
    NSString *key = nil;
    
    // find owner node (different for pre and post actions)
    if ([obj isEqual:equals]) {
        // pre action
        key = @"actionNode";
        
        PKToken *eqTok = (PKToken *)obj;
        NSAssert([eqTok isKindOfClass:[PKToken class]], @"");
        ownerNode = [a pop];
        
        [a push:ownerNode];
        [a push:eqTok]; // put '=' back
    } else if ([obj isKindOfClass:[PKBaseNode class]]) {
        // post action
        key = @"actionNode";

        ownerNode = (PKBaseNode *)obj;
        NSAssert([ownerNode isKindOfClass:[PKBaseNode class]], @"");
        
        [a push:ownerNode];
    } else if ([obj isKindOfClass:[PKToken class]]) {
        // before codeBlock. obj is 'before' or 'after'. discard.
        PKToken *tok = (PKToken *)obj;
        key = tok.stringValue;
        NSAssert([key isEqual:@"before"] || [key isEqual:@"after"], @"");
        ownerNode = [a pop];

        [a push:ownerNode];
    }
    
    NSUInteger len = [sourceTok.stringValue length];
    NSAssert(len > 1, @"");
    
    NSString *source = nil;
    if (2 == len) {
        source = @"";
    } else {
        source = [sourceTok.stringValue substringWithRange:NSMakeRange(1, len - 2)];
    }
    
    PKActionNode *actNode = [PKActionNode nodeWithToken:curly];
    actNode.source = source;
    [ownerNode setValue:actNode forKey:key];
}


- (void)parser:(PKParser *)p didMatchFactor:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    id possibleNode = [a pop];
    if ([possibleNode isKindOfClass:[PKBaseNode class]]) {
        PKBaseNode *node = (PKBaseNode *)possibleNode;
        
        id possiblePred = [a pop];
        if ([possiblePred isKindOfClass:[PKActionNode class]]) {
            PKActionNode *predNode = (PKActionNode *)possiblePred;
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
    
    PKActionNode *predNode = [PKActionNode nodeWithToken:predicateToken];
    predNode.source = source;
    
    [a push:predNode];
}


- (void)parser:(PKParser *)p didMatchIntersection:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    PKBaseNode *predicateNode = [a pop];
    PKBaseNode *subNode = [a pop];
    NSAssert([predicateNode isKindOfClass:[PKBaseNode class]], @"");
    NSAssert([subNode isKindOfClass:[PKBaseNode class]], @"");
    
    PKCollectionNode *interNode = [PKCollectionNode nodeWithToken:intToken];
    [interNode addChild:subNode];
    [interNode addChild:predicateNode];
    
    [a push:interNode];
}


- (void)parser:(PKParser *)p didMatchPhraseStar:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    PKBaseNode *subNode = [a pop];
    NSAssert([subNode isKindOfClass:[PKBaseNode class]], @"");
    
    PKCompositeNode *repNode = [PKCompositeNode nodeWithToken:repToken];
    [repNode addChild:subNode];
    
    [a push:repNode];
}


- (void)parser:(PKParser *)p didMatchPhrasePlus:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    PKBaseNode *subNode = [a pop];
    NSAssert([subNode isKindOfClass:[PKBaseNode class]], @"");
    
    PKMultipleNode *multiNode = [PKMultipleNode nodeWithToken:multiToken];
    [multiNode addChild:subNode];
    
    [a push:multiNode];
}


- (void)parser:(PKParser *)p didMatchPhraseQuestion:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);
    
    PKBaseNode *subNode = [a pop];
    NSAssert([subNode isKindOfClass:[PKBaseNode class]], @"");
    
    PKOptionalNode *optNode = [PKOptionalNode nodeWithToken:optToken];
    [optNode addChild:subNode];
    
    [a push:optNode];
}


- (void)parser:(PKParser *)p didMatchNegatedPrimaryExpr:(PKAssembly *)a {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), a);

    PKBaseNode *subNode = [a pop];
    NSAssert([subNode isKindOfClass:[PKBaseNode class]], @"");
    
    PKCompositeNode *negNode = [PKCompositeNode nodeWithToken:negToken];
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

    NSMutableArray *rhsNodes = [[[a objectsAbove:orToken] mutableCopy] autorelease];
    
    PKToken *orTok = [a pop]; // pop '|'
    NSAssert([orTok isKindOfClass:[PKToken class]], @"");
    NSAssert(orTok.isSymbol, @"");
    NSAssert([orTok.stringValue isEqualToString:@"|"], @"");

    PKAlternationNode *orNode = [PKAlternationNode nodeWithToken:orTok];
    
    PKBaseNode *left = nil;

    NSMutableArray *lhsNodes = [self objectsAbove:paren or:equals in:a];
    if (1 == [lhsNodes count]) {
        left = [lhsNodes lastObject];
    } else {
        PKCollectionNode *seqNode = [PKCollectionNode nodeWithToken:seqToken];
        for (PKBaseNode *child in [lhsNodes reverseObjectEnumerator]) {
            NSAssert([child isKindOfClass:[PKBaseNode class]], @"");
            [seqNode addChild:child];
        }
        left = seqNode;
    }
    [orNode addChild:left];

    PKBaseNode *right = nil;

    if (1 == [rhsNodes count]) {
        right = [rhsNodes lastObject];
    } else {
        PKCollectionNode *seqNode = [PKCollectionNode nodeWithToken:seqToken];
        for (PKBaseNode *child in [rhsNodes reverseObjectEnumerator]) {
            NSAssert([child isKindOfClass:[PKBaseNode class]], @"");
            [seqNode addChild:child];
        }
        right = seqNode;
    }
    [orNode addChild:right];

    [a push:orNode];
}

@synthesize grammarParser;
@synthesize assembler;
@synthesize preassembler;

@synthesize directiveTab;
@synthesize rootNode;
@synthesize wantsCharacters;
@synthesize equals;
@synthesize curly;
@synthesize paren;
@synthesize square;

@synthesize rootToken;
@synthesize defToken;
@synthesize refToken;
@synthesize seqToken;
@synthesize orToken;
@synthesize trackToken;
@synthesize diffToken;
@synthesize intToken;
@synthesize optToken;
@synthesize multiToken;
@synthesize repToken;
@synthesize cardToken;
@synthesize negToken;
@synthesize litToken;
@synthesize delimToken;
@synthesize predicateToken;

@synthesize assemblerSettingBehavior;
@end
