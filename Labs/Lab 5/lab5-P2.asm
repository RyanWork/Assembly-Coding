; Lab5 - Subroutine to print a record from an array of structures

; Constant definitions
Display		.EQU 04E9h	; address of Libra display



; Constant strings (prompts or labels to be printed to screen, etc)
s_name: 	.DB 'Name: $'
s_male: 	.DB 'Mr. $'
s_female: 	.DB 'Ms. $'
s_empNum: 	.DB 'Employee number: $'
s_salary: 	.DB 'Salary: $'

; Offsets to access individual fields within the records
ID			.EQU 0	; Zero bytes from start of record is ID
NAME 		.EQU 1	; One byte from start of record is name
GENDER 		.EQU 3	; 3 bytes from start of record is gender
SALARY 		.EQU 4	; 4 bytes from start of record is salary
REC_SIZE	.EQU 5	; Total size of each record is 5 bytes

; Other defines
male		.EQU 0	; Gender field: 0=male, 1=female
female		.EQU 1	;

;;;;;;;;;;;;;;;;;;;;
; Function: printEmployee
; Function to print an employee record to screen.
;
; Input Parameters:
; 	BX: Address of start of array of structures
;	AL: Record number to be printed (record numbering starts at 0)
; Output Paramters:
;	None.
printEmployee:
		; Save register values that will be modified in this routine
		PUSH AX		; FIX ME
		PUSH CX		; FIX ME
		PUSH SI		; FIX ME

		; Calculate starting address of this record
		; Starting address is START+(REC_NUM*REC_SIZE)
		MOV AH, REC_SIZE				; FIX ME  Load REC_SIZE into AH
		MUL AH				; FIX ME  Multiply REC_NUM (already in AL) by REC_SIZE (in AH)
		ADD AX, 0				; FIX ME  Compute START+(REC_NUM*REC_SIZE)

		; Print 'Name: ' label
		MOV SI, s_name					; FIX ME
		CALL printStr

		; Print Mr/Mrs according to gender
		MOV CL, GENDER					; FIX ME  Load the gender field into AL. Need to use displacement addressing mode
		CMP CL, male				; Compare gender to zero
		je printMale
	printFemale:
		MOV SI, s_female					; FIX ME  Print Ms.
		CALL printStr
		JMP	printName
	printMale:
		MOV SI, s_male				; FIX ME  Print Mr.
		CALL printStr

		; Print name. Must load name pointer into SI, then call printStr
	printName:
		MOV SI, NAME					; FIX ME  Load the name field as input parameter. Need to use displacement addressing mode
		CALL printStr				
		CALL newLine							; FIX ME  Print a newLine character
		
		; Print employee number
	printEmpNum:
		MOV SI, s_empNum						; FIX ME Print 'Employee number: '
		CALL printStr
		MOV SI, ID					; FIX ME  Print employee number. (Need to use displacement addressing mode)
		CALL printInt
									; FIX ME  Print a newLine character

		; Print employee salary
	printEmpSalary:
		MOV SI, s_salary			; FIX ME  Print the 'Salary: ' label 
		CALL printStr
		MOV CX, SALARY				; FIX ME  Load the SALARY field into AL. Need to use displacement addressing mode
		CALL printSalary			; Prints salary in 1000's of $
									; FIX ME  Print a newLine character

		; Restore registers
		POP SI	; FIX ME
		POP CX		; FIX ME
		POP AX		; FIX ME

	; Return to calling function
	RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; INSERT SUBROUTINES FROM lab5-P1.asm HERE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;
; printStr: Subroutine to print a '$'-terminated string
; Input parameters:
; 	SI: Address of start of string to be printed
; Output parameters:
;	None.
printStr:
	; Save registers modified by this subroutine
	PUSH DX		; FIX ME
	PUSH BX		; FIX ME
	PUSH SI		; FIX ME

	MOV DX, Display
	MOV BX,0
LoopPS:
	MOV AL, [SI+BX]	; Load the next char to be printed - USING INPUT PARAMETER SI
	CMP AL, '$'		; Compare the char to '$'
	JE quitPS		; If it is equal, then quit subroutine and return to calling code
	OUT DX,AL		; If it is not equal to '$', then print it
	INC BX			; Point to the next char to be printed
	jmp LoopPS		; Jump back to the top of the loop
quitPS:
	; Restore registers
	POP SI		; FIX ME
	POP BX		; FIX ME
	POP DX		; FIX ME

	RET


;;;;;;;;;;;;;;;;;
; printDigit: Subroutine to print a single decimal digit
; Input parameters:
; 	AL: Unsigned decimal digit (between 0-9) to be printed
; Output parameters:
;	None.
printDigit:
	; Save registers modified by this subroutine
	PUSH DX		; FIX ME
	PUSH AX		; FIX ME
	
	MOV DX, Display
	ADD AL, '0'		; Convert number to ASCII code
	OUT DX,AL		; Print it
	
	; Restore registers
	POP AX		; FIX ME
	POP DX		; FIX ME
	
	RET
	
		
;;;;;;;;;;;;;;;;;
; printInt: Subroutine to print a 1-byte unsigned (short) integer between 0-255
; Input parameters:
; 	AL: Unsigned short int to be printed
; Output parameters:
;	None.
printInt:
	; Save registers modified by this subroutine
	PUSH DX		; FIX ME
	PUSH CX		; FIX ME
	PUSH AX		; FIX ME
	
	MOV DX, Display
	MOV CL, 10		; Will be dividing by 10...
	
LoopPI:
	CMP AL, 10		; Compare the number to 10
	JL printLast	; If it is less than 10, then print this digit
	; If it is greater than 10, divide by 10
	MOV AH, 0		; Clear AH
	DIV CL			; Divide number by 10
	CALL printDigit ; Print the quotient in AL
	MOV AL, AH		; Move remainder into AL to be printed
	jmp LoopPI		; Jump back to the top of the loop
printLast:
	CALL printDigit
	
	; Restore registers
	POP AX		; FIX ME
	POP CX		; FIX ME
	POP DX		; FIX ME
	
	RET


;;;;;;;;;;;;;;;;;
; printSalary: Subroutine to print employee salary
; Input parameters:
; 	AL: Unsigned short int (0-99) representing salary in 1000's of $
; Output parameters:
;	None.

; Constant strings for this subroutine:
s_thousands: .DB ',000$'
s_dollars: .DB '$'

printSalary:
	; Save registers modified by this subroutine
	PUSH DX		; FIX ME
	PUSH AX		; FIX ME
	PUSH SI		; FIX ME
	
	MOV DX, Display
	
	MOV AH,AL			; Keep a copy of the salary in AH (need AL for printing...)
	MOV AL, [s_dollars]	; Print '$' preceeding number
	OUT DX,AL			; Print it
	MOV AL,AH			; Move salary back into AL
	CALL printInt		; Print the salary (0-255)
	MOV SI, s_thousands	; Move the starting address of s_thousands string into BX
	CALL printStr 		; Print ',000'
	
	; Restore registers
	POP SI		; FIX ME
	POP AX		; FIX ME
	POP DX		; FIX ME
	
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
	PUSH DX		; FIX ME
	PUSH AX		; FIX ME
	
	MOV DX, Display		; Initialize the output port number in DX
	MOV AL, s_LF		; Load line feed (LF) into AL
	out DX,AL			; print the char
	MOV AL, s_CR		; Load carriage return (CR) into AL
	out DX,AL			; print the char
	
	; Restore registers
	POP AX		; FIX ME
	POP DX		; FIX ME
	
	RET
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; END OF SUBROUTINES FROM lab5-P1.asm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		
;;;;;;;;;;;;;;;;;;;;;;;;	
; main: Main function to test all subroutines
main:

	; Print dayShiftDB[2]
	MOV  AX, dayShiftDB		; FIX ME Load address of dayShiftDB in register (?)
	MOV  CX, name2				; FIX ME Load record number in register (?)
	CALL printEmployee
	CALL newLine
	
	; Print nightShiftDB[0]
	MOV  AX, nightShiftDB				; FIX ME Load address of nightShiftDB
	MOV  CX, name0			; FIX ME Load record number
	CALL printEmployee
	CALL newLine
	
	; Print dayShiftDB[3]
	MOV  AX,dayShiftDB			; FIX ME Load address of dayShiftDB
	MOV  CX, name3			; FIX ME Load record number
	CALL printEmployee
	CALL newLine
	
	;Quit
	HLT
	
	
;;;;;;;;;;;;;;;;;;;;;;;;
; Test data
;

; Record format:
;Struct Employee {
;	int id;			// 1-byte unsigned integer ID
;	char* name;		// 2-byte pointer to string of chars
;	bool gender;	// 1-byte Boolean (zero-->male, else-->female)
;	short salary;	// 1-byte unsigned short int salary (in $1000’s)
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