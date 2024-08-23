  /*
  Transmitter in system v1.0
  By: Hanting Ye
  TU Delft
*/

#include "pwm_lib.h"
#include "tc_lib.h"
#include "CSK_underscreen.h"
//#include <WiseChipHUD.h>

using namespace arduino_due::pwm_lib;

#define PWM_PERIOD_PIN_38 100 // hundredth of usecs (1e-8 secs)
#define PWM_DUTY_PIN_38 0 //configure the brightness of red LED: 0 represents the lowest brightness; 100 represents the highest brightness
#define PWM_PERIOD_PIN_42 100 // 100 usecs in hundredth of usecs (1e-8 secs)
#define PWM_DUTY_PIN_42 0 //configure the brightness of green LED: 0 represents the lowest brightness; 100 represents the highest brightness
#define PWM_PERIOD_PIN_34 100 // 100 usecs in hundredth of usecs (1e-8 secs)
#define PWM_DUTY_PIN_34 0 //configure the brightness of blue LED: 0 represents the lowest brightness; 100 represents the highest brightness

#define CAPTURE_TIME_WINDOW 15000000 // usecs
#define DUTY_KEEPING_TIME 1000 // msecs 

// Define 3 LEDs
int led1 = 38;
int led2 = 42;
int led3 = 34;

#define led1 pwm_pin38 // R
#define led2 pwm_pin42 // G
#define led3 pwm_pin34 // B

int brightness = 255;
int fadeAmount = 5;

int Tx = 0; // Symbol
int count = 0; // Number of symbol


//WiseChipHUD myOLED;
//int j = 1; //screen intensity 0-31


// defining pwm object using pin 38, pin PC6 mapped to pin 38 on the DUE
// this object uses PWM channel 0
pwm<pwm_pin::PWML2_PC6> pwm_pin38;

// defining pwm objetc using pin 42, pin PA19 mapped to pin 42 on the DUE
// this object used PWM channel 1
pwm<pwm_pin::PWMH1_PA19> pwm_pin42;

// defining pwm objetc using pin 42, pin PC2 mapped to pin 42 on the DUE
// this object used PWM channel 1
pwm<pwm_pin::PWML0_PC2> pwm_pin34;

int data[1000];
int seed = 6;
int cnt = 1;




/*Transmitter color set up*/
void setColor(int red, int green, int blue)
{
  led1.set_duty(red);
  led2.set_duty(green);
  led3.set_duty(blue);
  //delayMicroseconds(200);
  delay(1);
}


void setup() {

  //  myOLED.begin();
  //  myOLED.clearAll(); // Clears all of the segments

  Serial.begin(250000);

  // starting PWM signals
  pwm_pin38.start(PWM_PERIOD_PIN_38,PWM_DUTY_PIN_38);
  pwm_pin42.start(PWM_PERIOD_PIN_42,PWM_DUTY_PIN_42);
  pwm_pin34.start(PWM_PERIOD_PIN_34,PWM_DUTY_PIN_34);

  randomSeed(seed);

  // 



}



void loop() {


  switch (Tx)
  {
    case 0: setColor(CSK0_R_ori4, CSK0_G_ori4, CSK0_B_ori4); break;
    case 1: setColor(CSK1_R_ori4, CSK1_G_ori4, CSK1_B_ori4); break;
    case 2: setColor(CSK2_R_ori4, CSK2_G_ori4, CSK2_B_ori4); break;
    case 3: setColor(CSK3_R_ori4, CSK3_G_ori4, CSK3_B_ori4); break;
  }

//  switch (Tx)
//  {
//    case 0: setColor(CSK0_R_ori4, CSK0_G_ori4, CSK0_B_ori4); break;
//    case 1: setColor(CSK0_R_ori4, CSK0_G_ori4, CSK0_B_ori4); break;
//    case 2: setColor(CSK2_R_ori4, CSK2_G_ori4, CSK2_B_ori4); break;
//    case 3: setColor(CSK2_R_ori4, CSK2_G_ori4, CSK2_B_ori4); break;
//  }

  //Serial.println(Tx);
  Tx++;
  if (Tx > 3) {
    Tx = 0;
  }


//  setColor(CSK7_R_ori8, CSK7_G_ori8, CSK7_B_ori8);
//  while(1){};


}
