+/*
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
  for (int i = 1; i < 8; i++) {
    setColor(100, 0, 0);
  }


}



void loop() {





  switch (Tx)
  {
    case 0: setColor(CSK0_R_ori8, CSK0_G_ori8, CSK0_B_ori8); break;
    case 1: setColor(CSK1_R_ori8, CSK1_G_ori8, CSK1_B_ori8); break;
    case 2: setColor(CSK2_R_ori8, CSK2_G_ori8, CSK2_B_ori8); break;
    case 3: setColor(CSK3_R_ori8, CSK3_G_ori8, CSK3_B_ori8); break;
    case 4: setColor(CSK4_R_ori8, CSK4_G_ori8, CSK4_B_ori8); break;
    case 5: setColor(CSK5_R_ori8, CSK5_G_ori8, CSK5_B_ori8); break;
    case 6: setColor(CSK6_R_ori8, CSK6_G_ori8, CSK6_B_ori8); break;
    case 7: setColor(CSK7_R_ori8, CSK7_G_ori8, CSK7_B_ori8); break;
  }

  //Serial.println(Tx);
  Tx++;
  if (Tx > 7) {
    Tx = 0;
  }

  // Random method

  //  data[cnt] = random(0, 8);
  //  Serial.println(cnt);
  //  cnt ++;
  //  if (cnt > 1000)
  //    cnt = 1;

}



//    // changing duty in pwm output pin 35
//    change_duty(pwm_pin35, PWM_DUTY_PIN_35);
//
//    // changing duty in pwm output pin 42
//    change_duty(pwm_pin42, PWM_DUTY_PIN_42);
//
//    // changing duty in pwm output pin 39
//    change_duty(pwm_pin39, PWM_DUTY_PIN_39);
//    //while (1) {}


//setColor(0, 0, 100);

/*Screen module*/

//i = 231
//Red  81

//  for (int i = 81; i < 82; i++) {
//    myOLED.AdjustIconLevel(i, j);
//  }


//Green 182-214   except for 198-211
/*for (int i = 182; i < 198; i++) {
  myOLED.AdjustIconLevel(i, j);
  }
  for (int i = 211; i < 214; i++) {
  myOLED.AdjustIconLevel(i, j);
  }*/

//For all component

//  for (int i = 0; i < 231; i++) {
//    myOLED.AdjustIconLevel(i, j);
//  }

//while (1) {}


//    switch (Tx)
//    {
//      case 0: setColor(brightness, 0, 0); break;
//      case 1: setColor(0, brightness, 0); break;
//      case 2: setColor(0, 0, brightness); break;
//      case 3: setColor(brightness, brightness, brightness); break;
//    }
//    //delayMicroseconds(250);
//    //delay(5000);
//
//
//    brightness = brightness - fadeAmount;
//    if (brightness == 0)
//    {
//      brightness = 255;
//    }
//
//    Tx++;
//    if (Tx > 3) {
//      Tx = 0;
//    }

//  brightness = brightness - fadeAmount;
//  if (brightness==0)
//  {
//  brightness=255;
//  }
