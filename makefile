CC	= g++
LEX	= flex
YACC	= bison
LIBS	= -L/usr/local/lib -ll 

c_lang: c_lang.tab.o lex.yy.o
	$(CC) -o c_lang c_lang.tab.o lex.yy.o $(LIBS)

c_lang.tab.o: c_lang.tab.cc
	$(CC) -c c_lang.tab.cc

lex.yy.o: lex.yy.cc
	$(CC) -c lex.yy.cc

c_lang.tab.cc: c_lang.y
	$(YACC) -d -o c_lang.tab.cc c_lang.y

lex.yy.cc: c_lang.l
	$(LEX) -o lex.yy.cc c_lang.l

clean:
	rm c_lang.tab.* lex.yy.* *.o

# c_lang: $(OBJS)
# 	$(CC) -o $@ $(OBJS) $(LIBS)

# testscan: $(TESTOBJS) c_lang_tab.h
# 	$(CC) -o $@ $(TESTOBJS) $(LIBS)

# c_lang_tab.cc: c_lang.y
# 	$(YACC) -d $<

# lex.yy.cc: c_lang.l c_lang.tab.cc
# 	$(LEX) $<

# clean:
# 	-rm -f lex.yy.* calc.tab.* *.o calc testscan *~

# .SUFFIXES: .c .o

# .c.o:
# 	$(CC) -c $< -o $@
