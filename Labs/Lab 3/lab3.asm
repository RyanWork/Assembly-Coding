; SYSC2001 - Lab 3
; Program to complete 8-bit unsigned shift & add multiplication
; AH = A; CH = Q; BH = M; Final 16-bit result in AX

.ORG 0000h
Data:
	Y:	.DB	15		; Multiplicand
	X: 	.DB	73		; Multiplier
	
.ORG 0010h
Init:
	MOV	AX,	0000h	; Initialize AX to zero. AH serves as accumulator and AX will hold product
	MOV	CH,	[X]		; Initialize CH (Q) = X
	MOV	BH,	[Y]		; Init BH (M) = Y
	MOV DL, 8h		; Init DL as a loop counter with number of iterations required
	
mainLoop:
	ROR CH, 1		; Shift out the lsb of the multiplier (Q[0]) into the carry flag
	JNC shift		; Check the carry flag: If Q[0] was not set, skip over Add and just shift
AddM:
	ADD AH, BH		; A = A + M
shift:
	RCR	AH, 1		; Shift AH and AL (16-bit result will be here eventually). Also need to shift CF into MSb of AH...
	RCR AL, 1
	DEC	DL 			; Decrement loop counter
	CMP	DL, 0		; If loop counter reaches zero, quit, else, loop back
	JG mainLoop
quit:
	HLT
.END	Init