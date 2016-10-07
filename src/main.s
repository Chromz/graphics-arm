 .text
 .align 2
 .global main
main:
	mov r0, #0
	bl getScreenAddr
	ldr r1,=pixelAddr
	str r0,[r1]

	bl enable_key_config

	bl draw_bg
	render$:
		@ldr r0, =goku_x
		@ldr r0, [r0]
		@ldr r1, =goku_y
		@ldr r1, [r1]
		@ldr r2, =Width_gok0
		@ldr r2, [r2]
		@ldr r3, =Height_gok0
		@ldr r3,[r3]
		mov r0, #50
		mov r1, #300
		mov r2, #66
		mov r3, #98
		bl reconstruct @ Reconstruir solo un pedazo del mapa

		bl getkey
		cmp r0, #'A'
		ldreq r1, =goku_x
		ldreq r1, [r1]
		addeq r1, #30
		ldreq r0, =goku_x
		streq r1, [r0]
		
		ldr r0, =goku_x
		ldr r0,[r0]
		ldr r1, =goku_y
		ldr r1,[r1]
		bl draw_goku
	b render$
	
	
.data
.global goku_x
goku_x: .word 50
.global goku_y
goku_y: .word 300
chaa: .byte 'a'
.global pixelAddr
pixelAddr: .word 0
