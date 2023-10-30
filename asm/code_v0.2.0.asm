.nolist
.includepath "/usr/share/avra/includes"
.include "m8def.inc"
.list


;.dec ROW

;rjmp reset


	ldi r16, 0xff
	out ddrb, r16
	ldi r16, 0xff
	out ddrd, r16


reset:

	ldi r17, 0
	ldi r16, 0b1

	ldi zl, low(ROW*2)
	ldi zh, high(ROW*2)
m3:

	;mov r1, r16
	st z, r16

	ldi r18, 1
	add zl, r18
	ldi r18, 0
	adc zh, r18

	inc r16
	inc r17

	cpi r17, 8
	brne m3
	

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
	
	ldi r20, 0b00000010
	ldi r19, 0xff
	ldi r18, 0xff
	subi r18, 1
	sbci r19, 0
	sbci r20, 0
	brcc pc-3


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

;reti
rjmp DISPLAY
	



.dseg
;ROW: .byte 8
ROW: .byte 8
;.db 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8
