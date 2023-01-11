		CSEG AT 0x0000			
			
	
INIT:	MOV A, #0xA0
		MOV R1, A
		MOV @R1, #0
		INC R1
		MOV @R1, #0
		MOV A, #0xB0
		MOV R1, A
		MOV @R1, #0
		INC R1
		MOV @R1, #0
		
		MOV R2, #0
		MOV R4, #0xA0
BEGIN:	
		MOV A, #0 ;row
		MOV R3, #0 ; i
		CLR F0
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
		SJMP Default
		
COUNT:		
		MOV A, R0 ; put key=1,2,3,4 to A
		RL A      ; key*2
		RL A      ; key*4
		ADD A, R3 ; key*4 + i ;A can select which number 
		

Addi:	CJNE A, #10, Sub
		CLR C
		MOV R1, #0xB0
		INC R1
		MOV A, @R1
		MOV B, A
		MOV R7, #0
		
		MOV R1, #0xA0
		INC R1
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
		
		SETB F0
		MOV R4, #0xA0
		ACALL Display
		
		MOV A, #0xB0 ;clear b
		MOV R1, A
		MOV @R1, #0
		INC R1
		MOV @R1, #0
		SJMP Default

Default: 
		INC R3
		CJNE R3,#4,SCAN
		SJMP BEGIN

Sub:	CJNE A, #11, Equal		
		

	
Equal:	CJNE A, #12, CC	
		MOV R6, #3

CC:		MOV B, A ; B = A	
		JB F0, CC2		
		
		ACALL StoreNum
		ACALL Display	
		SJMP Default
		
CC2:	MOV R4, #0xB0
		ACALL StoreNum
		ACALL Display	

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
		MOV A, #0
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
		ACALL DELAY
		RET
		
DELAY:	MOV R7,#0Xff		
LOOP1:	DJNZ R7,LOOP1
		MOV R7,#0Xff		
LOOP2:	DJNZ R7,LOOP2
		MOV R7,#0X6f		
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
			