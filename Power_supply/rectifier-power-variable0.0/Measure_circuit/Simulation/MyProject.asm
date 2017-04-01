
_protection:

;MyProject.c,22 :: 		protection()
;MyProject.c,25 :: 		PORTA^= 1 << 4;
	MOVLW      16
	XORWF      PORTA+0, 1
;MyProject.c,31 :: 		}
L_end_protection:
	RETURN
; end of _protection

_prog_init:

;MyProject.c,33 :: 		prog_init()
;MyProject.c,35 :: 		TRISA&=~(1<<4); // setting port 4 as output
	BCF        TRISA+0, 4
;MyProject.c,36 :: 		TRISA&=~(1<<5); // setting port 5 as output
	BCF        TRISA+0, 5
;MyProject.c,37 :: 		ANSEL=0b00000011;
	MOVLW      3
	MOVWF      ANSEL+0
;MyProject.c,38 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;MyProject.c,41 :: 		}
L_end_prog_init:
	RETURN
; end of _prog_init

_display:

;MyProject.c,42 :: 		display()
;MyProject.c,45 :: 		i=ADC_Read(0);       //voltage
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _i+0
	MOVF       R0+1, 0
	MOVWF      _i+1
;MyProject.c,46 :: 		k2=i;
	MOVF       R0+0, 0
	MOVWF      _k2+0
	MOVF       R0+1, 0
	MOVWF      _k2+1
;MyProject.c,47 :: 		i=i * 2.98 ;
	CALL       _int2double+0
	MOVLW      82
	MOVWF      R4+0
	MOVLW      184
	MOVWF      R4+1
	MOVLW      62
	MOVWF      R4+2
	MOVLW      128
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      _i+0
	MOVF       R0+1, 0
	MOVWF      _i+1
;MyProject.c,48 :: 		IntToStr(i,a);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _a+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;MyProject.c,50 :: 		tmp[0]=a[2];
	MOVF       _a+2, 0
	MOVWF      _tmp+0
;MyProject.c,51 :: 		tmp[1]=a[3];
	MOVF       _a+3, 0
	MOVWF      _tmp+1
;MyProject.c,52 :: 		tmp[2]=0x2e;
	MOVLW      46
	MOVWF      _tmp+2
;MyProject.c,53 :: 		tmp[3]=a[4];
	MOVF       _a+4, 0
	MOVWF      _tmp+3
;MyProject.c,54 :: 		tmp[4]=a[5];
	MOVF       _a+5, 0
	MOVWF      _tmp+4
;MyProject.c,55 :: 		tmp[5]=0x56;
	MOVLW      86
	MOVWF      _tmp+5
;MyProject.c,57 :: 		Lcd_Out(1,1,tmp);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _tmp+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,59 :: 		i=ADC_Read(1);      // ampilfied voltage i.e. current
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _i+0
	MOVF       R0+1, 0
	MOVWF      _i+1
;MyProject.c,60 :: 		i=i*1.94;    //1 is the correction factor
	CALL       _int2double+0
	MOVLW      236
	MOVWF      R4+0
	MOVLW      81
	MOVWF      R4+1
	MOVLW      120
	MOVWF      R4+2
	MOVLW      127
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      _i+0
	MOVF       R0+1, 0
	MOVWF      _i+1
;MyProject.c,61 :: 		IntToStr(i,a);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _a+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;MyProject.c,62 :: 		Lcd_Out(2,1,a);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _a+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,63 :: 		}
L_end_display:
	RETURN
; end of _display

_InitTimer0:

;MyProject.c,67 :: 		void InitTimer0(){
;MyProject.c,68 :: 		OPTION_REG	 = 0x88;
	MOVLW      136
	MOVWF      OPTION_REG+0
;MyProject.c,69 :: 		TMR0		 = 156;
	MOVLW      156
	MOVWF      TMR0+0
;MyProject.c,70 :: 		INTCON	 = 0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;MyProject.c,71 :: 		}
L_end_InitTimer0:
	RETURN
; end of _InitTimer0

_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,73 :: 		void Interrupt(){           //Interrupt Time : 100 us
;MyProject.c,75 :: 		if (TMR0IF_bit){
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_Interrupt0
;MyProject.c,76 :: 		TMR0IF_bit	 = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;MyProject.c,77 :: 		TMR0		 = 156;
	MOVLW      156
	MOVWF      TMR0+0
;MyProject.c,78 :: 		kl=kl+1;
	INCF       MyProject_kl+0, 1
	BTFSC      STATUS+0, 2
	INCF       MyProject_kl+1, 1
;MyProject.c,80 :: 		if(kl<k2)
	MOVLW      128
	XORWF      MyProject_kl+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _k2+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Interrupt16
	MOVF       _k2+0, 0
	SUBWF      MyProject_kl+0, 0
L__Interrupt16:
	BTFSC      STATUS+0, 0
	GOTO       L_Interrupt1
;MyProject.c,82 :: 		PORTA |= 1 << 5;               //setting a bit
	BSF        PORTA+0, 5
;MyProject.c,83 :: 		}
	GOTO       L_Interrupt2
L_Interrupt1:
;MyProject.c,84 :: 		else if((kl>=k2) && (kl< 1023))
	MOVLW      128
	XORWF      MyProject_kl+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _k2+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Interrupt17
	MOVF       _k2+0, 0
	SUBWF      MyProject_kl+0, 0
L__Interrupt17:
	BTFSS      STATUS+0, 0
	GOTO       L_Interrupt5
	MOVLW      128
	XORWF      MyProject_kl+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      3
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Interrupt18
	MOVLW      255
	SUBWF      MyProject_kl+0, 0
L__Interrupt18:
	BTFSC      STATUS+0, 0
	GOTO       L_Interrupt5
L__Interrupt9:
;MyProject.c,86 :: 		PORTA &= ~(1 << 5);                 //reseeting
	BCF        PORTA+0, 5
;MyProject.c,87 :: 		}
	GOTO       L_Interrupt6
L_Interrupt5:
;MyProject.c,90 :: 		kl=0;
	CLRF       MyProject_kl+0
	CLRF       MyProject_kl+1
;MyProject.c,91 :: 		}
L_Interrupt6:
L_Interrupt2:
;MyProject.c,94 :: 		}
L_Interrupt0:
;MyProject.c,95 :: 		}
L_end_Interrupt:
L__Interrupt15:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_main:

;MyProject.c,100 :: 		void main()
;MyProject.c,102 :: 		prog_init();
	CALL       _prog_init+0
;MyProject.c,103 :: 		InitTimer0();
	CALL       _InitTimer0+0
;MyProject.c,104 :: 		display();
	CALL       _display+0
;MyProject.c,105 :: 		while(1)
L_main7:
;MyProject.c,107 :: 		display();
	CALL       _display+0
;MyProject.c,108 :: 		protection();
	CALL       _protection+0
;MyProject.c,109 :: 		}
	GOTO       L_main7
;MyProject.c,110 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
