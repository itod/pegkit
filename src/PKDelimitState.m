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

#import <PEGKit/PKDelimitState.h>
#import <PEGKit/PKReader.h>
#import <PEGKit/PKTokenizer.h>
#import <PEGKit/PKToken.h>
#import <PEGKit/PKWhitespaceState.h>
#import <PEGKit/PKTypes.h>
#import "PKSymbolRootNode.h"

#import "PKDelimitDescriptorCollection.h"
#import "PKDelimitDescriptor.h"

@interface PKToken ()
@property (nonatomic, readwrite) NSUInteger offset;
@end

@interface PKTokenizer ()
- (NSInteger)tokenKindForStringValue:(NSString *)str;
@end

@interface PKTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
- (void)append:(PKUniChar)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;
- (PKTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(PKTokenizer *)t;
- (void)addStartMarker:(NSString *)start endMarker:(NSString *)end allowedCharacterSet:(NSCharacterSet *)set tokenKind:(NSInteger)kind;
@property (nonatomic) NSUInteger offset;
@end

@interface PKDelimitState ()
@property (nonatomic, retain) PKSymbolRootNode *rootNode;
@property (nonatomic, retain) PKDelimitDescriptorCollection *collection;
@end

@implementation PKDelimitState {
    NSInteger _nestedCount;
}

- (id)init {
    self = [super init];
    if (self) {
        self.rootNode = [[[PKSymbolRootNode alloc] init] autorelease];
        self.collection = [[[PKDelimitDescriptorCollection alloc] init] autorelease];
    }
    return self;
}


- (void)dealloc {
    self.rootNode = nil;
    self.collection = nil;
    [super dealloc];
}


- (void)addStartMarker:(NSString *)start endMarker:(NSString *)end allowedCharacterSet:(NSCharacterSet *)set {
    NSParameterAssert([start length]);

    // add markers to root node
    [_rootNode add:start];
    if ([end length]) {
        [_rootNode add:end];
    }
    
    // add descriptor to collection
    PKDelimitDescriptor *desc = [PKDelimitDescriptor descriptorWithStartMarker:start endMarker:end characterSet:set];
    NSAssert(_collection, @"");
    [_collection add:desc];
}


- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);
    
    NSString *startMarker = [_rootNode nextSymbol:r startingWith:cin];
    NSArray *descs = nil;
    
    if ([startMarker length]) {
        descs = [_collection descriptorsForStartMarker:startMarker];
        
        if (![descs count]) {
            [r unread:[startMarker length] - 1];
            return [[self nextTokenizerStateFor:cin tokenizer:t] nextTokenFromReader:r startingWith:cin tokenizer:t];
        }
    }
    
    [self resetWithReader:r];
    self.offset = r.offset - [startMarker length];
    [self appendString:startMarker];
    
    BOOL hasEndMarkers = NO;
    NSUInteger count = [descs count];
    if (0 == count) {
        NSAssert(0, @"should never reach");
        return nil;
    }
    
    PKUniChar startChars[count];
    PKUniChar endChars[count];
    
    // initialize for static analyzer
    for (NSUInteger k = 0; k < count; ++k) {
        startChars[k] = endChars[k] = '\0';
    }
    
    PKDelimitDescriptor *selectedDesc = nil;
    _nestedCount = 0;

    NSUInteger i = 0;
    for (PKDelimitDescriptor *desc in descs) {
        startChars[i] = [startMarker characterAtIndex:0];
        NSString *endMarker = desc.endMarker;
        PKUniChar e = PKEOF;
        
        if ([endMarker length]) {
            e = [endMarker characterAtIndex:0];
            hasEndMarkers = YES;
        }
        endChars[i++] = e;
    }
    
    NSCharacterSet *nlset = [NSCharacterSet newlineCharacterSet];
    PKUniChar c;
    for (;;) {
        c = [r read];
        //NSLog(@"%C", (UniChar)c);
        if (PKEOF == c) {
            if (hasEndMarkers && _balancesEOFTerminatedStrings) {
                [self appendString:[descs[0] endMarker]];
                break;
            } else if (hasEndMarkers) {
                [r unread:[[self bufferedString] length] - 1];
                return [[self nextTokenizerStateFor:cin tokenizer:t] nextTokenFromReader:r startingWith:cin tokenizer:t];
            }
        }
        
        //if (!hasEndMarkers && [t.whitespaceState isWhitespaceChar:c]) {
        if (!hasEndMarkers && [nlset characterIsMember:c]) {
            // if only the start marker was matched, dont return delimited string token. instead, defer tokenization
            if ([startMarker isEqualToString:[self bufferedString]]) {
                [r unread:[startMarker length] - 1];
                return [[self nextTokenizerStateFor:cin tokenizer:t] nextTokenFromReader:r startingWith:cin tokenizer:t];
            }
            // else, return delimited string tok
            break;
        }

        BOOL done = NO;
        NSString *endMarker = nil;
        NSCharacterSet *charSet = nil;
        BOOL hasConsumedAtLeastOneChar = [[self bufferedString] length];

        for (NSUInteger j = 0; j < count; ++j) {
            if ('\\' == c) {
                [self append:c]; // append escape backslash
                c = [r read];
                if (PKEOF == c) {
                    break;
                } else {
                    [self append:c]; // append escaped char and,
                    c = [r read]; // advance
                }
            }
            
            PKUniChar a = startChars[j];
            PKUniChar e = endChars[j];
            
            NSString *peek = nil;
            BOOL foundNestedStartMarker = NO;
            
            if (_allowsNestedMarkers && hasConsumedAtLeastOneChar && a == c) {
                selectedDesc = descs[j];
                endMarker = [selectedDesc endMarker];
                charSet = [selectedDesc characterSet];
                
                peek = [_rootNode nextSymbol:r startingWith:c];
                //NSLog(@"%@ %@", peek, [self bufferedString]);
                
                if ([startMarker isEqualToString:peek]) {
                    foundNestedStartMarker = YES;
                    _nestedCount++;
                }
            }
            
            if (!foundNestedStartMarker && (e == c || PKEOF == c)) {
                selectedDesc = descs[j];
                endMarker = [selectedDesc endMarker];
                charSet = [selectedDesc characterSet];
                
                if (!peek) {
                    peek = [_rootNode nextSymbol:r startingWith:c];
                }
                //NSLog(@"%@ %@", peek, [self bufferedString]);

                BOOL foundEndMarker = NO;
                if (endMarker && [endMarker isEqualToString:peek]) {
                    if (_allowsNestedMarkers && _nestedCount) {
                        _nestedCount--;
                    } else {
                        foundEndMarker = YES;
                    }
                }
                
                if (PKEOF == c) {
                    done = YES;
                    break;
                } else if (foundEndMarker) {
                    [self appendString:endMarker];
                    //c = [r read];
                    done = YES;
                    break;
                } else {
                    [r unread:[peek length] - 1];
                    if (e != [peek characterAtIndex:0]) {
                        [self append:c];
                        c = [r read];
                    }
                }

            }
        }

        if (done) {
            if (charSet) {
                NSString *contents = [self bufferedString];
                NSUInteger loc = [startMarker length];
                NSUInteger len = [contents length] - (loc + [endMarker length]);
                contents = [contents substringWithRange:NSMakeRange(loc, len)];
                
                for (NSUInteger i = 0; i < len; ++i) {
                    PKUniChar c = [contents characterAtIndex:i];

                    // check if char is not in allowed character set (if given)
                    if (![charSet characterIsMember:c]) {
                        // if not, unwind and return a symbol tok for cin
                        
                        NSUInteger buffLen = [[self bufferedString] length];
                        [r unread:buffLen - 1];

                        return [[self nextTokenizerStateFor:cin tokenizer:t] nextTokenFromReader:r startingWith:cin tokenizer:t];
                    }
                }
            }

            c = [r read];
            break;
        }
        
        
        [self append:c];
    }
    
    if (PKEOF != c) {
        [r unread];
    }
    
    PKToken *tok = [PKToken tokenWithTokenType:PKTokenTypeDelimitedString stringValue:[self bufferedString] doubleValue:0.0];
    tok.offset = self.offset;
    
    NSString *tokenKindKey = [NSString stringWithFormat:@"%@,%@", selectedDesc.startMarker, selectedDesc.endMarker];
    NSInteger tokenKind = [t tokenKindForStringValue:tokenKindKey];
    tok.tokenKind = tokenKind; //selectedDesc.tokenKind;

    return tok;
}

@end
