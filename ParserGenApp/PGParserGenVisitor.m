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

#import "PGParserGenVisitor.h"
#import <PEGKit/PKToken.h>

#import <PEGKit/PKParser.h>
#import "PGTokenKindDescriptor.h"
#import "NSString+PEGKitAdditions.h"

#import <TDTemplateEngine/TDTemplateEngine.h>

#define CLASS_NAME @"className"
#define MANUAL_MEMORY @"manualMemory"
#define TOKEN_KINDS_START_INDEX @"startIndex"
#define TOKEN_KINDS @"tokenKinds"
#define HAS_TOKEN_KINDS @"hasTokenKinds"
#define RULE_METHOD_NAMES @"ruleMethodNames"
#define ENABLE_MEMOIZATION @"enableMemoization"
#define ENABLE_ERROR_RECOVERY @"enableAutomaticErrorRecovery"
#define PARSE_TREE @"parseTree"
#define H_ACTION @"hAction"
#define IFACE_ACTION @"interfaceAction"
#define M_ACTION @"mAction"
#define EXT_ACTION @"extensionAction"
#define IVARS_ACTION @"ivarsAction"
#define IMPL_ACTION @"implementationAction"
#define INIT_ACTION @"initAction"
#define DEALLOC_ACTION @"deallocAction"
#define BEFORE_ACTION @"beforeAction"
#define AFTER_ACTION @"afterAction"
#define START_METHOD_NAME @"startMethodName"
#define START_METHOD_BODY @"startMethodBody"
#define METHODS @"methods"
#define METHOD_NAME @"methodName"
#define METHOD_BODY @"methodBody"
#define PRE_CALLBACK @"preCallback"
#define POST_CALLBACK @"postCallback"
#define TOKEN_KIND @"tokenKind"
#define CHILD_NAME @"childName"
#define DEPTH @"depth"
#define LAST @"last"
#define LOOKAHEAD_SET @"lookaheadSet"
#define OPT_BODY @"optBody"
#define DISCARD @"discard"
#define NEEDS_BACKTRACK @"needsBacktrack"
#define IS_NEGATION @"isNegation"
#define CHILD_STRING @"childString"
#define TERMINAL_CALL_STRING @"terminalCallString"
#define IF_TEST @"ifTest"
#define ACTION_BODY @"actionBody"
#define PREDICATE_BODY @"predicateBody"
#define PREDICATE @"predicate"
#define PREFIX @"prefix"
#define SUFFIX @"suffix"
#define PATTERN @"pattern"

@interface PGParserGenVisitor ()
- (void)push:(NSMutableString *)mstr;
- (NSMutableString *)pop;
- (NSArray *)sortedLookaheadSetForNode:(PGBaseNode *)node;
- (NSArray *)sortedArrayFromLookaheadSet:(NSSet *)set;
- (NSSet *)lookaheadSetForNode:(PGBaseNode *)node;

@property (nonatomic, retain) NSOutputStream *outputStream;
@property (nonatomic, retain) NSMutableArray *outputStringStack;
@property (nonatomic, retain) NSString *currentDefName;
@end

@implementation PGParserGenVisitor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.enableHybridDFA = YES;
        self.enableMemoization = YES;
        self.delegatePreMatchCallbacksOn = PGParserFactoryDelegateCallbacksOnNone;
        self.delegatePostMatchCallbacksOn = PGParserFactoryDelegateCallbacksOnAll;
        
        [self setUpTemplateEngine];
    }
    return self;
}


- (void)dealloc {
    self.engine = nil;
    self.interfaceOutputString = nil;
    self.implementationOutputString = nil;
    self.ruleMethodNames = nil;
    self.startMethodName = nil;
    self.outputStream = nil;
    self.outputStringStack = nil;
    self.currentDefName = nil;
    [super dealloc];
}


- (NSString *)templateStringNamed:(NSString *)filename {
    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"txt"];
    NSString *template = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    NSAssert([template length], @"");
    if (!template) {
        if (err) NSLog(@"%@", err);
    }
    return template;
}


- (void)setUpTemplateEngine {
    self.engine = [TDTemplateEngine templateEngine];
}


- (NSString *)processTemplate:(NSString *)tempStr withVariables:(NSDictionary *)vars {
    NSOutputStream *output = [NSOutputStream outputStreamToMemory];

    NSError *err = nil;
    [_engine processTemplateString:tempStr withVariables:vars toStream:output error:&err];
    
    NSString *result = [[[NSString alloc] initWithData:[output propertyForKey:NSStreamDataWrittenToMemoryStreamKey] encoding:NSUTF8StringEncoding] autorelease];
    
    NSAssert([result length], @"");
    return result;
}


- (void)push:(NSMutableString *)mstr {
    NSParameterAssert([mstr isKindOfClass:[NSMutableString class]]);
    
    [_outputStringStack addObject:mstr];
}


- (NSMutableString *)pop {
    NSAssert([_outputStringStack count], @"");
    NSMutableString *mstr = [[[_outputStringStack lastObject] retain] autorelease];
    [_outputStringStack removeLastObject];

    NSAssert([mstr isKindOfClass:[NSMutableString class]], @"");
    return mstr;
}


- (NSArray *)sortedLookaheadSetForNode:(PGBaseNode *)node {
    return [self sortedArrayFromLookaheadSet:[self lookaheadSetForNode:node]];
}


- (NSArray *)sortedArrayFromLookaheadSet:(NSSet *)set {
    NSArray *result = [[set allObjects] sortedArrayUsingComparator:^NSComparisonResult(PGTokenKindDescriptor *desc1, PGTokenKindDescriptor *desc2) {
        return [desc1.name compare:desc2.name];
    }];
    
    return result;
}


- (NSSet *)lookaheadSetForNode:(PGBaseNode *)node {
    NSParameterAssert(node);
    NSAssert(self.symbolTable, @"");

    NSMutableSet *set = [NSMutableSet set];
    
    switch (node.type) {
        case PGNodeTypeConstant: {
            PGConstantNode *constNode = (PGConstantNode *)node;
            if (constNode.token.tokenKind != TOKEN_KIND_BUILTIN_EMPTY) {
                [set addObject:constNode.tokenKind];
            }
        } break;
        case PGNodeTypeLiteral: {
            PGLiteralNode *litNode = (PGLiteralNode *)node;
            [set addObject:litNode.tokenKind];
        } break;
        case PGNodeTypeDelimited: {
            PGDelimitedNode *delimNode = (PGDelimitedNode *)node;
            [set addObject:delimNode.tokenKind];
        } break;
        case PGNodeTypeReference: {
            NSString *name = node.token.stringValue;
            PGDefinitionNode *defNode = self.symbolTable[name];
            //NSAssert1(defNode, @"Grammar is missing rule named: `%@`", name);
            if (!defNode) {
                [NSException raise:@"PKParseException" format:@"Unknown rule name: `%@` in rule: `%@`", name, _currentDefName];
            }
            [set unionSet:[self lookaheadSetForNode:defNode]];
        } break;
        case PGNodeTypeAlternation: {
            for (PGBaseNode *child in node.children) {
                [set unionSet:[self lookaheadSetForNode:child]];
            }
        } break;
        case PGNodeTypeNegation: {
            for (PGBaseNode *child in node.children) {
                [set unionSet:[self lookaheadSetForNode:child]];
                break; // single look ahead. to implement full LL(*), this would need to be enhanced here.
            }
        } break;
//        case PGNodeTypeDefinition:
//        case PGNodeTypeCollection: {
//            for (PKBaseNode *child in node.children) {
//                NSSet *childSet = [self lookaheadSetForNode:child];
//                [set unionSet:childSet];
//                PKBaseNode *concreteChild = [self concreteNodeForNode:child];
//                if ([concreteChild isKindOfClass:[PKOptionalNode class]]) {
//                    continue;
//                } else {
//                    break; // single look ahead. to implement full LL(*), this would need to be enhanced here.
//                }
//            }
//        } break;
        default: {
            for (PGBaseNode *child in node.children) {
                [set unionSet:[self lookaheadSetForNode:child]];
                break; // single look ahead. to implement full LL(*), this would need to be enhanced here.
            }
        } break;
    }
    
    return set;
}


- (void)setUpSymbolTableFromRoot:(PGRootNode *)node {
    
    NSUInteger c = [node.children count];
    
    NSMutableDictionary *symTab = [NSMutableDictionary dictionaryWithCapacity:c];
    
    for (PGBaseNode *child in node.children) {
        NSString *key = child.token.stringValue;
        symTab[key] = child;
    }
    
    self.symbolTable = symTab;
}


#pragma mark -
#pragma mark PKVisitor

- (void)visitRoot:(PGRootNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    NSParameterAssert(node);
    NSAssert(node.startMethodName, @"");
    //NSAssert(_enableHybridDFA ,@"");
    
    // setup symbol table
    [self setUpSymbolTableFromRoot:node];
    
    // setup stack
    self.outputStringStack = [NSMutableArray array];
    
    self.ruleMethodNames = [NSMutableArray array];
    self.startMethodName = node.startMethodName;
    
    // add namespace to token kinds
    for (PGTokenKindDescriptor *desc in node.tokenKinds) {
        NSString *newName = [NSString stringWithFormat:@"%@_%@", [node.grammarName uppercaseString], desc.name];
        desc.name = newName;
    }
    
    // setup vars
    id vars = [NSMutableDictionary dictionary];
    vars[MANUAL_MEMORY] = @(!_enableARC);
    vars[TOKEN_KINDS_START_INDEX] = @(TOKEN_KIND_BUILTIN_ANY + 1);
    vars[TOKEN_KINDS] = node.tokenKinds;
    vars[HAS_TOKEN_KINDS] = @([node.tokenKinds count]);
    NSString *className = node.grammarName;
    if (![className hasSuffix:@"Parser"]) {
        className = [NSString stringWithFormat:@"%@Parser", className];
    }
    vars[CLASS_NAME] = className;
    vars[H_ACTION] = [self grammarActionStringFrom:node.grammarActions[@"h"]];
    vars[IFACE_ACTION] = [self grammarActionStringFrom:node.grammarActions[@"interface"]];

    // do interface (header)
    NSString *intTemplate = [self templateStringNamed:@"PGClassInterfaceTemplate"];
    self.interfaceOutputString = [self processTemplate:intTemplate withVariables:vars];
    
    // do impl (.m)
    // setup child str buffer
    NSMutableString *childStr = [NSMutableString string];
    
    // recurse
    for (PGBaseNode *child in node.children) {
        [child visit:self];
        
        // pop
        [childStr appendString:[self pop]];
    }
    
    // start method
    NSString *startTemplate = [self templateStringNamed:@"PGMethodCallTemplate"];
    NSInteger depth = _depth + (_enableAutomaticErrorRecovery ? 1 : 0);
    NSMutableString *startMethodBodyStr = [NSMutableString stringWithString:[self processTemplate:startTemplate withVariables:@{DEPTH: @(depth), METHOD_NAME: _startMethodName}]];

    id eofVars = @{DEPTH: @(depth)};
    NSString *eofCallStr = [self processTemplate:[self templateStringNamed:@"PGEOFCallTemplate"] withVariables:eofVars];
    [startMethodBodyStr appendString:eofCallStr];
    
    if (_enableAutomaticErrorRecovery) {
        id recoverVars = @{DEPTH: @(_depth), CHILD_STRING: startMethodBodyStr};
        NSString *recoverStr = [self processTemplate:[self templateStringNamed:@"PGTryAndRecoverEOFTemplate"] withVariables:recoverVars];
        [startMethodBodyStr setString:recoverStr];
    }
    
    // merge
    vars[START_METHOD_NAME] = _startMethodName;
    vars[START_METHOD_BODY] = startMethodBodyStr;
    vars[METHODS] = childStr;
    vars[RULE_METHOD_NAMES] = self.ruleMethodNames;
    vars[ENABLE_MEMOIZATION] = @(self.enableMemoization);
    vars[ENABLE_ERROR_RECOVERY] = @(self.enableAutomaticErrorRecovery);
    vars[PARSE_TREE] = @((_delegatePreMatchCallbacksOn == PGParserFactoryDelegateCallbacksOnSyntax || _delegatePostMatchCallbacksOn == PGParserFactoryDelegateCallbacksOnSyntax));

    vars[M_ACTION] = [self grammarActionStringFrom:node.grammarActions[@"m"]];
    vars[EXT_ACTION] = [self grammarActionStringFrom:node.grammarActions[@"extension"]];
    vars[IVARS_ACTION] = [self grammarActionStringFrom:node.grammarActions[@"ivars"]];
    vars[IMPL_ACTION] = [self grammarActionStringFrom:node.grammarActions[@"implementation"]];
    vars[INIT_ACTION] = [self grammarActionStringFrom:node.grammarActions[@"init"]];
    vars[DEALLOC_ACTION] = [self grammarActionStringFrom:node.grammarActions[@"dealloc"]];
    vars[BEFORE_ACTION] = [self actionStringFrom:node.grammarActions[@"before"]];
    vars[AFTER_ACTION] = [self actionStringFrom:node.grammarActions[@"after"]];
    
    NSString *implTemplate = [self templateStringNamed:@"PGClassImplementationTemplate"];
    self.implementationOutputString = [self processTemplate:implTemplate withVariables:vars];

    //NSLog(@"%@", _interfaceOutputString);
    //NSLog(@"%@", _implementationOutputString);
}


- (NSString *)grammarActionStringFrom:(PGActionNode *)actNode {
    if (!actNode) return @"";
    
    id vars = @{ACTION_BODY: actNode.source, DEPTH: @(_depth)};
    NSString *result = [self processTemplate:[self templateStringNamed:@"PGGrammarActionTemplate"] withVariables:vars];
    
    return result;
}


- (NSString *)actionStringFrom:(PGActionNode *)actNode {
    if (!actNode || self.isSpeculating) return @"";
    
    id vars = @{ACTION_BODY: actNode.source, DEPTH: @(_depth)};
    NSString *result = [self processTemplate:[self templateStringNamed:@"PGActionTemplate"] withVariables:vars];
    
    return result;
}


- (NSString *)callbackStringForNode:(PGBaseNode *)node methodName:(NSString *)methodName isPre:(BOOL)isPre {
    // determine if we should include delegate callback call
    BOOL fireCallback = NO;
    BOOL isTerminal = 1 == [node.children count] && [[self concreteNodeForNode:node.children[0]] isTerminal];
    NSString *templateName = isPre ? @"PGPreCallbackTemplate" : @"PGPostCallbackTemplate";
    
    BOOL flag = isPre ? _delegatePreMatchCallbacksOn : _delegatePostMatchCallbacksOn;

    switch (flag) {
        case PGParserFactoryDelegateCallbacksOnNone:
            fireCallback = NO;
            break;
        case PGParserFactoryDelegateCallbacksOnAll:
            fireCallback = YES;
            break;
        case PGParserFactoryDelegateCallbacksOnTerminals: {
            fireCallback = isTerminal;
        } break;
        case PGParserFactoryDelegateCallbacksOnSyntax: {
            fireCallback = YES;
            if (isTerminal) {
                templateName = isPre ? @"PGPreCallbackSyntaxLeafTemplate" : @"PGPostCallbackSyntaxLeafTemplate";
            } else {
                templateName = isPre ? @"PGPreCallbackSyntaxInteriorTemplate" : @"PGPostCallbackSyntaxInteriorTemplate";
            }
        } break;
        default:
            NSAssert1(0, @"unsupported delegate callback setting behavior %lu", isPre ? _delegatePreMatchCallbacksOn : _delegatePostMatchCallbacksOn);
            break;
    }
    
    NSString *result = @"";
    
    if (fireCallback) {
        id vars = @{METHOD_NAME: methodName};
        result = [self processTemplate:[self templateStringNamed:templateName] withVariables:vars];
    }

    return result;
}


- (void)visitDefinition:(PGDefinitionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    self.depth = 1; // 1 for the try/catch wrapper

    // setup vars
    id vars = [NSMutableDictionary dictionary];
    NSString *methodName = node.token.stringValue;
    [self.ruleMethodNames addObject:methodName];

    vars[METHOD_NAME] = methodName;
    self.currentDefName = methodName;

    // setup child str buffer
    NSMutableString *childStr = [NSMutableString string];
    
    [childStr appendString:[self actionStringFrom:node.actionNode]];
    
    // recurse
    for (PGBaseNode *child in node.children) {
        [child visit:self];

        // pop
        [childStr appendString:[self pop]];
    }
    
    if (node.before) {
        [childStr insertString:[self actionStringFrom:node.before] atIndex:0];
    }
    
    if (node.after) {
        [childStr appendString:[self actionStringFrom:node.after]];
    }
    
    // merge
    vars[METHOD_BODY] = childStr;
    
    NSString *preCallbackStr = @"";
    NSString *postCallbackStr = @"";

    preCallbackStr = [self callbackStringForNode:node methodName:methodName isPre:YES];
    postCallbackStr = [self callbackStringForNode:node methodName:methodName isPre:NO];

    vars[PRE_CALLBACK] = preCallbackStr;
    vars[POST_CALLBACK] = postCallbackStr;

    NSString *templateName = nil;
    if (self.enableMemoization) {
        templateName = @"PGMethodMemoizationTemplate";
    } else {
        templateName = @"PGMethodTemplate";
    }

    NSString *template = [self templateStringNamed:templateName];
    NSMutableString *output = [NSMutableString stringWithString:[self processTemplate:template withVariables:vars]];
    
    // push
    [self push:output];
}


- (void)visitReference:(PGReferenceNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
        
    // stup vars
    id vars = [NSMutableDictionary dictionary];
    NSString *methodName = node.token.stringValue;
    vars[METHOD_NAME] = methodName;
    vars[DEPTH] = @(_depth);
    vars[DISCARD] = @(node.discard);

    // merge
    NSMutableString *output = [NSMutableString string];
    [output appendString:[self semanticPredicateForNode:node throws:YES]];
    
    NSString *template = [self templateStringNamed:@"PGMethodCallTemplate"];
    [output appendString:[self processTemplate:template withVariables:vars]];
    
    [output appendString:[self actionStringFrom:node.actionNode]];

    // push
    [self push:output];
}


- (void)visitNegation:(PGCompositeNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    // recurse
    NSAssert(1 == [node.children count], @"");
    PGBaseNode *child = node.children[0];
    
    NSArray *set = [self sortedLookaheadSetForNode:child];
    
    self.depth++;
    [child visit:self];
    self.depth--;
    
    // pop
    NSMutableString *childStr = [self pop];
    
    // setup vars
    id vars = [NSMutableDictionary dictionary];
    vars[DEPTH] = @(_depth);
    vars[METHOD_NAME] = self.currentDefName;
    vars[LOOKAHEAD_SET] = set;
    vars[LAST] = @([set count] - 1);
    vars[IF_TEST] = [self removeTabsAndNewLines:childStr];
    
    // TODO Predicates???
    
    NSMutableString *output = [NSMutableString string];
    [output appendString:[self semanticPredicateForNode:node throws:YES]];

    NSString *templateName = nil;
    if (_enableHybridDFA && [self isLL1:child]) { // ????
        templateName = @"PGNegationPredictTemplate";
    } else {
        templateName = @"PGNegationSpeculateTemplate";
    }
    
    [output appendString:[self processTemplate:[self templateStringNamed:templateName] withVariables:vars]];
    
    // action
    [output appendString:[self actionStringFrom:node.actionNode]];
    
    // push
    [self push:output];
}


// TODO make mutable
- (NSMutableString *)removeTabsAndNewLines:(NSMutableString *)inStr {
    [inStr replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [inStr length])];
    [inStr replaceOccurrencesOfString:@"    " withString:@"" options:0 range:NSMakeRange(0, [inStr length])];
    return inStr;
}


- (void)visitRepetition:(PGRepetitionNode *)node {
    // setup vars
    id vars = [NSMutableDictionary dictionary];
    vars[DEPTH] = @(_depth);
    
    NSAssert(1 == [node.children count], @"");
    PGBaseNode *child = node.children[0];
    
    NSArray *set = [self sortedLookaheadSetForNode:child];

    // setup template
    vars[LOOKAHEAD_SET] = set;
    vars[LAST] = @([set count] - 1);

    // Only need to speculate if this repetition's child is non-terminal
    BOOL isLL1 = (_enableHybridDFA && [self isLL1:child]);
    
    // recurse first and get entire child str
    self.depth += 1;
    
    // visit for speculative if test
    self.isSpeculating = YES;
    [child visit:self];
    self.isSpeculating = NO;
    NSString *ifTest = [self removeTabsAndNewLines:[self pop]];
    
    // visit for child body
    [child visit:self];

    self.depth -= 1;
    
    // pop
    NSMutableString *childStr = [self pop];
    vars[CHILD_STRING] = [[childStr copy] autorelease];
    
    NSString *templateName = nil;
    if (isLL1) { // ????
        templateName = @"PGRepetitionPredictTemplate";
    } else {
        vars[IF_TEST] = ifTest;
        templateName = @"PGRepetitionSpeculateTemplate";
    }
    
    // repetition
    NSMutableString *output = [NSMutableString string];
    [output appendString:[self semanticPredicateForNode:node throws:YES]];
    
    [output appendString:[self processTemplate:[self templateStringNamed:templateName] withVariables:vars]];

    // action
    [output appendString:[self actionStringFrom:node.actionNode]];

    // push
    [self push:output];

}


- (void)visitCollection:(PGCollectionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    NSAssert(1 == [node.token.stringValue length], @"");
    PKUniChar c = [node.token.stringValue characterAtIndex:0];
    switch (c) {
        case '.':
            [self visitSequence:node];
            break;
        default:
            NSAssert2(0, @"%s must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
            break;
    }
}


- (void)visitSequence:(PGCollectionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    // setup vars
    id vars = [NSMutableDictionary dictionary];
    vars[DEPTH] = @(_depth);
    
    // setup child str buffer
    NSMutableString *childStr = [NSMutableString string];
    [childStr appendString:[self semanticPredicateForNode:node throws:YES]];

    NSMutableString *partialChildStr = [NSMutableString string];
    NSUInteger partialCount = 0;

    BOOL hasTerminal = NO;
    
    NSMutableArray *concreteChildren = [NSMutableArray arrayWithCapacity:[node.children count]];
    for (PGBaseNode *child in node.children) {
        PGBaseNode *concreteNode = [self concreteNodeForNode:child];
        if (!concreteNode) {
            NSString *missingName = [child.name substringFromIndex:1];
            [NSException raise:@"PKParseException" format:@"Unknown rule name: `%@` in rule: `%@`", missingName, _currentDefName];
        }
        if ([concreteNode isKindOfClass:[PGLiteralNode class]] && [concreteChildren count]) hasTerminal = YES;
        [concreteChildren addObject:concreteNode];
    }

    // recurse
    BOOL depthIncreased = NO;
    NSUInteger i = 0;
    for (PGBaseNode *child in node.children) {
        PGBaseNode *concreteNode = concreteChildren[i];
        
        BOOL isCurrentChildLiteral = [concreteNode isKindOfClass:[PGLiteralNode class]];
        if (0 == i && !isCurrentChildLiteral) {
            partialCount++;
        }
        
        if (_enableAutomaticErrorRecovery && hasTerminal && partialCount == 1) {
            [childStr appendString:partialChildStr];
            [partialChildStr setString:@""];
            depthIncreased = YES;
            self.depth++;
        }

        [child visit:self];
        
        // pop
        NSString *terminalCallStr = [self pop];
        [partialChildStr appendString:terminalCallStr];
        
        if (_enableAutomaticErrorRecovery && isCurrentChildLiteral && partialCount > 0) {
            
            PGTokenKindDescriptor *desc = [(PGConstantNode *)concreteNode tokenKind];
            id resyncVars = @{TOKEN_KIND: desc, DEPTH: @(_depth - 1), CHILD_STRING: partialChildStr, TERMINAL_CALL_STRING: terminalCallStr};
            NSString *tryAndResyncStr = [self processTemplate:[self templateStringNamed:@"PGTryAndRecoverTemplate"] withVariables:resyncVars];
            
            [childStr appendString:tryAndResyncStr];
            
            // reset
            partialCount = 1;
            [partialChildStr setString:@""];
            if (depthIncreased) {
                self.depth--;
                depthIncreased = NO;
            }
        } else {
            NSAssert([partialChildStr length], @"");
            ++partialCount;
        }
        
        ++i;
    }

    //if (_enableAutomaticErrorRecovery && [node.children count] > 1) self.depth--;

    [childStr appendString:partialChildStr];

    [childStr appendString:[self actionStringFrom:node.actionNode]];

    // push
    [self push:childStr];
    
}


- (NSString *)semanticPredicateForNode:(PGBaseNode *)node throws:(BOOL)throws {
    NSString *result = @"";
    
    if (node.semanticPredicateNode) {
        NSString *predBody = [node.semanticPredicateNode.source stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSAssert([predBody length], @"");
        BOOL isStat = [predBody rangeOfString:@";"].length > 0;
        
        NSString *templateName = nil;
        if (throws) {
            templateName = isStat ? @"PGSemanticPredicateTestAndThrowStatTemplate" : @"PGSemanticPredicateTestAndThrowExprTemplate";
        } else {
            templateName = isStat ? @"PGSemanticPredicateTestStatTemplate" : @"PGSemanticPredicateTestExprTemplate";
        }
        
        result = [self processTemplate:[self templateStringNamed:templateName] withVariables:@{PREDICATE_BODY: predBody, DEPTH: @(self.depth)}];
        NSAssert(result, @"");
    }

    return result;
}


- (BOOL)isEmptyNode:(PGBaseNode *)node {
    return [node.token.stringValue isEqualToString:@"Empty"];
}


- (NSMutableString *)recurseAlt:(PGAlternationNode *)node la:(NSMutableArray *)lookaheadSets {
    // setup child str buffer
    NSMutableString *result = [NSMutableString string];
    
    // recurse
    NSUInteger idx = 0;
    for (PGBaseNode *child in node.children) {
        BOOL isEmpty = NO;
        
        if ([self isEmptyNode:child]) {
            isEmpty = YES;
            node.hasEmptyAlternative = YES;
            
            if (!child.actionNode) {
                ++idx;
                continue;
            }
        }
        
        id vars = [NSMutableDictionary dictionary];
        
        NSArray *set = [self sortedArrayFromLookaheadSet:lookaheadSets[idx]];
        vars[LOOKAHEAD_SET] = set;
        vars[LAST] = @([set count] - 1);
        vars[DEPTH] = @(_depth);
        vars[NEEDS_BACKTRACK] = @(_needsBacktracking);
        vars[IS_NEGATION] = @(PGNodeTypeNegation == child.type);

        NSString *templateName = nil;
        if (isEmpty) {
            templateName = @"PGElseEmptyTemplate";
        } else {
            // cannot test `idx` here to determine `if` vs `else` due to possible Empty child borking `idx`
            templateName = [result length] ? @"PGPredictElseIfTemplate" : @"PGPredictIfTemplate";
        }
        // process template.
        NSString *output = [self processTemplate:[self templateStringNamed:templateName] withVariables:vars];
        [result appendString:output];
        
        self.depth++;
        [child visit:self];
        self.depth--;
        
        // pop
        [result appendString:[self pop]];

        ++idx;
    }
    
    return result;
}


- (NSMutableString *)recurseAltForBracktracking:(PGAlternationNode *)node {
    // setup child str buffer
    NSMutableString *result = [NSMutableString string];
    
    // recurse
    NSUInteger idx = 0;
    for (PGBaseNode *child in node.children) {
        BOOL isEmpty = NO;
        
        if ([self isEmptyNode:child]) {
            isEmpty = YES;
            node.hasEmptyAlternative = YES;
            
            if (!child.actionNode) {
                ++idx;
                continue;
            }
        }

        // recurse first and get entire child str
        self.depth++;

        // visit for speculative if test
        self.isSpeculating = YES;
        [child visit:self];
        self.isSpeculating = NO;
        NSString *ifTest = [self removeTabsAndNewLines:[self pop]];

        // visit for child body
        [child visit:self];
        NSString *childBody = [self pop];
        self.depth--;

        // setup vars
        id vars = [NSMutableDictionary dictionary];
        vars[DEPTH] = @(_depth);
        vars[NEEDS_BACKTRACK] = @(_needsBacktracking);
        vars[CHILD_STRING] = ifTest;
        
        NSString *templateName = nil;
        if (isEmpty) {
            templateName = @"PGElseEmptyTemplate";
        } else {
            // cannot test `idx` here to determine `if` vs `else` due to possible Empty child borking `idx`
            templateName = [result length] ? @"PGSpeculateElseIfTemplate" : @"PGSpeculateIfTemplate";
        }

        // process template.
        NSString *output = [self processTemplate:[self templateStringNamed:templateName] withVariables:vars];

        [result appendString:output];
        [result appendString:childBody];

        ++idx;
    }
    
    return result;
}


- (void)visitAlternation:(PGAlternationNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    NSMutableString *childStr = nil;

    if (_enableHybridDFA) {
        // first fetch all child lookahead sets
        NSMutableArray *lookaheadSets = [NSMutableArray arrayWithCapacity:[node.children count]];
        
        for (PGBaseNode *child in node.children) {
            NSSet *set = [self lookaheadSetForNode:child];
            [lookaheadSets addObject:set];
        }
        
        NSMutableSet *all = [NSMutableSet setWithSet:lookaheadSets[0]];
        BOOL overlap = NO;
        for (NSUInteger i = 1; i < [lookaheadSets count]; ++i) {
            NSSet *set = lookaheadSets[i];
            overlap = [set intersectsSet:all];
            if (overlap) break;
            [all unionSet:set];
        }
        
        if (!overlap && [all containsObject:@(TOKEN_KIND_BUILTIN_DELIMITEDSTRING)]) {
            overlap = YES; // TODO ??
        }
        
        //NSLog(@"%@", lookaheadSets);
        self.needsBacktracking = overlap;
    
        if (_needsBacktracking) {
            childStr = [self recurseAltForBracktracking:node];
        } else {
            childStr = [self recurseAlt:node la:lookaheadSets];
        }
        self.needsBacktracking = NO;
    
    } else {
        self.needsBacktracking = YES;
        childStr = [self recurseAltForBracktracking:node];
    }

    id vars = [NSMutableDictionary dictionary];
    vars[METHOD_NAME] = _currentDefName;
    vars[DEPTH] = @(_depth);
    
    NSString *elseStr = nil;
    if (node.hasEmptyAlternative) {
        elseStr = [self processTemplate:[self templateStringNamed:@"PGPredictEndIfTemplate"] withVariables:vars];
    } else {
        elseStr = [self processTemplate:[self templateStringNamed:@"PGPredictElseTemplate"] withVariables:vars];
    }
    [childStr appendString:elseStr];

    // action
    [childStr appendString:[self actionStringFrom:node.actionNode]];

    // push
    [self push:childStr];
}


- (void)visitOptional:(PGOptionalNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);

    // recurse
    NSAssert(1 == [node.children count], @"");
    PGBaseNode *child = node.children[0];
    
    NSArray *set = [self sortedLookaheadSetForNode:child];
    
    BOOL isLL1 = _enableHybridDFA && [self isLL1:child];

    // recurse for speculation
    self.depth++;
    self.isSpeculating = YES;
    [child visit:self];
    self.isSpeculating = NO;
    
    NSMutableString *ifTest = [self removeTabsAndNewLines:[self pop]];

    // recurse for realz
    [child visit:self];
    self.depth--;

    // pop
    NSMutableString *childStr = [self pop];

    // setup vars
    id vars = [NSMutableDictionary dictionary];
    vars[DEPTH] = @(_depth);
    vars[LOOKAHEAD_SET] = set;
    vars[LAST] = @([set count] - 1);
    vars[CHILD_STRING] = childStr;
    vars[IF_TEST] = ifTest;
    
    NSMutableString *output = [NSMutableString string];
    [output appendString:[self semanticPredicateForNode:node throws:YES]];

    NSString *templateName = nil;
    if (isLL1) { // ????
        templateName = @"PGOptionalPredictTemplate";
    } else {
        templateName = @"PGOptionalSpeculateTemplate";
    }
    
    [output appendString:[self processTemplate:[self templateStringNamed:templateName] withVariables:vars]];
    
    // action
    [output appendString:[self actionStringFrom:node.actionNode]];

    // push
    [self push:output];
}


// if inNode is a #ref or $def, resolve to actual concrete node.
- (PGBaseNode *)concreteNodeForNode:(PGBaseNode *)inNode {
    PGBaseNode *node = inNode;
    while ([node isKindOfClass:[PGReferenceNode class]] || [node isKindOfClass:[PGDefinitionNode class]]) {
        while ([node isKindOfClass:[PGReferenceNode class]]) {
            node = self.symbolTable[node.token.stringValue];
        }
        
        if ([node isKindOfClass:[PGDefinitionNode class]]) {
            NSAssert(1 == [node.children count], @"");
            node = node.children[0];
        }
    }
    return node;
}


- (BOOL)isLL1:(PGBaseNode *)inNode {
    BOOL result = YES;
    
    PGBaseNode *node = [self concreteNodeForNode:inNode];
    
    if (node.semanticPredicateNode) {
        result = NO;
    } else if ([node isKindOfClass:[PGAlternationNode class]]) {
        for (PGBaseNode *child in node.children) {
            if (![self isLL1:child]) {
                result = NO;
                break;
            }
        }
    } else {
        result = node.isTerminal;
    }
    
    return result;
}


- (void)visitMultiple:(PGMultipleNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    // recurse
    NSAssert(1 == [node.children count], @"");
    PGBaseNode *child = node.children[0];
    
    NSArray *set = [self sortedLookaheadSetForNode:child];
    
    BOOL isLL1 = _enableHybridDFA && [self isLL1:child];
    
    // recurse for speculation
    self.depth++;
    self.isSpeculating = YES;
    [child visit:self];
    self.isSpeculating = NO;
    
    NSMutableString *ifTest = [self removeTabsAndNewLines:[self pop]];
    
    // recurse for realz
    [child visit:self];
    self.depth--;
    
    // pop
    NSMutableString *childStr = [self pop];

    // setup vars
    id vars = [NSMutableDictionary dictionary];
    vars[DEPTH] = @(_depth);
    vars[LOOKAHEAD_SET] = set;
    vars[LAST] = @([set count] - 1);
    vars[CHILD_STRING] = childStr;
    vars[IF_TEST] = ifTest;
    
    NSMutableString *output = [NSMutableString string];
    [output appendString:[self semanticPredicateForNode:node throws:YES]];

    NSString *templateName = nil;
    if (isLL1) { // ????
        templateName = @"PGMultiplePredictTemplate";
    } else {
        templateName = @"PGMultipleSpeculateTemplate";
    }
    
    [output appendString:[self processTemplate:[self templateStringNamed:templateName] withVariables:vars]];

    // action
    [output appendString:[self actionStringFrom:node.actionNode]];

    // push
    [self push:output];
}


- (void)visitConstant:(PGConstantNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
   
    // stup vars
    id vars = [NSMutableDictionary dictionary];
    NSString *methodName = node.token.stringValue;
    if ([@"S" isEqualToString:methodName]) {
        methodName = @"Whitespace";
    }
    vars[METHOD_NAME] = methodName;
    vars[DEPTH] = @(_depth);
    vars[DISCARD] = @(node.discard);
    
    // merge
    NSMutableString *output = [NSMutableString string];
    [output appendString:[self semanticPredicateForNode:node throws:YES]];
    
    NSString *template = [self templateStringNamed:@"PGConstantMethodCallTemplate"];
    [output appendString:[self processTemplate:template withVariables:vars]];
    
    [output appendString:[self actionStringFrom:node.actionNode]];

    // push
    [self push:output];
}


- (void)visitLiteral:(PGLiteralNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    // stup vars
    id vars = [NSMutableDictionary dictionary];
    vars[TOKEN_KIND] = node.tokenKind;
    vars[DEPTH] = @(_depth);
    vars[DISCARD] = @(node.discard);

    // merge
    NSMutableString *output = [NSMutableString string];
    [output appendString:[self semanticPredicateForNode:node throws:YES]];
    
    NSString *template = [self templateStringNamed:@"PGMatchCallTemplate"];
    [output appendString:[self processTemplate:template withVariables:vars]];
    
    [output appendString:[self actionStringFrom:node.actionNode]];

    // push
    [self push:output];
}


- (void)visitDelimited:(PGDelimitedNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    // stup vars
    id vars = [NSMutableDictionary dictionary];
    vars[TOKEN_KIND] = node.tokenKind;
    vars[DEPTH] = @(_depth);
    vars[DISCARD] = @(node.discard);
    vars[PREFIX] = node.startMarker;
    vars[SUFFIX] = node.endMarker;
    vars[METHOD_NAME] = self.currentDefName;
    
    // merge
    NSMutableString *output = [NSMutableString string];
    [output appendString:[self semanticPredicateForNode:node throws:YES]];
    
    NSString *template = [self templateStringNamed:@"PGMatchDelimitedStringTemplate"];
    [output appendString:[self processTemplate:template withVariables:vars]];
    
    [output appendString:[self actionStringFrom:node.actionNode]];
    
    // push
    [self push:output];
}


- (void)visitPattern:(PGPatternNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    // stup vars
    id vars = [NSMutableDictionary dictionary];
    //vars[TOKEN_KIND] = node.tokenKind;
    vars[DEPTH] = @(_depth);
    vars[DISCARD] = @(node.discard);
    vars[PATTERN] = [NSRegularExpression escapedPatternForString:node.string];
    vars[METHOD_NAME] = self.currentDefName;

    // merge
    NSMutableString *output = [NSMutableString string];
    [output appendString:[self semanticPredicateForNode:node throws:YES]];
    
    NSString *template = [self templateStringNamed:@"PGMatchPatternTemplate"];
    [output appendString:[self processTemplate:template withVariables:vars]];
    
    [output appendString:[self actionStringFrom:node.actionNode]];
    
    // push
    [self push:output];
}


- (void)visitAction:(PGActionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
    NSAssert2(0, @"%s must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}

@end
