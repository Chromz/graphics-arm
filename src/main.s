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
		push {r0-r1}
		bl wait
		pop {r0-r1}
	b render$
	
	
.data
goku_x: .word 50
goku_y: .word 300
chaa: .byte 'a'
.global pixelAddr
pixelAddr: .word 0
