 /*********************************************************
 * Autores: Jose Rodrigo Custodio, Alejandro Chaclan      *
 * Taller de Assembler, Seccion: 30                       *
 * Descripcion: Subrutinas relacionadas con graficos      *
 * La mayoria de estas subrutinas sirven para agregar     *
 * una capa de abstraccion para solo ejecutar metodos     *
 * sencillos en el main.                                  *
 *                                                        *
 *                                                        *
 *                                                        *
 *                                                        *
 *                                                        *
 *                                                        *
 **********************************************************
 */

/*
* R0, Direccion de memoria a la matriz
* R1, X inicial
* R2, Y inicial
* R3, Width de la matriz
* Stack-1 Height de la matriz
* Codigo Basado en el proporcionado en blackboard
* Dibuja de forma generica una imagen de dimensiones dadas
* en coordenadas dadas
*/
.global draw_image
draw_image:
	ldr r5, [sp], #4
	mov r4, r3
	mov r6, r0
	push {lr}

	add r4, r1
	add r5, r2
	x .req r1
	y .req r2
	color .req r3
	finalx .req r4
	finaly .req r5
	matrix_addr .req r6
	matrix_counter .req r7
	temp .req r8

	mov matrix_counter, #0
	mov temp, x

	next_x:
		mov x, temp
		draw_pixel:
			cmp x, finalx
			bge next_y
			ldrh color, [matrix_addr, matrix_counter]
			ldr r0, =pixelAddr
			ldr r0, [r0]
			push {r0-r12}
			bl pixel
			pop {r0-r12}
			add matrix_counter, #2 @ Se suma dos debido a que esta en depth 16
			add x, #1
			b draw_pixel

	next_y:
		add y, #1
		teq y, finaly
		bne next_x

		.unreq x
		.unreq y
		.unreq color
		.unreq finalx
		.unreq finaly
		.unreq matrix_addr
		.unreq matrix_counter
		.unreq temp

	pop {pc}

/**
* R0, Direccion de memoria a la matriz
* R1, X inicial
* R2, Y inicial
* R3, Width de la matriz
* Stack-1 Height de la matriz
* Dibuja a un heroe del juego, con transparencia (ignora el color rojo = 63488)
*/
.global draw_hero
draw_hero:
	ldr r5, [sp], #4
	mov r4, r3
	mov r6, r0
	push {lr}

	add r4, r1
	add r5, r2
	x .req r1
	y .req r2
	color .req r3
	finalx .req r4
	finaly .req r5
	matrix_addr .req r6
	matrix_counter .req r7
	temp .req r8

	mov matrix_counter, #0
	mov temp, x

	next_x0:
		mov x, temp
		draw_pixel0:
			cmp x, finalx
			bge next_y0
			ldrh color, [matrix_addr, matrix_counter]
			ldr r0, =63488 @ Color rojo a ignorar
			cmp color, r0
			addeq matrix_counter, #2
			addeq x, #1
			beq draw_pixel0
			ldr r0, =pixelAddr
			ldr r0, [r0]
			push {r0-r12}
			bl pixel
			pop {r0-r12}
			add matrix_counter, #2 @ Se suma dos debido a que esta en depth 16
			add x, #1
			b draw_pixel0

	next_y0:
		add y, #1
		teq y, finaly
		bne next_x0

		.unreq x
		.unreq y
		.unreq color
		.unreq finalx
		.unreq finaly
		.unreq matrix_addr
		.unreq matrix_counter
		.unreq temp

	pop {pc}

/**
*
* Metodo de abstraccion
* Dibuja unicamente la pantalla de controles del inicio
*
*/
.global draw_controls
draw_controls:
	push {lr}
	ldr r0, =Image_Matrix_inicio
	mov r1, #0
	mov r2, #0
	ldr r3, =Width_inicio
	ldr r3, [r3]
	ldr r4, =Height_inicio
	ldr r4, [r4]
	str r4, [sp, #-4]!
	bl draw_image
	pop {pc}

/**
*
* Metodo de abstraccion
* Dibuja unicamente la pantalla cuando goku gana
*
*/
.global draw_goku_win
draw_goku_win:
	push {lr}
	ldr r0, =Image_Matrix_gano_goku
	mov r1, #0
	mov r2, #0
	ldr r3, =Width_gano_goku
	ldr r3, [r3]
	ldr r4, =Height_gano_goku
	ldr r4, [r4]
	str r4, [sp, #-4]!
	bl draw_image
	pop {pc}
/**
*
* Metodo de abstraccion
* Dibuja unicamente la pantalla cuando vegeta gana
*
*/
.global draw_vegeta_win
draw_vegeta_win:
	push {lr}
	ldr r0, =Image_Matrix_gano_vegeta
	mov r1, #0
	mov r2, #0
	ldr r3, =Width_gano_vegeta
	ldr r3, [r3]
	ldr r4, =Height_gano_vegeta
	ldr r4, [r4]
	str r4, [sp, #-4]!
	bl draw_image
	pop {pc}

/**
*
* Metodo de abstraccion
* Dibuja unicamente el fondo de pantalla
*
*/
.global draw_bg
draw_bg:
	push {lr}
	ldr r0, =Image_Matrix_bg
	mov r1, #0
	mov r2, #0
	ldr r3, =Width_bg
	ldr r3, [r3]
	ldr r4, =Height_bg
	ldr r4, [r4]
	str r4, [sp, #-4]!
	bl draw_image
	pop {pc}
/*
* R0, x0 a reconstruir
* R1, y0 a reconstruir
* R2, Width de la reconstruccion
* R3, Height de la reconstruccion
* Metodo encargado de reconstruir solo un pedazo
* del fondo (con el objetivo de aumentar el rendimiento)
* calcula el offset en la matriz con la subrutina calculate_offset
*/

.global reconstruct
reconstruct:
	push {lr}
	mov r4, r0
	mov r5, r1
	mov r6, r2
	mov r7, r3

	mov r1, r4
	mov r2, r5
	mov r4, r6
	mov r5, r7

	x .req r1
	y .req r2

	color .req r3
	width .req r4
	height .req r5
	bytecounter .req r6
	xfinal .req r7
	yfinal .req r8
	temp .req r9
	matrix_addr .req r10

	mov xfinal, x
	add xfinal, width
	mov yfinal, y
	add yfinal, height

	mov temp, x
	ldr matrix_addr, =Image_Matrix_bg
	next_x1:
		mov x, temp
		@ Obtener l posicion inicial del bytecounter
		push {r0-r3}
		ldr r0, =Width_bg
		ldr r0, [r0]
		bl calculate_offset @ Obtener el offset de la matriz
		mov bytecounter, r0 @ Guardar la pos inicial del byte counter
		pop {r0-r3}
		draw_pixel1:
			cmp x, xfinal
			bge next_y1
			ldrh color, [matrix_addr, bytecounter]
			ldr r0, =pixelAddr
			ldr r0, [r0]
			push {r0-r12}
			bl pixel
			pop {r0-r12}
			add bytecounter, #2
			add x, #1
			b draw_pixel1
	next_y1:
		add y, #1
		teq y, yfinal
		bne next_x1
	.unreq x
	.unreq y
	.unreq xfinal
	.unreq yfinal
	.unreq temp
	.unreq bytecounter
	.unreq color
	.unreq width
	.unreq height
	.unreq matrix_addr
	pop {pc}
/*
*
* Calcula el offset de la matriz de una imagen de
* 16 bits de depth
*
*/
.global calculate_offset
calculate_offset:
	mov r3, #2
	mul r0, r3, r0
	mul r0, r2, r0
	mul r1, r3, r1
	add r0, r1
	mov pc, lr

/**
* Metodo de abstraccion
* Metodo que realiza todas las animaciones de Vegeta
* Golpes y movimiento
*/
.global draw_vegeta
draw_vegeta:
	push {lr}

	@ Comprobar si es necesario el cambio de sprite
	ldr r0, =anim_counter_veg
	ldr r0, [r0]
	ldr r1, =anim_tolerance_veg
	ldr r1, [r1] @ Obtener la tolerancia de la animacion
	cmp r0, r1 @ Comprobar cambio de sprite
	addne r0, #1
	ldrne r1, =anim_counter_veg
	strne r0, [r1] @ Actualizar el contador de la animacion
	bne draw_veg
	ldr r0, =vegeta_o @Se revisa que animacion se va a realizar
	ldr r0, [r0]
	cmp r0, #0
	beq check_idle_vegeta
	cmp r0, #1
	beq update_movr_veg
	cmp r0, #2
	beq update_movl_veg
	cmp r0, #3
	beq check_hit_v

	@ Se revisa de que lado esta vegeta para hacer la respectiva animacion del golpe
	check_hit_v:
		ldr r0, =vegeta_side
		ldr r1, [r0]
		cmp r1, #0
		beq update_veg_hit_right
		bne update_veg_hit_left

		@Se cargan las variables para poder dibujar la animacion de la derecha
		update_veg_hit_right:
			ldr r0, =vegeta_anim_turn
			ldr r0, [r0] @ Obtener el numero de animacion que toca
			cmp r0, #0 @ Verificar si es el primer sprite
			ldreq r1, =vegeta_addr
			ldreq r2, =Image_Matrix_v_hitr1
			streq r2, [r1]
			ldreq r1, =vegeta_width
			ldreq r2, =Width_v_hitr1
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =vegeta_height
			ldreq r2, =Height_v_hitr1
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #1 @ Verificar si es el segundo sprite
			ldreq r1, =vegeta_addr
			ldreq r2, =Image_Matrix_v_hitr2
			streq r2, [r1]
			ldreq r1, =vegeta_width
			ldreq r2, =Width_v_hitr2
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =vegeta_height
			ldreq r2, =Height_v_hitr2
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #2 @ Verificar si es el tercer sprite
			ldreq r1, =vegeta_addr
			ldreq r2, =Image_Matrix_v_hitr3
			streq r2, [r1]
			ldreq r1, =vegeta_width
			ldreq r2, =Width_v_hitr3
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =vegeta_height
			ldreq r2, =Height_v_hitr3
			ldreq r2, [r2]
			streq r2, [r1]

			moveq r0, #0
			addne r0, #1
			ldreq r2, =lock_anim_veg @Se regresa al idle una vez terminada esta animacion
			moveq r1, #0
			streqb r1, [r2]
			moveq r0, #0 @Se reinicia el contador de la animacion
			ldreq r2, =vegeta_hit
			moveq r3, #0
			streqb r3, [r2] @ Activar la bandera de golpe de Vegeta
			b change_anim_veg

		@Se cargan las variables para poder dibujar la animacion de la izquierda
		update_veg_hit_left:
			ldr r0, =vegeta_anim_turn
			ldr r0, [r0] @ Obtener el numero de animacion que toca
			cmp r0, #0
			ldreq r1, =vegeta_addr
			ldreq r2, =Image_Matrix_v_hitl1
			streq r2, [r1]
			ldreq r1, =vegeta_width
			ldreq r2, =Width_v_hitl1
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =vegeta_height
			ldreq r2, =Height_v_hitl1
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #1
			ldreq r1, =vegeta_addr
			ldreq r2, =Image_Matrix_v_hitl2
			streq r2, [r1]
			ldreq r1, =vegeta_width
			ldreq r2, =Width_v_hitl2
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =vegeta_height
			ldreq r2, =Height_v_hitl2
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #2
			ldreq r1, =vegeta_addr
			ldreq r2, =Image_Matrix_v_hitl3
			streq r2, [r1]
			ldreq r1, =vegeta_width
			ldreq r2, =Width_v_hitl3
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =vegeta_height
			ldreq r2, =Height_v_hitl3
			ldreq r2, [r2]
			streq r2, [r1]

			moveq r0, #0
			addne r0, #1
			ldreq r2, =lock_anim_veg @Se regresa al idle una vez terminada esta animacion
			moveq r1, #0
			streqb r1, [r2]
			moveq r0, #0 @Se reinicia el contador de la animacion
			ldreq r2, =vegeta_hit
			moveq r3, #0
			streqb r3, [r2]
			b change_anim_veg

	@Se revisa de que lado se encuentra vegeta para hacer la respectiva animacion
	check_idle_vegeta:
		ldr r0,=vegeta_side
		ldr r0,[r0]
		cmp r0, #0
		beq update_idle_veg_right
		bne update_idle_veg_left

		@ Se cargan las variables para hacer la animacion del idle de la derecha
		update_idle_veg_right:
			ldr r0, =vegeta_anim_turn
			ldr r0, [r0] @ Obtener el numero de animacion que toca
			cmp r0, #0
			ldreq r1, =vegeta_addr
			ldreq r2, =Image_Matrix_vegeta_idle_right1
			streq r2, [r1]
			ldreq r1, =vegeta_width
			ldreq r2, =Width_vegeta_idle_right1
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =vegeta_height
			ldreq r2, =Height_vegeta_idle_right1
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #1
			ldreq r1, =vegeta_addr
			ldreq r2, =Image_Matrix_vegeta_idle_right2
			streq r2, [r1]
			ldreq r1, =vegeta_width
			ldreq r2, =Width_vegeta_idle_right2
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =vegeta_height
			ldreq r2, =Height_vegeta_idle_right2
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #2
			ldreq r1, =vegeta_addr
			ldreq r2, =Image_Matrix_vegeta_idle_right3
			streq r2, [r1]
			ldreq r1, =vegeta_width
			ldreq r2, =Width_vegeta_idle_right3
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =vegeta_height
			ldreq r2, =Height_vegeta_idle_right3
			ldreq r2, [r2]
			streq r2, [r1]


			moveq r0, #0
			addne r0, #1
			b change_anim_veg

		@Animacion del idle de la izquierda
		update_idle_veg_left:
			ldr r0, =vegeta_anim_turn
			ldr r0, [r0] @ Obtener el numero de animacion que toca
			cmp r0, #0
			ldreq r1, =vegeta_addr
			ldreq r2, =Image_Matrix_vegeta_idle_left1
			streq r2, [r1]
			ldreq r1, =vegeta_width
			ldreq r2, =Width_vegeta_idle_left1
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =vegeta_height
			ldreq r2, =Height_vegeta_idle_left1
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #1
			ldreq r1, =vegeta_addr
			ldreq r2, =Image_Matrix_vegeta_idle_left2
			streq r2, [r1]
			ldreq r1, =vegeta_width
			ldreq r2, =Width_vegeta_idle_left2
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =vegeta_height
			ldreq r2, =Height_vegeta_idle_left2
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #2
			ldreq r1, =vegeta_addr
			ldreq r2, =Image_Matrix_vegeta_idle_left3
			streq r2, [r1]
			ldreq r1, =vegeta_width
			ldreq r2, =Width_vegeta_idle_left3
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =vegeta_height
			ldreq r2, =Height_vegeta_idle_left3
			ldreq r2, [r2]
			streq r2, [r1]

			moveq r0, #0
			addne r0, #1
			b change_anim_veg

	@Animacion para moverse a la derecha
	update_movr_veg:
		ldr r0, =vegeta_anim_turn
		ldr r0, [r0] @ Obtener el numero de animacion que toca
		cmp r0, #0
		ldreq r1, =vegeta_addr
		ldreq r2, =Image_Matrix_vegeta_right1
		streq r2, [r1]
		ldreq r1, =vegeta_width
		ldreq r2, =Width_vegeta_right1
		ldreq r2, [r2]
		streq r2, [r1]
		ldreq r1, =vegeta_height
		ldreq r2, =Height_vegeta_right1
		ldreq r2, [r2]
		streq r2, [r1]
		cmp r0, #1
		ldreq r1, =vegeta_addr
		ldreq r2, =Image_Matrix_vegeta_right2
		streq r2, [r1]
		ldreq r1, =vegeta_width
		ldreq r2, =Width_vegeta_right2
		ldreq r2, [r2]
		streq r2, [r1]
		ldreq r1, =vegeta_height
		ldreq r2, =Height_vegeta_right2
		ldreq r2, [r2]
		streq r2, [r1]
		cmp r0, #2
		ldreq r1, =vegeta_addr
		ldreq r2, =Image_Matrix_vegeta_right3
		streq r2, [r1]
		ldreq r1, =vegeta_width
		ldreq r2, =Width_vegeta_right3
		ldreq r2, [r2]
		streq r2, [r1]
		ldreq r1, =vegeta_height
		ldreq r2, =Height_vegeta_right3
		ldreq r2, [r2]
		streq r2, [r1]

		ldreq r2, =lock_anim_veg @Se regresa al idle una vez terminada esta animacion
		moveq r1, #0
		streqb r1, [r2]
		moveq r0, #0 @Se reinicia el contador de la animacion

		addne r0, #1
		b change_anim_veg

	@Animacion para moverse a la izquierda
	update_movl_veg:
		ldr r0, =vegeta_anim_turn
		ldr r0, [r0] @ Obtener el numero de animacion que toca
		cmp r0, #0
		ldreq r1, =vegeta_addr
		ldreq r2, =Image_Matrix_vegeta_left1
		streq r2, [r1]
		ldreq r1, =vegeta_width
		ldreq r2, =Width_vegeta_left1
		ldreq r2, [r2]
		streq r2, [r1]
		ldreq r1, =vegeta_height
		ldreq r2, =Height_vegeta_left1
		ldreq r2, [r2]
		streq r2, [r1]
		cmp r0, #1
		ldreq r1, =vegeta_addr
		ldreq r2, =Image_Matrix_vegeta_left2
		streq r2, [r1]
		ldreq r1, =vegeta_width
		ldreq r2, =Width_vegeta_left2
		ldreq r2, [r2]
		streq r2, [r1]
		ldreq r1, =vegeta_height
		ldreq r2, =Height_vegeta_left2
		ldreq r2, [r2]
		streq r2, [r1]
		cmp r0, #2
		ldreq r1, =vegeta_addr
		ldreq r2, =Image_Matrix_vegeta_left3
		streq r2, [r1]
		ldreq r1, =vegeta_width
		ldreq r2, =Width_vegeta_left3
		ldreq r2, [r2]
		streq r2, [r1]
		ldreq r1, =vegeta_height
		ldreq r2, =Height_vegeta_left3
		ldreq r2, [r2]
		streq r2, [r1]


		ldreq r2, =lock_anim_veg @Se regresa al idle una vez terminada esta animacion
		moveq r1, #0
		streqb r1, [r2]
		moveq r0, #0 @Se reinicia el contador de la animacion

		addne r0, #1
		b change_anim_veg

		@ Se guarda el numero de la animacion siguiente y se borra el vegeta anterior
		change_anim_veg:
			ldr r1, =vegeta_anim_turn
			str r0, [r1] @ Guardar el turno siguiente
			ldr r1, =anim_counter_veg
			mov r0, #0
			str r0, [r1]
			bl reconstruct_vegeta
			b draw_veg

	@Se dibuja la animacion que toca
	draw_veg:
		ldr r1, =vegeta_x
		ldr r1, [r1]
		ldr r2, =vegeta_y
		ldr r2, [r2]
		ldr r0, =vegeta_addr
		ldr r0, [r0]
		ldr r3, =vegeta_width
		ldr r3, [r3]
		ldr r4, =vegeta_height
		ldr r4, [r4]
		str r4, [sp, #-4]!
		bl draw_hero
pop {pc}

/**
* Metodo de abstraccion
* Metodo que realiza todas las animaciones de Goku
* Golpes y movimiento
*/
.global draw_goku
draw_goku:
	push {lr}

	@ Comprobar si es necesario el cambio de sprite
	ldr r0, =anim_counter
	ldr r0, [r0]
	ldr r1, =anim_tolerance
	ldr r1, [r1] @ Obtener la tolerancia de la animacion
	cmp r0, r1 @ Comprobar cambio de sprite
	addne r0, #1
	ldrne r1, =anim_counter
	strne r0, [r1] @ Actualizar el contador de la animacion
	bne draw_gok
	ldr r0, =goku_o @ Se revisa que animacion se va a realizar
	ldr r0, [r0]
	cmp r0, #0
	beq check_idle
	cmp r0, #1
	beq update_movr_gok
	cmp r0, #2
	beq update_movl_gok
	cmp r0, #3
	beq check_hit

	@ Se revisa de que lado esta goku para hacer la respectiva animacion del golpe
	check_hit:
		ldr r0, =goku_side
		ldr r1, [r0]
		cmp r1, #0
		beq update_gok_hit_right
		bne update_gok_hit_left

		@Se cargan las variables para poder dibujar la animacion de la derecha
		update_gok_hit_right:
			ldr r0, =goku_anim_turn
			ldr r0, [r0] @ Obtener el numero de animacion que toca
			cmp r0, #0
			ldreq r1, =goku_addr
			ldreq r2, =Image_Matrix_g_hitr1
			streq r2, [r1]
			ldreq r1, =goku_width
			ldreq r2, =Width_g_hitr1
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =goku_height
			ldreq r2, =Height_g_hitr1
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #1
			ldreq r1, =goku_addr
			ldreq r2, =Image_Matrix_g_hitr2
			streq r2, [r1]
			ldreq r1, =goku_width
			ldreq r2, =Width_g_hitr2
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =goku_height
			ldreq r2, =Height_g_hitr2
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #2
			ldreq r1, =goku_addr
			ldreq r2, =Image_Matrix_g_hitr3
			streq r2, [r1]
			ldreq r1, =goku_width
			ldreq r2, =Width_g_hitr3
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =goku_height
			ldreq r2, =Height_g_hitr3
			ldreq r2, [r2]
			streq r2, [r1]

			moveq r0, #0
			addne r0, #1
			ldreq r2, =lock_anim @Se regresa al idle una vez terminada esta animacion
			moveq r1, #0
			streqb r1, [r2]
			moveq r0, #0 @Se reinicia el contador de la animacion
			ldreq r2, =goku_hit
			moveq r3, #0
			streqb r3, [r2] @ Activar la bandera de golpe de goku
			b change_anim

		@Se cargan las variables para poder dibujar la animacion de la izquierda
		update_gok_hit_left:
			ldr r0, =goku_anim_turn
			ldr r0, [r0] @ Obtener el numero de animacion que toca
			cmp r0, #0
			ldreq r1, =goku_addr
			ldreq r2, =Image_Matrix_g_hitl1
			streq r2, [r1]
			ldreq r1, =goku_width
			ldreq r2, =Width_g_hitr1
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =goku_height
			ldreq r2, =Height_g_hitr1
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #1
			ldreq r1, =goku_addr
			ldreq r2, =Image_Matrix_g_hitl2
			streq r2, [r1]
			ldreq r1, =goku_width
			ldreq r2, =Width_g_hitr2
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =goku_height
			ldreq r2, =Height_g_hitr2
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #2
			ldreq r1, =goku_addr
			ldreq r2, =Image_Matrix_g_hitl3
			streq r2, [r1]
			ldreq r1, =goku_width
			ldreq r2, =Width_g_hitr3
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =goku_height
			ldreq r2, =Height_g_hitr3
			ldreq r2, [r2]
			streq r2, [r1]

			moveq r0, #0
			addne r0, #1
			ldreq r2, =lock_anim @Se regresa al idle una vez terminada esta animacion
			moveq r1, #0
			streqb r1, [r2]
			moveq r0, #0 @Se reinicia el contador de la animacion
			ldreq r2, =goku_hit
			moveq r3, #0
			streqb r3, [r2]
			b change_anim

	@Se revisa de que lado se encuentra goku para hacer la respectiva animacion
	check_idle:
		ldr r0,=goku_side
		ldr r0,[r0]
		cmp r0,#0
		beq update_idle_gok_right
		bne update_idle_gok_left

		@ Se cargan las variables para hacer la animacion del idle de la derecha
		update_idle_gok_right:
			ldr r0, =goku_anim_turn
			ldr r0, [r0] @ Obtener el numero de animacion que toca
			cmp r0, #0
			ldreq r1, =goku_addr
			ldreq r2, =Image_Matrix_goku_idle_right1
			streq r2, [r1]
			ldreq r1, =goku_width
			ldreq r2, =Width_goku_idle_right1
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =goku_height
			ldreq r2, =Height_goku_idle_right1
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #1
			ldreq r1, =goku_addr
			ldreq r2, =Image_Matrix_goku_idle_right2
			streq r2, [r1]
			ldreq r1, =goku_width
			ldreq r2, =Width_goku_idle_right2
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =goku_height
			ldreq r2, =Height_goku_idle_right2
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #2
			ldreq r1, =goku_addr
			ldreq r2, =Image_Matrix_goku_idle_right3
			streq r2, [r1]
			ldreq r1, =goku_width
			ldreq r2, =Width_goku_idle_right3
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =goku_height
			ldreq r2, =Height_goku_idle_right3
			ldreq r2, [r2]
			streq r2, [r1]

			moveq r0, #0
			addne r0, #1
			b change_anim

		@ Se cargan las variables para hacer la animacion del idle de la izquierda
		update_idle_gok_left:
			ldr r0, =goku_anim_turn
			ldr r0, [r0] @ Obtener el numero de animacion que toca
			cmp r0, #0
			ldreq r1, =goku_addr
			ldreq r2, =Image_Matrix_goku_idle_left1
			streq r2, [r1]
			ldreq r1, =goku_width
			ldreq r2, =Width_goku_idle_left1
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =goku_height
			ldreq r2, =Height_goku_idle_left1
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #1
			ldreq r1, =goku_addr
			ldreq r2, =Image_Matrix_goku_idle_left2
			streq r2, [r1]
			ldreq r1, =goku_width
			ldreq r2, =Width_goku_idle_left2
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =goku_height
			ldreq r2, =Height_goku_idle_left2
			ldreq r2, [r2]
			streq r2, [r1]
			cmp r0, #2
			ldreq r1, =goku_addr
			ldreq r2, =Image_Matrix_goku_idle_left3
			streq r2, [r1]
			ldreq r1, =goku_width
			ldreq r2, =Width_goku_idle_left3
			ldreq r2, [r2]
			streq r2, [r1]
			ldreq r1, =goku_height
			ldreq r2, =Height_goku_idle_left3
			ldreq r2, [r2]
			streq r2, [r1]

			moveq r0, #0
			addne r0, #1
			b change_anim

	@ Se cargan las variables para hacer la animacion del idle de la
	update_movr_gok:
		ldr r0, =goku_anim_turn
		ldr r0, [r0] @ Obtener el numero de animacion que toca
		cmp r0, #0
		ldreq r1, =goku_addr
		ldreq r2, =Image_Matrix_goku_right1
		streq r2, [r1]
		ldreq r1, =goku_width
		ldreq r2, =Width_goku_right1
		ldreq r2, [r2]
		streq r2, [r1]
		ldreq r1, =goku_height
		ldreq r2, =Height_goku_right1
		ldreq r2, [r2]
		streq r2, [r1]
		cmp r0, #1
		ldreq r1, =goku_addr
		ldreq r2, =Image_Matrix_goku_right2
		streq r2, [r1]
		ldreq r1, =goku_width
		ldreq r2, =Width_goku_right2
		ldreq r2, [r2]
		streq r2, [r1]
		ldreq r1, =goku_height
		ldreq r2, =Height_goku_right2
		ldreq r2, [r2]
		streq r2, [r1]
		cmp r0, #2
		ldreq r1, =goku_addr
		ldreq r2, =Image_Matrix_goku_right3
		streq r2, [r1]
		ldreq r1, =goku_width
		ldreq r2, =Width_goku_right3
		ldreq r2, [r2]
		streq r2, [r1]
		ldreq r1, =goku_height
		ldreq r2, =Height_goku_right3
		ldreq r2, [r2]
		streq r2, [r1]

		ldreq r2, =lock_anim @Se regresa al idle una vez terminada esta animacion
		moveq r1, #0
		streqb r1, [r2]
		moveq r0, #0 @Se reinicia el contador de la animacion

		addne r0, #1
		b change_anim

		update_movl_gok:
		ldr r0, =goku_anim_turn
		ldr r0, [r0] @ Obtener el numero de animacion que toca
		cmp r0, #0
		ldreq r1, =goku_addr
		ldreq r2, =Image_Matrix_goku_left1
		streq r2, [r1]
		ldreq r1, =goku_width
		ldreq r2, =Width_goku_left1
		ldreq r2, [r2]
		streq r2, [r1]
		ldreq r1, =goku_height
		ldreq r2, =Height_goku_left1
		ldreq r2, [r2]
		streq r2, [r1]
		cmp r0, #1
		ldreq r1, =goku_addr
		ldreq r2, =Image_Matrix_goku_left2
		streq r2, [r1]
		ldreq r1, =goku_width
		ldreq r2, =Width_goku_left2
		ldreq r2, [r2]
		streq r2, [r1]
		ldreq r1, =goku_height
		ldreq r2, =Height_goku_left2
		ldreq r2, [r2]
		streq r2, [r1]
		cmp r0, #2
		ldreq r1, =goku_addr
		ldreq r2, =Image_Matrix_goku_left3
		streq r2, [r1]
		ldreq r1, =goku_width
		ldreq r2, =Width_goku_left3
		ldreq r2, [r2]
		streq r2, [r1]
		ldreq r1, =goku_height
		ldreq r2, =Height_goku_left3
		ldreq r2, [r2]
		streq r2, [r1]

		ldreq r2, =lock_anim @Se regresa al idle una vez terminada esta animacion
		moveq r1, #0
		streqb r1, [r2]
		moveq r0, #0 @Se reinicia el contador de la animacion

		addne r0, #1
		b change_anim


		change_anim:
			ldr r1, =goku_anim_turn
			str r0, [r1] @ Guardar el turno siguiente
			ldr r1, =anim_counter
			mov r0, #0
			str r0, [r1]
			bl reconstruct_goku
			b draw_gok

	draw_gok:
		ldr r1, =goku_x
		ldr r1, [r1]
		ldr r2, =goku_y
		ldr r2, [r2]
		ldr r0, =goku_addr
		ldr r0, [r0]
		ldr r3, =goku_width
		ldr r3, [r3]
		ldr r4, =goku_height
		ldr r4, [r4]
		str r4, [sp, #-4]!
		bl draw_hero
	pop {pc}

/**
* Metodo de abstraccion
* Reconstruye el pedazo de fondo en donde se encuentra goku
*/
.global reconstruct_goku
reconstruct_goku:
	push {lr}
	ldr r0, =goku_x
	ldr r0, [r0]
	ldr r1, =goku_y
	ldr r1, [r1]
	mov r2, #80
	mov r3, #95
	bl reconstruct
	pop {pc}

/**
* Metodo de abstraccion
* Reconstruye el pedazo de fondo en donde se encuentra vegeta
*/
.global reconstruct_vegeta
reconstruct_vegeta:
	push {lr}
	ldr r0, =vegeta_x
	ldr r0, [r0]
	ldr r1, =vegeta_y
	ldr r1, [r1]
	mov r2, #80
	mov r3, #95
	bl reconstruct
	pop {pc}


.global process_input
process_input:
	push {lr}

	@ Se lee la tecla presionada
	bl getkey
	mov r1, r0
	@ Primero se revisa que goku no este realizando una animacion
	ldr r0, =lock_anim
	ldrb r0, [r0]
	cmp r0, #1
	beq vegeta_keys @ Si esta realizando una animacion, se salta a las teclas de vegeta

	@ Se revisan las teclas de goku
	goku_keys:
		cmp r1, #'w'
		beq upKey
		cmp r1, #'s'
		beq downKey
		cmp r1, #'d'
		beq rightKey
		cmp r1, #'a'
		beq leftKey
		cmp r1, #' '
		beq hitKey_g

	@ Se revisan las teclas de vegeta
	vegeta_keys:
		@ Primero se revisa que vegeta no este realizando una animacion
		ldr r0, =lock_anim_veg
		ldrb r0, [r0]
		cmp r0, #1
		beq ex_process_input

		cmp r1, #'A'
		beq upKey_veg
		cmp r1, #'B'
		beq downKey_veg
		cmp r1, #'C'
		beq rightKey_veg
		cmp r1, #'D'
		beq leftKey_veg
		cmp r1, #'l'
		beq hitKey_v
		bne ex_process_input

	@ Se realiza la animacion de vegeta hacia la derecha
	rightKey_veg:
		ldr r0, =vegeta_side
		mov r1,#0
		str r1, [r0]
		ldr r0, =lock_anim_veg
		mov r1, #1
		strb r1, [r0]
		ldr r0, =vegeta_o
		mov r1, #1
		str r1, [r0]
		bl reconstruct_vegeta
		ldr r1, =vegeta_x
		ldr r1, [r1]
		add r1, #20
		ldr r0, =575
		cmp r1, r0 @ Verificar si no colisiona con el borde de la derecha
		ldrlt r0, =vegeta_x
		strlt r1, [r0]
		b ex_process_input

	@ Se realiza la animacion de vegeta hacia la izquierda
	leftKey_veg:
		ldr r0, =vegeta_side
		mov r1,#1
		str r1, [r0]
		ldr r0, =lock_anim_veg
		@mov r1, #1
		strb r1, [r0]
		ldr r0, =vegeta_o
		mov r1, #2
		str r1, [r0]
		bl reconstruct_vegeta
		ldr r1, =vegeta_x
		ldr r1, [r1]
		sub r1, #20
		ldr r0, =0
		cmp r1, r0 @ Verificar si no colisiona con el borde de la derecha
		ldrgt r0, =vegeta_x
		strgt r1, [r0]
		b ex_process_input

	upKey_veg:
		b ex_process_input
	downKey_veg:
		b ex_process_input

	@ Se realiza la animacion de derecha de goku
	rightKey:
		ldr r0, =goku_side
		mov r1,#0
		str r1, [r0]
		ldr r0, =lock_anim
		mov r1, #1
		strb r1, [r0]
		ldr r0, =goku_o
		mov r1, #1
		str r1, [r0]
		bl reconstruct_goku
		ldr r1, =goku_x
		ldr r1, [r1]
		add r1, #20
		ldr r0, =575
		cmp r1, r0 @ Verificar si no colisiona con el borde de la derecha
		ldrlt r0, =goku_x
		strlt r1, [r0]
		b ex_process_input

	@ Se realiza la animacion de izquierda de goku
	leftKey:
		ldr r0, =goku_side
		mov r1,#1
		str r1, [r0]
		ldr r0,=lock_anim
		mov r1,#1
		strb r1, [r0]
		ldr r0, =goku_o
		mov r1, #2
		str r1, [r0]
		bl reconstruct_goku
		ldr r1,=goku_x
		ldr r1, [r1]
		sub r1,#20
		ldr r0,=0
		cmp r1, r0
		ldrgt r0,=goku_x
		strgt r1, [r0]
		b ex_process_input

	@Se realiza la animacion de golpe de goku
	hitKey_g:
		ldr r0, =goku_hit
		mov r1, #1
		strb r1, [r0]
		ldr r0, =lock_anim
		mov r1, #1
		strb r1, [r0]
		ldr r0, =goku_o
		mov r1, #3
		str r1, [r0]
		bl reconstruct_goku
		b ex_process_input

	@ Se realiza la animacion de golpe de vegeta
	hitKey_v:
		ldr r0, =vegeta_hit
		mov r1, #1
		strb r1, [r0]
		ldr r0, =lock_anim_veg
		mov r1, #1
		strb r1, [r0]
		ldr r0, =vegeta_o
		mov r1, #3
		str r1, [r0]
		bl reconstruct_vegeta
		b ex_process_input

	upKey:
		b ex_process_input
	downKey:
		b ex_process_input

	@ Se debe de resetear el anim_turn
	ex_process_input:
		ldr r0, =lock_anim_veg
		ldrb r0, [r0]
		cmp r0, #0
		ldreq r2, =vegeta_o
		moveq r1, #0
		streq r1, [r2]

		ldr r0, =lock_anim
		ldrb r0, [r0]
		cmp r0, #0
		ldreq r2, =goku_o
		moveq r1, #0
		streq r1, [r2]

		pop {pc}



