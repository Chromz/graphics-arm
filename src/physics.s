@ Subrutina que devuele quien le pego a quien
@ 0 si no se pegaron o empate
@ 1 Si Goku le pego a vegeta
@ 2 Si Vegeta le pego a Goku
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


	ldr r0, =goku_hit
	ldrb r0, [r0]
	ldr r1, =vegeta_hit
	ldrb r1, [r1]
	cmp r0, r1
	movgt r0, #1 @ Goku le pego
	movlt r0, #2 @ Vegeta le pego
	moveq r0, #0 @ No se pegaron
	mov pc, lr

	.unreq gx
	.unreq gy
	.unreq vx
	.unreq vy
	.unreq gw
	.unreq gh
	.unreq vw
	.unreq vh


	no_collision:
		mov r0, #0
		mov pc, lr


	