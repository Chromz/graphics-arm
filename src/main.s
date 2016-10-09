 .text
 .align 2
 .global main
main:
	mov r0, #0
	bl getScreenAddr
	ldr r1,=pixelAddr
	str r0,[r1]

	@ Cargar el sprite inicial de Goku
	ldr r0, =Image_Matrix_gok0
	ldr r1, =goku_addr
	str r0, [r1]

	@ Establecer el Width inicial de Goku
	ldr r0, =Width_gok0
	ldr r0, [r0]
	ldr r1, =goku_width
	str r0, [r1]

	@ Establecer el Height inicial de Goku
	ldr r0, =Height_gok0
	ldr r0, [r0]
	ldr r1, =goku_height
	str r0, [r1]

	@ Configurar la consola de linux para leer el teclado
	bl enable_key_config

	bl draw_bg
	render$:

		@bl update_physics @ Aplicarle las fisicas al juego
		bl process_input @ Procesar el input del teclado
		bl draw_goku @ Dibujar a Goku
		
	b render$
	
	
.data
@ Variables de bloqueo del input
@ -------------------------------------
.global lock_anim
lock_anim: .byte 0 @ 1 es bloqueado 0 es sin bloqueo
@ -------------------------------------
@ Variables de animacion de Goku
@ -------------------------------------
.global anim_counter
anim_counter: .word 0
.global anim_tolerance
anim_tolerance: .word 350
.global goku_anim_turn
goku_anim_turn: .word 1
.global goku_width
goku_width: .word 0
.global goku_height
goku_height: .word 0
.global goku_addr
goku_addr: .word 0
.global goku_o @ Estado de animacion de goku
goku_o: .word 0
@ -------------------------------------

@ Variables de control de las fisicas del mundo
@ -------------------------------------
.global gravity
gravity: .word 1
@ -------------------------------------


@ Variables de control de las fisicas de Goky
@-------------------------------------
.global goku_velocity_x
goku_velocity_x: .word 0
.global goku_velocity_y
goku_velocity_y: .word -1
.global goku_x
goku_x: .word 50
.global goku_y
goku_y: .word 300
chaa: .byte 'a'
@ -------------------------------------
.global pixelAddr
pixelAddr: .word 0
