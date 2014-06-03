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

#import "PGBaseNode.h"

@implementation PGBaseNode

+ (instancetype)nodeWithToken:(PKToken *)tok {
    return [[[self alloc] initWithToken:tok] autorelease];
}


- (void)dealloc {
    self.actionNode = nil;
    self.semanticPredicateNode = nil;
    self.defName = nil;
    self.before = nil;
    self.after = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    PGBaseNode *that = (PGBaseNode *)[super copyWithZone:zone];
    that->_discard = _discard;
    that->_actionNode = [_actionNode retain];
    that->_semanticPredicateNode = [_semanticPredicateNode retain];
    that->_defName = [_defName retain];
    that->_before = [_before retain];
    that->_after = [_after retain];
    return that;
}


- (BOOL)isEqual:(id)obj {
    if (![super isEqual:obj]) {
        return NO;
    }

    PGBaseNode *that = (PGBaseNode *)obj;
    
    if (_discard != that->_discard) {
        return NO;
    }
    
    if (![_actionNode isEqual:that->_actionNode]) {
        return NO;
    }
    
    if (![_semanticPredicateNode isEqual:that->_semanticPredicateNode]) {
        return NO;
    }
    
    if (![_defName isEqual:that->_defName]) {
        return NO;
    }
    
    return YES;
}


- (void)replaceChild:(PGBaseNode *)oldChild withChild:(PGBaseNode *)newChild {
    NSParameterAssert(oldChild);
    NSParameterAssert(newChild);
    NSUInteger idx = [self.children indexOfObject:oldChild];
    NSAssert(NSNotFound != idx, @"");
    [self.children replaceObjectAtIndex:idx withObject:newChild];
}


- (void)replaceChild:(PGBaseNode *)oldChild withChildren:(NSArray *)newChildren {
    NSParameterAssert(oldChild);
    NSParameterAssert(newChildren);

    NSUInteger idx = [self.children indexOfObject:oldChild];
    NSAssert(NSNotFound != idx, @"");
    
    [self.children replaceObjectsInRange:NSMakeRange(idx, 1) withObjectsFromArray:newChildren];
}


- (void)visit:(id <PGNodeVisitor>)v; {
    NSAssert2(0, @"%s is an abastract method. Must be overridden in %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
}


- (BOOL)isTerminal {
    NSAssert2(0, @"%s is an abastract method. Must be overridden in %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return NO;
}

@end
