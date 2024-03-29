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

# Linux Library
#LIBS	= -L/usr/local/lib -lfl -std=c++11 

# Main target executable files
TARGET = ../bin/CLanguage.out ../bin/SymbolTableDriver.out
TARGET += ../bin/TicketCoutner_test.out

# CLanguage build objects
MAINOBJS =  ../bin/CLanguage.tab.o ../bin/lex.yy.o 
MAINOBJS += ../bin/SymbolTable.o ../bin/CommandLineFlags.o 
MAINOBJS += ../bin/Globals.o ../bin/TokenReductionsLogger.o 
MAINOBJS += ../bin/SymbolInfoUtil.o ../bin/Node.o ../bin/TicketCounter.o
MAINOBJS += ../bin/LineStore.o ../bin/ThreeACtoASM.o

# Cleanup
CLEAN = ../bin/CLanguage.tab.cc ../bin/CLanguage.tab.hh ../bin/lex.yy.cc
CLEAN += ../bin/*.dot ../bin/*.png

all: $(TARGET)

../bin/CLanguage.out: $(MAINOBJS)
	$(CC) $(C11) $(HEADERS) -o ../bin/CLanguage.out $(MAINOBJS) $(LIBS)

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

../bin/Globals.o: ../src/flex_bison/Globals.cpp ../bin/Node.o
	$(CC) -c $< -o $@

../bin/TokenReductionsLogger.o: ../src/helpers/TokenReductionsLogger.cpp
	$(CC) $(C11) -c $< -o $@

../bin/SymbolInfoUtil.o: ../src/symbol_table/SymbolInfoUtil.cpp
	$(CC) $(C11) -c $< -o $@

../bin/SymbolTableDriver.out: ../src/symbol_table/SymbolTableDriver.cpp
	$(CC) $(C11) $< ../bin/SymbolTable.o -o $@

../bin/Node.o: ../src/abstract_syntax_tree/Node.cpp ../bin/TicketCounter.o ../bin/SymbolInfoUtil.o ../bin/LineStore.o
	$(CC) $(C11) -c $< -o $@

# ../bin/Node_test.out: ../src/abstract_syntax_tree/Node_test.cpp
# 	$(CC) $(C11) $< ../bin/Node.o ../bin/TicketCounter.o ../bin/SymbolInfoUtil.o -o $@

../bin/TicketCounter.o: ../src/helpers/TicketCounter.cpp
	$(CC) $(C11) -c $< -o $@

../bin/TicketCoutner_test.out: ../src/helpers/TicketCounter_test.cpp
	$(CC) $(C11) $< ../bin/TicketCounter.o -o $@

../bin/LineStore.o: ../src/helpers/LineStore.cpp
	$(CC) $(C11) -c $< -o $@

../bin/ThreeACtoASM.o: ../src/ThreeACtoASM.cpp
	$(CC) $(C11) -c $< -o $@


clean:
	rm $(MAINOBJS) $(CLEAN) $(TARGET)