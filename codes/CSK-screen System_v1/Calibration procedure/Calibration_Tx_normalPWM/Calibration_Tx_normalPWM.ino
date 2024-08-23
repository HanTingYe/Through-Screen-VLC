/*
  The whole system
  By: Hanting Ye
  SparkFun Electronics
  Date: November 23, 2020
  License: This code is public domain but you buy me a beer if you use this and we meet someday (Beerware license).
*/

#include <WiseChipHUD.h>
#include <AS73211.h>

// Define 3 LEDs
int led1 = 35;
int led2 = 42;
int led3 = 39;
int i = 0;
int brightness = 120;

int Number = 1000; //The number of symbols

int fadeAmount = 5;
int data[100];
int *cnt = data;
int seed;
int Tx = 0; // Symbol
int count = 0; // Number of symbol

AS73211 myXYZ;


/*Transmitter color set up*/
void setColor(int red, int green, int blue)
{
  analogWrite(led1, red);
  analogWrite(led2, green);
  analogWrite(led3, blue);
  //delayMicroseconds(250);
  //delay(5);
}

void setup() {

  Serial.begin(115200);
  while (Serial.available() > 0)
    Serial.read();
  myXYZ.begin();

  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);

  //analogWriteResolution(12);

}

void loop() {

  // Common cathode
  setColor(brightness, 0, 0); while(1){}//R
  //setColor(0, brightness, 0); while(1){}//G
  //setColor(0, 0, brightness); while(1){}//B
  //setColor(4085, 1500, 0); while(1){}
  //while(1){}
  
  brightness = brightness - fadeAmount;
  if (brightness==0)
  {
  brightness=255;
  }
  delay(1000);
  
  //setColor(97, 84, 30);
  

  // Common Anode
  //setColor(0, brightness, brightness); while(1){}//R
  //setColor(brightness, 0, brightness); while(1){}//B
  //setColor(brightness, brightness, 0); while(1){}//G
  //setColor(0, 0, 0); while(1){}
  //setColor(brightness, brightness, brightness);while(1){}
  

  /*
  switch (Tx)
  {
    case 0: setColor(brightness, 0, 0); break;
    case 1: setColor(0, brightness, 0); break;
    case 2: setColor(0, 0, brightness); break;
    case 3: setColor(brightness, brightness, brightness); break;
  }
  */
  //delayMicroseconds(250);
  //delay(5000);
  /*
  Tx++;
  if (Tx > 3) {
    Tx = 0;
  }
  */
  




}
