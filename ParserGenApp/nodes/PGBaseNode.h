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

#import <PEGKit/PKAST.h>
#import "PGNodeVisitor.h" // convenience

typedef NS_ENUM(NSUInteger, PGNodeType) {
    PGNodeTypeRoot = 0,
    PGNodeTypeDefinition,
    PGNodeTypeReference,
    PGNodeTypeConstant,
    PGNodeTypeLiteral,
    PGNodeTypeDelimited,
    PGNodeTypePattern,
    PGNodeTypeWhitespace,
    PGNodeTypeComposite,
    PGNodeTypeCollection,
    PGNodeTypeAlternation,
    PGNodeTypeOptional,
    PGNodeTypeMultiple,
    PGNodeTypeAction,
    PGNodeTypeRepetition,
    PGNodeTypeNegation,
};

@interface PGBaseNode : PKAST

+ (instancetype)nodeWithToken:(PKToken *)tok;

- (void)visit:(id <PGNodeVisitor>)v;

- (void)replaceChild:(PGBaseNode *)oldChild withChild:(PGBaseNode *)newChild;
- (void)replaceChild:(PGBaseNode *)oldChild withChildren:(NSArray *)newChildren;

@property (nonatomic, assign, readonly) BOOL isTerminal;

@property (nonatomic, assign) BOOL discard;
@property (nonatomic, retain) PGActionNode *actionNode;
@property (nonatomic, retain) PGActionNode *semanticPredicateNode;
@property (nonatomic, retain) PGActionNode *before;
@property (nonatomic, retain) PGActionNode *after;
@property (nonatomic, retain) NSString *defName;
@end
