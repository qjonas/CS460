# C++ Compiler
CC		= g++

# C++ Compilerflags
C11 	=	-std=c++11

# Lexical Analyzer Generator
LEX		= flex

# Parser Generator
YACC	= bison 

# Mac Users Library
LIBS	= -L/usr/local/lib -ll

# Linux
#LIBS	= -L/usr/local/lib -lfl -std=c++11 

# CLanguage build objects
BUILDOBJS =  CLanguage.tab.o lex.yy.o SymbolTable.o CommandLineFlags.o 
BUILDOBJS += SymbolType.o Globals.o TokenReductionsLogger.o SymbolInfoUtil.o

CLanguage: $(BUILDOBJS)
	$(CC) $(C11) -o CLanguage $(BUILDOBJS) $(LIBS)

CLanguage.tab.o: CLanguage.tab.cc
	$(CC) $(C11) -c CLanguage.tab.cc

lex.yy.o: lex.yy.cc
	$(CC) -c lex.yy.cc

CLanguage.tab.cc: CLanguage.y
	$(YACC) -d -o CLanguage.tab.cc CLanguage.y

lex.yy.cc: CLanguage.l
	$(LEX) -o lex.yy.cc CLanguage.l

SymbolTable.o: SymbolTable.cc 
	$(CC) $(C11) -c SymbolTable.cc 

CommandLineFlags.o: CommandLineFlags.cpp
	$(CC) $(C11) -c CommandLineFlags.cpp

SymbolType.o: SymbolType.cpp
	$(CC) $(C11) -c SymbolType.cpp -std=c++11

Globals.o: Globals.cpp
	$(CC) -c Globals.cpp

TokenReductionsLogger.o:
	$(CC) $(C11) -c TokenReductionsLogger.cpp

SymbolInfoUtil.o: SymbolInfoUtil.cpp
	$(CC) $(C11) -c SymbolInfoUtil.cpp

clean:
	rm *.o CLanguage.tab.cc CLanguage.tab.hh lex.yy.cc  CLanguage