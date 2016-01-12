default: all

all: src/Lexer.hs src/Parser.hs src/AG/AttributeGrammar.hs src/AG/LabellingCata.hs src/AG/PropertyCatas.hs

dev: all
	cd src && ghci Dev

#----------------------------

src/Lexer.hs:
	cd src && alex Lexer.x

src/Parser.hs:
	cd src && happy Parser.y

# uuagc:
#  -H              --haskellsyntax                 Use Haskell like syntax (equivalent to --lckeywords and --doublecolons --genlinepragmas)
#  -d              --data                          generate data type definition
#  -c              --catas                         generate catamorphisms
#  -f              --semfuns                       generate semantic functions
#  -w              --wrappers                      generate wappers for semantic domains
#  -s              --signatures                    generate signatures for semantic functions
src/AG/AttributeGrammar.hs: src/AG/AttributeGrammar.ag
	cd src/AG && uuagc -Hd AttributeGrammar.ag

src/AG/LabellingCata.hs: src/AG/AttributeGrammar.ag src/AG/LabellingCata.ag
	cd src/AG && uuagc -Hcfs LabellingCata.ag

src/AG/PropertyCatas.hs: src/AG/AttributeGrammar.ag src/AG/PropertyCatas.ag
	cd src/AG && uuagc -Hcfws PropertyCatas.ag

#----------------------------

clean:
	rm -f src/AG/*.hs src/Parser.hs src/Lexer.hs src/*.hi src/*.o src/Main

.PHONY: default all clean
