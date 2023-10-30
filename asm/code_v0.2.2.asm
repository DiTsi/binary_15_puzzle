.nolist
.includepath "/usr/share/avra/includes"
.include "m8def.inc"
.list


;.dec ROW

;rjmp reset
.org 0
rjmp reset
		  .org 9
rjmp DISPLAY


.def COORDINATES = r21
.def DIGIT = r22


reset:

	; set stack pointer
	ldi r16, high(ramend)
	out SPH, r16
	ldi r16, low(ramend)
	out SPL, r16


	; configure ports
	ldi r16, 0xff
	out ddrb, r16
	ldi r16, 0xff
	out ddrd, r16
	;ldi r16, 0b11111
	;out ddrc, r16


	;ldi COORDINATES, 0b00100011 ; 0b00XX00YY
	;ldi DIGIT, 4

	ldi r16, 1<TOIE0
	out TIMSK, r16

	;sei ; enable interrupts

	ldi r16, 1<<CS21
	out TCCR2, r16

	
;SET_CELL:
;	mov r16, COORDINATES ; X
;	swap r16
;	ldi r18, 0b00001111
;	and r16, r18 ; X
;	lsl r16 ; double_X
;
;	mov r17, COORDINATES ; Y
;	ldi r18, 0x0f
;	and r17, r18 ; Y
;	lsl r17 ; double_Y
;
;	ldi zl, low(ROW*2)
;	ldi zh, high(ROW*2)
;
;	add zl, r17
;	ldi r18, 0
;	adc zh, r18
;
;	ld r18, z ; low_string
;
;	sbrc DIGIT, 1
	


	


	
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

	


	












;	clr r18 
;	clr r19
;ree:
;	; DIGIT convert
;
;	mov r17, DIGIT
;	ldi r16, 0b1100
;	and r17, r16
;	lsr r17
;	lsr r17
;
;	; another order!!! mirrored digits!!!
;	or r18, r17
;	lsl r18
;	lsl r18
;
;	mov r17, DIGIT
;	ldi r16, 0b11
;	and r17, r16
;
;	or r19, r17
;	lsl r19
;	lsl r19
;
;	inc DIGIT
;
;	cpi DIGIT, 9
;	brne ree
;
;
;	ldi zl, low(ROW*2)
;	ldi zh, high(ROW*2)
;
;
;	mov r16, r19
;	rcall m3
;	mov r16, r18
;	rcall m3
;

;!!!
rjmp display

cycle:
	rjmp cycle




;m3:
;	st z, r16
;
;	ldi r18, 1
;	add zl, r18
;	ldi r18, 0
;	adc zh, r18
;ret
	

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
	
	ldi r18, 0xff
	subi r18, 1
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
ROW: .byte 8
;.db 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8
