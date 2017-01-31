#import "CreateTableStmtParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface CreateTableStmtParser ()

@end

@implementation CreateTableStmtParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"createTableStmt";
        self.tokenKindTab[@"NOT"] = @(CREATETABLESTMT_TOKEN_KIND_NOT_UPPER);
        self.tokenKindTab[@"CREATE"] = @(CREATETABLESTMT_TOKEN_KIND_CREATE);
        self.tokenKindTab[@"EXISTS"] = @(CREATETABLESTMT_TOKEN_KIND_EXISTS);
        self.tokenKindTab[@"TEMPORARY"] = @(CREATETABLESTMT_TOKEN_KIND_TEMPORARY);
        self.tokenKindTab[@"TABLE"] = @(CREATETABLESTMT_TOKEN_KIND_TABLE);
        self.tokenKindTab[@"TEMP"] = @(CREATETABLESTMT_TOKEN_KIND_TEMP);
        self.tokenKindTab[@"IF"] = @(CREATETABLESTMT_TOKEN_KIND_IF);
        self.tokenKindTab[@";"] = @(CREATETABLESTMT_TOKEN_KIND_SEMI_COLON);

        self.tokenKindNameTab[CREATETABLESTMT_TOKEN_KIND_NOT_UPPER] = @"NOT";
        self.tokenKindNameTab[CREATETABLESTMT_TOKEN_KIND_CREATE] = @"CREATE";
        self.tokenKindNameTab[CREATETABLESTMT_TOKEN_KIND_EXISTS] = @"EXISTS";
        self.tokenKindNameTab[CREATETABLESTMT_TOKEN_KIND_TEMPORARY] = @"TEMPORARY";
        self.tokenKindNameTab[CREATETABLESTMT_TOKEN_KIND_TABLE] = @"TABLE";
        self.tokenKindNameTab[CREATETABLESTMT_TOKEN_KIND_TEMP] = @"TEMP";
        self.tokenKindNameTab[CREATETABLESTMT_TOKEN_KIND_IF] = @"IF";
        self.tokenKindNameTab[CREATETABLESTMT_TOKEN_KIND_SEMI_COLON] = @";";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    PKParser_weakSelfDecl;

    [PKParser_weakSelf createTableStmt_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)createTableStmt_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:CREATETABLESTMT_TOKEN_KIND_CREATE discard:YES];
    [PKParser_weakSelf tempOpt_];
    [PKParser_weakSelf match:CREATETABLESTMT_TOKEN_KIND_TABLE discard:YES];
    [PKParser_weakSelf existsOpt_];
    [PKParser_weakSelf databaseName_];
    [PKParser_weakSelf match:CREATETABLESTMT_TOKEN_KIND_SEMI_COLON discard:YES];
    [PKParser_weakSelf execute:^{
    
	// NSString *dbName = POP();
	// BOOL ifNotExists = POP_BOOL();
	// BOOL isTemp = POP_BOOL();
	// NSLog(@"create table: %@, %d, %d", dbName, ifNotExists, isTemp);
	// go to town
	// myCreateTable(dbName, ifNotExists, isTemp);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchCreateTableStmt:)];
}

- (void)databaseName_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchQuotedString:NO];
    [PKParser_weakSelf execute:^{
    
	// pop the string value of the `PKToken` on the top of the stack
	NSString *dbName = POP_STR();
	// trim quotes
	dbName = [dbName substringWithRange:NSMakeRange(1, [dbName length]-2)];
	// leave it on the stack for later
	PUSH(dbName);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchDatabaseName:)];
}

- (void)tempOpt_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:CREATETABLESTMT_TOKEN_KIND_TEMP, CREATETABLESTMT_TOKEN_KIND_TEMPORARY, 0]) {
        if ([PKParser_weakSelf predicts:CREATETABLESTMT_TOKEN_KIND_TEMP, 0]) {
            [PKParser_weakSelf match:CREATETABLESTMT_TOKEN_KIND_TEMP discard:YES];
        } else if ([PKParser_weakSelf predicts:CREATETABLESTMT_TOKEN_KIND_TEMPORARY, 0]) {
            [PKParser_weakSelf match:CREATETABLESTMT_TOKEN_KIND_TEMPORARY discard:YES];
        } else {
            [PKParser_weakSelf raise:@"No viable alternative found in rule 'tempOpt'."];
        }
        [PKParser_weakSelf execute:^{
         PUSH(@YES); 
        }];
    } else {
        [PKParser_weakSelf matchEmpty:NO];
        [PKParser_weakSelf execute:^{
         PUSH(@NO); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchTempOpt:)];
}

- (void)existsOpt_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:CREATETABLESTMT_TOKEN_KIND_IF, 0]) {
        [PKParser_weakSelf match:CREATETABLESTMT_TOKEN_KIND_IF discard:YES];
        [PKParser_weakSelf match:CREATETABLESTMT_TOKEN_KIND_NOT_UPPER discard:YES];
        [PKParser_weakSelf match:CREATETABLESTMT_TOKEN_KIND_EXISTS discard:YES];
        [PKParser_weakSelf execute:^{
         PUSH(@YES); 
        }];
    } else {
        [PKParser_weakSelf matchEmpty:NO];
        [PKParser_weakSelf execute:^{
         PUSH(@NO); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExistsOpt:)];
}

@end