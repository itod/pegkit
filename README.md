PEGKit
======

PEGKit is a '[Parsing Expression Grammar](http://bford.info/packrat/)' toolkit for iOS and OS X written by [Todd Ditchendorf](http://celestialteapot.com) in Objective-C and released under the [MIT Open Source License](https://tldrlegal.com/license/mit-license).

PEGKit is heavily influced by [ANTLR](http://www.antlr.org/) by Terence Parr and ["Building Parsers with Java"](http://www.amazon.com/Building-Parsers-Java-Steven-Metsker/dp/0201719622) by Steven John Metsker. Also, PEGKit depends on [MGTemplateEngine](http://mattgemmell.com/2008/05/20/mgtemplateengine-templates-with-cocoa) by Matt Gemmell for its templating features.

The PEGKit Framework offers 2 basic services of general interest to Cocoa developers:

1. **String Tokenization** via the Objective-C `PKTokenizer` and `PKToken` classes.
1. **Objective-C parser generation via grammars** - Generate source code for an Objective-C parser class from simple, intuitive, and powerful [BNF](http://en.wikipedia.org/wiki/Backus%E2%80%93Naur_Form)-style grammars (similar to yacc or ANTLR). While parsing, the generated parser will provide callbacks to your Objective-C delegate.

The PEGKit source code is available [on Github](http://github.com/itod/parsekit/).

A tutorial for [using PEGKit in your iOS applications is available on GitHub](https://github.com/itod/PEGKitMiniMathTutorial).

##History

PEGKit is a re-write of an earlier framework by the same author called [ParseKit](http://parsekit.com). ParseKit should generally be considered deprecated, and PEGKit should probably be used for all future development.

* ***[ParseKit](http://parsekit.com)*** produces **dynamic**, **non-deterministic** parsers **at runtime**. The parsers produced by ParseKit exhibit poor (exponential) performance characteristics -- although they have some interesting properties which are useful in very rare circumstances.

* ***PEGKit*** produces **static** ObjC source code for **deterministic** ([PEG](http://en.wikipedia.org/wiki/Parsing_expression_grammar)) memoizing parsers **at design time** which you can then compile into your project. The parsers produced by PEGKit exhibit good (linear) performance characteristics.