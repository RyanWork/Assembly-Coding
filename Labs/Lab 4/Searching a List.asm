; SYSC2001 - Lab 4
; Program to complete 8-bit unsigned number to NASA
; 

Display	.EQU 04E9h			;Display variable assigned to 04E9h

.ORG 0010h					;Start at 0010h

;Start of list of applicants
AppNums:			
	.DB 01
	.DB 02
	.DB 03
	.DB 04
	.DB 05
	.DB 06
	.DB 07			
	.DB 08
	.DB 09
	.DB 10
Sent: .DB 0xFF				;Sentinel Variable at the end of the list addresses

;Intialize other necessary variables
myNum: .DB 02				;Assigned number to contestant
numIter: .DB 09				;initializes a value of 'n' iterations to loop
	
.ORG 0100h					;Initialize text in memory

;If user wins
winMsg: .DB ' was your position. You won!$'		;Win statement

;If user loses
loseMsg: .DB 'You lose :($'	;Lose statement

.ORG 0200h					;Start main code at 0200h

;Initialization
Main:						;Initialization Header
	MOV DX, Display			;Open I/O to DX register
	MOV SI, AppNums			;Point SI register to first value in list
	MOV CL, 00h				;Set counter to 0
	MOV AL, [myNum]			;Set value of AL to myNum

;Beginning of Loop
mainLoop:
	CMP SI, Sent			;Compare if SI register is sentinel variable
	JE loseNum				;If true, jump to sadMessage
	
	CMP CL, [numIter]		;Compare value of counter with number of Iterations
	JG loseNum				;If counter > number of Iterations jump to sadMessage

;Check if the number is a winning number
checkNum:
	CMP [SI], AL			;Compare value at SI to assigned number
	JE winNum				;Jump to winNum if they are equal
	
;Point to next item in list
pointNext:
	INC SI					;Point SI to next address in list
	INC CL					;Increment value of counter
	JMP mainLoop			;Jump back to mainLoop
	
;Print out winning messag
winNum:
	ADD CL, 31h				;Offset the number to print
	MOV AL, CL				;Mov position number into AL
	OUT DX, AL				;Print position number
	MOV BX, winMsg			;BX points to first character in winning message
	JMP printChar			;Jump to print character
	
;Print Losing Message
loseNum:
	MOV BX, loseMsg			;BX point to first character in losing message
	JMP printChar			;Jump to print character

;Point to next char in message
nextChar:
	INC BX					;BX to point to next char
	
;Print characters in message
printChar:
	MOV AL, [BX]			;Move character into AL
	CMP AL, '$'				;Check if delimiter in string
	JE quit					;If pointing to delimiter, exit program
	OUT DX, AL				;Else, print character
	JMP nextChar			;Jump to nextChar

;Quit program
quit:						
	HLT						;Causes the program to stop
.END Main