default: all

ag_files: $(patsubst %.ag,%.hs,$(wildcard src/AG/*.ag))

all: src/Parsing/Lexer.hs \
	src/Parsing/Parser.hs \
	ag_files

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

src/AG/%.hs : src/AG/AttributeGrammar.ag src/AG/%.ag
	cd src/AG && uuagc -Hcfws $*.ag

#----------------------------

clean:
	rm -f src/AG/*.hs src/Parsing/*.hs src/Main
	find src -name '*.hi' -delete
	find src -name '*.o' -delete

.PHONY: default all clean
