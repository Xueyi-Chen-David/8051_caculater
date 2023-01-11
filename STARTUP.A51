		CSEG AT 0x0000			
			
	
INIT:	
		MOV R6, #0; for remember add(1) or sub(2) or equal(3)
		MOV R2, #0
		
BEGIN:	
		MOV A, #0 ;row
		MOV R3, #0 ; i
		
		MOV A, #0xA0
		MOV R1, A
		MOV A, #0x3
		MOV @R1, A
		INC R1
		MOV A, #0x0
		MOV @R1, A
		INC R1
		MOV A, #0x5
		MOV @R1, A
		INC R1
		MOV A, #0x6
		MOV @R1, A
		ACALL Display
		SJMP BEGIN
		
Display:
		MOV A, #0
		MOV R2, A
		MOV A, #6 ; this number should modify !!!!!!!!!!! 8-n
		MOV R0, A ;move # to the left
		MOV B, #0
		MOV A, #0xA0
		MOV R4, A
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
		RET
		
DELAY:	MOV R7,#0XFF		
LOOP1:	DJNZ R7,LOOP1
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
			
		END	
			