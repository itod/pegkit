#import "TableIndexSpecParser.h"
#import <PEGKit/PEGKit.h>


@interface TableIndexSpecParser ()

@end

@implementation TableIndexSpecParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"qualifiedTableName";
        self.tokenKindTab[@"BY"] = @(TABLEINDEXSPEC_TOKEN_KIND_BY);
        self.tokenKindTab[@"INDEXED"] = @(TABLEINDEXSPEC_TOKEN_KIND_INDEXED);
        self.tokenKindTab[@"NOT"] = @(TABLEINDEXSPEC_TOKEN_KIND_NOT_UPPER);
        self.tokenKindTab[@"."] = @(TABLEINDEXSPEC_TOKEN_KIND_DOT);

        self.tokenKindNameTab[TABLEINDEXSPEC_TOKEN_KIND_BY] = @"BY";
        self.tokenKindNameTab[TABLEINDEXSPEC_TOKEN_KIND_INDEXED] = @"INDEXED";
        self.tokenKindNameTab[TABLEINDEXSPEC_TOKEN_KIND_NOT_UPPER] = @"NOT";
        self.tokenKindNameTab[TABLEINDEXSPEC_TOKEN_KIND_DOT] = @".";

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
    
    [self prefixOpt_]; 
    [self tableName_]; 
    [self execute:^{
    
    NSString *tableName = POP_STR();
    NSString *dbName = POP_STR();
    PUSH(dbName);
    PUSH(tableName);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchName:)];
}

- (void)prefixOpt_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self databaseName_]; 
        [self match:TABLEINDEXSPEC_TOKEN_KIND_DOT discard:YES]; 
        [self execute:^{
         PUSH(POP_STR()); 
        }];
    } else {
        [self matchEmpty:NO]; 
        [self execute:^{
         PUSH(@""); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrefixOpt:)];
}

- (void)indexOpt_ {
    
    if ([self speculate:^{ [self match:TABLEINDEXSPEC_TOKEN_KIND_INDEXED discard:YES]; [self match:TABLEINDEXSPEC_TOKEN_KIND_BY discard:YES]; [self indexName_]; }]) {
        [self match:TABLEINDEXSPEC_TOKEN_KIND_INDEXED discard:YES]; 
        [self match:TABLEINDEXSPEC_TOKEN_KIND_BY discard:YES]; 
        [self indexName_]; 
        [self execute:^{
         
        NSString *indexName = POP_STR();
        indexName = [indexName substringWithRange:NSMakeRange(1, [indexName length]-2)];
        PUSH(indexName);
    
        }];
    } else if ([self speculate:^{ [self match:TABLEINDEXSPEC_TOKEN_KIND_INDEXED discard:YES]; [self match:TABLEINDEXSPEC_TOKEN_KIND_NOT_UPPER discard:YES]; }]) {
        [self match:TABLEINDEXSPEC_TOKEN_KIND_INDEXED discard:YES]; 
        [self match:TABLEINDEXSPEC_TOKEN_KIND_NOT_UPPER discard:YES]; 
        [self execute:^{
         PUSH(@""); 
        }];
    } else {
        [self matchEmpty:NO]; 
        [self execute:^{
         PUSH(@""); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchIndexOpt:)];
}

@end