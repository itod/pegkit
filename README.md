PEGKit
======

PEGKit is a '[Parsing Expression Grammar](http://bford.info/packrat/)' toolkit for iOS and OS X written by [Todd Ditchendorf](http://celestialteapot.com) in Objective-C and released under the [MIT Open Source License](https://tldrlegal.com/license/mit-license).

**Always use the Xcode Workspace `PEGKit.xcworkspace`, *NOT* the Xcode Project.**

This project includes [TDTemplateEngine](https://github.com/itod/tdtemplateengine) as a Git Submodule. So proper cloning of this project requires the `--recursive` argument:

    git clone --recursive git@github.com:itod/pegkit.git

PEGKit is heavily influenced by [ANTLR](http://www.antlr.org/) by Terence Parr and ["Building Parsers with Java"](http://www.amazon.com/Building-Parsers-Java-Steven-Metsker/dp/0201719622) by Steven John Metsker.

The PEGKit Framework offers 2 basic services of general interest to Cocoa developers:

1. **String Tokenization** via the Objective-C `PKTokenizer` and `PKToken` classes.
1. **Objective-C parser generation via grammars** - Generate source code for an Objective-C parser class from simple, intuitive, and powerful [BNF](http://en.wikipedia.org/wiki/Backus%E2%80%93Naur_Form)-style grammars (similar to yacc or ANTLR). While parsing, the generated parser will provide callbacks to your Objective-C delegate.

The PEGKit source code is available [on Github](http://github.com/itod/pegkit/).

A tutorial for [using PEGKit in your iOS applications is available on GitHub](https://github.com/itod/PEGKitMiniMathTutorial).

##History

PEGKit is a re-write of an earlier framework by the same author called [ParseKit](https://github.com/itod/parsekit). ParseKit should generally be considered deprecated, and PEGKit should probably be used for all future development.

* ***[ParseKit](https://github.com/itod/parsekit)*** produces **dynamic**, **non-deterministic** parsers **at runtime**. The parsers produced by ParseKit exhibit poor (exponential) performance characteristics -- although they have some interesting properties which are useful in very rare circumstances.

* ***PEGKit*** produces **static** ObjC source code for **deterministic** ([PEG](http://en.wikipedia.org/wiki/Parsing_expression_grammar)) memoizing parsers **at design time** which you can then compile into your project. The parsers produced by PEGKit exhibit good (linear) performance characteristics.

---
##Documentation

* [Tokenization](#tokenization)
    * [Basic Usage of PKTokenizer](#basic-tokenizer-usage)
    * [Default Behavior of PKTokenizer](#default-tokenizer-behavior)
    * [Customizing PKTokenizer behavior](#custom-tokenizer-behavior)
* [Grammars](#garmmars)
    * [Basic Grammar Syntax](#basic-syntax)
    * [Rules](#rules)
    * [Grouping](#grouping)
    * [Discarding](#discarding)
    * [Actions](#actions)
    * [Rule Actions](#rule-actions)
    * [Grammar Actions](#grammar-actions)
    * [Semantic Predicates](#semantic-predicates)

---
<a name="tokenization"></a>
###Tokenization
---

<a name="basic-tokenizer-usage"></a>
####Basic Usage of PKTokenizer

**PEGKit** provides general-purpose string tokenization services through the **`PKTokenizer`** and **`PKToken`** classes. Cocoa developers will be familiar with the **`NSScanner`** class provided by the Foundation Framework which provides a similar service. However, the `PKTokenizer` class is much easier to use for many common tokenization tasks, and offers powerful configuration options if the default tokenization behavior doesn't match your needs.

<table border="1" cellpadding="5" cellspacing="0" width="100%">
	<tr>
		<th><tt><b>PKTokenizer</b></tt></th>
	</tr>
	<tr>
		<td>
			<p>
			<tt>+ (id)tokenizerWithString:(NSString *)s;</tt><br/>
			</p>
			<p>
				<tt>- (PKToken *)nextToken;</tt><br/>
				<tt>…</tt><br/>
			</p>
		</td>
	</tr>
</table>

To use `PKTokenizer`, provide it with an `NSString` object and retrieve a series of `PKToken` objects as you repeatedly call the `-nextToken` method. The `EOFToken` singleton signals the end.

```objc
NSString *s = @"2 != -47. /* comment */ Blast-off!! 'Woo-hoo!' //comment";

PKTokenizer *t = [PKTokenizer tokenizerWithString:s];
PKToken *eof = [PKToken EOFToken];
PKToken *tok = nil;

while (eof != (tok = [t nextToken])) {
    NSLog(@"(%@) (%.1f) : %@", tok.stringValue, tok.floatValue, [tok debugDescription]);
}
```

Outputs:

```objc
(2) (2.0) : <Number «2»>

(!=) (0.0) : <Symbol «!=»>

(-47) (-47.0) : <Number «-47»>

(.) (0.0) : <Symbol «.»>

(Blast-off) (0.0) : <Word «Blast-off»>

(!) (0.0) : <Symbol «!»>

(!) (0.0) : <Symbol «!»>

('Woo-hoo!') (0.0) : <Quoted String «'Woo-hoo!'»>
```

Each `PKToken` object returned has a `stringValue`, a `floatValue` and a `tokenType`. The tokenType is and enum value type called `PKTokenType` with possible values of:

  * `PKTokenTypeWord`

  * `PKTokenTypeNumber`

  * `PKTokenTypeQuotedString`

  * `PKTokenTypeSymbol`

  * `PKTokenTypeWhitespace`

  * `PKTokenTypeComment`

  * `PKTokenTypeDelimitedString`

`PKToken`s also have corresponding `BOOL` properties for convenience (`isWord`, `isNumber`, etc.)

<table border="1" cellpadding="5" cellspacing="0" width="100%">
	<tr>
		<th><tt><b>PKToken</b></tt></th>
	</tr>
	<tr>
		<td>
			<p>
				<tt>+ (PKToken *)EOFToken;</tt><br/>
			</p>
			<p>
				<tt>@property (readonly) PKTokenType tokenType;</tt><br/>
			</p>
			<p>
				<tt>@property (readonly) CGFloat floatValue;</tt><br/>
				<tt>@property (readonly, copy) NSString *stringValue;</tt><br/>
			</p>
			<p>
				<tt>@property (readonly) BOOL isNumber;</tt><br/>
				<tt>@property (readonly) BOOL isSymbol;</tt><br/>
				<tt>@property (readonly) BOOL isWord;</tt><br/>
				<tt>@property (readonly) BOOL isQuotedString;</tt><br/>
				<tt>@property (readonly) BOOL isWhitespace;</tt><br/>
				<tt>@property (readonly) BOOL isComment;</tt><br/>
				<tt>@property (readonly) BOOL isDelimitedString;</tt><br/>
			</p>
			<p>
				<tt>…</tt><br/>
			</p>
		</td>
	</tr>
</table>

<a name="default-tokenizer-behavior"></a>
####Default Behavior of PKTokenizer

The default behavior of `PKTokenizer` is correct for most common situations and will fit many tokenization needs without additional configuration.

#####Number

Sequences of digits (`«2»` `«42»` `«1054»`) are recognized as `Number` tokens. Floating point numbers containing a dot (`«3.14»`) are recognized as single `Number` tokens as you'd expect (rather than two Number tokens separated by a `«.»` `Symbol` token). By default, `PKTokenizer` will recognize a `«-»` symbol followed immediately by digits (`«-47»`) as a number token with a negative value. However, `«+»` characters are always seen as the beginning of a `Symbol` token by default, even when followed immediately by digits, so "explicitly-positive" `Number` tokens are not recognized by default (this behavior can be configured, see below).

#####Symbol

Most symbol characters (`«.»` `«!»`) are recognized as single-character `Symbol` tokens (even when sequential such as `«!»``«!»`). However, notice that `PKTokenizer` recognizes common multi-character symbols (`«!=»`) as a single `Symbol` token by default. In fact, `PKTokenizer` can be configured to recognize any given string as a multi-character symbol. Alternatively, it can be configured to always recognize each symbol character as an individual `Symbol` token (no multi- character symbols). The default multi-character symbols recognized by `PKTokenizer` are: `«<=»`, `«>=»`, `«!=»`, `«==»`.

#####Word

`«Blast-off»` is recognized as a single `Word` token despite containing a symbol character (`«-»`) that would normally signal the start of a new `Symbol` token. By default, `PKTokenzier` allows `Word` tokens to **contain** (but **not start with**) several symbol and number characters: `«-»`, `«_»`, `«'»`, `«0»`-`«9»`. The consequence of this behavior is that `PKTokenizer` will recognize the following strings as individual Word tokens by default: `«it's»`, `«first_name»`, `«sat-yr-9»` `«Rodham-Clinton»`. Again, you can configure `PKTokenizer` to alter this default behavior.

#####Quoted String

`PKTokenizer` produces `Quoted String` tokens for substrings enclosed in quote delimiter characters. The default delimiters are single- or double-quotes (`«'»` or `«"»`). The quote delimiter characters may be changed (see below), but must be a single character. Note that the stringValue of `Quoted String` tokens include the quote delimiter characters (`«'Woo-hoo!'»`).

#####Whitespace

By default, whitespace characters are silently consumed by `PKTokenizer`, and `Whitespace` tokens are never emitted. However, you can configure which characters are considered whitespace characters or even ask `PKTokenizer` to return `Whitespace` tokens containing the literal whitespace `stringValue`s by setting: `t.whitespaceState.reportsWhitespaceTokens = YES`.

#####Comment

By default, `PKTokenizer` recognizes C-style (`«//»`) and C++-style (`«/*»` `«*/»`) comments and silently removes the associated comments from the output rather than producing `Comment` tokens. See below for steps to either change comment delimiting markers, report `Comment` tokens, or to turn off comments recognition altogether.

#####Delimited String

The `Delimited String` token type is a powerful feature of PEGKit which can be used much like a regular expression. Use the `Delimited String` token type to ask `PKTokenizer` to recognize tokens with arbitrary start and end symbol strings much like a Quoted String but with more power:

  * The start and end symbols may be multi-char (e.g. `«<#»` `«#>»`)
  * The start and end symbols need not match (e.g. `«<?=»` `«?>»`)
  * The characters allowed within the delimited string may be specified using an NSCharacterSet

<a name="custom-tokenizer-behavior"></a>
####Customizing PKTokenizer behavior

There are two basic types of decisions `PKTokenizer` must make when tokenizing strings:

 1. Which token type should be created for a given start character?
 2. Which characters are allowed within the current token being created?

`PKTokenizer`'s behavior with respect to these two types of decisions is totally
configurable. Let's tackle them, starting with the second question first.

#####Changing which characters are allowed within a token of a particular type

Once `PKTokenizer` has decided which token type to create for a given start character (see below), it temporarily passes control to one of its "state" helper objects to finish consumption of characters for the current token. Therefore, the logic for deciding which characters are allowed within a token of a given type is controlled by the "state" objects which are instances of subclasses of the abstract `PKTokenizerState` class: `PKWordState`, `PKNumberState`, `PKQuoteState`, `PKSymbolState`, `PKWhitespaceState`, `PKCommentState`, and `PKDelimitState`. The state objects are accessible via properties of the `PKTokenizer` object.

<table border="1" cellpadding="5" cellspacing="0" width="100%">
	<tr>
		<th><tt><b>PKTokenizer</b></tt></th>
	</tr>
	<tr>
		<td>
			<p>
				<tt>…</tt><br/>
				<tt>@property (readonly, retain) PKWordState *wordState;</tt><br/>
				<tt>@property (readonly, retain) PKNumberState *numberState;</tt><br/>
				<tt>@property (readonly, retain) PKQuoteState *quoteState;</tt><br/>
				<tt>@property (readonly, retain) PKSymbolState *symbolState;</tt><br/>
				<tt>@property (readonly, retain) PKWhitespaceState *whitespaceState;</tt><br/>
				<tt>@property (readonly, retain) PKCommentState *commentState;</tt><br/>
				<tt>@property (readonly, retain) PKDelimitState *delimitState;</tt><br/>
			</p>
		</td>
	</tr>
</table>

Some of the `PKTokenizerState` subclasses have methods that alter which characters are allowed within tokens of their associated token type.

For example, if you want to add a new multiple-character symbol like `«===»`:

```objc
…
PKTokenizer *t = [PKTokenizer tokenizerWithString:s];
[t.symbolState add:@"==="];
…
```

Now `«===»` strings will be recognized as a single Symbol token with a stringValue of `«===»`. There is a corresponding `-[PKSymbolState remove:]` method for removing recognition of given multi-char symbols.

If you don't want to allow digits within Word tokens (digits **are** allowed within Words by default):

```objc
…
[t.wordState setWordChars:NO from:'0' to:'9'];
…
```

Say you want to allow floating-point Number tokens to end with a `«.»`, sans trailing `«0»`. In other words, you want `«49.»` to be recognized as a single `Number` token with a `floatValue` of `«49.0»` rather than a Number token followed by a `Symbol` token with a `stringValue` of `«.»`:

```objc
…
t.numberState.allowsTrailingDot = YES;
…
```

Recognition of scientific notation (exponential numbers) can be enabled to recognize numbers like `«10e+100»`, `«6.626068E-34»` and `«6.0221415e23»`. The resulting `PKToken` objects will have floatValues which represent the full value of the exponential number, yet retain the original exponential representation as their `stringValue`s.

```objc
…
t.numberState.allowsScentificNotation = YES;
…
```

Similarly, recognition of common octal and hexadecimal number notation can be enabled to recognize numbers like `«020»` (octal 16) and `«0x20»` (hex 32).

```objc
…
t.numberState.allowsOctalNotation = YES;
t.numberState.allowsHexadecimalNotation = YES;
…
```

The resulting `PKToken` objects will have a `tokenType` of `PKTokenTypeNumber` and a `stringValue` matching the original source notation (`«020»` or `«0x20»`). Their `floatValues` will represent the normal decimal value of the number (in this case `16` and `32`).

You can also configure which characters are recognized as whitespace within a whitespace token. To treat digits as whitespace characters within whitespace tokens:

```objc
…
[t.whitespaceState setWhitespaceChars:YES from:'0' to:'9'];
…
```

By default, whitespace chars are silently consumed by a tokenizer's `PKWhitespaceState`. To force reporting of `PKToken`s of type `PKTokenTypeWhitespace` containing the encountered whitespace chars as their `stringValues` (e.g. this would be necessary for a typical XML parser in which significant whitespace must be reported):

```objc
…
t.whitespaceState.reportsWhitespaceTokens = YES;
…
```

Similarly, comments are also silently consumed by default. To report `Comment` tokens instead:

```objc
…
t.commentState.reportsCommentTokens = YES;
…
```

#####Changing which token type is created for a given start character

`PKTokenizer` controls the logic for deciding which token type should be created
for a given start character before passing the responsibility for completing
tokens to its "state" helper objects. To change which token type is created
for a given start character, you must call a method of the `PKTokenizer` object
itself: `-[PKTokenizer setTokenizerState:from:to:]`.

<table border="1" cellpadding="5" cellspacing="0" width="100%">
	<tr>
		<th><tt><b>PKTokenizer</b></tt></th>
	</tr>
	<tr>
		<td>
			<p>
				<tt>…</tt>
				<pre>- (void)setTokenizerState:(PKTokenizerState *)state 
                     from:(PKUniChar)start 
                       to:(PKUniChar)end;</pre>
				<tt>…</tt><br/>
			</p>
		</td>
	</tr>
</table>

For example, suppose you want to turn off support for `Number` tokens altogether. To recognize digits as signaling the start of `Word` tokens:

```objc
…
PKTokenizer *t = [PKTokenizerWithString:s];
[t setTokenizerState:t.wordState from:'0' to:'9'];
…
```

This will cause `PKTokenizer` to begin creating a `Word` token (rather than a `Number` token) whenever a digit (`«0»`, `«1»`, `«2»`, `«3»`,`«4»`, `«5»`, `«6»`, `«7»`, `«8»`, `«9»`, `«0»` ) is encountered.

As another example, say you want to add support for new `Quoted String` token delimiters, such as `«#»`. This would cause a string like #oh hai# to be recognized as a `Quoted String`  token rather than a `Symbol`, two `Word`s, and a `Symbol`. Here's how:

```objc
…
[t setTokenizerState:t.quoteState from:'#' to:'#'];
…
```

Note that if the from: and to: arguments are the same char, only behavior for that single char is affected.

Alternatively, say you want to recognize `«+»` characters followed immediately by digits as explicitly positive Number tokens rather than as a Symbol token followed by a `Number` token:

```objc
…
[t setTokenizerState:t.numberState from:'+' to:'+'];
…
```

Finally, customization of comments recognition may be necessary. By default, `PKTokenizer` passes control to its `commentState` object which silently consumes the comment text found after `«//»` or between `«/*»` `«*/»`. This default behavior is achieved with the sequence:

```objc
…
[t setTokenizerState:t.commentState from:'/' to:'/'];
[t.commentState addSingleLineStartSymbol:@"//"];
[t.commentState addMultiLineStartSymbol:@"/*" endSymbol:@"*/"];
…
```

To recognize single-line comments starting with #:

```objc
…
[t setTokenizerState:t.commentState from:'#' to:'#'];
[t.commentState addSingleLineStartSymbol:@"#"];
…
```

To recognize multi-line "XML"- or "HTML"-style comments:

```objc
…
[t setTokenizerState:t.commentState from:'<' to:'<'];
[t.commentState addMultiLineStartSymbol:@"<!--" endSymbol:@"-->"];
…
```

To disable comments recognition altogether, tell `PKTokenizer` to pass control to its `symbolState` instead of its `commentState`.

```objc
…
[t setTokenizerState:t.symbolState from:'/' to:'/'];
…
```

Now `PKTokenizer` will return individual Symbol tokens for all `«/»` and `«*»` characters, as well as any other characters set as part of a comment start or end symbol.

---
<a name="grammars"></a>
###Grammars

<a name="basic-syntax"></a>
####Basic Grammar Syntax

PEGKit allows users to build parsers for custom languages from a declarative, BNF-style grammar without writing any code. By inserting your grammar into the **ParserGen.app** application, Objective-C source code is generated which contains a parser for your language – specifically, a subclass of `PKParser`.

The grammar below describes a simple toy language called ***Cold Beer*** and will serve as a quick introduction to the PEGKit grammar syntax. The rules of the *Cold Beer* language are as follows. The language consists of a sequence of one or more sentences beginning with the word `»cold«` followed by a repetition of either `»cold«` or `»freezing«` followed by `»beer«` and terminated by the symbol `».«`.

For example, each of the following lines are valid instances of the *Cold Beer* language (as is the example as a whole):

    cold cold cold freezing cold freezing cold beer.
    cold cold freezing cold beer.
    cold freezing beer.
    cold beer.

The following lines are ***not*** valid *Cold Beer* statements:

    freezing cold beer.
    cold freezing beer
    beer.

Here is a complete PEGKit grammar for the *Cold Beer* language.

    start = sentence+;
    sentence = adjectives 'beer' '.';
    adjectives = cold adjective*;
    adjective = cold | freezing;
    cold = 'cold';
    freezing = 'freezing';

As shown above, the PEGKit grammar syntax consists of individual language production declarations separated by `»;«`. Whitespace is ignored, so the productions can be formatted liberally with whitespace as the programmer prefers. Comments are also allowed and resemble the comment style of Objective-C. So a commented *Cold Beer* grammar may appear as:

    /*
        A Grammar for the Cold Beer Language
        by Todd Ditchendorf
    */
    start = sentence+;     // outermost production
    sentence = adjectives 'beer' '.';
    adjectives = cold adjective*;
    adjective = cold | 'freezing';
    cold = 'cold';
    freezing = 'freezing';

<a name="rules"></a>
####Rules

Every PEGKit grammar begins with the *highest-level* or *outermost* rule in the language. This rule must be declared first, but it may have any name you like. For *Cold Beer*, the outermost rule is:

    start = sentence+;

Which states that the outermost rule of this language consists of a *sequence* of one or more (`»+«`) instances of the `sentence` rule.

    sentence = adjectives 'beer' '.';

The `sentence` rule states that sentences are a *sequence* of the `adjective` rule followed by the literal strings `beer` and `.`

    adjectives = cold adjective*;

In turn, `adjectives` is a *sequence* of a single instance of the `cold` rule followed by a *repetition* (`»*«` read as 'zero or more') of the `adjective` rule.

    adjective = cold | freezing;
    cold = 'cold';
    freezing = 'freezing';

The `adjective` rule is an *alternation* of either an instance of the `cold` or the `freezing` rule. The `cold` rule is the literal string `cold` and `freezing` the literal string `freezing`.

<a name="grouping"></a>
####Grouping

A language may be expressed in many different, yet equivalent grammars. Rules may be referenced in any order (even before they are defined) and grouped using parentheses (`»(«` and `»)«`).

For example, the *Cold Beer* language could also be represented by the following grammar:

    start = ('cold' ('cold' | 'freezing')* 'beer' '.')+;

<a name="discarding"></a>
####Discarding

The post-fix `!` operator can be used to discard a token which is not needed to compute a result. 

Example:

    addExpr = atom ('+'! atom)*;
    atom = Number;
 
 The `+` token will not be necessary to calculate the result of matched addition expressions, so we can discard it.
 
<a name="actions"></a>
####Actions

Actions are small pieces of Objective-C source code embedded directly in a PEGKit grammar rule. Actions are enclosed in curly braces and placed after any rule reference.

In any action, there is a `self.assembly` object available (of type `PKAssembly`) which serves as a **stack** (via the `PUSH()` and `POP()` convenience macros). The assembly's stack contains the most recently parsed tokens (instances of `PKToken`), and also serves as a place to store your work as you compute the result.

Actions are executed immediately after their preceding rule reference matches. So tokens which have recently been matched are available at the top of the assembly's stack.

Example 1:

    // matches addition expressions like `1 + 3 + 4`
    addExpr  = atom plusAtom*;
    
    plusAtom = '+'! atom
    {
        PUSH_DOUBLE(POP_DOUBLE() + POP_DOUBLE());
    };
    
    atom     = Number
    {
        // pop the double value of token on the top of the stack
        // and push it back as a double value 
        PUSH_DOUBLE(POP_DOUBLE()); 
    };


Example 2:

    // matches or expressions like `foo or bar` or `foo || bar || baz`
    orExpr = item (or item {
        id rhs = POP();
        id lhs = POP();
        MyOrNode *orNode = [MyOrNode nodeWithChildren:lhs, rhs];
        PUSH(orNode);
    })*;
    or    =  'or'! | '||'!;
    item  = Word;

<a name="rule-actions"></a>
####Rule Actions
* **`@before`** - setup code goes here. executed before parsing of this rule begins.
* **`@after`** - tear down code goes here. executed after parsing of this rule ends.

Rule actions are placed inside a rule -- after the rule name, but before the `=` sign.

Example:

    // matches things like `-1` or `---1` or `--------1`
    
    @extension { // this is a "Grammar Action". See below.
        @property (nonatomic) BOOL negative;
    }
    
    unaryExpr 
    @before { _negative = NO; }
    @after  {
        double d = POP_DOUBLE();
        d = (_negative) ? -d : d;
        PUSH_DOUBLE(d);
    }
        = ('-'! { _negative = !_negative; })+ num;
    num = Number;

<a name="grammar-actions"></a>
####Grammar Actions
PEGKit has a feature inspired by ANTLR called **"Grammar Actions"**. Grammar Actions are a way to do exactly what you are looking for: inserting arbitrary code in various places in your Parser's .h and .m files. They must be placed at the top of your grammar before any rules are listed.

Here are all of the Grammar Actions currently available, along with a description of where their bodies are inserted in the source code of your generated parser:

#####**In the .h file:**
* **`@h`** - top of .h file
* **`@interface`** - inside the `@interface` portion of header

#####**In the .m file:**
* **`@m`** - top of .m file
* **`@extension`** - inside a private `@interface MyParser ()` class extension in the .m file
* **`@ivars`** - private ivars inside the `@implementation MyParser {}` in the .m file
* **`@implementation`** - inside your parser's `@implementation`. A place for defining methods.
* **`@init`** - inside your parser's `init` method
* **`@dealloc`** - inside your parser's `dealloc` method if ARC is not enabled
* **`@before`** - setup code goes here. executed before parsing begins.
* **`@after`** - tear down code goes here. executed after parsing ends.

(notice that the `@before` and `@after` Grammar Actions listed here are distinct from the `@before` and `@after` which may also be placed in each individual rule.)

<a name="semantic-predicates"></a>
####Semantic Predicates
Semantic Predicates are another feature lifted directly from ANTLR. Consider:

    lowercaseWord = { islower([LS(1) characterAtIndex:0]) }? Word;

The Semantic Predicate part is the `{ ... }?`. Like Grammar Actions, Semantic Predicates are small snippets of Objective-C code embedded directly in your grammar. These can be placed anywhere in your grammar rules. They should contain either a single expression or a series of statements ending in a `return` statement which evaluates to a boolean value. This one contains a single expression. If the expression evaluates to **false**, matching of the current rule (`lowercaseWord` in this case) will **fail**. A **true** value will allow matching to proceed.

There are also a number of convenience macros defined for your use in Predicates and Actions.

* `LS(num)` will fetch a **Lookahead String** and the argument specifies how far to lookahead. So `LS(1)` means lookahead by `1`. In other words, "fetch the string value of the first upcoming token the parser is about to try to match".

* `MATCHES_IGNORE_CASE(str, regexPattern)` is a convenience macro to do regex matches. It has a case-sensitive friend: `MATCHES(str, regexPattern)`. The second argument is an `NSString*` regex pattern. Meaning should be obvious.
