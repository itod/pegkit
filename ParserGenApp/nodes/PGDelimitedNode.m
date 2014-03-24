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

#import "PGDelimitedNode.h"

@implementation PGDelimitedNode

- (void)dealloc {
    self.startMarker = nil;
    self.endMarker = nil;
    self.tokenKind = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    PGDelimitedNode *that = (PGDelimitedNode *)[super copyWithZone:zone];
    that->_startMarker = [_startMarker retain];
    that->_endMarker = [_endMarker retain];
    that->_tokenKind = [_tokenKind retain];
    return that;
}


- (BOOL)isEqual:(id)obj {
    if (![super isEqual:obj]) {
        return NO;
    }
    
    PGDelimitedNode *that = (PGDelimitedNode *)obj;
    
    if (![_startMarker isEqual:that->_startMarker]) {
        return NO;
    }
    
    if (![_endMarker isEqual:that->_endMarker]) {
        return NO;
    }
    
    if (![_tokenKind isEqual:that->_tokenKind]) {
        return NO;
    }
    
    
    return YES;
}


- (NSUInteger)type {
    return PGNodeTypeDelimited;
}


- (NSString *)name {
    NSMutableString *mstr = [NSMutableString stringWithFormat:@"%%{'%@', '%@'", _startMarker, _endMarker];
    
    // TODO add charset
    
    [mstr appendString:@"}"];
    return [[mstr copy] autorelease];
}


- (void)visit:(id <PGNodeVisitor>)v; {
    [v visitDelimited:self];
}


- (BOOL)isTerminal {
    return YES;
}

@end
