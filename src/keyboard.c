 /*********************************************************
 * Autores: Jose Rodrigo Custodio, Alejandro Chaclan      *
 * Taller de Assembler, Seccion: 30                       *
 * Descripcion:                                           *
 *  Pseudo-driver de teclado, debido a la falta de tiempo *
 *  no fue posible realizar un driver, por lo que         *
 *  se modifico  el comportamiento de la consola de linux *
 *  y la syscall  read                                    *
 *                                                        *
 *                                                        *
 *                                                        *
 *                                                        *
 *                                                        *
 *                                                        *
 *                                                        *
 **********************************************************
 */
#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>

struct termios config_actual;
struct termios config_nueva;

/*
*
* Funcion encargada de colocar la consola de linux
* en raw mode, es decir que no tenga que esperar el caracter '\n'
* para leer del buffer stdin
*/
void enable_key_config()
{
    tcgetattr(fileno(stdin), &config_actual); // Cargar a la estructura la configuraciond de la terminal
    memcpy(&config_nueva, &config_actual, sizeof(struct termios)); // Copiar a la nueva esttructura
    config_nueva.c_lflag &= ~(ECHO|ICANON); // Eliminar la impresion en la consola mientras se lee
    config_nueva.c_cc[VTIME] = 0; // Cambiar atributo para que el poll sea inmediato (indica la cant de tiempo en intervalos de 0.1s)
    config_nueva.c_cc[VMIN] = 0; // Cambiar atributo para que el poll sea inmediato (indica la cant min de chars)
    tcsetattr(fileno(stdin), TCSANOW, &config_nueva); // Colocar la nueva configuracion
}

/* funcion que regresa a su estado inicial la consola */
void disable_key_config()
{
    tcsetattr(fileno(stdin), TCSANOW, &config_actual);   
}

/* Funcion que asegura que el programa sale con el normal de la consola */
void secure_leave(int s)
{
    disable_key_config();
    exit(1);
}

/* Handler de la salida de ctrl + c*/
void handle_ctrl_c()
{
    struct sigaction handler;

    handler.sa_handler = secure_leave; // Indicar la funcion a ejecutar cuando Ctrl-c
    sigemptyset(&handler.sa_mask);
    handler.sa_flags = 0;

    // Reemplazar el metodo por cuando se de la senial SIGINT
    // por el nuevo handler (secure_leave)
    sigaction(SIGINT, &handler, NULL); 

}

/**
* Metodo encargado de devolver la tecla que se presiono
* se debe estar ejecutando por todo el tiempo que se ejecuta
* el programa para mantener fresco el buffer
*/
int getkey() 
{
    int caracter_leido;
    caracter_leido = fgetc(stdin); // Cargar al caracter
    return caracter_leido;
}