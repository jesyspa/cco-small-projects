default: all

all: src/Parsing/Lexer.hs \
	src/Parsing/Parser.hs \
	src/AG/AttributeGrammar.hs \
	src/AG/LabellingCata.hs \
	src/AG/PropertyCatas.hs \
	src/AG/PrettyPrintCatas.hs \
	src/AG/ConstantPropagation.hs \
	src/AG/ApplyConstantPropagation.hs

dev: all
	cd src && ghci Dev

#----------------------------

src/Parsing/Lexer.hs: src/Parsing/Lexer.x
	cd src/Parsing && alex Lexer.x

src/Parsing/Parser.hs: src/Parsing/Parser.y
	cd src/Parsing && happy Parser.y

# uuagc:
#  -H              --haskellsyntax                 Use Haskell like syntax (equivalent to --lckeywords and --doublecolons --genlinepragmas)
#  -d              --data                          generate data type definition
#  -c              --catas                         generate catamorphisms
#  -f              --semfuns                       generate semantic functions
#  -w              --wrappers                      generate wappers for semantic domains
#  -s              --signatures                    generate signatures for semantic functions
src/AG/AttributeGrammar.hs: src/AG/AttributeGrammar.ag
	cd src/AG && uuagc -Hd AttributeGrammar.ag

# TODO: Make a rule for this.

src/AG/LabellingCata.hs: src/AG/AttributeGrammar.ag src/AG/LabellingCata.ag
	cd src/AG && uuagc -Hcfws LabellingCata.ag

src/AG/PropertyCatas.hs: src/AG/AttributeGrammar.ag src/AG/PropertyCatas.ag
	cd src/AG && uuagc -Hcfws PropertyCatas.ag

src/AG/PrettyPrintCatas.hs: src/AG/AttributeGrammar.ag src/AG/PrettyPrintCatas.ag
	cd src/AG && uuagc -Hcfws PrettyPrintCatas.ag

src/AG/ConstantPropagation.hs: src/AG/AttributeGrammar.ag src/AG/ConstantPropagation.ag
	cd src/AG && uuagc -Hcfws ConstantPropagation.ag

src/AG/ApplyConstantPropagation.hs: src/AG/AttributeGrammar.ag src/AG/ApplyConstantPropagation.ag
	cd src/AG && uuagc -Hcfws ApplyConstantPropagation.ag

#----------------------------

clean:
	rm -f src/AG/*.hs src/Parsing/*.hs src/Main
	find src -name '*.hi' -delete
	find src -name '*.o' -delete

.PHONY: default all clean
