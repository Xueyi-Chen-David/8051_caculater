		CSEG AT 0x0000			
				
INIT:	
		MOV R1, #0xA0
		MOV @R1, #0
		MOV R1, #0xA1
		MOV @R1, #0
		MOV R1, #0xB0
		MOV @R1, #0
		MOV R1, #0xB1
		MOV @R1, #0
		MOV P2, #0x3f
		MOV R2, #0
		MOV R4, #0xA0
		MOV R6, #0
		CLR F0
		MOV R5, #0
BEGIN:	
		MOV A, #0 ;row
		MOV R3, #0 ; i

/**************************************/
SCAN:	MOV A, R3
		MOV DPTR, #ScanCode
		MOVC A, @A+DPTR
		MOV P0, A
		ACALL WAIT	
		ACALL WAIT	
		MOV A,P0 ;when press A has a different resalt
		ANL A,#0xf0
		
		CJNE A, #0xe0, T
		MOV R0, #0
		SJMP COUNT
		
T:      CJNE A, #0xd0, T2
		MOV R0, #1
		SJMP COUNT
		
T2:     CJNE A, #0xb0, T3
		MOV R0, #2
		SJMP COUNT
		
T3:     CJNE A, #0x70, T4
		MOV R0, #3
		SJMP COUNT
		
T4: 	ACALL Display
		LJMP Default
		

COUNT:		
		MOV A, R0 ; put key=1,2,3,4 to A
		RL A      ; key*2
		RL A      ; key*4
		ADD A, R3 ; key*4 + i ;A can select which number 
		
		CJNE A, #10, Sub
		MOV R6, #1
		MOV R5, #1
		SJMP Addi
SCAN1:	SJMP SCAN		
Addi:	
		MOV R1, #0xB1
		MOV A, @R1
		MOV B, A
		MOV R7, #0
		MOV R1, #0xA1
		MOV A, @R1
		ADD A, B
		
		MOV B, #10
		DIV AB
		MOV @R1, B
		MOV R7, A
		
		MOV R1, #0xB0
		MOV A, @R1
		MOV B, A
		MOV R1, #0xA0
		MOV A, @R1
		ADD A, B
		ADD A, R7
		MOV B, #10
		DIV AB
		MOV @R1, B
		JNZ Overflow		
Next1:	
		MOV R4, #0xA0
		ACALL Display
		MOV A, #0xB0 ;clear b
		MOV R1, A
		MOV @R1, #0
		INC R1
		MOV @R1, #0
		
		SJMP Default
Addi2:	
		MOV A, #0xB0
		ACALL SubCommon
		MOV R7, A
		
		MOV A, #0xA0
		ACALL SubCommon
		SJMP Next1
		
		SUBB A, R7
		JC Addi3
		ACALL CCLemon
		SJMP Next1
Addi3:	
		CLR F0
		ACALL CCLemon
		SJMP Next1
CCLemon:	
		MOV B, #10
		DIV AB
		MOV R1, #0xA0
		MOV @R1, A
		INC R1
		MOV @R1, B
		RET
		
Overflow:	
		MOV A, #0xA0
		MOV R1, A
		MOV @R1, #9
		INC R1
		MOV @R1, #9
		SJMP Next1
		
Default: 
		INC R3
		CJNE R3,#4,SCAN1
		LJMP BEGIN

Sub:	CJNE A, #11, Equal		
		MOV R5, #1
		MOV R6, #2
Sub1:	MOV A, #0xB0
		ACALL SubCommon
		MOV R7, A
		
		MOV A, #0xA0
		ACALL SubCommon
		CLR C
		SUBB A, R7
		JC Sub2
Sub3:	MOV B, #10
		DIV AB
		MOV R1, #0xA0
		MOV @R1, A
		INC R1
		MOV @R1, B
		SJMP Next1
Sub2:	
		SETB F0
		CPL A
		ADD A, #1
		SJMP Sub3
		
SubCommon:		
		MOV R1,A
		MOV A, @R1
		MOV B, #10
		MUL AB
		MOV B, A
		INC R1
		MOV A, @R1
		ADD A, B
		RET
		
Equal:	CJNE A, #12, CLEAR	
		CJNE R6, #1, Equal1
		MOV R5, #0
		LJMP Addi 
Equal1: CJNE R6, #2, CC
		MOV R5, #0
		LJMP Sub1  
		
CLEAR:	CJNE A, #13, CC	
		LJMP INIT
			
CC:		MOV B, A ; B = A		
		CJNE R5, #0, CC2
		
		ACALL StoreNum
		ACALL Display	
		SJMP Default
		
CC2:	
		JB F0, CC3
		MOV R4, #0xB0
		ACALL StoreNum
		ACALL Display	
		SJMP Default
		
CC3:	
		MOV R4, #0xB0
		ACALL StoreNum
		CLR F0
		ACALL Display	
		SETB F0
		SJMP Default
		
StoreNum: 
		MOV R0, #1 
		MOV A, R4
		MOV R1, A
		
SN1:	MOV A, R0
		ADD A, R4
		MOV R1, A
		
		MOV A, @R1
		DEC R1
		MOV @R1, A
		INC R0
		
		CJNE R0, #2, SN1 ; this number should modify !!!!!!!!!!! n
		DEC R0
		MOV A, R4
		ADD A, R0
		MOV R1, A
		MOV @R1, B	

		RET
/**************************************/
;below is fuxking no problem
Display:
		JB F0, Display2
E4:		MOV A, #0
		MOV R2, A
		MOV R0, #6 ; this number should modify !!!!!!!!!!! 8-n
		MOV B, #0
E1:		
		MOV A, R4 ;r4 is address
		MOV R1, A
		MOV A, B		
		ADD A, R1
		MOV R1, A
		MOV A, @R1
		JZ E3
		
E5:		ACALL ShowNum
		
E2:		INC B
		INC R0
		MOV A, B
		CJNE A, #2, E1 ; this number should modify !!!!!!!!!!! n
		RET
		
E3:		CJNE R2, #0, E5
		SJMP E2
		
Display2:		
		MOV DPTR,#TABLE
		MOV P1,#5 ; this number should modify !!!!!!!!!!! 7-n
		MOV A, #0x40
		ACALL L0
		SJMP E4
		
/**************************************/
ShowNum:
        MOV DPTR,#TABLE
		MOV P1,R0 ; which led will be light
		INC R2
		MOVC A,@A+DPTR
		
L0:		
		MOV P2,A
		ACALL DELAY
		ACALL DELAY
		NOP
		RET
		
DELAY:	MOV R7,#0Xff		
LOOP1:	DJNZ R7,LOOP1
		MOV R7,#0Xff		
LOOP2:	DJNZ R7,LOOP2
		MOV R7,#0Xff		
LOOP3:	DJNZ R7,LOOP3
		RET
			
			
WAIT:	ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY	
		ACALL DELAY	
		ACALL DELAY	
		RET

TABLE:  
		DB 3fh ;0
	    DB 06h ;1
	    DB 5bh ;2
	    DB 4fh ;3
	    DB 66h ;4
	    DB 6dh ;5
        DB 7dh ;6
  	    DB 07h ;7
		DB 7fh ;8
		DB 6fh ;9
			
ScanCode:
		DB 11111110B ;0xfe
		DB 11111101B ;0xfd
		DB 11111011B ;0xfb
		DB 11110111B ;0xf7
			
		END	
			