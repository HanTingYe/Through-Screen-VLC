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
  //delayMicroseconds(500);
  delay(1);
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
    setColor(CSK16_R_32, CSK16_G_32, CSK16_B_32);
  }


}



void loop() {





  switch (Tx)
  {
    case 0: setColor(CSK0_R_32, CSK0_G_32, CSK0_B_32); break;
    case 1: setColor(CSK1_R_32, CSK1_G_32, CSK1_B_32); break;
    case 2: setColor(CSK2_R_32, CSK2_G_32, CSK2_B_32); break;
    case 3: setColor(CSK3_R_32, CSK3_G_32, CSK3_B_32); break;
    case 4: setColor(CSK4_R_32, CSK4_G_32, CSK4_B_32); break;
    case 5: setColor(CSK5_R_32, CSK5_G_32, CSK5_B_32); break;
    case 6: setColor(CSK6_R_32, CSK6_G_32, CSK6_B_32); break;
    case 7: setColor(CSK7_R_32, CSK7_G_32, CSK7_B_32); break;
    case 8: setColor(CSK8_R_32, CSK8_G_32, CSK8_B_32); break;
    case 9: setColor(CSK9_R_32, CSK9_G_32, CSK9_B_32); break;
    case 10: setColor(CSK10_R_32, CSK10_G_32, CSK10_B_32); break;
    case 11: setColor(CSK11_R_32, CSK11_G_32, CSK11_B_32); break;
    case 12: setColor(CSK12_R_32, CSK12_G_32, CSK12_B_32); break;
    case 13: setColor(CSK13_R_32, CSK13_G_32, CSK13_B_32); break;
    case 14: setColor(CSK14_R_32, CSK14_G_32, CSK14_B_32); break;
    case 15: setColor(CSK15_R_32, CSK15_G_32, CSK15_B_32); break;
    case 16: setColor(CSK16_R_32, CSK16_G_32, CSK16_B_32); break;
    case 17: setColor(CSK17_R_32, CSK17_G_32, CSK17_B_32); break;
    case 18: setColor(CSK18_R_32, CSK18_G_32, CSK18_B_32); break;
    case 19: setColor(CSK19_R_32, CSK19_G_32, CSK19_B_32); break;
    case 20: setColor(CSK20_R_32, CSK20_G_32, CSK20_B_32); break;
    case 21: setColor(CSK21_R_32, CSK21_G_32, CSK21_B_32); break;
    case 22: setColor(CSK22_R_32, CSK22_G_32, CSK22_B_32); break;
    case 23: setColor(CSK23_R_32, CSK23_G_32, CSK23_B_32); break;
    case 24: setColor(CSK24_R_32, CSK24_G_32, CSK24_B_32); break;
    case 25: setColor(CSK25_R_32, CSK25_G_32, CSK25_B_32); break;
    case 26: setColor(CSK26_R_32, CSK26_G_32, CSK26_B_32); break;
    case 27: setColor(CSK27_R_32, CSK27_G_32, CSK27_B_32); break;
    case 28: setColor(CSK28_R_32, CSK28_G_32, CSK28_B_32); break;
    case 29: setColor(CSK29_R_32, CSK29_G_32, CSK29_B_32); break;
    case 30: setColor(CSK30_R_32, CSK30_G_32, CSK30_B_32); break;
    case 31: setColor(CSK31_R_32, CSK31_G_32, CSK31_B_32); break;
  }

  //Serial.println(Tx);
  Tx++;
  if (Tx > 31) {
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
