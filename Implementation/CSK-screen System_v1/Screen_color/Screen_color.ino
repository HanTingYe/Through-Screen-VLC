/*
  The screen color
  By: Hanting Ye
  SparkFun Electronics
  Date: November 23, 2020
  License: This code is public domain but you buy me a beer if you use this and we meet someday (Beerware license).
*/

#include <WiseChipHUD.h>

WiseChipHUD myOLED;
int j = 15; //screen intensity 0-31






void setup() {

  myOLED.begin();

  Serial.begin(115200);

}

void loop() {



  /*Screen module*/
  myOLED.clearAll(); // Clears all of the segments
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
  
  for (int i = 0; i < 231; i++) {
    myOLED.AdjustIconLevel(i, j);
  }
  
while(1){}






}
