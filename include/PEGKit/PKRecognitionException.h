//
//  PEGRecognitionException.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 3/28/13.
//
//

#import <Foundation/Foundation.h>

@interface PKRecognitionException : NSException

- (id)init; // use me

@property (nonatomic, retain) NSString *currentReason;
@end
