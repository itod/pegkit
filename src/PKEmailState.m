//
//  PKEmailState.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 3/31/10.
//  Copyright 2010 Todd Ditchendorf. All rights reserved.
//

#import <PEGKit/PKEmailState.h>
#import <PEGKit/PKReader.h>
#import <PEGKit/PKTokenizer.h>
#import <PEGKit/PKToken.h>
#import <PEGKit/PKTypes.h>

@interface PKToken ()
@property (nonatomic, readwrite) NSUInteger offset;
@end

@interface PKTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
- (void)append:(PKUniChar)c;
- (NSString *)bufferedString;
- (PKTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(PKTokenizer *)t;
@end

@interface PKEmailState ()
- (BOOL)parseNameFromReader:(PKReader *)r;
- (BOOL)parseHostFromReader:(PKReader *)r;
@property (nonatomic) PKUniChar c;
@property (nonatomic) PKUniChar lastChar;
@end

@implementation PKEmailState

- (void)dealloc {
    [super dealloc];
}


- (void)append:(PKUniChar)ch {
    self.lastChar = ch;
    [super append:ch];
}


- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    NSParameterAssert(r);
    [self resetWithReader:r];
    
    self.lastChar = PKEOF;
    self.c = cin;
    BOOL matched = [self parseNameFromReader:r];
    if (matched) {
        matched = [self parseHostFromReader:r];
    }

    if (PKEOF != _c) {
        [r unread];
    }
    
    NSString *s = [self bufferedString];
    if (matched) {
        if ('.' == _lastChar) {
            s = [s substringToIndex:[s length] - 1];
            [r unread];
        }
        
        PKToken *tok = [PKToken tokenWithTokenType:PKTokenTypeEmail stringValue:s floatValue:0.0];
        tok.offset = offset;
        return tok;
    } else {
        [r unread:[s length] - 1];
        return [[self nextTokenizerStateFor:cin tokenizer:t] nextTokenFromReader:r startingWith:cin tokenizer:t];
    }
}


- (BOOL)parseNameFromReader:(PKReader *)r {
    BOOL result = NO;
    BOOL hasAtLeastOneChar = NO;

    for (;;) {
        if (PKEOF == _c || isspace(_c)) {
            result = NO;
            break;
        } else if ('@' == _c && hasAtLeastOneChar) {
            //[self append:c];
            result = YES;
            break;
        } else {
            hasAtLeastOneChar = YES;
            [self append:_c];
            self.c = [r read];
        }
    }
    
    return result;
}


- (BOOL)parseHostFromReader:(PKReader *)r {
    BOOL result = NO;
    BOOL hasAtLeastOneChar = NO;
    BOOL hasDot = NO;
    
    // ^[:space:]()<>/"'
    for (;;) {
        if (PKEOF == _c || isspace(_c) || '(' == _c || ')' == _c || '<' == _c || '>' == _c || '/' == _c || '"' == _c || '\'' == _c) {
            result = hasAtLeastOneChar && hasDot;
            break;
        } else {
            if ('.' == _c) {
                hasDot = YES;
            }
            hasAtLeastOneChar = YES;
            [self append:_c];
            self.c = [r read];
        }
    }
    
    return result;
}

@end
