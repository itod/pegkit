#import "CreateTableStmtParser.h"
#import <PEGKit/PEGKit.h>

#define LT(i) [self LT:(i)]
#define LA(i) [self LA:(i)]
#define LS(i) [self LS:(i)]
#define LF(i) [self LD:(i)]

#define POP()        [self.assembly pop]
#define POP_STR()    [self popString]
#define POP_TOK()    [self popToken]
#define POP_BOOL()   [self popBool]
#define POP_INT()    [self popInteger]
#define POP_UINT()   [self popUnsignedInteger]
#define POP_FLOAT()  [self popFloat]
#define POP_DOUBLE() [self popDouble]

#define PUSH(obj)      [self.assembly push:(id)(obj)]
#define PUSH_BOOL(yn)  [self pushBool:(BOOL)(yn)]
#define PUSH_INT(i)    [self pushInteger:(NSInteger)(i)]
#define PUSH_UINT(u)   [self pushUnsignedInteger:(NSUInteger)(u)]
#define PUSH_FLOAT(f)  [self pushFloat:(float)(f)]
#define PUSH_DOUBLE(d) [self pushDouble:(double)(d)]

#define EQ(a, b) [(a) isEqual:(b)]
#define NE(a, b) (![(a) isEqual:(b)])
#define EQ_IGNORE_CASE(a, b) (NSOrderedSame == [(a) compare:(b)])

#define MATCHES(pattern, str)               ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:0                                  error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)
#define MATCHES_IGNORE_CASE(pattern, str)   ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:NSRegularExpressionCaseInsensitive error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)

#define ABOVE(fence) [self.assembly objectsAbove:(fence)]
#define EMPTY() [self.assembly isStackEmpty]

#define LOG(obj) do { NSLog(@"%@", (obj)); } while (0);
#define PRINT(str) do { printf("%s\n", (str)); } while (0);

@interface PKParser ()
@property (nonatomic, retain) NSMutableDictionary *tokenKindTab;
@property (nonatomic, retain) NSMutableArray *tokenKindNameTab;
@property (nonatomic, retain) NSString *startRuleName;
@property (nonatomic, retain) NSString *statementTerminator;
@property (nonatomic, retain) NSString *singleLineCommentMarker;
@property (nonatomic, retain) NSString *blockStartMarker;
@property (nonatomic, retain) NSString *blockEndMarker;
@property (nonatomic, retain) NSString *braces;

- (BOOL)popBool;
- (NSInteger)popInteger;
- (double)popDouble;
- (PKToken *)popToken;
- (NSString *)popString;

- (void)pushBool:(BOOL)yn;
- (void)pushInteger:(NSInteger)i;
- (void)pushDouble:(double)d;
@end

@interface CreateTableStmtParser ()

@end

@implementation CreateTableStmtParser { }

- (id)initWithDelegate:(id)d {
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
    [self execute:(id)^{
    
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
    [self execute:(id)^{
    
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
        [self execute:(id)^{
         PUSH(@YES); 
        }];
    } else {
        [self matchEmpty:NO]; 
        [self execute:(id)^{
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
        [self execute:(id)^{
         PUSH(@YES); 
        }];
    } else {
        [self matchEmpty:NO]; 
        [self execute:(id)^{
         PUSH(@NO); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExistsOpt:)];
}

@end