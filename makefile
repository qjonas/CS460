# C++ Compiler
CC		= g++

# Lexical Analyzer Generator
LEX		= flex

# Parser Generator
YACC	= bison 

# Mac Users Library
LIBS	= -L/usr/local/lib -ll -std=c++11 

# Linux
#LIBS	= -L/usr/local/lib -lfl -std=c++11 

c_lang: c_lang.tab.o lex.yy.o SymbolTable.o
	$(CC) -o c_lang c_lang.tab.o lex.yy.o SymbolTable.o $(LIBS)

c_lang.tab.o: c_lang.tab.cc
	$(CC) -c c_lang.tab.cc

lex.yy.o: lex.yy.cc
	$(CC) -c lex.yy.cc

c_lang.tab.cc: c_lang.y
	$(YACC) -d -o c_lang.tab.cc c_lang.y

lex.yy.cc: c_lang.l
	$(LEX) -o lex.yy.cc c_lang.l

SymbolTable.o: SymbolTable.cc
	$(CC) -c SymbolTable.cc -std=c++11

clean:
	rm c_lang.tab.* lex.yy.* *.o c_lang