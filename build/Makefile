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
BUILDOBJS =  ../bin/CLanguage.tab.o ../bin/lex.yy.o 
BUILDOBJS += ../bin/SymbolTable.o ../bin/CommandLineFlags.o 
BUILDOBJS += ../bin/Globals.o ../bin/TokenReductionsLogger.o 
BUILDOBJS += ../bin/SymbolInfoUtil.o

all: ../bin/CLanguage.out ../bin/SymbolTableDriver.out

../bin/CLanguage.out: $(BUILDOBJS)
	$(CC) $(C11) -o ../bin/CLanguage.out $(BUILDOBJS) $(LIBS)

../bin/CLanguage.tab.o: ../bin/CLanguage.tab.cc
	$(CC) $(C11) -c $< -o $@

../bin/lex.yy.o: ../bin/lex.yy.cc
	$(CC) -c $< -o $@

../bin/CLanguage.tab.cc: ../src/flex_bison/CLanguage.y
	$(YACC) -d -o $@ $<

../bin/lex.yy.cc: ../src/flex_bison/CLanguage.l
	$(LEX) -o $@ $<

../bin/SymbolTable.o: ../src/symbol_table/SymbolTable.cc 
	$(CC) $(C11) -c $< -o $@

../bin/CommandLineFlags.o: ../src/helpers/CommandLineFlags.cpp
	$(CC) $(C11) -c $< -o $@

../bin/Globals.o: ../src/flex_bison/Globals.cpp
	$(CC) -c $< -o $@

../bin/TokenReductionsLogger.o: ../src/helpers/TokenReductionsLogger.cpp
	$(CC) $(C11) -c $< -o $@

../bin/SymbolInfoUtil.o: ../src/symbol_table/SymbolInfoUtil.cpp
	$(CC) $(C11) -c $< -o $@

../bin/SymbolTableDriver.out: 
	$(CC) $(C11) $< ../src/symbol_table/SymbolTableDriver.cpp ../bin/SymbolTable.o -o $@

clean:
	rm $(BUILDOBJS) ../bin/CLanguage.tab.cc ../bin/CLanguage.tab.hh ../bin/lex.yy.cc
	rm ../bin/SymbolTableDriver.out