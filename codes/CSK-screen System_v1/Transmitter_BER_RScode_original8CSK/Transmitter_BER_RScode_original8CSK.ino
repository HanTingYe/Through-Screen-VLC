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
#include "RS-FEC.h"
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
int Tx_unit = 0;
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

boolean data_unit[24];
boolean char_unit[8];
boolean *cnt_unit = data_unit;
boolean *cnt_char_unit = char_unit;
int data_unit_dec[3];
char message_unit[3];
//byte byte_unit[8];
//byte *cnt_byte_unit = byte_unit;
//int data[1000];
int seed = 6;
int cnt = 1;


const int msglen = 12;
const uint8_t ECC_LENGTH = 6;  //Max message lenght, and "gurdian bytes", Max corrected bytes ECC_LENGTH/2
char message_frame[msglen]; // The message size would be different, so need a container
char encoded[msglen + ECC_LENGTH];


RS::ReedSolomon<msglen, ECC_LENGTH> rs;


String bytesStr;
String TxStr; // Symbol
byte bytes[8];
int bit_count = 0;


boolean *bitadd(boolean *p, boolean a, boolean b, boolean c)
{
  *p++ = a;
  *p++ = b;
  *p++ = c;
  return (p);
}

boolean *split_array(boolean *p, boolean *q)
{
  for (int i = 0; i < 8; i++)
  {
    *p++ = *q++;
  }
  return (q);
}

int convertBinToDec(boolean Bin[]) {
  int ReturnInt = 0;
  for (int i = 0; i < 8; i++) {
    if (Bin[7 - i]) {
      ReturnInt += 1 << i;
    }
  }
  return ReturnInt;
}

//boolean Bin[8]={0}; Needs to be initialized
void convertDecToBin(int Dec, boolean Bin[]) {

  for (int i = 7; i >= 0; i--) {
    if (Dec) {
      Bin[i] = Dec & 1;
    }
    Dec >>= 1;
  }

  //  for (int i = 7 ; i >= 0 ; i--) {
  //    if (pow(2, i) <= Dec) {
  //      Dec = Dec - pow(2, i);
  //      Bin[8 - (i + 1)] = 1;
  //    } else {
  //    }
  //  }
}


int *int2byte(int *p, byte *q)
{
  int i = 0;
  while (i < 8)
  {
    *q++ = *p++;
    i++;
  }
  return (p);
}

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
  delayMicroseconds(200);
  //delay(1);
}


void setup() {

  Serial.begin(250000);

  // starting PWM signals
  pwm_pin35.start(PWM_PERIOD_PIN_35, PWM_DUTY_PIN_35);
  pwm_pin42.start(PWM_PERIOD_PIN_42, PWM_DUTY_PIN_42);
  pwm_pin39.start(PWM_PERIOD_PIN_39, PWM_DUTY_PIN_39);

  randomSeed(seed);

  while (Tx_unit < 8)
  {
    switch (Tx_unit)
    {
      case 0: cnt_unit = bitadd(cnt_unit, 0, 0, 0); break;
      case 1: cnt_unit = bitadd(cnt_unit, 0, 0, 1); break;
      case 2: cnt_unit = bitadd(cnt_unit, 0, 1, 0); break;
      case 3: cnt_unit = bitadd(cnt_unit, 0, 1, 1); break;
      case 4: cnt_unit = bitadd(cnt_unit, 1, 0, 0); break;
      case 5: cnt_unit = bitadd(cnt_unit, 1, 0, 1); break;
      case 6: cnt_unit = bitadd(cnt_unit, 1, 1, 0); break;
      case 7: cnt_unit = bitadd(cnt_unit, 1, 1, 1); break;
    }

    Tx_unit++;
  }
  cnt_unit = data_unit;
  for (int i = 0; i < 3; i++) {
    cnt_unit = split_array(cnt_char_unit, cnt_unit);
    data_unit_dec[i] = convertBinToDec(char_unit);
  }
  for (int i = 0; i < 3; i++) {
    message_unit[i] = (char) data_unit_dec[i];
  }


  char temp[3];
  strcpy(temp, message_unit);

  for (int i = 0; i < (4 - 1); i++)
  {
    strcat(temp, message_unit);
  }
  strcpy(message_frame, temp);

  //
  //  for (int i = 0; i < 4; i++)
  //  {
  //    for (int j = 0; j < 3; i++)
  //      message_frame[3 * i + j] = message_unit[j];
  //  }

  //  for (int i = 0; i < 12; i++) {
  //    Serial.print(message_frame[i]);
  //    }

  rs.Encode(message_frame, encoded);

  Serial.print("Original: "); Serial.println(message_frame);
  Serial.print("Encoded:  ");
  for (int i = 0; i < sizeof(encoded); i++) {
    Serial.print(encoded[i]);
  }
  //
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
    bytesChar[8] = '\0';
    bytesStr += bytesChar;

  }


  Serial.println("");
  Serial.println(bytesStr);

  for (int i = 1; i < 8; i++) {
    setColor(100, 0, 0);
  }


}



void loop() {





  TxStr = bytesStr.substring(bit_count, (bit_count + 3));
  Tx = TxStr.toInt();
  switch (Tx)
  {
    case 0: setColor(CSK0_R_ori8, CSK0_G_ori8, CSK0_B_ori8); break;
    case 1: setColor(CSK1_R_ori8, CSK1_G_ori8, CSK1_B_ori8); break;
    case 10: setColor(CSK2_R_ori8, CSK2_G_ori8, CSK2_B_ori8); break;
    case 11: setColor(CSK3_R_ori8, CSK3_G_ori8, CSK3_B_ori8); break;
    case 100: setColor(CSK4_R_ori8, CSK4_G_ori8, CSK4_B_ori8); break;
    case 101: setColor(CSK5_R_ori8, CSK5_G_ori8, CSK5_B_ori8); break;
    case 110: setColor(CSK6_R_ori8, CSK6_G_ori8, CSK6_B_ori8); break;
    case 111: setColor(CSK7_R_ori8, CSK7_G_ori8, CSK7_B_ori8); break;
  }
  bit_count = bit_count + 3;
  //Serial.println(bit_count);
  if (bit_count > ((msglen + ECC_LENGTH) * 8 - 1))
  {
    bit_count = 0;
    //Serial.println(bit_count);
    //while (1) {};
  }

  // Random method

  //  data[cnt] = random(0, 8);
  //Serial.println(cnt);
  //  cnt ++;
  //  if (cnt > 1000)
  //    cnt = 1;

}
