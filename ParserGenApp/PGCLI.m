//
//  PGCLI.m
//  PEGKit
//
//  Created by Ewan Mellor on 7/29/14.
//
//

#import "PGGenerator.h"

#import "PGCLI.h"


#define nsfprintf(__fp, ...) \
    fprintf(__fp, "%s\n", [[NSString stringWithFormat:__VA_ARGS__] UTF8String])


@interface PGCLI ()

@property (nonatomic) PGGenerator * generator;
@property (nonatomic) NSString * grammarFile;

@end


@implementation PGCLI


-(instancetype)init {
    self = [super init];
    if (self) {
        _generator = [[PGGenerator alloc] init];
    }
    return self;
}


-(BOOL)willHandleCommandLine {
    [self parseArgs];

    return (self.grammarFile != nil);
}


-(int)handleCommandLine {
    if (self.generator.destinationPath.length == 0 || self.grammarFile.length == 0) {
        nsfprintf(stderr,
                  @"\n"
                  @"Usage:\n"
                  @"\n"
                  @"    ParserGenApp -grammar <file path> -destPath <directory path> <options>\n"
                  @"\n"
                  @"Options are any combination of:\n"
                  @"    -parserName <name>\n"
                  @"    -enableARC 1\n"
                  @"    -enableAutomaticErrorRecovery 1\n"
                  @"    -enableHybridDFA 1\n"
                  @"    -enableMemoization 1\n");
        return 1;
    }

    BOOL ok = [self loadGrammar];
    if (!ok) {
        return 1;
    }

    ok = [self generate];
    if (!ok) {
        return 1;
    }

    return 0;
}


-(void)parseArgs {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];

    self.grammarFile = [ud stringForKey:@"grammar"];

    self.generator.destinationPath = [ud stringForKey:@"destPath"];
    if (self.generator.destinationPath == nil) {
        self.generator.destinationPath = [ud stringForKey:@"destinationPath"];
    }
    self.generator.enableARC = [ud boolForKey:@"enableARC"];
    self.generator.enableAutomaticErrorRecovery = [ud boolForKey:@"enableAutomaticErrorRecovery"];
    self.generator.enableHybridDFA = [ud boolForKey:@"enableHybridDFA"];
    self.generator.enableMemoization = [ud boolForKey:@"enableMemoization"];
    self.generator.parserName = [ud stringForKey:@"parserName"];
}


-(BOOL)loadGrammar {
    NSString * path = [self.grammarFile stringByExpandingTildeInPath];
    NSError * err = nil;
    NSString * grammar = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if (grammar == nil) {
        nsfprintf(stderr, NSLocalizedString(@"Failed to load grammar: %@", nil), [err localizedDescription]);
        return NO;
    }
    else {
        self.generator.grammar = grammar;
        return YES;
    }
}


-(BOOL)generate {
    bool ok = [self.generator generate];
    if (!ok) {
        nsfprintf(stderr, NSLocalizedString(@"Failed to generate: %@", nil), [self.generator.error localizedDescription]);
    }
    return ok;
}


@end
