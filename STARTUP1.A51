		CSEG AT 0x0000			
INIT:	
		MOV A, #0xA0
		MOV R1, A
		MOV @R1, #0
		INC R1
		MOV @R1, #0
		MOV A, #0xB0
		MOV R1, A
		MOV @R1, #0
		INC R1
		MOV @R1, #0
		MOV R4, #0xA0
		MOV R6, #0; for remember add(1) or sub(2) or equal(3)
		MOV R2, #0
BEGIN:	
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


ProcessNum: 
		MOV R0, #1 
		MOV A, R4
		MOV R1, A
		
Pr1:		
		MOV A, R0
		ADD A, R4
		MOV R1, A
		
		MOV A, @R1
		DEC R1
		MOV @R1, A
		INC R0
		
		CJNE R0, #2, Pr1 ;if R0 equal n !!!!!!!!!!
		DEC R0
		MOV A, R4
		ADD A, R0
		MOV R1, A
		MOV @R1, B
		
		ACALL Display
		RET
		
Display:
		
;		MOV A, #6 ; this number should modify !!!!!!!!!!!
;		MOV R0, A ;move # to the left
;		MOV B, #0

		MOV DPTR,#TABLE
		MOV A, #0xA1
		MOV R1, A
		MOV A, @R1
		MOVC A,@A+DPTR
		MOV P1,#6 
		MOV P2, A
		ACALL DELAY
		
;		INC R1
;		MOV A, @R1
;		MOV P1,#6 ; which led will be light
;		MOVC A,@A+DPTR
;		MOV P2, A
;		ACALL DELAY
		

		
;E1:		
;		MOV A, R4 ;r4 is address
;		MOV R1, A
;		MOV A, B		
;		ADD A, R1
;		MOV R1, A
;		MOV A, @R1
;		JZ E3
;E5:		ACALL ShowNum
;		
;E2:		INC B
;		INC R0
;		MOV A, B
;		CJNE A, #2, E1
;		RET
		
;E3:		
;		CJNE R0, #6, E4 ; this number should modify !!!!!!!!!!!
;		SJMP E2
		
;E4:		CJNE R0, #7, E4
;		CJNE R2, #0, E5
;		SJMP E2


/**************************************/

ShowNum:
        MOV DPTR,#TABLE
		MOV P1,R0 ; which led will be light
		MOVC A,@A+DPTR
		INC R2
		
L0:		
		MOV P2,A
		ACALL DELAY
		RET
		
DELAY: 
		MOV R4, #0xff
		DJNZ R4, $
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
			
