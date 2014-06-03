#import "TableIndexParser.h"
#import <PEGKit/PEGKit.h>


@interface TableIndexParser ()

@end

@implementation TableIndexParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"qualifiedTableName";
        self.tokenKindTab[@"BY"] = @(TABLEINDEX_TOKEN_KIND_BY);
        self.tokenKindTab[@"INDEXED"] = @(TABLEINDEX_TOKEN_KIND_INDEXED);
        self.tokenKindTab[@"NOT"] = @(TABLEINDEX_TOKEN_KIND_NOT_UPPER);
        self.tokenKindTab[@"."] = @(TABLEINDEX_TOKEN_KIND_DOT);

        self.tokenKindNameTab[TABLEINDEX_TOKEN_KIND_BY] = @"BY";
        self.tokenKindNameTab[TABLEINDEX_TOKEN_KIND_INDEXED] = @"INDEXED";
        self.tokenKindNameTab[TABLEINDEX_TOKEN_KIND_NOT_UPPER] = @"NOT";
        self.tokenKindNameTab[TABLEINDEX_TOKEN_KIND_DOT] = @".";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {

    [self qualifiedTableName_]; 
    [self matchEOF:YES]; 

}

- (void)qualifiedTableName_ {
    
    [self name_]; 
    [self indexOpt_]; 
    [self execute:^{
    
    // now stack contains 3 `NSString`s. 
    // ["mydb", "mytable", "foo"]
    // NSString *indexName = POP();
    // NSString *tableName = POP();
    // NSString *dbName = POP();
    // do stuff here

    }];

    [self fireDelegateSelector:@selector(parser:didMatchQualifiedTableName:)];
}

- (void)databaseName_ {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDatabaseName:)];
}

- (void)tableName_ {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchTableName:)];
}

- (void)indexName_ {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchIndexName:)];
}

- (void)name_ {
    
    if ([self speculate:^{ [self databaseName_]; [self match:TABLEINDEX_TOKEN_KIND_DOT discard:YES]; }]) {
        [self databaseName_]; 
        [self match:TABLEINDEX_TOKEN_KIND_DOT discard:YES]; 
    }
    [self tableName_]; 
    [self execute:^{
    
    // now stack contains 2 `PKToken`s of type Word
    // [<Word «mydb»>, <Word «mytable»>]
	// pop their string values
    NSString *tableName = POP_STR();
    NSString *dbName = POP_STR();
    PUSH(dbName);
    PUSH(tableName);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchName:)];
}

- (void)indexOpt_ {
    
    if ([self predicts:TABLEINDEX_TOKEN_KIND_INDEXED, TABLEINDEX_TOKEN_KIND_NOT_UPPER, 0]) {
        [self index_]; 
    } else {
        [self matchEmpty:NO]; 
        [self execute:^{
         PUSH(@""); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchIndexOpt:)];
}

- (void)index_ {
    
    if ([self predicts:TABLEINDEX_TOKEN_KIND_INDEXED, 0]) {
        [self match:TABLEINDEX_TOKEN_KIND_INDEXED discard:YES]; 
        [self match:TABLEINDEX_TOKEN_KIND_BY discard:YES]; 
        [self indexName_]; 
        [self execute:^{
         
        // now top of stack will be a Quoted String `PKToken`
        // […, <Quoted String «"foo"»>]
		// pop its string value
        NSString *indexName = POP_STR();
        // trim quotes
        indexName = [indexName substringWithRange:NSMakeRange(1, [indexName length]-2)];
        // leave it on the stack for later
        PUSH(indexName);
    
        }];
    } else if ([self predicts:TABLEINDEX_TOKEN_KIND_NOT_UPPER, 0]) {
        [self match:TABLEINDEX_TOKEN_KIND_NOT_UPPER discard:YES]; 
        [self match:TABLEINDEX_TOKEN_KIND_INDEXED discard:YES]; 
        [self execute:^{
         PUSH(@""); 
        }];
    } else {
        [self raise:@"No viable alternative found in rule 'index'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchIndex:)];
}

@end