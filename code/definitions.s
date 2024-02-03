    AREA MYDATA, DATA, READWRITE
		
RCC_BASE	    EQU		0x40021000
RCC_APB2ENR		EQU		RCC_BASE + 0x18


GPIOC_BASE         EQU      0x40011000   ; port c
GPIOC_CRH          EQU      GPIOC_BASE+0x04
GPIOC_ODR          EQU      GPIOC_BASE+0x0C
GPIOC_IDR          EQU      GPIOC_BASE+0x08
GPIOC_BRR          EQU      GPIOC_BASE +  0x14
GPIOC_BSRR         EQU      GPIOC_BASE +  0x10



GPIOA_BASE         EQU      0x40010800
GPIOA_CRH          EQU      GPIOA_BASE+0x04
GPIOA_CRL          EQU      GPIOA_BASE
GPIOA_ODR          EQU      GPIOA_BASE+0x0C
GPIOA_BRR          EQU      GPIOA_BASE +  0x14
GPIOA_BSRR         EQU      GPIOA_BASE +  0x10


GPIOB_BASE         EQU      0x40010C00
GPIOB_CRH          EQU      GPIOB_BASE+0x04
GPIOB_CRL          EQU      GPIOB_BASE
GPIOB_ODR          EQU      GPIOB_BASE+0x0C
GPIOB_IDR          EQU      GPIOB_BASE+0x08
GPIOB_BRR          EQU      GPIOB_BASE +  0x14
GPIOB_BSRR         EQU     GPIOB_BASE +  0x10


INTERVAL EQU 0x566004		;just a number to perform the delay. this number takes roughly 1 second to decrement until it reaches 0



;the following are pins connected from the TFT to our EasyMX board
;RD = PB9		Read pin	--> to read from touch screen input 
;WR = PB8		Write pin	--> to write data/command to display
;RS = PB12		Command pin	--> to choose command or data to write
;CS = PB6		Chip Select	--> to enable the TFT, lol	(active low)
;RST= PB14		Reset		--> to reset the TFT (active low)
;D0-7 = PA0-7	Data BUS	--> Put your command or data on this bus



;just some color codes, 16-bit colors coded in RGB 565
BLACK	EQU   	0x0000		;inverted note
BLUE 	EQU  	0x001F		;0xF800
RED  	EQU  	0xF800		;0x001F
RED2   	EQU 	0x4000
GREEN 	EQU  	0x07E0		;0xF81F			MAGENTA
CYAN  	EQU  	0x07FF		;0xFFE0			YELLOW
MAGENTA EQU 	0xF81F		;0x07E0			GREEN
YELLOW	EQU  	0xFFE0		;0x07FF			CYAN
WHITE 	EQU  	0xFFFF
GREEN2 	EQU 	0x2FA4
CYAN2 	EQU  	0x07FF


DINOBKG EQU 	0xF2FF
	
	
WHITE_EGG1_X	DCW		0x00
WHITE_EGG1_Y	DCW		0x00
WHITE_EGG2_X	DCW		0x00 ;34AN LW HYB2O 3 WHITE
WHITE_EGG2_Y	DCW		0x00
	
RED_EGG1_X	DCW		0x00
RED_EGG1_Y	DCW		0x00
RED_EGG2_X	DCW		0x00 ; 34AN LW HYB2O 2 RED
RED_EGG2_Y	DCW		0x00

RED_EGGX_OFFSET	DCW	0x00
WHITE_EGGX_OFFSET DCW 0x00

RANDOM_EGG_NUMBER DCW 0x00
RANDOM_FLAG 	DCW 	0x00
EGG_MATAT 	DCW 	0x00
STEP_EGG_INITIAL DCW 0x00 

BASKET_X	DCW		0x00 ; 34AN LW HYB2O 2 RED
BASKET_Y	DCW		0x00

SCORE       DCW     0x00
SCORE_RED   DCW     0x00
SCORE_WHITE DCW     0x00 
FLAG_WHITE 	DCW     0x00 ; 0 m3mlt4 decrement abl keda 1 3mlt decrement abl keda 
FLAG_RED	DCW 	0x00 ; 0 m3mlt4 decrement abl keda 1 3mlt decrement abl keda 
CURRENT_TIMESTEP   DCW		0x00 ;INCREMENTED EACH GAME LOOP (USED FOR RANDOMIZATION)
CURRENT_FRAME  	   DCW		0x00 ;INCREMENTED EACH TIME THE GAME IS PLAYED (EACH ENTIRE ROUND) 

		END 