#import "ElementParser.h"
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>


@interface ElementParser ()

@property (nonatomic, retain) NSMutableDictionary *lists_memo;
@property (nonatomic, retain) NSMutableDictionary *list_memo;
@property (nonatomic, retain) NSMutableDictionary *elements_memo;
@property (nonatomic, retain) NSMutableDictionary *element_memo;
@property (nonatomic, retain) NSMutableDictionary *lbracket_memo;
@property (nonatomic, retain) NSMutableDictionary *rbracket_memo;
@property (nonatomic, retain) NSMutableDictionary *comma_memo;
@end

@implementation ElementParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"lists";
        self.tokenKindTab[@"["] = @(ELEMENT_TOKEN_KIND_LBRACKET);
        self.tokenKindTab[@"]"] = @(ELEMENT_TOKEN_KIND_RBRACKET);
        self.tokenKindTab[@","] = @(ELEMENT_TOKEN_KIND_COMMA);

        self.tokenKindNameTab[ELEMENT_TOKEN_KIND_LBRACKET] = @"[";
        self.tokenKindNameTab[ELEMENT_TOKEN_KIND_RBRACKET] = @"]";
        self.tokenKindNameTab[ELEMENT_TOKEN_KIND_COMMA] = @",";

        self.lists_memo = [NSMutableDictionary dictionary];
        self.list_memo = [NSMutableDictionary dictionary];
        self.elements_memo = [NSMutableDictionary dictionary];
        self.element_memo = [NSMutableDictionary dictionary];
        self.lbracket_memo = [NSMutableDictionary dictionary];
        self.rbracket_memo = [NSMutableDictionary dictionary];
        self.comma_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.lists_memo = nil;
    self.list_memo = nil;
    self.elements_memo = nil;
    self.element_memo = nil;
    self.lbracket_memo = nil;
    self.rbracket_memo = nil;
    self.comma_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_lists_memo removeAllObjects];
    [_list_memo removeAllObjects];
    [_elements_memo removeAllObjects];
    [_element_memo removeAllObjects];
    [_lbracket_memo removeAllObjects];
    [_rbracket_memo removeAllObjects];
    [_comma_memo removeAllObjects];
}

- (void)start {
    PKParser_weakSelfDecl;

    [PKParser_weakSelf lists_];
    [PKParser_weakSelf matchEOF:YES];

}

- (void)__lists {
    PKParser_weakSelfDecl;
    do {
        [PKParser_weakSelf list_];
    } while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf list_];}]);

    [self fireDelegateSelector:@selector(parser:didMatchLists:)];
}

- (void)lists_ {
    [self parseRule:@selector(__lists) withMemo:_lists_memo];
}

- (void)__list {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf lbracket_];
    [PKParser_weakSelf elements_];
    [PKParser_weakSelf rbracket_];

    [self fireDelegateSelector:@selector(parser:didMatchList:)];
}

- (void)list_ {
    [self parseRule:@selector(__list) withMemo:_list_memo];
}

- (void)__elements {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf element_];
    while ([PKParser_weakSelf speculate:^{ [PKParser_weakSelf comma_];[PKParser_weakSelf element_];}]) {
        [PKParser_weakSelf comma_];
        [PKParser_weakSelf element_];
    }

    [self fireDelegateSelector:@selector(parser:didMatchElements:)];
}

- (void)elements_ {
    [self parseRule:@selector(__elements) withMemo:_elements_memo];
}

- (void)__element {
    PKParser_weakSelfDecl;
    if ([PKParser_weakSelf predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [PKParser_weakSelf matchNumber:NO];
    } else if ([PKParser_weakSelf predicts:ELEMENT_TOKEN_KIND_LBRACKET, 0]) {
        [PKParser_weakSelf list_];
    } else {
        [PKParser_weakSelf raise:@"No viable alternative found in rule 'element'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchElement:)];
}

- (void)element_ {
    [self parseRule:@selector(__element) withMemo:_element_memo];
}

- (void)__lbracket {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:ELEMENT_TOKEN_KIND_LBRACKET discard:NO];

    [self fireDelegateSelector:@selector(parser:didMatchLbracket:)];
}

- (void)lbracket_ {
    [self parseRule:@selector(__lbracket) withMemo:_lbracket_memo];
}

- (void)__rbracket {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:ELEMENT_TOKEN_KIND_RBRACKET discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchRbracket:)];
}

- (void)rbracket_ {
    [self parseRule:@selector(__rbracket) withMemo:_rbracket_memo];
}

- (void)__comma {
    PKParser_weakSelfDecl;
    [PKParser_weakSelf match:ELEMENT_TOKEN_KIND_COMMA discard:YES];

    [self fireDelegateSelector:@selector(parser:didMatchComma:)];
}

- (void)comma_ {
    [self parseRule:@selector(__comma) withMemo:_comma_memo];
}

@end