//
//  PGCLI.h
//  PEGKit
//
//  Created by Ewan Mellor on 7/29/14.
//
//

#import <Foundation/Foundation.h>


@interface PGCLI : NSObject

/**
 * @return true if there are command-line arguments that this class can handle.
 */
-(BOOL)willHandleCommandLine;

/**
 * @return The value that should be returned from main.
 */
-(int)handleCommandLine;

@end
