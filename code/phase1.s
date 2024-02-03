	
    INCLUDE definitions.s
	;INCLUDE egcellent.s

	AREA MYCODE, CODE, READONLY


	EXPORT __main
    ENTRY

__main FUNCTION
    ;This is the main funcion, you should only call two functions, one that sets up the TFT
	;And the other that draws a rectangle over the entire screen (ie from (0,0) to (320,240)) with a certain color of your choice
	

	
	;FINAL TODO: CALL FUNCTION SETUP
	BL CONFIG_BUTTONS
	BL SETUP

	
    BL INITIALIZE_VARIABLES
	BL INITIALIZE_WHITE_EGG
	BL INITIALIZE_RED_EGG
	;FINAL TODO: DRAW THE ENTIRE SCREEN WITH A CERTAIN COLOR
	
	;LDR R10, =MAGENTA
	;BL DRAW_RECTANGLE_FILLED
		
	;LDR R10, =YELLOW
	;BL DRAW_RECTANGLE_FILLED2
	MOV R0, #0
	MOV R1, #0
	MOV R3, #320
	MOV R4, #240
	BL DRAWCHICKENGAME
	;BL RANDOM1
	
	;BEQ INPUT_LOOP
	;BNE INPUT_LOOP

	
MAINLOOP

	
	PUSH{R0-R7}
;	MOV R0, #0
;	MOV R1, #0
;	MOV R3, #320
;	MOV R4, #240
	

	;BL DRAW_EGGCELLENT
	;BL DRAWDINOGAME
	;BL DRAW_LOSE_SCREEN
	LDR R6,= SCORE
	LDRH R7,[R6] ; SCORE IS INSIDE R7
	CMP R7, #50
	BGE BARA_YA_KALAB
	POP{R0-R7}
	

INPUT_LOOP

	LDR R0, =GPIOC_IDR
	LDR R1, [R0]
	MOV R2, #1
	LSL R2, #14
	AND R1, R1, R2
	CMP R1, #0
	BEQ LEFT_PRESSED
	
	LDR R0, =GPIOB_IDR
	LDR R1, [R0]
	MOV R2, #1
	LSL R2, #7
	AND R1, R1, R2
	CMP R1, #0
	BEQ RIGHT_PRESSED
	
	B EGGS
	
LEFT_PRESSED
    BL MOVE_BASKET_LEFT
	;BL delay_10_MILLIsecond
	B EGGS
	
RIGHT_PRESSED
    BL MOVE_BASKET_RIGHT
	;BL delay_10_MILLIsecond
	 

EGGS

	LDR R9, = RANDOM_FLAG
	LDRH R11,[R9]
	CMP R11,#0
	BEQ WHITEFLAG
	CMP R11,#1
	BEQ REDFLAG
	
WHITEFLAG
	 BL MOVE_WHITE_EGG1_DOWN
	 B KAMAL_HAYATAK
	
REDFLAG
	 BL MOVE_RED_EGG1_DOWN
	 
KAMAL_HAYATAK 

	 BL delay_sixtth_second ; DH EL DELAY EL HYTL3B FRH
	 LDR R9, = EGG_MATAT
	 LDRH R11,[R9]
	 CMP R11,#0
	 BEQ ANZLY_YA_EGGYA
	 BL delay_10_MILLIsecond
	 
	 LDR R6,= SCORE
	 LDRH R7,[R6] ; SCORE IS INSIDE R7
	 CMP R7, #50
	 BNE INPUT_LOOP

ANZLY_YA_EGGYA
	
	LDR R9, = RANDOM_EGG_NUMBER
	LDRH R5,[R9]
	ADD R5,#1
	STRH R5, [R9]
	CMP R5,#1
	BEQ RANDPATTERN1
	CMP R5,#2
	BEQ RANDPATTERN2
	CMP R5,#3
	BEQ RANDPATTERN3
	CMP R5,#4
	BEQ RANDPATTERN4
	CMP R5,#5
	BEQ RANDPATTERN5
	CMP R5,#6
	BEQ RANDPATTERN6
	CMP R5,#7
	BEQ RANDPATTERN7
	CMP R5,#8
	BEQ RANDPATTERN8
	CMP R5,#9
	BEQ RANDPATTERN9
	CMP R5,#10
	BEQ RANDPATTERN10
	
	
RANDPATTERN1 
	BL RANDOM1
	B BARA_YA_KALAB
	
RANDPATTERN2 
	BL RANDOM2	
	B BARA_YA_KALAB
	
RANDPATTERN3
	BL RANDOM3
	B BARA_YA_KALAB
	
RANDPATTERN4
	BL RANDOM4
	B BARA_YA_KALAB
	
RANDPATTERN5
	BL RANDOM5	
	B BARA_YA_KALAB
	
RANDPATTERN6
	BL RANDOM6
	B BARA_YA_KALAB

RANDPATTERN7
	BL RANDOM7
	B BARA_YA_KALAB

RANDPATTERN8
	BL RANDOM8
	B BARA_YA_KALAB

RANDPATTERN9
	BL RANDOM9
	B BARA_YA_KALAB

RANDPATTERN10
	LDR R9, = RANDOM_EGG_NUMBER
	LDRH R5,[R9]
	MOV R5,#0
	STRH R5, [R9]
	BL RANDOM10		

BARA_YA_KALAB
	 LDR R6,= SCORE
	 LDRH R7,[R6] ; SCORE IS INSIDE R7
	 CMP R7, #50
	 BNE INPUT_LOOP
	 BNE MAINLOOP
	
    ENDFUNC
	
CONFIG_BUTTONS FUNCTION
	PUSH{R0-R12, LR}
	
	LDR R0, =RCC_APB2ENR
	LDR R1, [R0]
	MOV R2, #1
	ORR R1, R1, R2, LSL #3
	STR R1, [R0]
	
	LDR R0, =RCC_APB2ENR
	LDR R1, [R0]
	MOV R2, #1
	ORR R1, R1, R2, LSL #4
	STR R1, [R0]
	
	
	LDR R0, =GPIOC_CRH ;PC13, 14, 15 ; input
	MOV R1, #0x88888888
	STR R1, [R0]
	
	LDR R0, =GPIOC_ODR ; pull up
	MOV R1, #0xFFFFFFFF
	STR R1, [R0]
	
	
	LDR R0, =GPIOB_CRL ;PB ; input port b pin 7
	LDR R1, [R0]
	MOV R2, #0x80000000
	ORR R1, R1, R2
	STR R1, [R0]
	
	LDR R0, =GPIOB_ODR ; pull up port b
	MOV R1, #0xFFFFFFFF
	STR R1, [R0]
	
	POP{R0-R12, PC}
	ENDFUNC
;#####################################################################################################################################################################
LCD_WRITE   FUNCTION
	;this function takes what is inside r2 and writes it to the tft
	;this function writes 8 bits only
	;later we will choose whether those 8 bits are considered a command, or just pure data
	;your job is to just write 8-bits (regardless if data or command) to PE0-7 and set WR appropriately
	;arguments: R2 = data to be written to the D0-7 bus

	;TODO: PUSH THE NEEDED REGISTERS TO SAVE THEIR CONTENTS. HINT: Push any register you will modify inside the function
	PUSH {r0-r3, LR}


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING WR to 0 ;;;;;;;;;;;;;;;;;;;;;
	;TODO: RESET WR TO 0
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	LSL R3, #8
	MVN R3, R3
	AND r0, r0, R3
	STRH r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;BL delay_1_second

	;;;;;;;;;;;;; HERE YOU PUT YOUR DATA which is in R2 TO PE0-7 ;;;;;;;;;;;;;;;;;
	;TODO: SET PE0-7 WITH THE LOWER 8-bits of R2
	LDR r1, =GPIOA_ODR
	STRB r2, [r1]			;only write the lower byte to PE0-7
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;BL delay_1_second

	;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING WR to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET WR TO 1 AGAIN (ie make a rising edge)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #8
	STRH r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;BL delay_1_second


	;TODO: POP THE REGISTERS YOU JUST PUSHED.
	POP {R0-r3, PC}
    ENDFUNC
;#####################################################################################################################################################################




;#####################################################################################################################################################################
LCD_COMMAND_WRITE   FUNCTION
	;this function writes a command to the TFT, the command is read from R2
	;it writes LOW to RS first to specify that we are writing a command not data.
	;then it normally calls the function LCD_WRITE we just defined above
	;arguments: R2 = data to be written on D0-7 bus

	;TODO: PUSH ANY NEEDED REGISTERS
	PUSH {R0-R3, LR}
	


	;TODO: SET RD HIGH (we won't need reading anyways, but we must keep read pin to high, which means we will not read anything)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #9
	STRH r0, [r1]

	;;;;;;;;;;;;;;;;;;;;;;;;; SETTING RS to 0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RS TO 0 (to specify that we are writing commands not data on the D0-7 bus)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	LSL R3, #12
	MVN R3, R3
	AND r0, r0, R3
	STRH r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;TODO: CALL FUNCTION LCD_WRITE
	BL LCD_WRITE


	;TODO: POP ALL REGISTERS YOU PUSHED
	POP {R0-R3, PC}
    ENDFUNC
;#####################################################################################################################################################################






;#####################################################################################################################################################################
LCD_DATA_WRITE  FUNCTION
	;this function writes Data to the TFT, the data is read from R2
	;it writes HIGH to RS first to specify that we are writing actual data not a command.
	;arguments: R2 = data

	;TODO: PUSH ANY NEEDED REGISTERS
	PUSH {R0-R3, LR}

	;TODO: SET RD TO HIGH (we don't need to read anything)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #9
	STRH r0, [r1]

	;;;;;;;;;;;;;;;;;;;; SETTING RS to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RS TO 1 (to specify that we are sending actual data not a command on the D0-7 bus)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #12
	STRH r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;TODO: CALL FUNCTION LCD_WRITE
	BL LCD_WRITE

	;TODO: POP ANY REGISTER YOU PUSHED
	POP {R0-R3, PC}
    ENDFUNC
;#####################################################################################################################################################################







;#####################################################################################################################################################################
LCD_INIT    FUNCTION
	;This function executes the minimum needed LCD initialization measures
	;Only the necessary Commands are covered
	;Eventho there are so many more in the DataSheet

	;TODO: PUSH ANY NEEDED REGISTERS
  	PUSH {R0-R3, LR}

	;;;;;;;;;;;;;;;;; HARDWARE RESET (putting RST to high then low then high again) ;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RESET PIN TO HIGH
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #14
	STRH r0, [r1]

	;TODO: DELAY FOR SOME TIME
	BL delay_1_second

	;TODO: RESET RESET PIN TO LOW
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	LSL R3, #14
	MVN R3, R3
	AND r0, r0, R3
	STRH r0, [r1]

	;TODO: DELAY FOR SOME TIME
	BL delay_1_second

	;TODO: SET RESET PIN TO HIGH AGAIN
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #14
	STRH r0, [r1]

	;TODO: DELAY FOR SOME TIME
	BL delay_1_second
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






	;;;;;;;;;;;;;;;;; PREPARATION FOR WRITE CYCLE SEQUENCE (setting CS to high, then configuring WR and RD, then resetting CS to low) ;;;;;;;;;;;;;;;;;;
	;TODO: SET CS PIN HIGH
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #6
	STR r0, [r1]
    
    

	;TODO: SET WR PIN HIGH
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #8
	STRH r0, [r1]

	;TODO: SET RD PIN HIGH
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #9
	STRH r0, [r1]

    

	;TODO: SET CS PIN LOW
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	LSL R3, #6
	MVN R3, R3
	AND r0, r0, R3
	STR r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	B skip_this_line1
	LTORG
skip_this_line1



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SOFTWARE INITIALIZATION SEQUENCE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: ISSUE THE "SET CONTRAST" COMMAND, ITS HEX CODE IS 0xC5
	MOV R2, #0xC5
	BL LCD_COMMAND_WRITE

	;THIS COMMAND REQUIRES 2 PARAMETERS TO BE SENT AS DATA, THE VCOM H, AND THE VCOM L
	;WE WANT TO SET VCOM H TO A SPECIFIC VOLTAGE WITH CORRESPONDS TO A BINARY CODE OF 1111111 OR 0x7F HEXA
	;TODO: SEND THE FIRST PARAMETER (THE VCOM H) NEEDED BY THE COMMAND, WITH HEX 0x7F, PARAMETERS ARE SENT AS DATA BUT COMMANDS ARE SENT AS COMMANDS
	MOV R2, #0x7F
	BL LCD_DATA_WRITE

	;WE WANT TO SET VCOM L TO A SPECIFIC VOLTAGE WITH CORRESPONDS TO A BINARY CODE OF 00000000 OR 0x00 HEXA
	;TODO: SEND THE SECOND PARAMETER (THE VCOM L) NEEDED BY THE CONTRAST COMMAND, WITH HEX 0x00, PARAMETERS ARE SENT AS DATA BUT COMMANDS ARE SENT AS COMMANDS
	MOV R2, #0x00
	BL LCD_DATA_WRITE


	;MEMORY ACCESS CONTROL AKA MADCLT | DATASHEET PAGE 127
	;WE WANT TO SET MX (to draw from left to right) AND SET MV (to configure the TFT to be in horizontal landscape mode, not a vertical screen)
	;TODO: ISSUE THE COMMAND MEMORY ACCESS CONTROL, HEXCODE 0x36
	MOV R2, #0x36
	BL LCD_COMMAND_WRITE

	;TODO: SEND ONE NEEDED PARAMETER ONLY WITH MX AND MV SET TO 1. HOW WILL WE SEND PARAMETERS? AS DATA OR AS COMMAND?
	;MOV R2, #0x68
	BL LCD_DATA_WRITE



	;COLMOD: PIXEL FORMAT SET | DATASHEET PAGE 134
	;THIS COMMAND LETS US CHOOSE WHETHER WE WANT TO USE 16-BIT COLORS OR 18-BIT COLORS.
	;WE WILL ALWAYS USE 16-BIT COLORS
	;TODO: ISSUE THE COMMAND COLMOD
	MOV R2, #0x3A
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE NEEDED PARAMETER WHICH CORRESPONDS TO 16-BIT RGB AND 16-BIT MCU INTERFACE FORMAT
	MOV R2, #0x55
	BL LCD_DATA_WRITE
	


	;SLEEP OUT | DATASHEET PAGE 101
	;TODO: ISSUE THE SLEEP OUT COMMAND TO EXIT SLEEP MODE (THIS COMMAND TAKES NO PARAMETERS, JUST SEND THE COMMAND)
	MOV R2, #0x11
	BL LCD_COMMAND_WRITE

	;NECESSARY TO WAIT 5ms BEFORE SENDING NEXT COMMAND
	;I WILL WAIT FOR 10MSEC TO BE SURE
	;TODO: DELAY FOR AT LEAST 10ms
	BL delay_1_second


	;DISPLAY ON | DATASHEET PAGE 109
	;TODO: ISSUE THE COMMAND, IT TAKES NO PARAMETERS
	MOV R2, #0x29
	BL LCD_COMMAND_WRITE


	;COLOR INVERSION OFF | DATASHEET PAGE 105
	;NOTE: SOME TFTs HAS COLOR INVERTED BY DEFAULT, SO YOU WOULD HAVE TO INVERT THE COLOR MANUALLY SO COLORS APPEAR NATURAL
	;MEANING THAT IF THE COLORS ARE INVERTED WHILE YOU ALREADY TURNED OFF INVERSION, YOU HAVE TO TURN ON INVERSION NOT TURN IT OFF.
	;TODO: ISSUE THE COMMAND, IT TAKES NO PARAMETERS
	MOV R2, #0x20
	BL LCD_COMMAND_WRITE



	;MEMORY WRITE | DATASHEET PAGE 245
	;WE NEED TO PREPARE OUR TFT TO SEND PIXEL DATA, MEMORY WRITE SHOULD ALWAYS BE ISSUED BEFORE ANY PIXEL DATA SENT
	;TODO: ISSUE MEMORY WRITE COMMAND
	MOV R2, #0x2C
	BL LCD_COMMAND_WRITE	


	;TODO: POP ALL PUSHED REGISTERS
	POP {R0-R3, PC}
    ENDFUNC
;#####################################################################################################################################################################









;#####################################################################################################################################################################
ADDRESS_SET     FUNCTION
	;THIS FUNCTION TAKES X1, X2, Y1, Y2
	;IT ISSUES COLUMN ADDRESS SET TO SPECIFY THE START AND END COLUMNS (X1 AND X2)
	;IT ISSUES PAGE ADDRESS SET TO SPECIFY THE START AND END PAGE (Y1 AND Y2)
	;THIS FUNCTION JUST MARKS THE PLAYGROUND WHERE WE WILL ACTUALLY DRAW OUR PIXELS, MAYBE TARGETTING EACH PIXEL AS IT IS.
	;R0 = X1
	;R1 = X2
	;R3 = Y1
	;R4 = Y2

	;PUSHING ANY NEEDED REGISTERS
	PUSH {R0-R4, LR}
	

	;COLUMN ADDRESS SET | DATASHEET PAGE 110
	MOV R2, #0x2A
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE FIRST PARAMETER (HIGHER 8-BITS OF THE STARTING COLUMN, AKA HIGHER 8-BITS OF X1)
	MOV R2, R0
	LSR R2, #8
	BL LCD_DATA_WRITE

	;TODO: SEND THE SECOND PARAMETER (LOWER 8-BITS OF THE STARTING COLUMN, AKA LOWER 8-BITS OF X1)
	MOV R2, R0
	BL LCD_DATA_WRITE


	;TODO: SEND THE THIRD PARAMETER (HIGHER 8-BITS OF THE ENDING COLUMN, AKA HIGHER 8-BITS OF X2)
	MOV R2, R1
	LSR R2, #8
	BL LCD_DATA_WRITE

	;TODO: SEND THE FOURTH PARAMETER (LOWER 8-BITS OF THE ENDING COLUMN, AKA LOWER 8-BITS OF X2)
	MOV R2, R1
	BL LCD_DATA_WRITE


	;PAGE ADDRESS SET | DATASHEET PAGE 110
	MOV R2, #0x2B
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE FIRST PARAMETER (HIGHER 8-BITS OF THE STARTING PAGE, AKA HIGHER 8-BITS OF Y1)
	MOV R2, R3
	LSR R2, #8
	BL LCD_DATA_WRITE

	;TODO: SEND THE SECOND PARAMETER (LOWER 8-BITS OF THE STARTING PAGE, AKA LOWER 8-BITS OF Y1)
	MOV R2, R3
	BL LCD_DATA_WRITE


	;TODO: SEND THE THIRD PARAMETER (HIGHER 8-BITS OF THE ENDING PAGE, AKA HIGHER 8-BITS OF Y2)
	MOV R2, R4
	LSR R2, #8
	BL LCD_DATA_WRITE

	;TODO: SEND THE FOURTH PARAMETER (LOWER 8-BITS OF THE ENDING PAGE, AKA LOWER 8-BITS OF Y2)
	MOV R2, R4
	BL LCD_DATA_WRITE

	;MEMORY WRITE
	MOV R2, #0x2C
	BL LCD_COMMAND_WRITE


	;POPPING ALL REGISTERS I PUSHED
	POP {R0-R4, PC}
    ENDFUNC
;#####################################################################################################################################################################





;#####################################################################################################################################################################
DRAWPIXEL   FUNCTION
	PUSH {R0-R5, r10, LR}
	;THIS FUNCTION TAKES X AND Y AND A COLOR AND DRAWS THIS EXACT PIXEL
	;NOTE YOU HAVE TO CALL ADDRESS SET ON A SPECIFIC PIXEL WITH LENGTH 1 AND WIDTH 1 FROM THE STARTING COORDINATES OF THE PIXEL, THOSE STARTING COORDINATES ARE GIVEN AS PARAMETERS
	;THEN YOU SIMPLY ISSUE MEMORY WRITE COMMAND AND SEND THE COLOR
	;R0 = X
	;R1 = Y
	;R10 = COLOR

	;CHIP SELECT ACTIVE, WRITE LOW TO CS
	LDR r3, =GPIOB_ODR
	LDR r4, [r3]
	MOV R5, #1
	LSL R5, #6
	MVN R5, R5
	AND r4, r4, R5
	STR r4, [r3]

	;TODO: SETTING PARAMETERS FOR FUNC 'ADDRESS_SET' CALL, THEN CALL FUNCTION ADDRESS SET
	;NOTE YOU MIGHT WANT TO PERFORM PARAMETER REORDERING, AS ADDRESS SET FUNCTION TAKES X1, X2, Y1, Y2 IN R0, R1, R3, R4 BUT THIS FUNCTION TAKES X,Y IN R0 AND R1
	MOV R3, R1 ;Y1
	ADD R1, R0, #1 ;X2
	ADD R4, R3, #1 ;Y2
	BL ADDRESS_SET


	
	;MEMORY WRITE
	MOV R2, #0x2C
	BL LCD_COMMAND_WRITE


	;SEND THE COLOR DATA | DATASHEET PAGE 114
	;HINT: WE SEND THE HIGHER 8-BITS OF THE COLOR FIRST, THEN THE LOWER 8-BITS
	;HINT: WE SEND THE COLOR OF ONLY 1 PIXEL BY 2 DATA WRITES, THE FIRST TO SEND THE HIGHER 8-BITS OF THE COLOR, THE SECOND TO SEND THE LOWER 8-BITS OF THE COLOR
	;REMINDER: WE USE 16-BIT PER PIXEL COLOR
	;TODO: SEND THE SINGLE COLOR, PASSED IN R10
	MOV R2, R10
	LSR R2, #8
	BL LCD_DATA_WRITE
	MOV R2, R10
	BL LCD_DATA_WRITE


	
	POP {R0-R5, r10, PC}
    ENDFUNC
;#####################################################################################################################################################################





;##########################################################################################################################################
DRAW_RECTANGLE_FILLED   FUNCTION
	;TODO: IMPLEMENT THIS FUNCTION ENTIRELY, AND SPECIFY THE ARGUMENTS IN COMMENTS, WE DRAW A RECTANGLE BY SPECIFYING ITS TOP-LEFT AND LOWER-RIGHT POINTS, THEN FILL IT WITH THE SAME COLOR
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	;COLOR = [] r10
	
	
	PUSH {R0-R12, LR}
	
	push{r0-r4}


	PUSH {R1}
	PUSH {R3}
	
	pop {r1}
	pop {r3}
	
	;THE NEXT FUNCTION TAKES x1, x2, y1, y2
	;R0 = x1
	;R1 = x2
	;R3 = y1
	;R4 = y2
	bl ADDRESS_SET
	
	pop{r0-r4}
	

	SUBS R3, R3, R0
	add r3, r3, #1
	SUBS R4, R4, R1
	add r4, r4, #1
	MUL R3, R3, R4


;MEMORY WRITE
	MOV R2, #0x2C
	BL LCD_COMMAND_WRITE


RECT_FILL_LOOP
	MOV R2, R10
	LSR R2, #8
	BL LCD_DATA_WRITE
	MOV R2, R10
	BL LCD_DATA_WRITE

	SUBS R3, R3, #1
	CMP R3, #0
	BGT RECT_FILL_LOOP


END_RECT_FILL
	POP {R0-R12, PC}

    ENDFUNC
;##########################################################################################################################################





;#####################################################################################################################################################################
SETUP   FUNCTION
	;THIS FUNCTION ENABLES PORT A, MARKS IT AS OUTPUT, CONFIGURES SOME GPIO
	;THEN FINALLY IT CALLS LCD_INIT (HINT, USE THIS SETUP FUNCTION DIRECTLY IN THE MAIN)
	PUSH {R0-R12, LR}

    BL PORTA_CONF    

	BL LCD_INIT

	POP {R0-R12, PC}

    ENDFUNC
;#####################################################################################################################################################################



;###########################################################################################################################################

PORTA_CONF  FUNCTION
    PUSH {R0-R2, LR}
    ; Enable GPIOA clock
    LDR R0, =RCC_APB2ENR         ; Address of RCC_APB2ENR register
    LDR R1, [R0]                 ; Read the current value of RCC_APB2ENR
	MOV R2, #1
    ORR R1, R1, R2, LSL #2        ; Set bit 2 to enable GPIOA clock
    STR R1, [R0]                 ; Write the updated value back to RCC_APB2ENR
    
    ; Configure PORT A AS OUTPUT (LOWER 8 PINS)
    LDR R0, =GPIOA_CRL                  
    MOV R2, #0x33333333     ;ALL 8 LOWER PINS OF PORT A AS OUTPUT WITH MAX SPEED OF 50 MHZ
    STR R2, [R0]

    ; Configure PORT A AS OUTPUT (HIGHER 8 PINS)
    LDR R0, =GPIOA_CRH           ; Address of GPIOC_CRH register
    MOV R2, #0x33333333     ;ALL 8 LOWER PINS OF PORT A AS OUTPUT WITH MAX SPEED OF 50 MHZ
    STR R2, [R0]                 ; Write the updated value back to GPIOC_CRH



    ; Enable GPIOC clock
    LDR R0, =RCC_APB2ENR         ; Address of RCC_APB2ENR register
    LDR R1, [R0]                 ; Read the current value of RCC_APB2ENR
	MOV R2, #1
    ORR R1, R1, R2, LSL #4        ; Set bit 4 to enable GPIOC clock
    STR R1, [R0]                 ; Write the updated value back to RCC_APB2ENR
    
    ; Configure PC13 as input pull up 
    LDR R0, =GPIOC_CRH           ; Address of GPIOC_CRH register
    LDR R1, [R0]                 ; Read the current value of GPIOC_CRH
    MOV R1, #0x88888888      ; Set mode bits for pin 13 (input mode)
    STR R1, [R0]                 ; Write the updated value back to GPIOC_CRH

	LDR R0, =GPIOC_ODR
;###################################################0XFFFFFFFFFFF##############################################
	MOV R1, #0xFFFF
	STR R1, [R0]


    ; Enable GPIOB clock
    LDR R0, =RCC_APB2ENR         ; Address of RCC_APB2ENR register
    LDR R1, [R0]                 ; Read the current value of RCC_APB2ENR
	MOV R2, #1
    ORR R1, R1, R2, LSL #3        ; Set bit 3 to enable GPIOB clock
    STR R1, [R0]                 ; Write the updated value back to RCC_APB2ENR
    
    
    LDR R0, =GPIOB_CRL           ; Address of GPIOC_CRL register
    MOV R1, #0x33333333      ; Set mode bits for pin 13 (output mode, max speed 50 MHz)
	AND R1, R1, #0x0FFFFFFF
	ORR R1, R1, #0x80000000
    STR R1, [R0]                 ; Write the updated value back to GPIOC_CRH


    LDR R0, =GPIOB_CRH           ; Address of GPIOC_CRL register
    MOV R1, #0x33333333      ; Set mode bits for pin 13 (output mode, max speed 50 MHz)
    STR R1, [R0]                 ; Write the updated value back to GPIOC_CRH


	LDR R0, =GPIOB_ODR
;###################################################0XFFFFFFFFFFF##############################################
	MOV R1, #0xFFFF
	STR R1, [R0]



    POP{R0-R2, PC}

    ENDFUNC


;###########################################################################################################################################




;###########################################################################################################################################

delay_1_second FUNCTION
    PUSH {R0-R12, LR}               ; Push R4 and Link Register (LR) onto the stack
    LDR R0, =INTERVAL           ; Load the delay coun
DelayInner_Loop
        SUBS R0, #1             ; Decrement the delay count
		cmp	R0, #0
        BGT DelayInner_Loop     ; Branch until the count becomes zero
    
    POP {R0-R12, PC}                ; Pop R4 and return from subroutine
	ENDFUNC

;###########################################################################################################################################


;###########################################################################################################################################
delay_half_second	FUNCTION
	;this function just delays for half a second
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop1
	SUBS r8, #2
	CMP r8, #0
	BGE delay_loop1

	POP {R8, PC}
	ENDFUNC
	
;###########################################################################################################################################
delay_quarter_second	FUNCTION
	;this function just delays for half a second
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop2
	SUBS r8, #4
	CMP r8, #0
	BGE delay_loop2
	POP {R8, PC}
	ENDFUNC
;###########################################################################################################################################

;###########################################################################################################################################
delay_eighth_second	FUNCTION
	;this function just delays for half a second
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop3
	SUBS r8, #8
	CMP r8, #0
	BGE delay_loop3
	POP {R8, PC}
	ENDFUNC
;###########################################################################################################################################

delay_sixtth_second	FUNCTION
	;this function just delays for half a second
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop4
	SUBS r8, #6
	CMP r8, #0
	BGE delay_loop4
	POP {R8, PC}
	ENDFUNC
;###########################################################################################################################################

delay_twenty_second	FUNCTION
	;this function just delays for half a second
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop5
	SUBS r8, #17
	CMP r8, #0
	BGE delay_loop5
	POP {R8, PC}
	ENDFUNC
;###########################################################################################################################################

delay_sixtyfour_second	FUNCTION
	;this function just delays for half a second
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop6
	SUBS r8, #64
	CMP r8, #0
	BGE delay_loop6
	POP {R8, PC}
	ENDFUNC
;###########################################################################################################################################



delay_10_MILLIsecond FUNCTION
    PUSH {R0-R12, LR}               ; Push R4 and Link Register (LR) onto the stack
    LDR R0, =INTERVAL           ; Load the delay count
DelayInner_Loop2
        SUBS R0, #1000             ; Decrement the delay count
		cmp	R0, #0
        BGT DelayInner_Loop2     ; Branch until the count becomes zero
    
    POP {R0-R12, PC}                ; Pop R4 and return from subroutine
	ENDFUNC

;#####################################################################################################################################################################

	
;###########################################################################################################################################

DrawDino FUNCTION         ;draws the dinosaur head (dino game)
;TODO: IMPLEMENT THIS FUNCTION ENTIRELY, AND SPECIFY THE ARGUMENTS IN COMMENTS, WE DRAW A RECTANGLE BY SPECIFYING ITS TOP-LEFT AND LOWER-RIGHT POINTS, THEN FILL IT WITH THE SAME COLOR
	;X1 = [] r0
	;Y1 = [] r3
	;SIZE is 23X8
	
	
	PUSH{R0-R12, LR}
	
	;draw HEAD
	PUSH{R0-R4,R10}
	;UPPER RECT
	MOV R10, #0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R3, #29 
	ADD R4, #9
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;LOWER RECT
	PUSH{R0-R4,R10}
	
	MOV R10, #0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R1, #10
	ADD R3, #39
	ADD R4, #33
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;TODO DRAW EYES AND SMILE
	; left eye
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #6
	ADD R1, #6
	ADD R3, #11
	ADD R4, #11
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	; right eye
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #19
	ADD R1, #6
	ADD R3, #24
	ADD R4, #11
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	; MOUTH
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #12
	ADD R1, #22
	ADD R3, #28
	ADD R4, #27
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;DRAW NICK
	PUSH{R0-R4,R10}
	MOV R10, #0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #11
	ADD R1, #34
	ADD R3, #26
	ADD R4, #99
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	
	POP{R0-R12, PC}
	
	ENDFUNC
;###########################################################################################################################################


;###########################################################################################################################################

	B skip_this_line2
	LTORG
skip_this_line2
;###########################################################################################################################################



;###########################################################################################################################################
DrawLives FUNCTION     ;this function draws the lives display atthe top of the screen (dino game)
	PUSH{R0-R12, LR}
	
	;draw HEAD
	PUSH{R0-R4,R10}
	;UPPER RECT
	MOV R10, #0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R3, #21
	ADD R4, #8
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;LOWER RECT
	PUSH{R0-R4,R10}
	
	MOV R10, #0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R1, #9
	ADD R3, #27
	ADD R4, #24
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;TODO DRAW EYES AND SMILE
	; left eye
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #6
	ADD R1, #4
	ADD R3, #9
	ADD R4, #7
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	; right eye
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #15
	ADD R1, #4
	ADD R3, #18
	ADD R4, #7
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	; MOUTH
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #10
	ADD R1, #17
	ADD R3, #17
	ADD R4, #20
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	; THE X SIGN
	;ONE
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #24
	ADD R3, #39
	ADD R4, #5
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;TWO
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #40
	ADD R1, #6
	ADD R3, #45
	ADD R4, #11
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;THREE
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #46
	ADD R1, #12
	ADD R3, #51
	ADD R4, #17
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;FOUR
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #52
	ADD R1, #18
	ADD R3, #57
	ADD R4, #23
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;FIVE
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #58
	ADD R1, #24
	ADD R3, #63
	ADD R4, #29
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;SIX
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #58
	ADD R3, #64
	ADD R4, #5
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;SEVEN
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #52
	ADD R1, #6
	ADD R3, #57
	ADD R4, #11
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;EIGHT
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #40
	ADD R1, #18
	ADD R3, #45
	ADD R4, #23
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;NINE
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #34
	ADD R1, #24
	ADD R3, #39
	ADD R4, #29
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;THE NUMBER
	
	;ONE 
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #70
	ADD R3, #81
	ADD R4, #5
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;TWO
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #81
	ADD R1, #6
	ADD R3, #87
	ADD R4, #11
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;THREE
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #75
	ADD R1, #12
	ADD R3, #80
	ADD R4, #17
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;FOUR
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #69
	ADD R1, #18
	ADD R3, #74
	ADD R4, #27
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;FIVE
	PUSH{R0-R4,R10}
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0, #75
	ADD R1, #22
	ADD R3, #87
	ADD R4, #27
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	POP{R0-R12, PC}
	
	ENDFUNC
;###########################################################################################################################################



;###########################################################################################################################################
DrawNav FUNCTION   ; this function draws the navbar (eggcellent game)
	
	PUSH{R0-R12, LR}
	PUSH{R0-R4,R10}
	MOV R10, #0x07FF
	MOV R3,R0
	MOV R4,R1
	
	ADD R3, #320 
	ADD R4, #35
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	POP{R0-R12, PC}
	
	ENDFUNC	
;###########################################################################################################################################
	B skip_this_line3
	LTORG
skip_this_line3

;###########################################################################################################################################
DrawBlocks FUNCTION   ; this function draws the blocks representing the dino's neck parts to collect (dino game)
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;1
	PUSH{R0-R4,R10}
	
	MOV R10,#0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#189
	ADD R1,#41
	ADD R3,#198
	ADD R4,#68
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	
	;2
	PUSH{R0-R4,R10}
	
	MOV R10,#0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#159
	ADD R1,#71
	ADD R3,#168
	ADD R4,#97
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;3
    PUSH{R0-R4,R10}
	
	MOV R10,#0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#130
	ADD R1,#101
	ADD R3,#139
	ADD R4,#123
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10} 
	
    ;4
	PUSH{R0-R4,R10}
	
	MOV R10,#0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#96
	ADD R1,#128
	ADD R3,#105
	ADD R4,#154
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;----------------
	PUSH{R0-R4,R10}
	
	MOV R10,#0X07FF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#53
	ADD R1,#159
	ADD R3,#247
	ADD R4,#164
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	POP{R0-R12,PC}
	ENDFUNC
;###########################################################################################################################################








;###########################################################################################################################################
DrawScore FUNCTION   ; this function draws the score displayed at the top of the screen (both games)
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;----
	
	;draw s
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#6
	ADD R1,#2
	ADD R3,#19
	ADD R4,#5
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#6
	ADD R3,#5
	ADD R4,#10
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;-----
	
    PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#6
	ADD R1,#11
	ADD R3,#15
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;|
	;|
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#16
	ADD R1,#16
	ADD R3,#20
	ADD R4,#21
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;-----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#22
	ADD R3,#15
	ADD R4,#25
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;draw C
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#29
	ADD R1,#2
	ADD R3,#38
	ADD R4,#5
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#25
	ADD R1,#6
	ADD R3,#28
	ADD R4,#21
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;-----
	
   PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#29
	ADD R1,#22
	ADD R3,#38
	ADD R4,#25
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;|
	;|
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#39
	ADD R1,#18
	ADD R3,#42
	ADD R4,#21
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#39
	ADD R1,#6
	ADD R3,#42
	ADD R4,#9
	
	B skip_this_line4
	LTORG
skip_this_line4

	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;draw O
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#53
	ADD R1,#1
	ADD R3,#64
	ADD R4,#4
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#49
	ADD R1,#5
	ADD R3,#52
	ADD R4,#22
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;-----
	
    PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#53
	ADD R1,#22
	ADD R3,#64
	ADD R4,#25
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;|
	;|
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#65
	ADD R1,#5
	ADD R3,#68
	ADD R4,#21
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	
	;DRAW R
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#75
	ADD R1,#1
	ADD R3,#87
	ADD R4,#4
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#75
	ADD R1,#1
	ADD R3,#78
	ADD R4,#26
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
   PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#88
	ADD R1,#5
	ADD R3,#91
	ADD R4,#12
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#79
	ADD R1,#12
	ADD R3,#88
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#85
	ADD R1,#12
	ADD R3,#88
	ADD R4,#26
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;DRAW E
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#98
	ADD R1,#1
	ADD R3,#112
	ADD R4,#4
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#98
	ADD R1,#1
	ADD R3,#101
	ADD R4,#26
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;---
    PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#102
	ADD R1,#12
	ADD R3,#111
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#102
	ADD R1,#23
	ADD R3,#112
	ADD R4,#26
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;DRAW COLON
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#121
	ADD R1,#6
	ADD R3,#124
	ADD R4,#11
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;DOWN
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#121
	ADD R1,#15
	ADD R3,#124
	ADD R4,#21
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;DRAW TWO ZERO
	PUSH{R0-R4,R10}
	MOV R0,#166
	MOV R1,#5
	BL Draw0
	MOV R0,#135
	MOV R1,#5
	BL Draw0
	
    POP{R0-R4,R10}
	
	POP{R0-R12,PC}
	ENDFUNC
;###########################################################################################################################################
	
DRAW_L FUNCTION
	PUSH{R0-R12,LR}
	
	MOV R0,#0
	MOV R1,#0
	;1
	PUSH{R0-R4,R10}
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#62
	ADD R1,#62
	ADD R3,#69
	ADD R4,#160
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;2
	PUSH{R0-R4,R10}
	
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#62
	ADD R1,#153
	ADD R3,#101
	ADD R4,#160
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	POP{R0-R12,PC}
	ENDFUNC
;###########################################################################################################################################	

DRAW_O FUNCTION
	PUSH{R0-R12,LR}
	MOV R0,#0
	MOV R1,#0
	;1
	PUSH{R0-R4,R10}
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#108
	ADD R1,#62
	ADD R3,#114
	ADD R4,#160
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;2
	PUSH{R0-R4,R10}
	
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#108
	ADD R1,#62
	ADD R3,#152
	ADD R4,#70
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;3
	PUSH{R0-R4,R10}
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#146
	ADD R1,#62
	ADD R3,#152
	ADD R4,#160
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;4
	PUSH{R0-R4,R10}
	
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#108
	ADD R1,#153
	ADD R3,#152
	ADD R4,#160
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	POP{R0-R12,PC}
	ENDFUNC
;###########################################################################################################################################
DRAW_S FUNCTION
	PUSH{R0-R12,LR}
	MOV R0,#0
	MOV R1,#0
	;1
	PUSH{R0-R4,R10}
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#160
	ADD R1,#62
	ADD R3,#201
	ADD R4,#70
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;2
	PUSH{R0-R4,R10}
	
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#160
	ADD R1,#62
	ADD R3,#166
	ADD R4,#110
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;3
	PUSH{R0-R4,R10}
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#160
	ADD R1,#104
	ADD R3,#201
	ADD R4,#110
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;4
	PUSH{R0-R4,R10}
	
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#195
	ADD R1,#104
	ADD R3,#201
	ADD R4,#160
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;5
	PUSH{R0-R4,R10}
	
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#160
	ADD R1,#153
	ADD R3,#201
	ADD R4,#160
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	POP{R0-R12,PC}
	ENDFUNC
;###########################################################################################################################################
	
DRAW_E FUNCTION
	PUSH{R0-R12,LR}
	;1
	MOV R0,#0
	MOV R1,#0
	PUSH{R0-R4,R10}
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#208
	ADD R1,#62
	ADD R3,#250
	ADD R4,#70
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;2
	PUSH{R0-R4,R10}
	
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#208
	ADD R1,#62
	ADD R3,#215
	ADD R4,#160
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;3
	PUSH{R0-R4,R10}
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#208
	ADD R1,#104
	ADD R3,#245
	ADD R4,#111
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;4
	PUSH{R0-R4,R10}
	
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#208
	ADD R1,#153
	ADD R3,#251
	ADD R4,#160
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	POP{R0-R12,PC}
	ENDFUNC
	
;###########################################################################################################################################	
	
DRAW_LOSE_SCREEN FUNCTION
	
	PUSH{R0-R12,LR}
	PUSH{R0-R4,R10}
	
	LDR R10,=BLUE
	MOV R0,#0
	MOV R1,#0
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#320
	ADD R4,#240
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	BL DRAW_L
	BL DRAW_O
	BL DRAW_S
	BL DRAW_E
	
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL __main


	
	
	POP{R0-R12,PC}
	ENDFUNC
	
	
;###########################################################################################################################################
DRAW_Y  FUNCTION 
	
	PUSH{R0-R12,LR}
	
	;draw rect1
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#0
	
	;set the end point
	ADD R3,#7
	ADD R4,#56
	
	BL DRAW_RECTANGLE_FILLED 
	POP{R0-R4, R10}
	;///////////////////////////////////////////////////////
	;draw rect2
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#46
	ADD R1,#0
	
	;set the end point
	ADD R3,#53
	ADD R4,#117
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	;//////////////////////////////////////////////////////////
	;draw rect3
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#49
	
	;set the end point
	ADD R3,#53
	ADD R4,#56
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	;/////////////////////////////////////////////////////////
	;draw rect4
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#110
	
	;set the end point
	ADD R3,#53
	ADD R4,#117
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	;////////////////////////////////////////////////////////////////
	
	
	POP{R0-R12,PC}
	
	
	ENDFUNC 
;#####################################################################################################################################################
DRAW_A  FUNCTION 
	
	PUSH{R0-R12,LR}
	
	;draw rect1
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#0
	
	;set the end point
	ADD R3,#7
	ADD R4,#117
	
	BL DRAW_RECTANGLE_FILLED 
	POP{R0-R4, R10}
	;///////////////////////////////////////////////////////
	;draw rect2
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#0
	
	;set the end point
	ADD R3,#56
	ADD R4,#7
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	;//////////////////////////////////////////////////////////
	;draw rect3
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#49
	ADD R1,#0
	
	;set the end point
	ADD R3,#56
	ADD R4,#117
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	;/////////////////////////////////////////////////////////
	;draw rect4
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#52
	
	;set the end point
	ADD R3,#56
	ADD R4,#56
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	;////////////////////////////////////////////////////////////////
	
	
	POP{R0-R12,PC}
	
	
	ENDFUNC 
;####################################################################################################################################################
DRAW_EXCLAMATION FUNCTION 
	
	PUSH{R0-R12,LR}
	
	;draw rect1
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#0
	
	;set the end point
	ADD R3,#7
	ADD R4,#100
	
	BL DRAW_RECTANGLE_FILLED 
	POP{R0-R4, R10}
	;///////////////////////////////////////////////////////
	;draw rect2
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#105
	
	;set the end point
	ADD R3,#7
	ADD R4,#120
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	;//////////////////////////////////////////////////////////
	POP{R0-R12,PC}
	
	ENDFUNC
;#################################################################################################################################################
DRAW_WIN   FUNCTION 
	PUSH{R0-R12,LR}
	
	;draw BACKGROUND
	PUSH{R0-R4, R10}
	LDR R10,=GREEN
	;make the start and the end points the same 
	MOV R0,#0
	MOV R1,#0
	MOV R3,#320
	MOV R4,#240
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
    ;///////////////////////////////////////////////////////////////
	PUSH{R0-R4, R10}

	MOV R0,#45
	MOV R1,#54
	BL DRAW_Y
	
	MOV R0,#111
	MOV R1,#54
	BL DRAW_A
	
	MOV R0,#178
	MOV R1,#54
	BL DRAW_Y
	
	MOV R0,#268
	MOV R1,#54
	BL DRAW_EXCLAMATION

	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL __main
	 
	POP{R0-R4,R10}
	POP{R0-R12,PC}

	
	
	ENDFUNC

;###########################################################################################################################################
DRAW_WINGS  FUNCTION  ; this function draws the wings of the chicken (eggcellent game)
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;1
	PUSH{R0-R4,R10}
	MOV R10,#0xFFFF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#16
	ADD R1,#21
	ADD R3,#45
	ADD R4,#50
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;2
	PUSH{R0-R4,R10}
	
	MOV R10,#0xFFFF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#10
	ADD R1,#27
	ADD R3,#51
	ADD R4,#50
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;3
    PUSH{R0-R4,R10}
	
	MOV R10,#0xFFFF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#3
	ADD R1,#33
	ADD R3,#58
	ADD R4,#50
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
    ;4
	PUSH{R0-R4,R10}
	MOV R10,#0xFFFF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#0
	ADD R1,#39
	ADD R3,#61
	ADD R4,#47
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;5
	PUSH{R0-R4,R10}
	MOV R10,#0xFFFF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#7
	ADD R1,#51
	ADD R3,#9
	ADD R4,#53
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;6
	PUSH{R0-R4,R10}
	MOV R10,#0xFFFF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#52
	ADD R1,#51
	ADD R3,#54
	ADD R4,#53
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	POP{R0-R12,PC}

	ENDFUNC
	
;###########################################################################################################################################
	
	
;###########################################################################################################################################	
DRAW_BODY FUNCTION   ; this function draws the chicken's bode (eggcellent game)
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;1
	PUSH{R0-R4,R10}
	MOV R10,#0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#23
	ADD R1,#21
	ADD R3,#38
	ADD R4,#56
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;2
	PUSH{R0-R4,R10}
	
	MOV R10,#0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#20
	ADD R1,#27
	ADD R3,#41
	ADD R4,#53
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;3
    PUSH{R0-R4,R10}
	
	MOV R10,#0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#13
	ADD R1,#33
	ADD R3,#48
	ADD R4,#50
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;4
	PUSH{R0-R4,R10}
	MOV R10,#0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#10
	ADD R1,#36
	ADD R3,#51
	ADD R4,#47
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;5
	PUSH{R0-R4,R10}
	MOV R10,#0xF81F
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#17
	ADD R1,#30
	ADD R3,#45
	ADD R4,#32
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	POP{R0-R12,PC}
	ENDFUNC
;###########################################################################################################################################


;###########################################################################################################################################
DRAW_FEET FUNCTION    ; this function draws the chicken's feet (eggcellent game)
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;1
	PUSH{R0-R4,R10}
	MOV R10,#0x07FF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#20
	ADD R1,#57
	ADD R3,#22
	ADD R4,#59
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;2
	PUSH{R0-R4,R10}
	
	MOV R10,#0x07FF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#17
	ADD R1,#60
	ADD R3,#22
	ADD R4,#62
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;3
    PUSH{R0-R4,R10}
	
	MOV R10,#0x07FF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#14
	ADD R1,#63
	ADD R3,#22
	ADD R4,#65
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;4
	PUSH{R0-R4,R10}
	MOV R10,#0x07FF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#39
	ADD R1,#57
	ADD R3,#41
	ADD R4,#59
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;5
	PUSH{R0-R4,R10}
	MOV R10,#0x07FF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#39
	ADD R1,#60
	ADD R3,#44
	ADD R4,#62
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;6
	PUSH{R0-R4,R10}
	MOV R10,#0x07FF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#39
	ADD R1,#63
	ADD R3,#47
	ADD R4,#65
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	POP{R0-R12,PC}
	ENDFUNC	
;###########################################################################################################################################


;###########################################################################################################################################
DRAW_HEAD FUNCTION    ; this function draws the chicken's head(eggcellent game)
	;X1=[]R0
	;Y1=[]R1
	
	PUSH{R0-R12,LR}
	
	;white1
	PUSH{R0-R4,R10}
	MOV R10,#0xFFFF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#20
	ADD R1,#9
	ADD R3,#41
	ADD R4,#17
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;white2
	PUSH{R0-R4,R10}
	MOV R10,#0xFFFF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#23
	ADD R1,#6
	ADD R3,#38
	ADD R4,#20
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;white3
    PUSH{R0-R4,R10}
	
	MOV R10,#0xFFFF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#26
	ADD R1,#3
	ADD R3,#35
	ADD R4,#5
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
    ;YELLOW
	PUSH{R0-R4,R10}
	MOV R10,#0x07FF
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#29
	ADD R1,#12
	ADD R3,#32
	ADD R4,#17
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;BLACK1
	PUSH{R0-R4,R10}
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#23
	ADD R1,#9
	ADD R3,#25
	ADD R4,#11
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;BLACK2
	PUSH{R0-R4,R10}
	MOV R10,#0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#36
	ADD R1,#9
	ADD R3,#38
	ADD R4,#11
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;RED
	PUSH{R0-R4,R10}
	MOV R10,#0x001F
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#26
	ADD R1,#0
	ADD R3,#35
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	POP{R0-R12,PC}
	ENDFUNC
;###########################################################################################################################################


;###########################################################################################################################################
DRAW_BASKET FUNCTION ; this function draws the basket where the eggs are collected(eggcellent game)
	PUSH {r0-r12,LR}
	
	;DRAW RECT
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	
	
	;draw rect1
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#27
	ADD R1,#8
	
	;set the end point
	ADD R3,#60
	ADD R4,#26
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	 
	;draw rect2
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#18
	ADD R1,#8
	
	;set the end point
	ADD R3,#69
	ADD R4,#24
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	
	;draw rect3
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#11
	ADD R1,#8
	
	;set the end point
	ADD R3,#76
	ADD R4,#21
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw rect4
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#8
	ADD R1,#8
	
	;set the end point
	ADD R3,#79
	ADD R4,#19
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	

	;draw rect5
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#4
	ADD R1,#5
	
	;set the end point
	ADD R3,#7
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw rect6
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#0
	
	;set the end point
	ADD R3,#3
	ADD R4,#11
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	B skip_this_line5
	LTORG
skip_this_line5
	
	
	;draw rect7
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#80
	ADD R1,#5
	
	;set the end point
	ADD R3,#82
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
		
	;draw rect8
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#83
	ADD R1,#0
	
	;set the end point
	ADD R3,#86
	ADD R4,#11
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	POP {R0-R12, PC}
	ENDFUNC
;##########################################################################################################################################

	B skip_this_line6
    LTORG
skip_this_line6
;##########################################################################################################################################
DRAW_WHITE_EGG FUNCTION      ; this function draws a white egg {eggcellent game)
	PUSH {R0-R12, LR}
	
	;LDR R5,=WHITE_EGG1_X
	;LDRH R0,[R5]
	
	;LDR R5,=WHITE_EGG1_Y
	;LDRH R1,[R5]
	
	;draw cyan rect1
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#9
	
	;set the end point
	ADD R3,#27
	ADD R4,#23
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw cyan rect2
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#6
	ADD R1,#3
	
	;set the end point
	ADD R3,#21
	ADD R4,#29
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}


	;draw cyan rect3
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#3
	ADD R1,#6
	
	;set the end point
	ADD R3,#24
	ADD R4,#26
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw cyan rect4
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#9
	ADD R1,#0
	
	;set the end point
	ADD R3,#18
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw white rect1
	PUSH{R0-R4, R10}
	LDR R10,=WHITE 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#9
	ADD R1,#3
	
	;set the end point
	ADD R3,#18
	ADD R4,#26
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw white rect2
	PUSH{R0-R4, R10}
	LDR R10,=WHITE 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#6
	ADD R1,#6
	
	;set the end point
	ADD R3,#21
	ADD R4,#23
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw white rect3
	PUSH{R0-R4, R10}
	LDR R10,=WHITE 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#3
	ADD R1,#12
	
	;set the end point
	ADD R3,#24
	ADD R4,#20
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}


    POP {R0-R12, PC}
	ENDFUNC

;##########################################################################################################################################


;######################################################################################################################################################
DRAW_RED_EGG  FUNCTION        ; this function draws a red egg(eggcellent game)
	
	PUSH {R0-R12, LR}
	
	;draw red rect1
	PUSH{R0-R4, R10}
	LDR R10,=BLUE
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#9
	
	;set the end point
	ADD R3,#27
	ADD R4,#23
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	
	;draw red rect2
	PUSH{R0-R4, R10}
	LDR R10,=BLUE
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#6
	ADD R1,#3
	
	;set the end point
	ADD R3,#21
	ADD R4,#29
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}


	;draw red rect3
	PUSH{R0-R4, R10}
	LDR R10,=BLUE
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#3
	ADD R1,#6
	
	;set the end point
	ADD R3,#24
	ADD R4,#26
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw red rect4
	PUSH{R0-R4, R10}
	LDR R10,=BLUE
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#9
	ADD R1,#0
	
	;set the end point
	ADD R3,#18
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	POP{R0-R12,PC}

	
	ENDFUNC

;################################################################################################################################################

	B skip_this_line7
	LTORG
skip_this_line7

;#####################################################################################################################################################


;#####################################################################################################################################################################
DRAWCHICKEN FUNCTION  ; this function collects all the chicken parts to draw a whole chicken (eggcellent game)
	PUSH{R0-R12,LR}
	BL DRAW_WINGS
	BL DRAW_BODY
	BL DRAW_FEET
	BL DRAW_HEAD
	
	POP{R0-R12,PC}
	ENDFUNC
;#######################################################################################################################################


;#######################################################################################################################################	
DRAW_BAR  FUNCTION   ; this function draws the bar under the chicken feet (eggcellent game)
	
	PUSH {R0-R12, LR}
	
	;draw red rect4
	PUSH{R0-R4, R10}
	LDR R10,=YELLOW 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#0
	
	;set the end point
	ADD R3,#320
	ADD R4,#8
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
  

	POP {R0-R12, PC}

    ENDFUNC
;#######################################################################################################################################


;###############################################################################################################################################
DRAW_RED_EGG_NAV FUNCTION     ; this function draws the red egg dispalyed on the navigation  bar (eggcellent game)
	PUSH{R0-R12,LR}
	
	;draw red rect1
	PUSH{R0-R4, R10}
	LDR R10,=BLUE 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#6
	
	;set the end point
	ADD R3,#15
	ADD R4,#11
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw red rect2
	PUSH{R0-R4, R10}
	LDR R10,=BLUE 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#3
	ADD R1,#3
	
	;set the end point
	ADD R3,#12
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw red rect3
	PUSH{R0-R4, R10}
	LDR R10,=BLUE 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#6
	ADD R1,#0
	
	;set the end point
	ADD R3,#9
	ADD R4,#3
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;DRAW THE dots 
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#23
	ADD R1,#3
	
	;set the end point
	ADD R3,#27
	ADD R4,#7
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#23
	ADD R1,#11
	
	;set the end point
	ADD R3,#27
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	POP{R0-R12,PC}
	ENDFUNC
;#####################################################################################################################################


;#####################################################################################################################################
DRAW_WHITE_EGG_NAV FUNCTION    ; this function draws the white egg displayed on the nav bar (eggcellent game)
	PUSH{R0-R12,LR}
	
	;draw red rect1
	PUSH{R0-R4, R10}
	LDR R10,=WHITE 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#6
	
	;set the end point
	ADD R3,#15
	ADD R4,#11
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw red rect2
	PUSH{R0-R4, R10}
	LDR R10,=WHITE 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#3
	ADD R1,#3
	
	;set the end point
	ADD R3,#12
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw red rect3
	PUSH{R0-R4, R10}
	LDR R10,=WHITE 
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#6
	ADD R1,#0
	
	;set the end point
	ADD R3,#9
	ADD R4,#3
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;DRAW THE dots 
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#23
	ADD R1,#3
	
	;set the end point
	ADD R3,#27
	ADD R4,#7
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#23
	ADD R1,#11
	
	;set the end point
	ADD R3,#27
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	POP{R0-R12,PC}
	ENDFUNC

;#####################################################################################################################################


;#######################################################################################################################################
DRAW_TWO FUNCTION  ;draws the number 2 displayed on the nav bar (eggcellent game)
	PUSH {R0-R12,LR}
	;THE NUMBER
	
	;draw rect1
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#12
	
	;set the end point
	ADD R3,#12
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw rect1
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#12
	
	;set the end point
	ADD R3,#12
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw rect2
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#3
	ADD R1,#9
	
	;set the end point
	ADD R3,#5
	ADD R4,#11
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw rect3
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#6
	ADD R1,#6
	
	;set the end point
	ADD R3,#9
	ADD R4,#8
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw rect4
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#10
	ADD R1,#3
	
	;set the end point
	ADD R3,#12
	ADD R4,#5
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw rect5
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#3
	ADD R1,#0
	
	;set the end point
	ADD R3,#9
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw rect6
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#3
	
	;set the end point
	ADD R3,#2
	ADD R4,#5
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	POP {R0-R12,PC}
	ENDFUNC
;#########################################################################################################

	B skip_this_line8
	LTORG
skip_this_line8
;#########################################################################################################
DRAW_ONE FUNCTION    ; draws the number 1 displayed on the navbar (eggcellent game)
	PUSH{R0-R12,LR}
	
	;draw rect1
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#6
	ADD R1,#0
	
	;set the end point
	ADD R3,#8
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw rect2
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#3
	ADD R1,#0
	
	;set the end point
	ADD R3,#5
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	;draw rect3
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#3
	
	;set the end point
	ADD R3,#2
	ADD R4,#5
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	POP{R0-R12,PC}
	
	ENDFUNC
;################################################################################################################################################
DRAW_THREE FUNCTION 
	
	PUSH{R0-R12,LR}
	
	;draw rect1
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#0
	
	;set the end point
	ADD R3,#9
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw rect2
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#7
	
	;set the end point
	ADD R3,#9
	ADD R4,#8
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw rect3
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#13
	
	;set the end point
	ADD R3,#9
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw rect4
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#7
	ADD R1,#0
	
	;set the end point
	ADD R3,#9
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	POP{R0-R12,PC}
	ENDFUNC


;################################################################################################################################################
	
;################################################################################################################################################
DRAW_FOUR  FUNCTION 
	
	PUSH {R0-R12,LR}
	;THE NUMBER
	
	;draw rect1
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#7
	ADD R1,#0
	
	;set the end point
	ADD R3,#9
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw rect2
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#7
	
	;set the end point
	ADD R3,#12
	ADD R4,#9
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw rect3
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#0
	
	;set the end point
	ADD R3,#0
	ADD R4,#9
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	
	POP{R0-R12,PC}
	
	ENDFUNC
;################################################################################################################################################
DRAW_FIVE FUNCTION 
	
	PUSH{R0-R12,LR}
	
	;draw rect1
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#0
	
	;set the end point
	ADD R3,#10
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw rect2
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#0
	
	;set the end point
	ADD R3,#2
	ADD R4,#9
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw rect3
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#7
	
	;set the end point
	ADD R3,#10
	ADD R4,#9
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw rect4
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#8
	ADD R1,#7
	
	;set the end point
	ADD R3,#10
	ADD R4,#17
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	;draw rect5
	PUSH{R0-R4, R10}
	LDR R10,=BLACK
	;make the start and the end points the same 
	MOV R3,R0 
	MOV R4,R1
	
	;set the starting point
	ADD R0,#0
	ADD R1,#15
	
	;set the end point
	ADD R3,#10
	ADD R4,#17
	
	BL DRAW_RECTANGLE_FILLED 
	
	POP{R0-R4,R10}
	
	
	POP{R0-R12,PC}
	
	
	ENDFUNC 

	B skip_this_line22
	LTORG
skip_this_line22
;#################################################################################################################################################
INITIALIZE_VARIABLES	FUNCTION
	PUSH{R0-R12,LR}
	;THIS FUNCTION JUST INITIALIZES ANY VARIABLE IN THE DATASECTION TO ITS INITIAL VALUES
	;ALTHOUGH WE SPECIFIED SOME VALUES IN THE DATA AREA, BUT THEIR VALUES MIGHT BE ALTERED DURING BOOT TIME.
	;SO WE NEED TO IMPLEMENT THIS FUNCTION THAT REINITIALIZES ALL VARIABLES
	;DINO VARIABLES
	LDR R9, =CURRENT_TIMESTEP
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	
	LDR R9, =CURRENT_FRAME
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	
	LDR R5, =BASKET_X
	LDRH R3,[R5]
	MOV R3,#113
	STRH R3, [R5]
	
	;TODO: INITIALIZE STARTING_Y TO 170, NOTICE THAT STARTING_Y IS DECLARED AS 16-BITS
	LDR R5, =BASKET_Y
	LDRH R3,[R5]
	MOV R3,#205
	STRH R3, [R5]
	
	LDR R9, =RED_EGGX_OFFSET
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	
	LDR R9, =WHITE_EGGX_OFFSET
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	
	LDR R9, = RANDOM_EGG_NUMBER
	LDRH R11,[R9]
	MOV R11,#1
	STRH R11, [R9]
	
	
	;RANDOM_FLAG (0 white) (1 red)
	LDR R9, = RANDOM_FLAG
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	
	;EGG_MATAT
	LDR R9, = EGG_MATAT
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	
	
	LDR R9, = STEP_EGG_INITIAL
	LDRH R11,[R9]
	MOV R11,#3
	STRH R11, [R9]

	LDR R5, =SCORE_RED
	LDRH R3,[R5]
	MOV R3,#3
	STRH R3, [R5]
	
	
	LDR R5, =SCORE_WHITE
	LDRH R3,[R5]
	MOV R3,#5
	STRH R3, [R5]
	
	LDR R5, =SCORE
	LDRH R3,[R5]
	MOV R3,#0
	STRH R3, [R5]
	
	LDR R5, =FLAG_WHITE
	LDRH R3,[R5]
	MOV R3,#0
	STRH R3, [R5]
	
	LDR R5, =FLAG_RED
	LDRH R3,[R5]
	MOV R3,#0
	STRH R3, [R5]
	

	POP{R0-R12,PC}
	ENDFUNC
;################################################################################################################################################


;################################################################################################################################################
INITIALIZE_WHITE_EGG	FUNCTION
	PUSH{R0-R12,LR}
	;THIS FUNCTION JUST INITIALIZES ANY VARIABLE IN THE DATASECTION TO ITS INITIAL VALUES
	;ALTHOUGH WE SPECIFIED SOME VALUES IN THE DATA AREA, BUT THEIR VALUES MIGHT BE ALTERED DURING BOOT TIME.
	;SO WE NEED TO IMPLEMENT THIS FUNCTION THAT REINITIALIZES ALL VARIABLES
	
	;TODO: INITIALIZE STARTING_X TO 17, NOTICE THAT STARTING_X IS DECLARED AS 16-BITS
	
	LDR R5, =WHITE_EGG1_X
	LDRH R3,[R5]
	MOV R3, #17
	STRH R3, [R5]
	
	LDR R9, =WHITE_EGGX_OFFSET
	LDRH R11, [R9]
	
	ADD R3, R3, R11
	STRH R3,[R5]
	
	;TODO: INITIALIZE STARTING_Y TO 11, NOTICE THAT STARTING_Y IS DECLARED AS 16-BITS
	LDR R5, =WHITE_EGG1_Y
	LDRH R3,[R5]
	MOV R3,#114
	STRH R3, [R5]
	
	
	POP{R0-R12,PC}
	ENDFUNC
;################################################################################################################################################



;################################################################################################################################################

INITIALIZE_RED_EGG FUNCTION
    PUSH {R0-R12,LR}
	;THIS FUNCTION JUST INITIALIZES ANY VARIABLE IN THE DATASECTION TO ITS INITIAL VALUES
	;ALTHOUGH WE SPECIFIED SOME VALUES IN THE DATA AREA, BUT THEIR VALUES MIGHT BE ALTERED DURING BOOT TIME.
	;SO WE NEED TO IMPLEMENT THIS FUNCTION THAT REINITIALIZES ALL VARIABLES
    
    LDR R5, =RED_EGG1_X
	LDRH R3,[R5]
	MOV R3,#17
    STRH R3, [R5]
	
    LDR R9, =RED_EGGX_OFFSET
    LDRH R11, [R9] 
    
    ADD R3, R3, R11
    STRH R3, [R5]   
    
    LDR R5, =RED_EGG1_Y
    MOV R3, #114    
    STRH R3, [R5]   
    
    POP {R0-R12,PC}
    ENDFUNC
	;################################################################################################################################################
	B skip_this_line16
	LTORG
skip_this_line16
;#####################################################################################################################################################
DRAW_NAV_NUMBER FUNCTION 
	PUSH{R0-R12,LR}
	
	LDR R0, =SCORE_WHITE
	LDRH R3,[R0]
	MOV R0, #290
	MOV R1, #10
	CMP R3,#4
	BEQ NUMBER_4
	CMP R3,#3
	BEQ NUMBER_3
	CMP R3,#2
	BEQ NUMBER_2
	CMP R3,#1
	BEQ NUMBER_1
	CMP R3,#0
	BEQ LOOSE_WHITE
	
NUMBER_1
	BL DRAW_ONE
	B ATL3BRA_5
NUMBER_2
	BL DRAW_TWO
	B ATL3BRA_5
NUMBER_3
	BL DRAW_THREE
	B ATL3BRA_5
NUMBER_4
	BL DRAW_FOUR
	B ATL3BRA_5
LOOSE_WHITE
	BL DRAW_LOSE_SCREEN

	
ATL3BRA_5	
	POP{R0-R12,PC}
	
	ENDFUNC

;#####################################################################################################################################################

;#####################################################################################################################################################
DRAW_NAV_NUMBER2 FUNCTION 
	PUSH{R0-R12,LR}
	
	LDR R0, =SCORE_RED
	LDRH R3,[R0]
	MOV R0, #225
	MOV R1, #10
	CMP R3,#2
	BEQ NUMBER2
	CMP R3,#1
	BEQ NUMBER1
	CMP R3,#0
	BEQ LOOSE_RED
	
NUMBER1
	BL DRAW_ONE
	B ATL3BRA_6
NUMBER2
	BL DRAW_TWO
	B ATL3BRA_6
LOOSE_RED	
	BL DRAW_LOSE_SCREEN

	
ATL3BRA_6	
	POP{R0-R12,PC}
	
	ENDFUNC

;#####################################################################################################################################################
	B skip_this_line18
	LTORG
skip_this_line18
;#####################################################################################################################################################
;###########################################################################################################################################
Draw1 FUNCTION
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#6
	ADD R1,#1
	ADD R3,#14
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#11
	ADD R1,#3
	ADD R3,#14
	ADD R4,#25
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
   PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#26
	ADD R3,#24
	ADD R4,#27
	POP{R0-R4,R10}
	
	POP{R0-R12,PC}
	ENDFUNC
;#####################################################################################################################################################################################################################################
Draw2 FUNCTION
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#2
	ADD R1,#1
	ADD R3,#24
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#23
	ADD R1,#3
	ADD R3,#24
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
   PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#2
	ADD R1,#14
	ADD R3,#24
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#2
	ADD R1,#16
	ADD R3,#3
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#4
	ADD R1,#26
	ADD R3,#24
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	POP{R0-R12,PC}
	ENDFUNC
;#########################################################################################################################################################################
Draw3 FUNCTION
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#1
	ADD R3,#24
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#23
	ADD R1,#3
	ADD R3,#24
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
   PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#14
	ADD R3,#22
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#26
	ADD R3,#24
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	POP{R0-R12,PC}
	ENDFUNC
;#########################################################################################################################################################################
Draw4 FUNCTION
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#8
	ADD R1,#1
	ADD R3,#13
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#6
	ADD R1,#2
	ADD R3,#7
	ADD R4,#5
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
   PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#5
	ADD R1,#5
	ADD R3,#6
	ADD R4,#8
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#3
	ADD R1,#8
	ADD R3,#4
	ADD R4,#11
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#11
	ADD R3,#2
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#3
	ADD R1,#13
	ADD R3,#11
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#12
	ADD R1,#3
	ADD R3,#13
	ADD R4,#25
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#26
	ADD R3,#24
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	POP{R0-R12,PC}
	ENDFUNC
;#########################################################################################################################################################################
Draw5 FUNCTION
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#1
	ADD R3,#24
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#3
	ADD R3,#2
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
   PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#3
	ADD R1,#14
	ADD R3,#24
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#23
	ADD R1,#16
	ADD R3,#24
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#26
	ADD R3,#24
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	POP{R0-R12,PC}
	ENDFUNC
;#########################################################################################################################################################################
Draw6 FUNCTION
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#1
	ADD R3,#24
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#3
	ADD R3,#2
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
   PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#3
	ADD R1,#14
	ADD R3,#24
	ADD R4,#15
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#23
	ADD R1,#16
	ADD R3,#24
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#3
	ADD R1,#26
	ADD R3,#22
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;----
	
	POP{R0-R12,PC}
	ENDFUNC
;#########################################################################################################################################################################
Draw7 FUNCTION
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#1
	ADD R3,#24
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#23
	ADD R1,#3
	ADD R3,#24
	ADD R4,#8
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
   PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#21
	ADD R1,#8
	ADD R3,#22
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#19
	ADD R1,#13
	ADD R3,#20
	ADD R4,#19
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;----
	 ;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#18
	ADD R1,#18
	ADD R3,#19
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	POP{R0-R12,PC}
	ENDFUNC
;#########################################################################################################################################################################
Draw8 FUNCTION
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#1
	ADD R3,#24
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#3
	ADD R3,#2
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
   PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#23
	ADD R1,#3
	ADD R3,#24
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#3
	ADD R1,#13
	ADD R3,#22
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#3
	ADD R1,#26
	ADD R3,#22
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	POP{R0-R12,PC}
	ENDFUNC
;###############################
;#########################################################################################################################################################################
Draw0 FUNCTION
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#1
	ADD R3,#24
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#3
	ADD R3,#2
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
   PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#23
	ADD R1,#3
	ADD R3,#24
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;----
	
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#3
	ADD R1,#26
	ADD R3,#22
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	POP{R0-R12,PC}
	ENDFUNC
	;#########################################################################################################################################################################
Draw9 FUNCTION
	;X1=[]R0
	;Y1=[]R1
	PUSH{R0-R12,LR}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#1
	ADD R3,#24
	ADD R4,#2
	
	BL DRAW_RECTANGLE_FILLED
	
	POP{R0-R4,R10}
	;|
	;|
	
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#1
	ADD R1,#3
	ADD R3,#2
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;|
	;|
   PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#23
	ADD R1,#3
	ADD R3,#24
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
    ;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#3
	ADD R1,#13
	ADD R3,#22
	ADD R4,#14
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	;----
	PUSH{R0-R4,R10}
	
	MOV R10, #0x0000
	MOV R3,R0
	MOV R4,R1
	
	ADD R0,#3
	ADD R1,#26
	ADD R3,#22
	ADD R4,#27
	
	BL DRAW_RECTANGLE_FILLED
    POP{R0-R4,R10}
	
	POP{R0-R12,PC}
	ENDFUNC
;####################################################################################################################
WIN_YA_EBN_EL_HALAL FUNCTION
	PUSH{R0-R12,LR}
	POP{R0-R12,PC}
	ENDFUNC
;#########################################################################################################################################################################
CHOOSE_STEP	FUNCTION
	PUSH{R0-R12,LR}
	LDR R6,= SCORE
	LDRH R7,[R6] ; SCORE IS INSIDE R7
	 
	CMP R7, #10
	BEQ STEP1
	CMP R7, #20
	BEQ STEP2
	CMP R7, #30
	BEQ STEP3
	CMP R7, #40
	BEQ STEP4
	CMP R7, #50  
	BEQ WIN
	BNE ATLA3_YA_7AYAWAN
	
STEP1
	LDR R9, =STEP_EGG_INITIAL
	LDRH R10,[R9]
	MOV R10,#3
	STRH R10,[R9]
	B ATLA3_YA_7AYAWAN
	
STEP2
	LDR R9, =STEP_EGG_INITIAL
	LDRH R10,[R9]
	MOV R10,#4
	STRH R10,[R9]
	B ATLA3_YA_7AYAWAN
	
STEP3
	LDR R9, =STEP_EGG_INITIAL
	LDRH R10,[R9]
	MOV R10,#6
	STRH R10,[R9]
	B ATLA3_YA_7AYAWAN
	
STEP4
	LDR R9, =STEP_EGG_INITIAL
	LDRH R10,[R9]
	MOV R10,#7
	STRH R10,[R9]
	B ATLA3_YA_7AYAWAN
	
WIN
	BL DRAW_WIN
	
	
ATLA3_YA_7AYAWAN
	POP{R0-R12,PC}
	ENDFUNC


;#####################################################################################################################################################
INCREMENT_SCORE FUNCTION 
	PUSH{R0-R12,LR}
	
	BL CHOOSE_STEP
	;	background makan el rkmen
	PUSH{R0-R4,R10}
	MOV R10,#0x07FF
	MOV R0,#135
	MOV R1,#5
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#55
	ADD R4,#26
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	; R4= HIGHER BIT , R3=LOWER BIT 
	LDR R5, =SCORE  
	LDRH R6,[R5] ; EL SCORE BGD NOW
	LDRH R3,[R5] ; FA DH SCORE AWL MA YBDA2 W B3D KEDA ANA HN2AS FY FA MSH 3YZA YSM3 FY R0 lower part 
	MOV R4,#0 ; higher part 
	CMP R3,#9
	BLE HIGHER_PART

SCORE_LOOP
	SUB R3,#10
	ADD R4,#1
	CMP R3,#10
	BGE SCORE_LOOP
	
; R1 FYHA EL HIGHER DIGIT W R3 FYHA EL LOWER DIGIT

HIGHER_PART
    MOV R0,#135
	MOV R1,#5
	CMP R4,#0
	BEQ SCORE_0H
	CMP R4,#1
	BEQ SCORE_1H
	CMP R4,#2
	BEQ SCORE_2H
	CMP R4,#3
	BEQ SCORE_3H
	CMP R4,#4
	BEQ SCORE_4H
	
SCORE_0H
	BL Draw0
	B LOWER_PART
SCORE_1H
	BL Draw1
	B LOWER_PART
SCORE_2H
	BL Draw2
	B LOWER_PART
SCORE_3H
	BL Draw3
	B LOWER_PART
SCORE_4H
	BL Draw4
	B LOWER_PART
	
LOWER_PART
	MOV R0,#166
	MOV R1,#5
	CMP R3,#0
	BEQ SCORE_0L
	CMP R3,#1
	BEQ SCORE_1L
	CMP R3,#2
	BEQ SCORE_2L
	CMP R3,#3
	BEQ SCORE_3L
	CMP R3,#4
	BEQ SCORE_4L
	CMP R3,#5
	BEQ SCORE_5L
	CMP R3,#6
	BEQ SCORE_6L
	CMP R3,#7
	BEQ SCORE_7L
	CMP R3,#8
	BEQ SCORE_8L
	CMP R3,#9
	BEQ SCORE_9L

SCORE_0L
	BL Draw0
	B ATL3BRA_7
SCORE_1L
	BL Draw1
	B ATL3BRA_7
SCORE_2L
	BL Draw2
	B ATL3BRA_7
SCORE_3L
	BL Draw3
	B ATL3BRA_7
SCORE_4L
	BL Draw4
	B ATL3BRA_7
SCORE_5L
	BL Draw5
	B ATL3BRA_7
SCORE_6L
	BL Draw6 
	B ATL3BRA_7
SCORE_7L
	BL Draw7
	B ATL3BRA_7
SCORE_8L
	BL Draw8
	B ATL3BRA_7
SCORE_9L
	BL Draw9
	B ATL3BRA_7
	

ATL3BRA_7

	POP{R0-R12,PC}
	ENDFUNC 


;#####################################################################################################################################################
	B skip_this_line19
	LTORG
skip_this_line19

;#####################################################################################################################################################
RANDOM1 FUNCTION
    PUSH {R0-R12,LR}
	LDR R9, =WHITE_EGGX_OFFSET
	MOV R11, #0
	STRH R11, [R9]
	BL INITIALIZE_WHITE_EGG
	BL MOVE_WHITE_EGG1_DOWN
	LDR R9, = RANDOM_FLAG
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
    POP {R0-R12,PC}
    ENDFUNC

RANDOM2 FUNCTION
    PUSH {R0-R12,LR}
	LDR R9, =WHITE_EGGX_OFFSET
	MOV R11, #129
	STRH R11, [R9]
	BL INITIALIZE_WHITE_EGG
	BL MOVE_WHITE_EGG1_DOWN
	LDR R9, = RANDOM_FLAG
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
    POP {R0-R12,PC}
    ENDFUNC
	
RANDOM3 FUNCTION
    PUSH {R0-R12,LR}
	LDR R9, =WHITE_EGGX_OFFSET
	MOV R11, #129
	STRH R11, [R9]
	BL INITIALIZE_WHITE_EGG
	BL MOVE_WHITE_EGG1_DOWN
	LDR R9, = RANDOM_FLAG
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
    POP {R0-R12,PC}
    ENDFUNC
	
RANDOM4 FUNCTION
    PUSH {R0-R12,LR}
	LDR R9, =RED_EGGX_OFFSET
	MOV R11, #257
	STRH R11, [R9]
	BL INITIALIZE_RED_EGG
	BL MOVE_RED_EGG1_DOWN
	LDR R9, = RANDOM_FLAG
	LDRH R11,[R9]
	MOV R11,#1
	STRH R11, [R9]
    POP {R0-R12,PC}
    ENDFUNC
	
RANDOM5 FUNCTION
	PUSH{R0-R12,LR}
	LDR R9, =WHITE_EGGX_OFFSET
	MOV R11, #194
	STRH R11, [R9]
	BL INITIALIZE_WHITE_EGG	
	BL MOVE_WHITE_EGG1_DOWN
	LDR R9, = RANDOM_FLAG
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	POP {R0-R12,PC}
	ENDFUNC
	
RANDOM6 FUNCTION
	PUSH{R0-R12,LR}
	LDR R9, =RED_EGGX_OFFSET
	MOV R11, #0
	STRH R11, [R9]
	BL INITIALIZE_RED_EGG
	BL MOVE_RED_EGG1_DOWN
	LDR R9, = RANDOM_FLAG
	LDRH R11,[R9]
	MOV R11,#1
	STRH R11, [R9]
	POP {R0-R12,PC}
	ENDFUNC
	
RANDOM7 FUNCTION
	PUSH{R0-R12,LR}
	LDR R9, =WHITE_EGGX_OFFSET
	MOV R11, #64
	STRH R11, [R9]
	BL INITIALIZE_WHITE_EGG 
	BL MOVE_WHITE_EGG1_DOWN
	LDR R9, = RANDOM_FLAG
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	POP {R0-R12,PC}
	ENDFUNC
	
RANDOM8 FUNCTION
	PUSH{R0-R12,LR}
	LDR R9, =WHITE_EGGX_OFFSET
	MOV R11, #194
	STRH R11, [R9]
	BL INITIALIZE_WHITE_EGG 
	BL MOVE_WHITE_EGG1_DOWN
	LDR R9, = RANDOM_FLAG
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	POP {R0-R12,PC}
	ENDFUNC
	
RANDOM9 FUNCTION
	PUSH{R0-R12,LR}
	LDR R9, =RED_EGGX_OFFSET
	MOV R11, #129
	STRH R11, [R9]
	BL INITIALIZE_RED_EGG
	BL MOVE_RED_EGG1_DOWN
	LDR R9, = RANDOM_FLAG
	LDRH R11,[R9]
	MOV R11,#1
	STRH R11, [R9]
	POP {R0-R12,PC}
	ENDFUNC
	
RANDOM10 FUNCTION
    PUSH {R0-R12,LR}			
	LDR R9, =RED_EGGX_OFFSET
	MOV R11, #64
	STRH R11, [R9]
	BL INITIALIZE_RED_EGG
	BL MOVE_RED_EGG1_DOWN
	LDR R9, = RANDOM_FLAG
	LDRH R11,[R9]
	MOV R11,#1
	STRH R11, [R9]
    POP {R0-R12,PC}
    ENDFUNC

	


;#####################################################################################################################################################

MOVE_WHITE_EGG1_DOWN FUNCTION    ; this function moves the egg down 
	
	PUSH{R0-R12,LR}
	LDR R9, = EGG_MATAT  ;AWL MA ND5OL N3TBAR EN EL EGG MAMTATA4 
	LDRH R11,[R9]
	MOV R11,#1
	STRH R11, [R9]
	
	LDR R5, =WHITE_EGG1_X
	LDRH R0,[R5]
	
	LDR R5, =WHITE_EGG1_Y
	LDRH R1,[R5]
	
	LDR R5, =STEP_EGG_INITIAL
	LDRH R7,[R5]
	
	MOV R5,R1
	ADD R5,#30
	ADD R5,R7
	CMP R5, #240
	BGE GOTO_ATL3BRA
	
	;TODO: COVER THE SPIRIT WITH THE BACKGROUND COLOR
	
	CMP R5, #205
	BGE COLLISION_SOLVE
	
DRAW_3ADY
	;	background
	PUSH{R0-R4,R10}
	LDR R10, =BLACK
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#27
	ADD R4,#30
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;TODO: REDRAW THE SPIRIT IN THE NEW COORDINATES AND UPDATE ITS COORDINATES IN THE DATASECTION
	LDR R5, =WHITE_EGG1_Y
	LDRH R1,[R5]
	LDR R4, =STEP_EGG_INITIAL
	LDRH R7,[R4]
	ADD R1,R7
	STRH R1, [R5]
	LDR R5, =WHITE_EGG1_X
	LDRH R0,[R5]
	BL DRAW_WHITE_EGG
	B ATL3BRA_KHALES

COLLISION_SOLVE   ; R0->START EGG , R1->START BASKET , R3-> END EGG , R4->END BASKET 
	PUSH{R0-R12}
	; COMPARE EN EL EGG STARTING POINT M3 EL STARTING BTA3 EL BASKET
	LDR R5, =WHITE_EGG1_X  
	LDRH R0,[R5]
	
	LDR R5, =BASKET_X
	LDRH R1,[R5]
	
	MOV R3,R0
	ADD R3,#27
	
	MOV R4,R1
	ADD R4,#85
	
    ;CHECK1   CHECK IF THE WHOLE EGG IS INSIDE THE BASKET
	CMP R1,R0 
	BGE CHECK2
	CMP R4,R3
	BLE CHECK2
	LDR R5, =SCORE  
	LDRH R0,[R5]
	ADD R0,#1
	STRH R0, [R5]
	LDR R9, = EGG_MATAT
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	BL INCREMENT_SCORE
	POP {R0-R12}
	B BACKGROUND
	
	
CHECK2  ; CHECKS FOR CORNER CASES
	POP {R0-R12}
	PUSH{R0-R12}
	LDR R5, =WHITE_EGG1_X  
	LDRH R0,[R5]
	LDR R5, =BASKET_X
	LDRH R1,[R5]
	CMP R1,R0 
	;FOR NAVBAR
	LDR R5, =SCORE_WHITE  
	LDRH R0,[R5]
	LDR R6, =FLAG_WHITE  
	LDRH R1,[R6]
	CMP R1,#1
	BEQ GO_ON_WITH_YOUR_LIFE

	SUB R0,#1
	STRH R0, [R5]
	MOV R8,#1
	STRH R8, [R6]

	B SKIP_MEE
GOTO_ATL3BRA
	B ATL3BRA
SKIP_MEE	
	
	;DRAW THE BACKGROUNG OVER THE NUMBER DISPLAY IN THE NAVBAR
	MOV R10, #0x07FF
	MOV R0,#290
	MOV R1,#10
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#13
	ADD R4,#18
	BL DRAW_RECTANGLE_FILLED
	BL DRAW_NAV_NUMBER
	
GO_ON_WITH_YOUR_LIFE
	POP{R0-R12}
	BGE CHECK4
	B   CHECK3
	
CHECK3 ; CHECK IF THE RIGHT HALF OF THE EGG LIES INSIDE THE BASKET 
	PUSH{R0-R12}
	LDR R5, =WHITE_EGG1_X  
	LDRH R0,[R5]
	LDR R5, =BASKET_X
	LDRH R1,[R5]
	MOV R4,R1
	ADD R4,#85
	CMP R0,R4 
	POP{R0-R12}
	BLE BACKGROUNDSCORE   ;THIS MEANS THAT THE RIGHT HALF OF THE EGG LIES INSIDE THE BASKET SO ERASE THE EGG 
	B DRAW_3ADY      ;THIS MEANS THAT THE EGG IS OUTSIDE THE BASKET SO MAKE THE EGG CONTINUE FALLING
	
CHECK4  ; CHECK IF THE LEFT HALF OF THE EGG LIES INSIDE THE BASKET 
	PUSH{R0-R12}
	LDR R5, =WHITE_EGG1_X  
	LDRH R0,[R5]
	LDR R5, =BASKET_X
	LDRH R1,[R5]
	MOV R3,R0
	ADD R3,#27
	CMP R3,R1 
	POP{R0-R12}
	BGE BACKGROUNDSCORE
	B DRAW_3ADY

BACKGROUND
    ;	background
	LDR R10, =BLACK
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#27
	ADD R4,#30
	BL DRAW_RECTANGLE_FILLED
	BL INITIALIZE_WHITE_EGG
	B  ATL3BRA

BACKGROUNDSCORE
    ;	background
	LDR R10, =BLACK
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#27
	ADD R4,#30
	BL DRAW_RECTANGLE_FILLED
	BL INITIALIZE_WHITE_EGG
	LDR R5, =SCORE  
	LDRH R0,[R5]
	ADD R0,#1
	STRH R0, [R5]
	BL INCREMENT_SCORE


ATL3BRA
    ;	background
	LDR R10, =BLACK
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#27
	ADD R4,#30
	BL DRAW_RECTANGLE_FILLED
	BL INITIALIZE_WHITE_EGG
	LDR R5, =FLAG_WHITE 	 
	LDRH R0,[R5]
	MOV R0,#0 ; brg3 el flag b zero once el egg dy 5las 
	STRH R0, [R5]
	LDR R9, = EGG_MATAT
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	
ATL3BRA_KHALES
;DRAW BACKGROUND SODa fo2 el egg , me7tagin n e3raf el x bta3etha kam bardou + el score fl nav bta3 el missed eggs yezid 
	
	POP{R0-R12,PC}
	
	ENDFUNC
;################################################################################################################################################
	B skip_this_line17
	LTORG
skip_this_line17
;#####################################################################################################################################################

;#################################################################################################################################################
MOVE_RED_EGG1_DOWN FUNCTION    ; this function moves the egg down 
	
	PUSH{R0-R12,LR}
	LDR R9, = EGG_MATAT
	LDRH R11,[R9]
	MOV R11,#1
	STRH R11, [R9]
	
	LDR R5, =RED_EGG1_X
	LDRH R0,[R5]
	
	LDR R5, =RED_EGG1_Y
	LDRH R1,[R5]
	
	LDR R5, =STEP_EGG_INITIAL
	LDRH R7,[R5]
	
	MOV R5,R1
	ADD R5,#30
	ADD R5,R7
	CMP R5, #240
	BGE GOTO_ATL3BRA2
	
	;TODO: COVER THE SPIRIT WITH THE BACKGROUND COLOR
    CMP R5,#205
	BGE COLLISION_SOLVE2
	
	
DRAW_3ADY2	
	;	background
	PUSH{R0-R4,R10}
	LDR R10, =BLACK
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#27
	ADD R4,#30
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;TODO: REDRAW THE SPIRIT IN THE NEW COORDINATES AND UPDATE ITS COORDINATES IN THE DATASECTION
	LDR R5, =RED_EGG1_Y
	LDRH R1,[R5]
	LDR R4, =STEP_EGG_INITIAL
	LDRH R7,[R4]
	ADD R1,R7
	STRH R1, [R5]
	LDR R5, =RED_EGG1_X
	LDRH R0,[R5]
	BL DRAW_RED_EGG
	BL ATL3BRA_KHALES2
	
COLLISION_SOLVE2
	PUSH{R0-R12}
	LDR R5, =RED_EGG1_X  
	LDRH R0,[R5]
	LDR R5, =BASKET_X
	LDRH R1,[R5]
	MOV R3,R0
	ADD R3,#27
	MOV R4,R1
	ADD R4,#85
	
	B SKIP_MEE2
GOTO_ATL3BRA2
	B ATL3BRA2
SKIP_MEE2
    ;CHECK1   CHECK IF THE WHOLE EGG IS INSIDE THE BASKET
	CMP R1,R0 
	BGE CHECK_2
	CMP R4,R3
	BLE CHECK_2
	LDR R9, = EGG_MATAT
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	;FOR NAVBAR
	LDR R5, =SCORE_RED  
	LDRH R0,[R5]
	LDR R6, =FLAG_RED 
	LDRH R1,[R6]
	CMP R1,#1
	BEQ GO_ON_WITH_YOUR_LIFE2

	SUB R0,#1
	STRH R0, [R5]
	MOV R8,#1
	STRH R8, [R6]

	
	;DRAW THE BACKGROUNG OVER THE NUMBER DISPLAY IN THE NAVBAR
	MOV R10, #0x07FF
	MOV R0,#225
	MOV R1,#10
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#13
	ADD R4,#18
	BL DRAW_RECTANGLE_FILLED
	BL DRAW_NAV_NUMBER2
	
GO_ON_WITH_YOUR_LIFE2
	POP {R0-R12}
	B BACKGROUND_2
	
	
CHECK_2  ; CHECKS FOR CORNER CASES
	POP {R0-R12}
	PUSH{R0-R12}
	LDR R5, =RED_EGG1_X  
	LDRH R0,[R5]
	LDR R5, =BASKET_X
	LDRH R1,[R5]
	CMP R1,R0 
	POP{R0-R12}
	BGE CHECK_4
	B   CHECK_3
	
CHECK_3 ; CHECK IF THE RIGHT HALF OF THE EGG LIES INSIDE THE BASKET 
	PUSH{R0-R12}
	LDR R5, =RED_EGG1_X  
	LDRH R0,[R5]
	LDR R5, =BASKET_X
	LDRH R1,[R5]
	MOV R4,R1
	ADD R4,#85
	CMP R0,R4 
;	LDR R9, = EGG_MATAT
;	LDRH R11,[R9]
;	MOV R11,#0
;	STRH R11, [R9]
	POP{R0-R12}
	BLE BACKGROUND_2   ;THIS MEANS THAT THE RIGHT HALF OF THE EGG LIES INSIDE THE BASKET SO ERASE THE EGG 
	B DRAW_3ADY2      ;THIS MEANS THAT THE EGG IS OUTSIDE THE BASKET SO MAKE THE EGG CONTINUE FALLING
	
CHECK_4  ; CHECK IF THE LEFT HALF OF THE EGG LIES INSIDE THE BASKET 
	PUSH{R0-R12}
	LDR R5, =RED_EGG1_X  
	LDRH R0,[R5]
	LDR R5, =BASKET_X
	LDRH R1,[R5]
	MOV R3,R0
	ADD R3,#27
	CMP R3,R1 
;	LDR R9, = EGG_MATAT
;	LDRH R11,[R9]
;	MOV R11,#0
;	STRH R11, [R9]
	POP{R0-R12}
	BGE BACKGROUND_2
	B DRAW_3ADY2

BACKGROUND_2
	
    ;	background
	LDR R10, =BLACK
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#27
	ADD R4,#30
	BL DRAW_RECTANGLE_FILLED
	BL INITIALIZE_RED_EGG
	

ATL3BRA2
    ;	background
	LDR R10, =BLACK
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#27
	ADD R4,#30
	BL DRAW_RECTANGLE_FILLED
	BL INITIALIZE_RED_EGG
    LDR R5, =FLAG_RED	 
	LDRH R0,[R5]
	MOV R0,#0 ; brg3 el flag b zero once el egg dy 5las 
	STRH R0, [R5]
	LDR R9, = EGG_MATAT
	LDRH R11,[R9]
	MOV R11,#0
	STRH R11, [R9]
	
ATL3BRA_KHALES2
;DRAW BACKGROUND SODa fo2 el egg , me7tagin n e3raf el x bta3etha kam bardou + el score fl nav bta3 el missed eggs yezid 
	POP{R0-R12,PC}
	
	ENDFUNC


;##################################################################################################################################################

;#################################################################################################################
MOVE_BASKET_RIGHT FUNCTION    ; this function moves the BASKET RIGHT 
	
	PUSH{R0-R12,LR}
	
	LDR R5, =BASKET_X
	LDRH R0,[R5]
	
	LDR R5, =BASKET_Y
	LDRH R1,[R5]
	
	MOV R5,R0
	ADD R5,#86
	ADD R5,#15
	CMP R5, #320
	BGE ATL3BRA_KHALES3
		
	;TODO: COVER THE SPIRIT WITH THE BACKGROUND COLOR

	
	;	background
	PUSH{R0-R4,R10}
	LDR R10, =BLACK
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#86
	ADD R4,#26
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;TODO: REDRAW THE SPIRIT IN THE NEW COORDINATES AND UPDATE ITS COORDINATES IN THE DATASECTION
	LDR R5, =BASKET_X
	LDRH R0,[R5]
	ADD R0,#15
	STRH R0, [R5]
	LDR R5, =BASKET_Y
	LDRH R1,[R5]
	BL DRAW_BASKET
	


	B skip_this_line1000
	LTORG
skip_this_line1000
    	
ATL3BRA_KHALES3
;DRAW BACKGROUND SODa fo2 el egg , me7tagin n e3raf el x bta3etha kam bardou + el score fl nav bta3 el missed eggs yezid 
	POP{R0-R12,PC}
	
	ENDFUNC

;################################################################################################################################################
;#################################################################################################################
MOVE_BASKET_LEFT FUNCTION    ; this function moves the BASKET RIGHT 
	
	PUSH{R0-R12,LR}
	
	LDR R5, =BASKET_X
	LDRH R0,[R5]
	
	LDR R5, =BASKET_Y
	LDRH R1,[R5]
	
	MOV R5,R0
	SUB R5,#15
	CMP R5, #0
	BLE ATL3BRA_KHALES4
	
	;TODO: COVER THE SPIRIT WITH THE BACKGROUND COLOR

	
	;	background
	PUSH{R0-R4,R10}
	LDR R10, =BLACK
	MOV R3,R0
	MOV R4,R1
	
	ADD R3,#86
	ADD R4,#26
	
	BL DRAW_RECTANGLE_FILLED
	POP{R0-R4,R10}
	
	;TODO: REDRAW THE SPIRIT IN THE NEW COORDINATES AND UPDATE ITS COORDINATES IN THE DATASECTION
	LDR R5, =BASKET_X
	LDRH R0,[R5]
	SUB R0,#15
	STRH R0, [R5]
	LDR R5, =BASKET_Y
	LDRH R1,[R5]
	BL DRAW_BASKET
	


ATL3BRA_KHALES4
;DRAW BACKGROUND SODa fo2 el egg , me7tagin n e3raf el x bta3etha kam bardou + el score fl nav bta3 el missed eggs yezid 
	POP{R0-R12,PC}
	
	ENDFUNC
;################################################################################################################################################



;#################################################################################################################################################
DRAWCHICKENGAME FUNCTION     ; this function collects all the compnents of eggcellent game to display them at the same time 
	PUSH{R0-R12,LR}
	
 	MOV R10, #0x0000
	BL DRAW_RECTANGLE_FILLED
	
	MOV R0, #0
	MOV R1, #0
	BL DrawNav
	
	MOV R0, #0
	MOV R1, #38
	BL DRAWCHICKEN
	
	MOV R0, #65
	MOV R1, #38
	BL DRAWCHICKEN
	
	MOV R0, #130
	MOV R1, #38
	BL DRAWCHICKEN
	
	MOV R0, #195
	MOV R1, #38
	BL DRAWCHICKEN
	
	MOV R0, #259
	MOV R1, #38
	BL DRAWCHICKEN
	
	MOV R0,#113
	MOV R1,#205
	BL DRAW_BASKET
	
	
;	MOV R0,#219
;	MOV R1,#147
;	BL DRAW_RED_EGG
	
	MOV R0, #0
	MOV R1, #104
	BL DRAW_BAR
	
	MOV R0, #225
	MOV R1, #10
	BL  DRAW_THREE 
	
	MOV R0, #290
	MOV R1, #10
	BL  DRAW_FIVE

	MOV R0, #193
	MOV R1, #10
	BL DRAW_RED_EGG_NAV
	
	MOV R0, #255
	MOV R1, #10
	BL DRAW_WHITE_EGG_NAV
	
	MOV R0, #5
	MOV R1, #3
	BL DrawScore
	
	POP{R0-R12,PC}
	
	ENDFUNC
;#######################################################################################################################################

;#######################################################################################################################################
DRAWDINOGAME FUNCTION    ; this function collects all the components of the dino game to display them at the same time 
	
	PUSH{R0-R12,LR}
	
	LDR R10, =DINOBKG
	BL DRAW_RECTANGLE_FILLED
	
	MOV R0, #1
	MOV R1, #1
	BL DrawBlocks
	
	MOV R0, #200
	MOV R1, #141
	BL DrawDino
	
	MOV R0, #229
	MOV R1, #3
	BL DrawLives
	
;	MOV R0, #1
;	MOV R1, #1
	;BL DrawScore
	
	
	PUSH{R0-R12,LR}
	ENDFUNC
	
	
	
	END
;#####################################################################################################################################################################