 /*********************************************************
 * Autores: Jose Rodrigo Custodio, Alejandro Chaclan      *
 * Taller de Assembler, Seccion: 30                       *
 * Descripcion: Subrutinas relacionadas con colisiones y  *
 * fisicas.                                               *
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


/* Subrutina que devuele quien le pego a quien
* 0 si no se pegaron o empate
* 1 Si Goku le pego a vegeta
* 2 Si Vegeta le pego a Goku
*/
.global collides
collides:
	ldr r0, =goku_x
	ldr r0, [r0]
	ldr r1, =goku_y
	ldr r1, [r1]
	ldr r2, =vegeta_x
	ldr r2, [r2]
	ldr r3, =vegeta_y
	ldr r3, [r3]
	ldr r4, =goku_width
	ldr r4, [r4]
	ldr r5, =goku_height
	ldr r5, [r5]
	ldr r6, =vegeta_width
	ldr r6, [r6]
	ldr r7, =vegeta_height
	ldr r7, [r7]

	gx .req r0
	gy .req r1
	vx .req r2
	vy .req r3
	gw .req r4
	gh .req r5
	vw .req r6
	vh .req r7
	aux .req r8

	@ Comparar las dimensiones de los cuadrados formados por goku y vegeta
	@ Si se intersectan, es colision de lo contrario no.
	add aux, vx, vw
	cmp gx, aux
	bge no_collision
	add aux, gx, gw
	cmp aux, vx
	ble no_collision
	add aux, vy, vh
	cmp gy, aux
	bge no_collision
	add aux, gy, gh
	cmp aux, vy
	ble no_collision

	.unreq gx
	.unreq gy
	.unreq vx
	.unreq vy
	.unreq gw
	.unreq gh
	.unreq vw
	.unreq vh

	ldr r0, =goku_hit
	ldrb r0, [r0] @ Obtener la bandera si goku realizo un golpe
	ldr r1, =vegeta_hit
	ldrb r1, [r1] @ Obtener la bandera si vegeta realizo un golpe
	cmp r0, r1
	movgt r0, #1 @ Goku le pego
	movlt r0, #2 @ Vegeta le pego
	moveq r0, #0 @ No se pegaron
	mov pc, lr

	no_collision:
		mov r0, #0
		mov pc, lr

.global check_collision
check_collision:
	push {lr}

	bl collides

	cmp r0, #1
	bleq reconstruct_hp_vegeta
	ldreq r1, =375
	ldreq r2, =63
	ldreq r3, =vegeta_hp
	ldreq r3, [r3]
	subeq r3, #20
	ldreq r4, =vegeta_hp
	streq r3, [r4]
	bleq draw_hp

	cmp r0, #2
	bleq reconstruct_hp_goku
	ldreq r1, =69
	ldreq r2, =63
	ldreq r3, =goku_hp
	ldreq r3, [r3]
	subeq r3, #20
	ldreq r4, =goku_hp
	streq r3, [r4]
	bleq draw_hp

	ldr r0, =vegeta_hit
	mov r1, #0
	strb r1, [r0]
	ldr r0, =goku_hit
	mov r1, #0
	strb r1, [r0]

	pop {pc}

.global reconstruct_hp_vegeta
reconstruct_hp_vegeta:
	push {lr}
	ldr r0,= 375
	ldr r1,= 63
	ldr r2,= 197
	ldr r3,= 28
	bl reconstruct
	pop {pc}

.global reconstruct_hp_goku
reconstruct_hp_goku:
	push {lr}
	ldr r0,= 69
 	ldr r1,= 63
	ldr r2,= 197
	ldr r3,= 28
	bl reconstruct
	pop {pc}

@ R1: Coordenada x de la vida
@ R2: Coordenada y de la vida
@ R3: Vida del personaje
.global draw_hp
draw_hp:
	push {lr}

	mov r6, r3

	x .req r1
	y .req r2
	color .req r3
	xFinal .req r4
	yFinal .req r5

	ldr color, =63488

	add xFinal, x, r6
	add yFinal, y, #27

	mov r6, x

	nextYHp:
		add y,#1
		cmp y, yFinal
		bgt endHp

		mov x, r6
		nextXHp:
			cmp x, xFinal
			bge nextYHp

			ldr r0,=pixelAddr
			ldr r0,[r0]
			push {r0-r12}
			bl pixel
			pop {r0-r12}

			add x,#1
			b nextXHp


	endHp:
		.unreq x
		.unreq y
		.unreq color
		.unreq xFinal
		.unreq yFinal

	pop {pc}
