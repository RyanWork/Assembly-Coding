; SYSC2001 - Lab 3
; Program to complete 8-bit unsigned shift & add multiplication
; AH = A; CH = Q; BH = M; Final 16-bit result in AX

.ORG 0000h
Data:
	Y:	.DB	15		; Multiplicand
	X: 	.DB	73		; Multiplier
	
.ORG 0010h
Init:
	MOV	AL, 0Fh 	; Initialize AX to zero. AH serves as accumulator and AX will hold product
	MOV BX, 49h
	
	MUL BX
	
quit:
	HLT
.END	Init