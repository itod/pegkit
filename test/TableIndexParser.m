#import "TableIndexParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


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
    PKParser_weakSelfDecl;

    [PKParser_weakSelf qualifiedTableName_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)qualifiedTableName_ {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf name_];
    [PKParser_weakSelf indexOpt_];
    [PKParser_weakSelf execute:^{
    
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
    if ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf databaseName_];[PKParser_weakSelf match:TABLEINDEX_TOKEN_KIND_DOT discard:YES];}]) {
        [PKParser_weakSelf databaseName_];
        [PKParser_weakSelf match:TABLEINDEX_TOKEN_KIND_DOT discard:YES];
    }
    [PKParser_weakSelf tableName_];
    [PKParser_weakSelf execute:^{
    
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
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TABLEINDEX_TOKEN_KIND_INDEXED, TABLEINDEX_TOKEN_KIND_NOT_UPPER, 0]) {
        [PKParser_weakSelf index_];
    } else {
        [PKParser_weakSelf matchEmpty:NO];
        [PKParser_weakSelf execute:^{
         PUSH(@""); 
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchIndexOpt:)];
}

- (void)index_ {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TABLEINDEX_TOKEN_KIND_INDEXED, 0]) {
        [PKParser_weakSelf match:TABLEINDEX_TOKEN_KIND_INDEXED discard:YES];
        [PKParser_weakSelf match:TABLEINDEX_TOKEN_KIND_BY discard:YES];
        [PKParser_weakSelf indexName_];
        [PKParser_weakSelf execute:^{
         
        // now top of stack will be a Quoted String `PKToken`
        // […, <Quoted String «"foo"»>]
		// pop its string value
        NSString *indexName = POP_STR();
        // trim quotes
        indexName = [indexName substringWithRange:NSMakeRange(1, [indexName length]-2)];
        // leave it on the stack for later
        PUSH(indexName);
    
        }];
    } else if ([PKParser_weakSelf predicts:TABLEINDEX_TOKEN_KIND_NOT_UPPER, 0]) {
        [PKParser_weakSelf match:TABLEINDEX_TOKEN_KIND_NOT_UPPER discard:YES];
        [PKParser_weakSelf match:TABLEINDEX_TOKEN_KIND_INDEXED discard:YES];
        [PKParser_weakSelf execute:^{
         PUSH(@""); 
        }];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'index'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchIndex:)];
}

@end