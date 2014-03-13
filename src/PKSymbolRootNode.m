//  Copyright 2010 Todd Ditchendorf
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <PEGKit/PKReader.h>
#import "PKSymbolRootNode.h"

@interface PKSymbolNode ()
@property (nonatomic, retain) NSMutableDictionary *children;
@end

@interface PKSymbolRootNode ()
- (void)addWithFirst:(PKUniChar)c rest:(NSString *)s parent:(PKSymbolNode *)p;
- (void)removeWithFirst:(PKUniChar)c rest:(NSString *)s parent:(PKSymbolNode *)p;
- (NSString *)nextWithFirst:(PKUniChar)c rest:(PKReader *)r parent:(PKSymbolNode *)p;
@end

@implementation PKSymbolRootNode

- (id)init {
    if (self = [super initWithParent:nil character:PKEOF]) {
        
    }
    return self;
}


- (void)add:(NSString *)s {
    NSParameterAssert(s);
    if ([s length] < 2) return;
    
    [self addWithFirst:[s characterAtIndex:0] rest:[s substringFromIndex:1] parent:self];
}


- (void)remove:(NSString *)s {
    NSParameterAssert(s);
    if ([s length] < 2) return;
    
    [self removeWithFirst:[s characterAtIndex:0] rest:[s substringFromIndex:1] parent:self];
}


- (void)addWithFirst:(PKUniChar)c rest:(NSString *)s parent:(PKSymbolNode *)p {
    NSParameterAssert(p);
    NSNumber *key = [NSNumber numberWithInteger:c];
    PKSymbolNode *child = [p.children objectForKey:key];
    if (!child) {
        child = [[[PKSymbolNode alloc] initWithParent:p character:c] autorelease];
        [p.children setObject:child forKey:key];
    }
    
    NSUInteger len = [s length];

    if (len) {
        NSString *rest = nil;

        if (len > 1) {
            rest = [s substringFromIndex:1];
        }
        
        [self addWithFirst:[s characterAtIndex:0] rest:rest parent:child];
    }
}


- (void)removeWithFirst:(PKUniChar)c rest:(NSString *)s parent:(PKSymbolNode *)p {
    NSParameterAssert(p);
    NSNumber *key = [NSNumber numberWithInteger:c];
    PKSymbolNode *child = [p.children objectForKey:key];
    if (child) {
        NSString *rest = nil;
        
        NSUInteger len = [s length];
        if (0 == len) {
            return;
        } else if (len > 1) {
            rest = [s substringFromIndex:1];
            [self removeWithFirst:[s characterAtIndex:0] rest:rest parent:child];
        }
        
        [p.children removeObjectForKey:key];
    }
}


- (NSString *)nextSymbol:(PKReader *)r startingWith:(PKUniChar)cin {
    NSParameterAssert(r);
    return [self nextWithFirst:cin rest:r parent:self];
}


- (NSString *)nextWithFirst:(PKUniChar)c rest:(PKReader *)r parent:(PKSymbolNode *)p {
    NSParameterAssert(p);
    NSString *result = [NSString stringWithFormat:@"%C", (unichar)c];

    // this also works.
//    NSString *result = [[[NSString alloc] initWithCharacters:(const unichar *)&c length:1] autorelease];
    
    NSNumber *key = [NSNumber numberWithInteger:c];
    PKSymbolNode *child = [p.children objectForKey:key];
    
    if (!child) {
        if (p == self) {
            return result;
        } else {
            [r unread];
            return @"";
        }
    } 
    
    c = [r read];
    if (PKEOF == c) {
        return result;
    }
    
    return [result stringByAppendingString:[self nextWithFirst:c rest:r parent:child]];
}

@end
