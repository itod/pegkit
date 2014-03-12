//
//  NSArray+PEGKitAdditions.m
//  PEGKit
//
//  Created by Todd Ditchendorf on 12/16/08.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "NSArray+PEGKitAdditions.h"

@implementation NSArray (PEGKitAdditions)

- (NSArray *)reversedArray {
    return [[[self reversedMutableArray] copy] autorelease];
}


- (NSMutableArray *)reversedMutableArray {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    for (id obj in [self reverseObjectEnumerator]) {
        [result addObject:obj];
    }
    return result;
}

@end
