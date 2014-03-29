#import "TableIndexSpecParser.h"
#import <PEGKit/PEGKit.h>

#define LT(i) [self LT:(i)]
#define LA(i) [self LA:(i)]
#define LS(i) [self LS:(i)]
#define LF(i) [self LD:(i)]

#define POP()            [self.assembly pop]
#define POP_STR()        [self popString]
#define POP_QUOTED_STR() [self popQuotedString]
#define POP_TOK()        [self popToken]
#define POP_BOOL()       [self popBool]
#define POP_INT()        [self popInteger]
#define POP_UINT()       [self popUnsignedInteger]
#define POP_FLOAT()      [self popFloat]
#define POP_DOUBLE()     [self popDouble]

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

@interface TableIndexSpecParser ()

@end

@implementation TableIndexSpecParser { }

- (id)initWithDelegate:(id)d {
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