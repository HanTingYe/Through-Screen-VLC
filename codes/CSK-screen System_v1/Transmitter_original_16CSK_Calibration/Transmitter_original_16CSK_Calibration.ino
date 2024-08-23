  /*
  Transmitter in system v1.0
  By: Hanting Ye
  TU Delft
  Date: March 1, 2020
  License: This code is public domain but you buy me a beer if you use this and we meet someday (Beerware license).
*/

#include "pwm_lib.h"
#include "tc_lib.h"
#include "CSK_underscreen.h"
//#include <WiseChipHUD.h>

using namespace arduino_due::pwm_lib;

#define PWM_PERIOD_PIN_35 100 // hundredth of usecs (1e-8 secs)
#define PWM_DUTY_PIN_35 0 // 100 msecs in hundredth of usecs (1e-8 secs)

#define PWM_PERIOD_PIN_42 100 // 100 usecs in hundredth of usecs (1e-8 secs)
#define PWM_DUTY_PIN_42 0 // 10 usec in hundredth of usecs (1e-8 secs)

#define PWM_PERIOD_PIN_39 100 // 100 usecs in hundredth of usecs (1e-8 secs)
#define PWM_DUTY_PIN_39 0 // 10 usec in hundredth of usecs (1e-8 secs)

#define CAPTURE_TIME_WINDOW 15000000 // usecs
#define DUTY_KEEPING_TIME 1000 // msecs 

// Define 3 LEDs
int led1 = 35;
int led2 = 42;
int led3 = 39;

#define led1 pwm_pin35 // R
#define led2 pwm_pin42 // G
#define led3 pwm_pin39 // B

int brightness = 255;
int fadeAmount = 5;

int Tx = 0; // Symbol
int count = 0; // Number of symbol


//WiseChipHUD myOLED;
//int j = 1; //screen intensity 0-31


// defining pwm object using pin 35, pin PC3 mapped to pin 35 on the DUE
// this object uses PWM channel 0
pwm<pwm_pin::PWMH0_PC3> pwm_pin35;

// defining pwm objetc using pin 42, pin PA19 mapped to pin 42 on the DUE
// this object used PWM channel 1
pwm<pwm_pin::PWMH1_PA19> pwm_pin42;

// defining pwm objetc using pin 42, pin PA19 mapped to pin 42 on the DUE
// this object used PWM channel 2
pwm<pwm_pin::PWMH2_PC7> pwm_pin39;

int data[1000];
int seed = 6;
int cnt = 1;




/*Transmitter color set up*/
void setColor(int red, int green, int blue)
{
  led1.set_duty(red);
  led2.set_duty(green);
  led3.set_duty(blue);
  delayMicroseconds(200);
  //delay(1);
}


void setup() {

  //  myOLED.begin();
  //  myOLED.clearAll(); // Clears all of the segments

  Serial.begin(250000);

  // starting PWM signals
  pwm_pin35.start(PWM_PERIOD_PIN_35, PWM_DUTY_PIN_35);
  pwm_pin42.start(PWM_PERIOD_PIN_42, PWM_DUTY_PIN_42);
  pwm_pin39.start(PWM_PERIOD_PIN_39, PWM_DUTY_PIN_39);

  randomSeed(seed);

  // 



}



void loop() {


  switch (Tx)
  {
    case 0: setColor(CSK0_R_ori16, CSK0_G_ori16, CSK0_B_ori16); break;
    case 1: setColor(CSK1_R_ori16, CSK1_G_ori16, CSK1_B_ori16); break;
    case 2: setColor(CSK2_R_ori16, CSK2_G_ori16, CSK2_B_ori16); break;
    case 3: setColor(CSK3_R_ori16, CSK3_G_ori16, CSK3_B_ori16); break;
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
