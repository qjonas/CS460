CC	= cc
LEX	= flex
YACC	= bison
LIBS	= -L/usr/local/lib -ll 

OBJS	= lex.yy.o calc.tab.o
TESTOBJS	= driver.o lex.yy.o

calc: $(OBJS)
	$(CC) -o $@ $(OBJS) $(LIBS)

testscan: $(TESTOBJS) calc.tab.h
	$(CC) -o $@ $(TESTOBJS) $(LIBS)

calc.tab.c: calc.y
	$(YACC) -d $<

lex.yy.c: calc.lex calc.tab.c
	$(LEX) $<

clean:
	-rm -f lex.yy.* calc.tab.* *.o calc testscan *~

.SUFFIXES: .c .o

.c.o:
	$(CC) -c $< -o $@
