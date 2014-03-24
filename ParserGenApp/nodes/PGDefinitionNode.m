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

#import "PGDefinitionNode.h"
#import <PEGKit/PKToken.h>

@implementation PGDefinitionNode

- (void)dealloc {
    self.callbackName = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    PGDefinitionNode *that = (PGDefinitionNode *)[super copyWithZone:zone];
    that->_callbackName = [_callbackName copyWithZone:zone];
    return that;
}


- (BOOL)isEqual:(id)obj {
    if (![super isEqual:obj]) {
        return NO;
    }
    
    PGDefinitionNode *that = (PGDefinitionNode *)obj;
    
    if (![_callbackName isEqual:that->_callbackName]) {
        return NO;
    }

    return YES;
}


- (NSUInteger)type {
    return PGNodeTypeDefinition;
}


- (NSString *)name {
    NSString *pname = self.token.stringValue;
    NSAssert([pname length], @"");
    
    NSString *str = [NSString stringWithFormat:@"$%@", pname];
    
    if (_callbackName) {
        str = [NSString stringWithFormat:@"%@(%@)", str, _callbackName];
    }
    
    return str;
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitDefinition:self];
}


- (BOOL)isTerminal {
    NSAssert2(0, @"%s is an abastract method. Must be overridden in %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return NO;
}

@end
