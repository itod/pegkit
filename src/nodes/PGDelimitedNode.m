//
//  PKNodeDelimited.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 10/5/12.
//
//

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
