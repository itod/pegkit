#import "TableIndexSpecParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


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
    PKParser_weakSelfDecl;

    [PKParser_weakSelf qualifiedTableName_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)qualifiedTableName_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf name_];
    [PKParser_weakSelf indexOpt_];
    [PKParser_weakSelf execute:^{
    
    // NSString *indexName = POP();
    // NSString *tableName = POP();
    // NSString *dbName = POP();
    // do stuff here

    }];

    [self fireDelegateSelector:@selector(parser:didMatchQualifiedTableName:)];
}

- (void)databaseName_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchWord:NO];

    [self fireDelegateSelector:@selector(parser:didMatchDatabaseName:)];
}

- (void)tableName_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchWord:NO];

    [self fireDelegateSelector:@selector(parser:didMatchTableName:)];
}

- (void)indexName_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf matchQuotedString:NO];

    [self fireDelegateSelector:@selector(parser:didMatchIndexName:)];
}

- (void)name_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf prefixOpt_];
    [PKParser_weakSelf tableName_];
    [PKParser_weakSelf execute:^{
    
    NSString *tableName = POP_STR();
    NSString *dbName = POP_STR();
    PUSH(dbName);
    PUSH(tableName);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchName:)];
}

- (void)prefixOpt_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [PKParser_weakSelf databaseName_];
        [PKParser_weakSelf match:TABLEINDEXSPEC_TOKEN_KIND_DOT discard:YES];
        [PKParser_weakSelf execute:^{
         PUSH(POP_STR()); 
        }];
    } else {
        [PKParser_weakSelf matchEmpty:NO];
        [PKParser_weakSelf execute:^{
         PUSH(@""); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrefixOpt:)];
}

- (void)indexOpt_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:TABLEINDEXSPEC_TOKEN_KIND_INDEXED discard:YES];[PKParser_weakSelf match:TABLEINDEXSPEC_TOKEN_KIND_BY discard:YES];[PKParser_weakSelf indexName_];}]) {
        [PKParser_weakSelf match:TABLEINDEXSPEC_TOKEN_KIND_INDEXED discard:YES];
        [PKParser_weakSelf match:TABLEINDEXSPEC_TOKEN_KIND_BY discard:YES];
        [PKParser_weakSelf indexName_];
        [PKParser_weakSelf execute:^{
         
        NSString *indexName = POP_STR();
        indexName = [indexName substringWithRange:NSMakeRange(1, [indexName length]-2)];
        PUSH(indexName);
    
        }];
    } else if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf match:TABLEINDEXSPEC_TOKEN_KIND_INDEXED discard:YES];[PKParser_weakSelf match:TABLEINDEXSPEC_TOKEN_KIND_NOT_UPPER discard:YES];}]) {
        [PKParser_weakSelf match:TABLEINDEXSPEC_TOKEN_KIND_INDEXED discard:YES];
        [PKParser_weakSelf match:TABLEINDEXSPEC_TOKEN_KIND_NOT_UPPER discard:YES];
        [PKParser_weakSelf execute:^{
         PUSH(@""); 
        }];
    } else {
        [PKParser_weakSelf matchEmpty:NO];
        [PKParser_weakSelf execute:^{
         PUSH(@""); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchIndexOpt:)];
}

@end