 .text
 .align 2
 .global main
main:

	bl handle_ctrl_c
	mov r0, #0
	bl getScreenAddr
	ldr r1,=pixelAddr
	str r0,[r1]

	@ Cargar el sprite inicial de Goku
	ldr r0, =Image_Matrix_goku_idle_right1
	ldr r1, =goku_addr
	str r0, [r1]

	@ Establecer el Width inicial de Goku
	ldr r0, =Width_goku_idle_right1
	ldr r0, [r0]
	ldr r1, =goku_width
	str r0, [r1]

	@ Establecer el Height inicial de Goku
	ldr r0, =Height_goku_idle_right1
	ldr r0, [r0]
	ldr r1, =goku_height
	str r0, [r1]

    @ Establecer el sprite inicial de Vegeta
    ldr r0, =Image_Matrix_vegeta_idle_left1
    ldr r1, =vegeta_addr
    str r0, [r1]

    @ Establecer el Width iniclal de Vegeta
    ldr r0, =Width_vegeta_idle_left1
    ldr r0, [r0]
    ldr r1, =vegeta_width
    str r0, [r1]

    @ Establecer el Height inicial de Vegeta
    ldr r0, =Height_vegeta_idle_left1
    ldr r0,[r0]
    ldr r1, =vegeta_height
    str r0,[r1]


	@ Configurar la consola de linux para leer el teclado
	bl enable_key_config

	bl draw_bg
	render$:

		@bl update_physics @ Aplicarle las fisicas al juego
		bl process_input @ Procesar el input del teclado
		bl draw_goku @ Dibujar a Goku
        bl draw_vegeta @Dibujar a vegeta

	b render$


.data
@ Variables de bloqueo del input
@ -------------------------------------
.global lock_anim
lock_anim: .byte 0 @ 1 es bloqueado 0 es sin bloqueo
.global lock_anim_veg
lock_anim_veg: .byte 0

@ -------------------------------------
@ Variables de animacion de Vegeta
@ -------------------------------------
.global vegeta_side
vegeta_side: .word 1 @ 0 si esta a la derecha, 1 si esta a la izquierda
.global anim_counter_veg
anim_counter_veg: .word 0
.global anim_tolerance_veg
anim_tolerance_veg: .word 100
.global vegeta_anim_turn
vegeta_anim_turn: .word 1
.global vegeta_width
vegeta_width: .word 0
.global vegeta_height
vegeta_height: .word 0
.global vegeta_addr
vegeta_addr: .word 0
.global vegeta_o @ Estado de animacion de vegeta
vegeta_o: .word 0
@ -------------------------------------

@ -------------------------------------
@ Variables de animacion de Goku
@ -------------------------------------
.global goku_side
goku_side: .word 0 @0 si esta a la derecha, 1 si esta a la izquierda
.global anim_counter
anim_counter: .word 0
.global anim_tolerance
anim_tolerance: .word 100
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

@ Variables de control de las fisicas de Vegeta
@-------------------------------------
.global vegeta_velocity_x
vegeta_velocity_x: .word 0
.global vegeta_velocity_y
vegeta_velocity_y: .word -1
.global vegeta_x
vegeta_x: .word 450
.global vegeta_y
vegeta_y: .word 320
@ -------------------------------------

@ Variables de control de las fisicas de Goku
@-------------------------------------
.global goku_velocity_x
goku_velocity_x: .word 0
.global goku_velocity_y
goku_velocity_y: .word -1
.global goku_x
goku_x: .word 50
.global goku_y
goku_y: .word 310
chaa: .byte 'a'
@ -------------------------------------
.global pixelAddr
pixelAddr: .word 0
