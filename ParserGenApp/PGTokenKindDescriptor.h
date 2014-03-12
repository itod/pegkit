//
//  PKTokenKindDescriptor.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 3/27/13.
//
//

#import <Foundation/Foundation.h>

@interface PGTokenKindDescriptor : NSObject

+ (PGTokenKindDescriptor *)descriptorWithStringValue:(NSString *)s name:(NSString *)name;
+ (PGTokenKindDescriptor *)anyDescriptor;
+ (PGTokenKindDescriptor *)eofDescriptor;

+ (void)clearCache;

@property (nonatomic, copy) NSString *stringValue;
@property (nonatomic, copy) NSString *name;
@end
