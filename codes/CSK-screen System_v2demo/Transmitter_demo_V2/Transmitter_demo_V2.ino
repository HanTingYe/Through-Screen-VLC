/*
  Transmitter in system v1.0
  By: Hanting Ye
  TU Delft
  Date: April 5, 2020
  License: This code is public domain but you buy me a beer if you use this and we meet someday (Beerware license).
*/

#include "pwm_lib.h"
#include "tc_lib.h"
#include "RS-FEC.h"
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

// Transmitted messages
char message[] = "Hello World!";
const int msglen = 12;  const uint8_t ECC_LENGTH = 6;  //Max message lenght, and "gurdian bytes", Max corrected bytes ECC_LENGTH/2
char message_frame[msglen]; // The message size would be different, so need a container
char encoded[msglen + ECC_LENGTH];
char repaired[msglen];

RS::ReedSolomon<msglen, ECC_LENGTH> rs;

String bytesStr;
String TxStr; // Symbol
byte bytes[8];
int bit_count = 0;

//test code
unsigned int timecnt;



char ByteToChar( byte p_ucVal )
{
  switch (p_ucVal)
  {
    case 0:
      return '0';

    case 1:
      return '1';
  }
}

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

  memset(message_frame, 0, sizeof(message_frame));        // Clear the array
  for (uint i = 0; i <= msglen; i++) {
    message_frame[i] = message[i];      // Fill with the message
  }

  rs.Encode(message_frame, encoded);

  for (int message_count = 0; message_count <= (msglen + ECC_LENGTH - 1); message_count++)
  {
    //char myChar = message.charAt(message_count);
    for (int i = 7; i >= 0; i--) {
      bytes[7 - i] = bitRead(encoded[message_count], i); // bit number
    }
    //char bytes;
    char bytesChar[8];
    for (int i = 0; i <= 7; i++) {
      bytesChar[i] = ByteToChar(bytes[i]);
    }
    bytesChar[8]= '\0';
    bytesStr += bytesChar;
  }

  Serial.print("Original: "); Serial.println(message_frame);
  Serial.print("Encoded:  ");        for (uint i = 0; i < sizeof(encoded); i++) {
    Serial.write(encoded[i]);
  }     
  Serial.println("");  
  Serial.println(bytesStr);

  //
  for (int i = 1; i < 8; i++) {
    setColor(100, 0, 0);
  }


}



void loop() {

//  timecnt = micros();


  TxStr = bytesStr.substring(bit_count, (bit_count + 3));
  Tx = TxStr.toInt();
  switch (Tx)
  {
    case 0: setColor(CSK0_R, CSK0_G, CSK0_B); break;
    case 1: setColor(CSK1_R, CSK1_G, CSK1_B); break;
    case 10: setColor(CSK2_R, CSK2_G, CSK2_B); break;
    case 11: setColor(CSK3_R, CSK3_G, CSK3_B); break;
    case 100: setColor(CSK4_R, CSK4_G, CSK4_B); break;
    case 101: setColor(CSK5_R, CSK5_G, CSK5_B); break;
    case 110: setColor(CSK6_R, CSK6_G, CSK6_B); break;
    case 111: setColor(CSK7_R, CSK7_G, CSK7_B); break;
  }
  bit_count = bit_count + 3;
  if (bit_count > ((msglen + ECC_LENGTH) * 8 - 1))
  {
    bit_count = 0;
  }


//  timecnt = micros() - timecnt;
//  Serial.print(timecnt);
//  Serial.print(",");
//  while (1) {};



}
