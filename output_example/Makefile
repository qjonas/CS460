CC	= g++
LEX	= flex
YACC	= bison
LIBS	= -L/usr/local/lib -ll -std=c++11

calc: lex.yy.o calc.tab.o
	$(CC) -o calc lex.yy.o calc.tab.o TokenReductionsLogger.o $(LIBS) 

lex.yy.o: lex.yy.c TokenReductionsLogger.o
	$(CC) -c lex.yy.c $(LIBS)

calc.tab.o: calc.tab.c TokenReductionsLogger.o
	$(CC) -c calc.tab.c $(LIBS)

TokenReductionsLogger.o:
	$(CC) -c ../TokenReductionsLogger.cpp $(LIBS)

calc.tab.c: calc.y
	$(YACC) -d $<

lex.yy.c: calc.lex calc.tab.c
	$(LEX) $<

clean:
	-rm -f lex.yy.* calc.tab.* *.o calc testscan *~
