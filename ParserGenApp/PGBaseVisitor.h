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

#import "PGNodeVisitor.h"

// convenience
#import "PGBaseNode.h"
#import "PGRootNode.h"
#import "PGDefinitionNode.h"
#import "PGReferenceNode.h"
#import "PGConstantNode.h"
#import "PGDelimitedNode.h"
#import "PGLiteralNode.h"
#import "PGPatternNode.h"
#import "PGCompositeNode.h"
#import "PGCollectionNode.h"
#import "PGAlternationNode.h"
#import "PGOptionalNode.h"
#import "PGMultipleNode.h"
#import "PGActionNode.h"

@interface PGBaseVisitor : NSObject <PGNodeVisitor>

- (void)recurse:(PGBaseNode *)node;

@property (nonatomic, retain) PGBaseNode *rootNode;
@property (nonatomic, retain) NSMutableDictionary *symbolTable;
@end
