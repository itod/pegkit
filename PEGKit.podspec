Pod::Spec.new do |s|

  s.name         = "PEGKit"
  s.version      = "0.4.2"
  s.summary      = "Parsing Expression Grammar toolkit for iOS and OS X"

  s.description  = <<-DESC
                   PEGKit is a 'Parsing Expression Grammar' toolkit for iOS and OS X written by Todd Ditchendorf in Objective-C and released under the MIT Open Source License.

                   PEGKit is heavily influenced by ANTLR by Terence Parr and "Building Parsers with Java" by Steven John Metsker.

                   The PEGKit Framework offers 2 basic services of general interest to Cocoa developers:

                   1. String Tokenization via the Objective-C PKTokenizer and PKToken classes.

                   2. Objective-C parser generation via grammars - Generate source code for an Objective-C parser class from simple, intuitive, and powerful BNF-style grammars (similar to yacc or ANTLR). While parsing, the generated parser will provide callbacks to your Objective-C delegate.
                   DESC

  s.homepage     = "https://github.com/itod/pegkit"
  s.license      = { :type => 'MIT', :file => "SOFTWARE_LICENSE" }
  s.author       = { "Todd Ditchendorf" => "http://celestialteapot.com/" }
  
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  s.source       = { :git => "https://github.com/itod/pegkit.git", :tag => "v0.4.2" }
  s.source_files = "src/**/*.{h,m}", "include/**/*.{h,m}"
  s.prefix_header_file  = "PEGKit_Prefix.pch"
  s.public_header_files = "include/**/*.h"
  s.requires_arc = false
  s.ios.frameworks = "Foundation"
  s.osx.frameworks = "Foundation"

end
