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

#import "PGDocument.h"
//#import <PEGKit/PEGKit.h>
#import "PGParserGenVisitor.h"

@interface PGDocument ()
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@end

@implementation PGDocument

- (instancetype)init {
    self = [super init];
    if (self) {
        self.factory = [PGParserFactory factory];
        _factory.collectTokenKinds = YES;
        
        self.enableARC = YES;
        self.enableHybridDFA = YES;
        self.enableMemoization = YES;
        self.enableAutomaticErrorRecovery = NO;
        
        self.destinationPath = [@"~/Desktop" stringByExpandingTildeInPath];
        self.parserName = @"ExpressionParser";
        
        self.delegatePreMatchCallbacksOn = PGParserFactoryDelegateCallbacksOnNone;
        self.delegatePostMatchCallbacksOn = PGParserFactoryDelegateCallbacksOnAll;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"expression" ofType:@"grammar"];
        self.grammar = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    return self;
}


- (void)dealloc {
    self.destinationPath = nil;
    self.parserName = nil;
    self.grammar = nil;
    
    self.textView = nil;
    
    self.factory = nil;
    self.root = nil;
    self.visitor = nil;
    [super dealloc];
}


- (void)awakeFromNib {

}


#pragma mark -
#pragma mark NSDocument

- (NSString *)windowNibName {
    return @"PGDocument";
}


- (void)windowControllerDidLoadNib:(NSWindowController *)wc {
    [super windowControllerDidLoadNib:wc];
    
    [_textView setFont:[NSFont fontWithName:@"Monaco" size:12.0]];
    [self focusTextView];
}


+ (BOOL)autosavesInPlace {
    return YES;
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    NSAssert([[NSThread currentThread] isMainThread], @"");
    NSMutableDictionary *tab = [NSMutableDictionary dictionaryWithCapacity:9];
    
    if (_destinationPath) tab[@"destinationPath"] = _destinationPath;
    if (_grammar) tab[@"grammar"] = _grammar;
    if (_parserName) tab[@"parserName"] = _parserName;
    tab[@"enableARC"] = @(_enableARC);
    tab[@"enableHybridDFA"] = @(_enableHybridDFA);
    tab[@"enableMemoization"] = @(_enableMemoization);
    tab[@"enableAutomaticErrorRecovery"] = @(_enableAutomaticErrorRecovery);
    tab[@"delegatePreMatchCallbacksOn"] = @(_delegatePreMatchCallbacksOn);
    tab[@"delegatePostMatchCallbacksOn"] = @(_delegatePostMatchCallbacksOn);
    
    //NSLog(@"%@", tab);
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tab];
    return data;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    NSAssert([[NSThread currentThread] isMainThread], @"");
    NSDictionary *tab = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //NSLog(@"%@", tab);
    
    self.destinationPath = tab[@"destinationPath"];
    self.grammar = tab[@"grammar"];
    self.parserName = tab[@"parserName"];
    self.enableARC = [tab[@"enableARC"] boolValue];
    self.enableHybridDFA = [tab[@"enableHybridDFA"] boolValue];
    self.enableMemoization = [tab[@"enableMemoization"] boolValue];
    self.enableAutomaticErrorRecovery = [tab[@"enableAutomaticErrorRecovery"] boolValue];
    self.delegatePreMatchCallbacksOn = [tab[@"delegatePreMatchCallbacksOn"] integerValue];
    self.delegatePostMatchCallbacksOn = [tab[@"delegatePostMatchCallbacksOn"] integerValue];
    
    return YES;
}


#pragma mark -
#pragma mark Actions

- (IBAction)generate:(id)sender {
    NSString *destPath = [[_destinationPath copy] autorelease];
    NSString *parserName = [[_parserName copy] autorelease];
    NSString *grammar = [[_grammar copy] autorelease];
    
    if (![destPath length] || ![parserName length] || ![grammar length]) {
        NSBeep();
        return;
    }
    
    self.busy = YES;
    self.error = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self generateWithDestinationPath:destPath parserName:parserName grammar:grammar];
    });
}


- (IBAction)browse:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    NSWindow *win = [[[self windowControllers] lastObject] window];
    
    NSString *path = nil;
    
    if (_destinationPath) {
        path = _destinationPath;
        
        BOOL isDir;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] || !isDir) {
            path = nil;
        }
    }
    
    if (path) {
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        [panel setDirectoryURL:pathURL];
    }
    
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanCreateDirectories:YES];
    [panel setCanChooseFiles:NO];
    
    [panel beginSheetModalForWindow:win completionHandler:^(NSInteger result) {
        if (NSOKButton == result) {
            NSString *path = [[panel URL] relativePath];
            self.destinationPath = path;
            
            [self updateChangeCount:NSChangeDone];
        }
    }];
}


- (IBAction)reveal:(id)sender {
    NSString *path = _destinationPath;
    
    BOOL isDir;
    NSFileManager *mgr = [NSFileManager defaultManager];
    while ([path length] && ![mgr fileExistsAtPath:path isDirectory:&isDir]) {
        path = [path stringByDeletingLastPathComponent];
    }
    
    NSString *filename = self.parserName;
    if (![filename hasSuffix:@"Parser"]) {
        filename = [NSString stringWithFormat:@"%@Parser.m", filename];
    } else {
        filename = [NSString stringWithFormat:@"%@.m", filename];
    }

    path = [path stringByAppendingPathComponent:filename];
    
    if ([path length]) {
        [[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:nil];
    }
}


#pragma mark -
#pragma mark Private


- (void)generateWithDestinationPath:(NSString *)destPath parserName:(NSString *)parserName grammar:(NSString *)grammar {
    NSError *err = nil;
    self.root = (id)[_factory ASTFromGrammar:_grammar error:&err];
    if (err) {
        self.error = err;
        goto done;
    }
    
    NSAssert([_root.startMethodName length], @"");
    NSString *className = self.parserName;
    NSAssert([className length], @"");
    if (![className hasSuffix:@"Parser"]) {
        className = [NSString stringWithFormat:@"%@Parser", className];
    }
    
    _root.grammarName = self.parserName;
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    _visitor.enableARC = _enableARC;
    _visitor.enableHybridDFA = _enableHybridDFA; //NSAssert(_enableHybridDFA, @"");
    _visitor.enableMemoization = _enableMemoization;
    _visitor.enableAutomaticErrorRecovery = _enableAutomaticErrorRecovery;
    _visitor.delegatePreMatchCallbacksOn = _delegatePreMatchCallbacksOn;
    _visitor.delegatePostMatchCallbacksOn = _delegatePostMatchCallbacksOn;
    
    @try {
        [_root visit:_visitor];
    }
    @catch (NSException *ex) {
        id userInfo = @{NSLocalizedFailureReasonErrorKey: [ex reason]};
        NSError *err = [NSError errorWithDomain:[ex name] code:0 userInfo:userInfo];
        self.error = err;
        goto done;
    }
    
    NSString *path = [[NSString stringWithFormat:@"%@/%@.h", destPath, className] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSMutableString *str = [NSMutableString stringWithString:[err localizedFailureReason]];
        [str appendFormat:@"\n\n%@", [path stringByDeletingLastPathComponent]];
        id dict = [NSMutableDictionary dictionaryWithDictionary:[err userInfo]];
        dict[NSLocalizedFailureReasonErrorKey] = str;
        self.error = [NSError errorWithDomain:[err domain] code:[err code] userInfo:dict];
        goto done;
    }
    
    path = [[NSString stringWithFormat:@"%@/%@.m", destPath, className] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSMutableString *str = [NSMutableString stringWithString:[err localizedFailureReason]];
        [str appendFormat:@"\n\n%@", [path stringByDeletingLastPathComponent]];
        id dict = [NSMutableDictionary dictionaryWithDictionary:[err userInfo]];
        dict[NSLocalizedFailureReasonErrorKey] = str;
        self.error = [NSError errorWithDomain:[err domain] code:[err code] userInfo:dict];
        goto done;
    }
    
done:
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self done];
    });
}


- (void)done {
    if (_error) {
        [[NSSound soundNamed:@"Basso"] play];
        [self displayError:_error];
    } else {
        [[NSSound soundNamed:@"Hero"] play];
    }
    
    self.busy = NO;
    [self focusTextView];
}


- (void)focusTextView {
    NSWindow *win = [[[self windowControllers] lastObject] window];
    [win makeFirstResponder:_textView];
}


- (void)displayError:(NSError *)error {
    NSString *title = NSLocalizedString(@"Error parsing grammar", @"");
    NSString *msg = [error localizedFailureReason];
    NSString *defaultButton = NSLocalizedString(@"OK", @"");
    NSString *altButton = nil;
    NSString *otherButton = nil;
    NSRunAlertPanel(title, @"%@", defaultButton, altButton, otherButton, msg);
}

@end
