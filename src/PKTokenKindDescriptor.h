//
//  PKTokenKindDescriptor.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 3/27/13.
//
//

#import <Foundation/Foundation.h>

@interface PKTokenKindDescriptor : NSObject

+ (PKTokenKindDescriptor *)descriptorWithStringValue:(NSString *)s name:(NSString *)name;
+ (PKTokenKindDescriptor *)anyDescriptor;
+ (PKTokenKindDescriptor *)eofDescriptor;

+ (void)clearCache;

@property (nonatomic, copy) NSString *stringValue;
@property (nonatomic, copy) NSString *name;
@end
