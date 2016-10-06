@ Suburutina de establecer una direccion de memoria al reloj de la raspberry pi
.global GetTimerAddress
GetTimerAddress:
    timerAddr	.req r0
	push {lr}
	ldr timerAddr,=0x3F003000 @Timer base para raspberry 2
	@modificaciones para utilizar la memoria virtual
	bl phys_to_virt
 	ldr r1, =timerloc
 	str r0, [r1] 
	pop {pc}
	.unreq timerAddr

@ Subrutina para obtener el tiempo almacenado en 8 bytes del reloj de la rasp
.global GetCurrentTime
GetCurrentTime:
    push {lr}
    ldr r0, =timerloc
    ldr r0, [r0]
    ldrd r0, r1, [r0, #4] 
    pop {pc}

@ Subrutina para ejecutar un delay por un tiempo
@ R0, Tiempo en MICROSEGUNDOS
.global Timer
Timer:
    push {lr}
    gap .req r2
    mov gap, r0
    bl GetCurrentTime @ Obtener el tiempo inicial
    time_init .req r3
    mov time_init, r0
    time_loop:
        bl GetCurrentTime
        sub r1, r0, time_init @ Obtener el delta del tiempo
        cmp r1, gap @ Verificar si ya se cumplio el ancho del delay
        ble time_loop
    .unreq gap
    .unreq time_init
    pop {pc}
