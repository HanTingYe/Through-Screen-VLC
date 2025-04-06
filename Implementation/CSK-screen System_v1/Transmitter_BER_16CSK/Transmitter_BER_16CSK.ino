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

//Modulation index
const int M = 16;
const int CSKlen = 4;

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

boolean data_unit[M * CSKlen];
boolean char_unit[8];
boolean *cnt_unit = data_unit;
boolean *cnt_char_unit = char_unit;
int data_unit_dec[M * CSKlen / 8];
char message_unit[M * CSKlen / 8];
//byte byte_unit[8];
//byte *cnt_byte_unit = byte_unit;
//int data[1000];
int seed = 6;
int cnt = 1;


const int msglen = 8;
const uint8_t ECC_LENGTH = 4;  //Max message lenght, and "gurdian bytes", Max corrected bytes ECC_LENGTH/2

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


boolean *bitadd16(boolean *p, boolean a, boolean b, boolean c, boolean d)
{
  *p++ = a;
  *p++ = b;
  *p++ = c;
  *p++ = d;
  return (p);
}

boolean *bitadd32(boolean *p, boolean a, boolean b, boolean c, boolean d, boolean e)
{
  *p++ = a;
  *p++ = b;
  *p++ = c;
  *p++ = d;
  *p++ = e;
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
  //delayMicroseconds(500);
  delay(1);
}


void setup() {

  Serial.begin(250000);

  // starting PWM signals
  pwm_pin35.start(PWM_PERIOD_PIN_35, PWM_DUTY_PIN_35);
  pwm_pin42.start(PWM_PERIOD_PIN_42, PWM_DUTY_PIN_42);
  pwm_pin39.start(PWM_PERIOD_PIN_39, PWM_DUTY_PIN_39);

  randomSeed(seed);

  while (Tx_unit < M)
  {
    boolean temp[8] = {0};
    convertDecToBin(Tx_unit, temp);
    cnt_unit = bitadd16(cnt_unit, temp[4], temp[5], temp[6], temp[7]);
    Tx_unit++;
  }

  for (int i = 0; i < (M * CSKlen ); i++) {
    Serial.print(data_unit[i]);
  }
  Serial.println("");
  cnt_unit = data_unit;
  for (int i = 0; i < (M * CSKlen / 8); i++) {
    cnt_unit = split_array(cnt_char_unit, cnt_unit);
    data_unit_dec[i] = convertBinToDec(char_unit);
  }

//    for (int i = 0; i < (M * CSKlen / 8); i++) {
//    Serial.println(data_unit_dec[i]);
//  }
  
  for (int i = 0; i < (M * CSKlen / 8); i++) {
    message_unit[i] = (char) data_unit_dec[i];
  }
  //message_unit[M * CSKlen / 8] = '\0';


  char message_frame[msglen]; // The message size would be different, so need a container
  char temp[M * CSKlen / 8];

  //  strcpy(temp, message_unit);

  for (uint i = 0; i < M * CSKlen / 8; i++)
  {
    temp[i] = message_unit[i];
  }
  //  temp[M * CSKlen / 8] = '\0';

  for (int i = 0; i < (msglen / (M * CSKlen / 8) - 1); i++)
  {
    strcat(temp, message_unit);
  }
  for (uint i = 0; i < msglen; i++)
  {
    message_frame[i] = temp[i];
  }
  //strcpy(message_frame, temp);
  //message_frame[msglen]='\0';
  //
  //  for (int i = 0; i < 4; i++)
  //  {
  //    for (int j = 0; j < 3; i++)
  //      message_frame[3 * i + j] = message_unit[j];
  //  }




  rs.Encode(message_frame, encoded);

  Serial.print("Original: "); Serial.println(message_frame);
//    for (int i = 0; i < sizeof(message_frame); i++) {
//      Serial.print(message_frame[i]);
//    }
  Serial.print("Encoded:  ");
  for (int i = 0; i < sizeof(encoded); i++) {
    Serial.print(encoded[i]);
  }
  
//  for(uint i = 1; i < 3; i++) {        encoded[i] = '-';    } //Let's steal some byte from 20 to 25.
//  char repaired[msglen];
//  rs.Decode(encoded, repaired);
//  repaired[msglen]='\0';
//  String result;    memcmp(message_frame, repaired, msglen) == 0 ? result="SUCCESS" : result="FAILURE"; //Compare the arrays
//  Serial.print("Result: ");   Serial.println(result);
//  Serial.print("Repaired: "); Serial.println(repaired);
//  while(1){};
  
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
    setColor(CSK8_R_16, CSK8_G_16, CSK8_B_16);
  }


}



void loop() {





  TxStr = bytesStr.substring(bit_count, (bit_count + 4));
  Tx = TxStr.toInt();
  switch (Tx)
  {
    case 0: setColor(CSK0_R_16, CSK0_G_16, CSK0_B_16); break;
    case 1: setColor(CSK1_R_16, CSK1_G_16, CSK1_B_16); break;
    case 10: setColor(CSK2_R_16, CSK2_G_16, CSK2_B_16); break;
    case 11: setColor(CSK3_R_16, CSK3_G_16, CSK3_B_16); break;
    case 100: setColor(CSK4_R_16, CSK4_G_16, CSK4_B_16); break;
    case 101: setColor(CSK5_R_16, CSK5_G_16, CSK5_B_16); break;
    case 110: setColor(CSK6_R_16, CSK6_G_16, CSK6_B_16); break;
    case 111: setColor(CSK7_R_16, CSK7_G_16, CSK7_B_16); break;
    case 1000: setColor(CSK8_R_16, CSK8_G_16, CSK8_B_16); break;
    case 1001: setColor(CSK9_R_16, CSK9_G_16, CSK9_B_16); break;
    case 1010: setColor(CSK10_R_16, CSK10_G_16, CSK10_B_16); break;
    case 1011: setColor(CSK11_R_16, CSK11_G_16, CSK11_B_16); break;
    case 1100: setColor(CSK12_R_16, CSK12_G_16, CSK12_B_16); break;
    case 1101: setColor(CSK13_R_16, CSK13_G_16, CSK13_B_16); break;
    case 1110: setColor(CSK14_R_16, CSK14_G_16, CSK14_B_16); break;
    case 1111: setColor(CSK15_R_16, CSK15_G_16, CSK15_B_16); break;
  }
  bit_count = bit_count + 4;
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
