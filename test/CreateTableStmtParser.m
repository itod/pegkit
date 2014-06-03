#import "CreateTableStmtParser.h"
#import <PEGKit/PEGKit.h>


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

    [self createTableStmt_]; 
    [self matchEOF:YES]; 

}

- (void)createTableStmt_ {
    
    [self match:CREATETABLESTMT_TOKEN_KIND_CREATE discard:YES]; 
    [self tempOpt_]; 
    [self match:CREATETABLESTMT_TOKEN_KIND_TABLE discard:YES]; 
    [self existsOpt_]; 
    [self databaseName_]; 
    [self match:CREATETABLESTMT_TOKEN_KIND_SEMI_COLON discard:YES]; 
    [self execute:^{
    
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
    
    [self matchQuotedString:NO]; 
    [self execute:^{
    
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
    
    if ([self predicts:CREATETABLESTMT_TOKEN_KIND_TEMP, CREATETABLESTMT_TOKEN_KIND_TEMPORARY, 0]) {
        if ([self predicts:CREATETABLESTMT_TOKEN_KIND_TEMP, 0]) {
            [self match:CREATETABLESTMT_TOKEN_KIND_TEMP discard:YES]; 
        } else if ([self predicts:CREATETABLESTMT_TOKEN_KIND_TEMPORARY, 0]) {
            [self match:CREATETABLESTMT_TOKEN_KIND_TEMPORARY discard:YES]; 
        } else {
            [self raise:@"No viable alternative found in rule 'tempOpt'."];
        }
        [self execute:^{
         PUSH(@YES); 
        }];
    } else {
        [self matchEmpty:NO]; 
        [self execute:^{
         PUSH(@NO); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchTempOpt:)];
}

- (void)existsOpt_ {
    
    if ([self predicts:CREATETABLESTMT_TOKEN_KIND_IF, 0]) {
        [self match:CREATETABLESTMT_TOKEN_KIND_IF discard:YES]; 
        [self match:CREATETABLESTMT_TOKEN_KIND_NOT_UPPER discard:YES]; 
        [self match:CREATETABLESTMT_TOKEN_KIND_EXISTS discard:YES]; 
        [self execute:^{
         PUSH(@YES); 
        }];
    } else {
        [self matchEmpty:NO]; 
        [self execute:^{
         PUSH(@NO); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExistsOpt:)];
}

@end