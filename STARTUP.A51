		CSEG AT 0x0000	
		MOV R2, #2; this is to limit the number to n digits!!!!!!!! (n)----------------
		MOV R6, #0; for remember add(1) or sub(2) or equal(3)
		
BEGIN:	;r2,3
		MOV A, #0 ;row
		MOV R3, #0 ; i
		
SCAN:	
		MOV A, R3
		MOV DPTR, #ScanCode
		MOVC A, @A+DPTR
		MOV P0, A
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
		
T4: 	
		ACALL Display
		SJMP Default


COUNT:		
		MOV A, R0 ; put key=1,2,3,4 to A
		RL A      ; key*2
		RL A      ; key*4
		ADD A, R3 ; key*4 + i ;A can select which number 
		MOV B, A ; B = A	
		CJNE R2, #2, Handle1 ; no number no disaply
		CJNE A, #0, Handle1  ; first number is zero no disaply
		SJMP Default		

Default: 
		INC R3
		CJNE R3,#4,SCAN
		SJMP BEGIN
		
Handle1:
		MOV R4, #0XA0
		ACALL ProcessNum
		SJMP Default



ProcessNum: ; at most push 2 number
		CJNE R2, #0, Pr1 ; if r2 is zero, it means don't put more digits in
		ACALL Display
		RET
		
Pr1:
Display:
		JZ Default ; if A is zero, it means no number is given
		
		CLR C
		MOV A, #7
		MOV R0, A ;move # to the left
		
		ACALL ShowNum
E3:		RET
		
		


/**************************************/

ShowNum:
        MOV DPTR,#TABLE
		MOV P1,R0 ; which led will be light
		MOV A, B
		MOVC A,@A+DPTR
		
L0:		
		MOV P2,A
		ACALL DELAY
		RET
		
DELAY: 
		MOV R1, #0xff
		DJNZ R1, $
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
			
