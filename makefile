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

CLanguage: CLanguage.tab.o lex.yy.o SymbolTable.o FrontendFlags.o
	$(CC) -o CLanguage CLanguage.tab.o lex.yy.o SymbolTable.o $(LIBS)

CLanguage.tab.o: CLanguage.tab.cc
	$(CC) -c CLanguage.tab.cc

lex.yy.o: lex.yy.cc
	$(CC) -c lex.yy.cc

CLanguage.tab.cc: CLanguage.y
	$(YACC) -d -o CLanguage.tab.cc CLanguage.y

lex.yy.cc: CLanguage.l
	$(LEX) -o lex.yy.cc CLanguage.l

SymbolTable.o: SymbolTable.cc
	$(CC) -c SymbolTable.cc -std=c++11

FrontendFlags.o: FrontendFlags.cpp
	$(CC) -c FrontendFlags.cpp

clean:
	rm *.o CLanguage.tab.cc CLanguage.tab.hh lex.yy.cc  CLanguage