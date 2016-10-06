
all: main.o sprites.o graphics.o pixel.o keyboard.o
	gcc -g main.o sprites.o graphics.o pixel.o keyboard.o -o main.out

main.o: src/main.s
	gcc -g -c src/main.s
sprites.o: src/sprites.s
	gcc -g -c src/sprites.s
graphics.o: src/graphics.s
	gcc -g -c src/graphics.s
pixel.o: src/pixel.c
	gcc -g -c src/pixel.c
keyboard.o: src/keyboard.c
	gcc -g -c src/keyboard.c
clean:
	rm *o main