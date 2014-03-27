#import "TableIndexParser.h"
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
#define POP_DOUBLE() [self popDouble]

#define PUSH(obj)      [self.assembly push:(id)(obj)]
#define PUSH_BOOL(yn)  [self pushBool:(BOOL)(yn)]
#define PUSH_INT(i)    [self pushInteger:(NSInteger)(i)]
#define PUSH_DOUBLE(d) [self pushDouble:(double)(d)]

#define EQ(a, b) [(a) isEqual:(b)]
#define NE(a, b) (![(a) isEqual:(b)])
#define EQ_IGNORE_CASE(a, b) (NSOrderedSame == [(a) compare:(b)])

#define MATCHES(pattern, str)               ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:0                                  error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)
#define MATCHES_IGNORE_CASE(pattern, str)   ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:NSRegularExpressionCaseInsensitive error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)

#define ABOVE(fence) [self.assembly objectsAbove:(fence)]

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

@interface TableIndexParser ()
@end

@implementation TableIndexParser

- (id)initWithDelegate:(id)d {
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

- (void)start {
    [self qualifiedTableName_]; 
    [self matchEOF:YES]; 
}

- (void)qualifiedTableName_ {
    
    [self name_]; 
    [self indexOpt_]; 
    [self execute:(id)^{
    
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
    [self execute:(id)^{
    
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
        [self execute:(id)^{
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
        [self execute:(id)^{
         
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
        [self execute:(id)^{
         PUSH(@""); 
        }];
    } else {
        [self raise:@"No viable alternative found in rule 'index'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchIndex:)];
}

@end