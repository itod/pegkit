#import "MiniMath2Parser.h"
#import <PEGKit/PEGKit.h>


@interface MiniMath2Parser ()

@end

@implementation MiniMath2Parser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"expr";


    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {

    [self expr_]; 
    [self matchEOF:YES]; 

}

- (void)expr_ {
    
    [self addExpr_]; 

}

@end