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
	ldi r16, 0x0f

	ldi zl, low(ROW*2)
	ldi zh, high(ROW*2)

m3:

	mov r0, r16
	spm

	ldi r18, 1
	add zl, r18
	ldi r18, 0
	adc zh, r18

	inc r16
	inc r17

	cpi r17, 7
	brne m3
	

DISPLAY:

	;push r16
	;push r17
	;push r18
	;push r19

	ldi r17, 0b01111111

	ldi zl, low(ROW*2)
	ldi zh, high(ROW*2)

m1:
	rol r17

	lpm
	mov r16, r0
	out portd, r16
	out portb, r17
	

	; delay
	ldi r19, 0x00
	ldi r18, 0x0f
	subi r18, 1
	sbci r19, 0
	brcc pc-2


	ldi r16, 0xff
	out portb, r16

	ldi r16, 1
	add zl, r16
	ldi r16, 0
	adc zh, r16

;	cpi r17, 0b10111111
	sbrc r17, 7
	rjmp m1
;	brne m1

	;pop r19
	;pop r18
	;pop r17
	;pop r16

;reti
rjmp DISPLAY
	

.dseg
ROW: .byte 8
