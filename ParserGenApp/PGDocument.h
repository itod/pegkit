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

#import <Cocoa/Cocoa.h>

@class NoodleLineNumberView;

@interface PGDocument : NSDocument

- (IBAction)generate:(id)sender;
- (IBAction)browse:(id)sender;
- (IBAction)reveal:(id)sender;

@property (nonatomic, copy) NSString *destinationPath;
@property (nonatomic, copy) NSString *parserName;
@property (nonatomic, retain) NSError *error;

@property (nonatomic, assign) BOOL enableARC;
@property (nonatomic, assign) BOOL enableHybridDFA;
@property (nonatomic, assign) BOOL enableMemoization;
@property (nonatomic, assign) BOOL enableAutomaticErrorRecovery;
@property (nonatomic, assign) NSInteger delegatePreMatchCallbacksOn;
@property (nonatomic, assign) NSInteger delegatePostMatchCallbacksOn;

@property (nonatomic, retain) IBOutlet NSScrollView* scrollView;
@property (strong) NoodleLineNumberView	*lineNumberView;
@property (nonatomic, retain) IBOutlet NSTextView *textView;

// These two are here for backwards compatibiltly with old saved files
@property (nonatomic, copy) NSString *grammar;
@property (nonatomic, assign) BOOL busy;


@end
