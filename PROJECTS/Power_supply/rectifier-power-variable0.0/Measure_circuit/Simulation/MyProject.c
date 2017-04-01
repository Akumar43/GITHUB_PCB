char a[7]=""  ;
char tmp[7]="";
int i;
int k2;

static int kl=0;
sbit LCD_RS at RC5_bit;
sbit LCD_EN at RC4_bit;
sbit LCD_D4 at RC3_bit;
sbit LCD_D5 at RC2_bit;
sbit LCD_D6 at RC1_bit;
sbit LCD_D7 at RC0_bit;

sbit LCD_RS_Direction at TRISC5_bit;
sbit LCD_EN_Direction at TRISC4_bit;
sbit LCD_D4_Direction at TRISC3_bit;
sbit LCD_D5_Direction at TRISC2_bit;
sbit LCD_D6_Direction at TRISC1_bit;
sbit LCD_D7_Direction at TRISC0_bit;


protection()
{
static int count1;
PORTA^= 1 << 4;





}

prog_init()
{
TRISA&=~(1<<4); // setting port 4 as output
TRISA&=~(1<<5); // setting port 5 as output
ANSEL=0b00000011;
Lcd_Init();
//Lcd_Out(1,1,"hi");                 // Write text in first row
//delay_ms(100);
}
display()
{
int ind;
    i=ADC_Read(0);       //voltage
    k2=i;
    i=i * 2.98 ;
    IntToStr(i,a);

    tmp[0]=a[2];
    tmp[1]=a[3];
    tmp[2]=0x2e;
    tmp[3]=a[4];
    tmp[4]=a[5];
    tmp[5]=0x56;

    Lcd_Out(1,1,tmp);

    i=ADC_Read(1);      // ampilfied voltage i.e. current
    i=i*1.94;    //1 is the correction factor
    IntToStr(i,a);
    Lcd_Out(2,1,a);
}



void InitTimer0(){
  OPTION_REG	 = 0x88;
  TMR0		 = 156;
  INTCON	 = 0xA0;
}

void Interrupt(){           //Interrupt Time : 100 us

  if (TMR0IF_bit){
    TMR0IF_bit	 = 0;
    TMR0		 = 156;
    kl=kl+1;
    
     if(kl<k2)
    {
        PORTA |= 1 << 5;               //setting a bit
    }
    else if((kl>=k2) && (kl< 1023))
    {
        PORTA &= ~(1 << 5);                 //reseeting
    }
    else
    {
        kl=0;
    }
    
    
  }
}



////////////////////
void main()
{
    prog_init();
    InitTimer0();
     display();
    while(1)
    {
        display();
       protection();
    }
}