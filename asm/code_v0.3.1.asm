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
.def NUM = r29


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
	
	
	
	; clear RAM
	ldi zl, low(ROW*2)
	ldi zh, high(ROW*2)
	ldi r17, 0
	ldi r16, 0
e2:	
	st z, r17
	ldi r18, 1
	add zl, r18
	ldi r18, 0
	adc zh, r18
	inc r16
	cpi r16, 16
	brne e2

;	ldi r17, 0
;	ldi r16, 0b1
;
;	ldi zl, low(ROW*2)
;	ldi zh, high(ROW*2)
;m3:
;	st z, r16
;
;	ldi r18, 1
;	add zl, r18
;	ldi r18, 0
;	adc zh, r18
;
;	inc r16
;	inc r17
;
;	cpi r17, 8
;	brne m3

	; Manual game select

	; start timer2
	ldi r16, CS21<<1 | CS20<<1
	out TCCR2, r16

;	ldi NUM, 1
	
w1:	sbis pinc, 0
	rcall SET_DIGIT
	sbis pinc, 1
	rcall SET_DIGIT
	sbis pinc, 2
	rcall SET_DIGIT
	sbis pinc, 3
	rcall SET_DIGIT
rjmp w1

SET_DIGIT:

;!!!
	ldi r17, 0x0f
	ldi r16, 0xff
	rcall delay2


	in r16, TCNT0 ; 0..255
	
	; /16
	swap r16
	ldi r17, 0x0f
	and r16, r17 ; r16 = 0..15

	ldi zl, low(COORD*2)
	ldi zh, high(COORD*2)

	ldi r17, 0
	add zl, r16
	adc zh, r17

	lpm r17, Z
;	mov r17, r0 ; r16=coord

;!!!!
mov r25, r17

ldi zl, low(ROW*2)
ldi zh, high(ROW*2)

ldi r16, 7
ldi r17, 0
add zl, r16
adc zh, r17

st z, r25

ldi r17, 0x0f
ldi r16, 0xff
rcall delay2

;rcall toggle
ret

	mov r17, r16
	ldi r18, 0x0f
	and r17, r18 ; r17 - Y
	
	swap r16
	ldi r18, 0x0f
	and r16, r18 ; r16 - X


	ldi zl, low(ROW*2)
	ldi zh, high(ROW*2)
	
	add zl, r17
	ldi r18, 0
	adc zh, r18

	ld r18, z ; r18 - low_row
	
	ldi r19, 1
	add zl, r19
	ldi r19, 0
	adc zh, r19
	ld r19, z ; r19 - high_row 

	sbrs NUM, 0
	sbr r20, 0 ; r20 - low_row_new
	lsr NUM
	lsl r20
	sbrs NUM, 0
	sbr r20, 0
	lsr NUM

	sbrs NUM, 0
	sbr r21, 0 ; r20 - high_row_new
	lsr NUM
	lsl r21
	sbrs NUM, 0
	sbr r21, 0
	lsr NUM

	subi r16, 2
	mov r22, r16
e1:	lsl r20
	lsl r21
	dec r22
	cpi r22, 0
	brne e1

	or r18, r20
	or r19, r21


	ldi zl, low(ROW*2)
	ldi zh, high(ROW*2)
	
	add zl, r17
	ldi r22, 0
	adc zh, r22
	
	st z, r18

	ldi r22, 1
	add zl, r22
	ldi r22, 0
	adc zh, r22

	st z, r19

	inc NUM

ret






cycle:
	sbis pinc, 0
	rcall LEFT
;	sbis pinc, 3
;	rcall RIGHT
;	sbis pinc, 1
;	rcall UP
;	sbis pinc, 2
;	rcall DOWN
	
	rjmp cycle


LEFT:
	ldi r17, 0x03
	ldi r16, 0xff
	rcall delay2	

	;LEFT function
	rcall toggle
	
	sbic pinc, 0
	rjmp end_left

	ldi r17, 0x01
	ldi r16, 0xff
	rcall delay2
	
;!!!!!!!!
1:	sbic pinc, 2
	rjmp pc-6
	
	;Increase brightness
	cpi BRIGHTNESS, 0xff
	breq pc+2
	inc BRIGHTNESS
	
	;delay
	ldi r17, 0x1f
	ldi r16, 0xff
	rcall delay2
	
	rjmp 1

end_left:
	
	ldi r17, 0x03
	ldi r16, 0xff
	rcall delay2

ret

toggle:

	; set r25 in high row

	ldi zl, low(ROW*2)
	ldi zh, high(ROW*2)
	
	ldi r16, 7
	ldi r17, 0
	add zl, r16
	adc zh, r17

	st Z, r25

ret


DISPLAY:

	push r16
	push r17
	push r18
	push r19
	push r22

	ldi zl, low(ROW*2)
	ldi zh, high(ROW*2)
	
	ldi r17, 0b1

m1:
	ldi r22, 0xff
	eor r22, r17

	ld r16, z
	out portd, r16
	out portb, r22
	
	; Brightness delay
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


	pop r22
	pop r19
	pop r18
	pop r17
	pop r16

reti
;rjmp DISPLAY
	
delay2:
	subi r16, 1
	sbci r17, 0
	brcc pc-3
ret


COORD:
.db 0b00000110, 0b00100110, 0b01000110, 0b01100110, 0b00000100, 0b00100100, 0b01000100, 0b01100100, 0b00000010, 0b00100010, 0b01000010, 0b01100010, 0b00000000, 0b00100000, 0b01000000, 0b01100000

.dseg
;ROW: .byte 8
ROW: .byte 8
;.db 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8
;xy	0x06, 0x26, 0x46, 0x66,
;	0x04, 0x24...
