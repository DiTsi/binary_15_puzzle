.nolist
.includepath "/usr/share/avra/includes"
.include "m8def.inc"
.list


.org 0x0
rjmp RESET
.org 0x9
rjmp DISPLAY
;.dec ROW

;rjmp reset

.def BRIGHTNESS = r25



RESET:


	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r16, low(RAMEND)
	out SPL, r16

	ldi r16, 0xff
	out ddrb, r16
	ldi r16, 0xff
	out ddrd, r16

	;timer0
	ldi r16, 1<<TOIE0
	out TIMSK, r16

	ldi r16, 1<<CS01
	out TCCR0, r16



	sei



	ldi BRIGHTNESS, 0x02



	ldi r17, 0
	ldi r16, 0b1

	ldi zl, low(ROW*2)
	ldi zh, high(ROW*2)
m3:
	st z, r16

	ldi r18, 1
	add zl, r18
	ldi r18, 0
	adc zh, r18

	inc r16
	inc r17

	cpi r17, 8
	brne m3
	cpi BRIGHTNESS, 0x01
	breq pc+2




cycle:
	sbis pinc, 0
	rcall LEFT
	sbis pinc, 3
	rcall RIGHT

	rjmp cycle



	;CHANGE ALGORITHM!!! CHECKING IS WRONG




LEFT:
	
	;LEFT function
	
	ldi r16, 0xff
	subi r16, 1
	brcc pc-1
	
	
	sbic pinc, 0
	ret
	
	1:
	sbic pinc, 3 ; right
	rjmp pc-3
	
	;Increase brightness
	cpi BRIGHTNESS, 0xff
	breq pc+2
	inc BRIGHTNESS
	
	;delay
	ldi r17, 0x1f
	ldi r16, 0xff
	subi r16, 1
	sbci r17, 0
	brcc pc-2
	
	rjmp 1


RIGHT:
	
	;RIGHT function
	
	ldi r16, 0xff
	subi r16, 1
	brcc pc-1
	
	
	sbic pinc, 3
	ret
	
	2:
	sbic pinc, 0 ; right
	rjmp pc-3
	
	;Decrease brightness
	cpi BRIGHTNESS, 0x01
	breq pc+2
	dec BRIGHTNESS
	
	;delay
	ldi r17, 0x1f
	ldi r16, 0xff
	subi r16, 1
	sbci r17, 0
	brcc pc-2
	
	rjmp 2


DISPLAY:

	push r16
	push r17
	push r18
	push r19

	ldi zl, low(ROW*2)
	ldi zh, high(ROW*2)
	
	ldi r17, 0b1

m1:
	ldi r22, 0xff
	eor r22, r17

	ld r16, z
	out portd, r16
	out portb, r22
	
	; instead r18 -> LIGHT_INTENSITY
	mov r18, BRIGHTNESS
;	ldi r18, 0x05
	subi r18, 1
	brcc pc-1


	ldi r16, 0xff
	out portb, r16
	clr r16
	out portd, r16

	ldi r16, 1
	add zl, r16
	ldi r16, 0
	adc zh, r16

	lsl r17

	cpi r17, 0
	brne m1


	pop r19
	pop r18
	pop r17
	pop r16

reti
;rjmp DISPLAY
	



.dseg
;ROW: .byte 8
ROW: .byte 8
;.db 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8
