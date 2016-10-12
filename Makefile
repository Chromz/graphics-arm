
all: main.o graphics.o bg.o physics.o char_sprites.o keyboard.o pixel.o
	gcc -g main.o bg.o graphics.o physics.o char_sprites.o keyboard.o pixel.o -o main.out
main.o: src/main.s
	gcc -g -c src/main.s
bg.o: src/bg.s
	gcc -g -c src/bg.s
graphics.o: src/graphics.s
	gcc -g -c src/graphics.s
physics.o: src/physics.s
	gcc -g -c src/physics.s
char_sprites.o: src/char_sprites.s
	gcc -g -c src/char_sprites.s
keyboard.o: src/keyboard.c
	gcc -g -c src/keyboard.c
pixel.o: src/pixel.c
	gcc -g -c src/pixel.c
clean:
	rm -rf *o main.out