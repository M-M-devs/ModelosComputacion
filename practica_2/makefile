LDFLAGS:=-L/usr/local/opt/flex/lib
CPPFLAGS:=-I/usr/local/opt/flex/include

all:
	flex analizador.lex
	gcc $(LDFLAGS) $(CPPFLAGS) lex.yy.c -o prog -lfl
	./prog < main.txt

incorrecto:
	flex analizador.lex
	gcc $(LDFLAGS) $(CPPFLAGS) lex.yy.c -o prog -lfl
	./prog < main_error.txt

clean:
	rm -rf lex.yy.c prog*