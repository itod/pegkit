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

#import "PGBaseVisitor.h"

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

@implementation PGBaseVisitor

- (void)dealloc {
    self.rootNode = nil;
    self.symbolTable = nil;
    [super dealloc];
}


- (void)recurse:(PGBaseNode *)node {
    for (PGBaseNode *child in node.children) {
        [child visit:self];
    }
}


- (void)visitRoot:(PGRootNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);

}


- (void)visitDefinition:(PGDefinitionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitReference:(PGReferenceNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitComposite:(PGCompositeNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitCollection:(PGCollectionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitAlternation:(PGAlternationNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitOptional:(PGOptionalNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitMultiple:(PGMultipleNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitConstant:(PGConstantNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitLiteral:(PGLiteralNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitDelimited:(PGDelimitedNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitPattern:(PGPatternNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitAction:(PGActionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitRepetition:(PGRepetitionNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}


- (void)visitNegation:(PGNegationNode *)node {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, node);
    
}

@end
