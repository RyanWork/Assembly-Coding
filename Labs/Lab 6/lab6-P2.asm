; Lab6 - Subroutine to retrive and print a salary from 
;		  an Employee record from an array of structures

; Constant definitions
Display	.EQU 04E9h	; address of Libra display

; Offsets to access individual fields within the records
ID			.EQU 0	; Zero bytes from start of record is ID
NAME 		.EQU 1	; One byte from start of record is name
GENDER 		.EQU 3	; 3 bytes from start of record is gender
SALARY 		.EQU 4	; 4 bytes from start of record is salary
REC_SIZE	.EQU 5	; Total size of each record is 5 bytes


;;;;;;;;;;;;;;;;;;;;
; Function: getSalary
; Function to retrive the salary of the specified employee record.
;
; Input Parameters:
; 	Stack: 16-bit address of start of array of structures
;	Stack: 8-bit record number to be printed (record numbering starts at 0)
; Output Paramters:
;	Stack: returns 8-bit salary of specified Employee record
getSalary:
	; Save register values that will be modified in this routine
	PUSH AX							; FIX ME
	PUSH SI							; FIX ME
	PUSH BP							; FIX ME
	PUSH BX

	; Get input parameters from the stack. 
	; Use SI for the start address of the array of structures
	; Use AL for record number
	MOV BP, SP							; FIX ME
	MOV SI, [BP + 10]							; FIX ME
	MOV AL, [BP + 12]							; FIX ME
	
	; Calculate OFFSET of this record (distance from starting address of array of structures)
	; Offset is REC_NUM*REC_SIZE)
	MOV AH, REC_SIZE			; FIX ME: Load REC_SIZE into suitable register (for MUL)
	MUL AH						; FIX ME: Multiply REC_NUM by REC_SIZE 
	MOV BX, AX					; FIX ME: move offset into a suitable register (see next line)

	; For the next instruction, you MUST USE BASED-INDEXED Addressing mode (look it up!)
	MOV AL, [SI + SALARY + BX]					; FIX ME - Load the salary of this record into AL

	MOV [BP + 14], AL						; FIX ME - Save return value into reserved slot in stack frame
	
	; Restore registers
	POP BX
	POP BP							; FIX ME
	POP SI							; FIX ME
	POP AX	 						; FIX ME

	; Return to calling function
	RET							; FIX ME


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; INSERT SUBROUTINES FROM lab6-P1.asm HERE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;
; printInt: Subroutine to print a 1-byte unsigned (short) integer between 0-255
; Input parameters:
; 	Stack: Unsigned short int to be printed
; Output parameters:
;	None.
printInt:
	; Save registers modified by this subroutine
	PUSH AX
	PUSH CX
	PUSH BP		; FIX ME
	
	; Retrieve input parameter from stack into AL
	MOV BP, SP			; FIX ME - make a copy of SP
	MOV AL, [BP + 8]	; FIX ME - read from the appropriate slot of your stack frame
	
	MOV CL, 10			; Will be dividing by 10...
	
LoopPI:
	CMP AL, 10		; Compare the number to 10
	JL printLast	; If it is less than 10, then print this digit
	; If it is greater than 10, divide by 10
	MOV AH, 0		; Clear AH
	DIV CL			; Divide number by 10
	PUSH AX				; FIX ME - Push the input parameter of printDigit onto the stack
	CALL printDigit ; Print the quotient in AL
	POP AX				; FIX ME - Pop the input parameter of printDigit back off the stack
	MOV AL, AH		; Move remainder into AL to be printed
	jmp LoopPI		; Jump back to the top of the loop
printLast:
	PUSH AX				; FIX ME - Push the input parameter of printDigit onto the stack
	CALL printDigit ; Print the quotient in AL
	POP AX				; FIX ME - Pop the input parameter of printDigit back off the stack

	; Restore registers
	POP BP			; FIX ME
	POP CX
	POP AX
	
	RET


;;;;;;;;;;;;;;;;;
; printDigit: Subroutine to print a single decimal digit
; Input parameters:
; 	Stack: Unsigned decimal digit (between 0-9) to be printed
; Output parameters:
;	None.
printDigit:
	; Save registers modified by this subroutine
	PUSH AX
	PUSH DX
	PUSH BP			; FIX ME
	
	; Retrieve input parameter from stack into AL
	MOV BP, SP			; FIX ME - make a copy of SP
	MOV AL, [BP + 8]			; FIX ME - read from the appropriate slot of your stack frame
	
	MOV DX, Display
	ADD AL, '0'		; Convert number to ASCII code
	OUT DX,AL		; Print it
	
	; Restore registers
	POP BP			; FIX ME
	POP DX
	POP AX
	
	RET
	
		
;;;;;;;;;;;;;;;;;
; printSalary: Subroutine to print employee salary
; Input parameters:
; 	Stack: Unsigned short int (0-255) representing salary in 1000's of $
; Output parameters:
;	None.

printSalary:
	; Save registers modified by this subroutine
	PUSH AX
	PUSH SI				; Not strictly necessary, but please keep
	PUSH DX
	PUSH BP				; FIX ME
	
	; Retrieve input parameter from stack into AL
	MOV BP, SP			; FIX ME - make a copy of SP
	MOV AL, [BP + 10]	; FIX ME - read from the appropriate slot of your stack frame
	
	MOV DX, Display
	
	MOV AH,AL			; Keep a copy of the salary in AH (need AL for printing...)
	MOV AL, '$'			; Print '$' preceeding number
	OUT DX,AL			; Print it
	MOV AL,AH			; Move salary back into AL
	PUSH AX				; FIX ME - Push the input parameter of printInt onto the stack
	CALL printInt		; Print the salary (0-255)
	POP AX				; FIX ME - Pop the input parameter of printInt back off the stack

	MOV AL, ','			; Print ',' after number
	OUT DX,AL			; Print it
	MOV AL, '0'			; Print '0' after comma
	OUT DX,AL			; Print a zero
	OUT DX,AL			; Print a zero
	OUT DX,AL			; Print a zero
	
	; Restore registers
	POP BP				; FIX ME
	POP DX
	POP SI
	POP AX
	
	RET


;;;;;;;;;;;;;;;;;
; newLine: Subroutine to print a newline and a linefeed character
; Input parameters:
; 	None.
; Output parameters:
;	None.

; Constants for this subroutine:
s_CR .EQU 0Dh		; ASCII value for Carriage return
s_LF .EQU 0Ah		; ASCII value for NewLine

newLine:
	; Save registers modified by this subroutine
	PUSH AX
	PUSH DX
	
	MOV DX, Display		; Initialize the output port number in DX
	MOV AL, s_LF		; Load line feed (LF) into AL
	out DX,AL			; print the char
	MOV AL, s_CR		; Load carriage return (CR) into AL
	out DX,AL			; print the char
	
	; Restore registers
	POP DX
	POP AX
	
	RET
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; END OF SUBROUTINES FROM lab6-P1.asm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		
;;;;;;;;;;;;;;;;;;;;;;;;	
; main: Main function to test all subroutines
main:

	; Print salary of dayShiftDB[0]
	MOV BX, dayShiftDB
	MOV AL, 0
	PUSH AX					; FIX ME Make room on stack for return value from getSalary
	PUSH AX					; FIX ME Push record number
	PUSH BX						; FIX ME Push starting address of array of structures
	CALL getSalary						; FIX ME Invoke getSalary subroutine
	POP BX						; FIX ME Pop starting address of array of structures
	POP AX						; FIX ME Pop record number
	call printSalary		; Input parameter for printSalary is already on the stack!
	CALL newLine
	POP DX						; FIX ME Pop the return value from getSalary
	
	; Print dayShiftDB[3] FIX ME. Add LINES BELOW TO DO THIS

	MOV BX, dayShiftDB
	MOV AL, 3
	PUSH AX					; FIX ME Make room on stack for return value from getSalary
	PUSH AX					; FIX ME Push record number
	PUSH BX						; FIX ME Push starting address of array of structures
	CALL getSalary						; FIX ME Invoke getSalary subroutine
	POP BX						; FIX ME Pop starting address of array of structures
	POP AX						; FIX ME Pop record number
	call printSalary		; Input parameter for printSalary is already on the stack!
	CALL newLine
	POP DX						; FIX ME Pop the return value from getSalary
	
	; Print nightShiftDB[0] FIX ME. Add LINES BELOW TO DO THIS

	MOV BX, nightShiftDB
	MOV AL, 0
	PUSH AX					; FIX ME Make room on stack for return value from getSalary
	PUSH AX					; FIX ME Push record number
	PUSH BX						; FIX ME Push starting address of array of structures
	CALL getSalary						; FIX ME Invoke getSalary subroutine
	POP BX						; FIX ME Pop starting address of array of structures
	POP AX						; FIX ME Pop record number
	call printSalary		; Input parameter for printSalary is already on the stack!
	CALL newLine
	POP DX						; FIX ME Pop the return value from getSalary
	
	;Quit
	HLT
	
	
;;;;;;;;;;;;;;;;;;;;;;;;
; Test data
;

; Record format:
;Struct Employee {
;	char* name;	// 2-byte pointer to string of chars
;	bool gender;	// 1-byte Boolean (zero-->male, else-->female)
;	short salary;	// 1-byte unsigned short int salary (in $1000�s)
;	int id;		// 1-byte unsigned integer ID
;};
.ORG 5000h

dayShiftDB:
	; Record dayShiftDB[0]
	.DB 12			; dayShiftDB[0].id
	.DW name0		; dayShiftDB[0].name
	.DB 0			; dayShiftDB[0].gender
	.DB 50			; dayShiftDB[0].salary
	
	; Record dayShiftDB[1]
	.DB 27
	.DW name1		
	.DB 1
	.DB 58
	
	; Record dayShiftDB[2]
	.DB 1
	.DW name2		
	.DB 1
	.DB 70

	; Record dayShiftDB[3]
	.DB 77
	.DW name3		
	.DB 0
	.DB 32

nightShiftDB:
	.DB 7
	.DW name4		; Record nightShiftDB[0]
	.DB 1
	.DB 99
	
	.DB 80
	.DW name5		; Record nightShiftDB[1]
	.DB 0
	.DB 75

name0: .DB 'Sam Jones$'
name1: .DB 'Sara Thomas$'
name2: .DB 'Samira Smith$'
name3: .DB 'Max Golshani$'
name4: .DB 'The Boss!$'
name5: .DB 'Sven Svenderson$'

.END main		;Entry point of program is main()