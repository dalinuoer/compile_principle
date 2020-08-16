# c/Users/Qin/Documents/GitHub/compile_principle/exp04
b5.exe: parsetest.o parser.tab.o lex.yy.o errormsg.o util.o 
	gcc -o b5.exe parsetest.o parser.tab.o lex.yy.o errormsg.o util.o

parsetest.o: parsetest.c errormsg.h util.h
	gcc -c parsetest.c

parser.tab.o: parser.tab.c util.h errormsg.h
	gcc -c parser.tab.c

parser.tab.c: parser.y
	bison -dv parser.y

parser.tab.h: parser.tab.c
	echo "parser.tab.h was created at the same time as parser.tab.c"

errormsg.o: errormsg.c errormsg.h util.h
	gcc -c errormsg.c


lex.yy.o: lex.yy.c parser.tab.h errormsg.h util.h
	gcc -c lex.yy.c

lex.yy.c: parser.l
	flex parser.l

util.o: util.c util.h
	gcc -c util.c

#测试例test0.p
test00:
	./b5.exe testcases/test0.p

#测试例test1.p
test01:
	./b5.exe testcases/test1.p

clean: 
	rm -f b5.exe util.o parsetest.o lex.yy.o errormsg.o parser.tab.c parser.tab.h parser.tab.o *.stackdump parser.output *.out *.bak

