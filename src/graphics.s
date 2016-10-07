/*
* R0, Direccion de memoria a la matriz
* R1, X inicial
* R2, Y inicial
* R3, Width de la matriz
* Stack-1 Height de la matriz 
* Codigo Basado en el proporcionado en blackboard
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
			ldr r0, =63488
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

@ R0, x init
@ R1, y init
.global draw_goku
draw_goku:
	push {lr}
	mov r2, r1
	mov r1, r0
	ldr r0, =Image_Matrix_gok0
	ldr r3, =Width_gok0
	ldr r3, [r3]
	ldr r4, =Height_gok0
	ldr r4, [r4]
	str r4, [sp, #-4]!
	bl draw_hero
	pop {pc}

@ R0, x0 a reconstruir
@ R1, y0 a reconstruir
@ R2, Width de la reconstruccion
@ R3, Height de la reconstruccion
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
		bl calculate_offset
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
	pop {lr}

@ R0, Width
@ R1, X
@ R2, Y
.global calculate_offset
calculate_offset:
	mov r3, #2
	mul r0, r3, r0
	mul r0, r2, r0
	mul r1, r3, r1
	add r0, r1
	mov pc, lr


.global wait
wait:
	ldr r0,=0x989680
	mov r1, #0
	sleep:
		add r1, #1
		cmp r1, r0
		bne sleep
	mov pc, lr



	


	