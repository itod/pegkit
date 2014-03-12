//
//  PKURLState.h
//  PEGKit
//
//  Created by Todd Ditchendorf on 3/26/10.
//  Copyright 2010 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PEGKit/PKTokenizerState.h>

/*!
    @class      PKURLState 
    @brief      A URL state returns a URL from a reader.
    @details    
*/    
@interface PKURLState : PKTokenizerState

@property (nonatomic) BOOL allowsWWWPrefix;
@end
