/*
  Receiver in system v1.0
  By: Hanting Ye
  TU Delft
  Date: March 1, 2020
  License: This code is public domain but you buy me a beer if you use this and we meet someday (Beerware license).
*/

#include <WiseChipHUD.h>
#include <AS73211.h>


int Number = 100000; //The number of symbols

int fadeAmount = 5;
int data[100];
int *cnt = data;
int Tx = 0; // Symbol
int count = 0; // Number of symbol

AS73211 myXYZ;
WiseChipHUD myOLED;
int j = 1; //screen intensity 0-31



void setup() {

  Serial.begin(115200);
  while (Serial.available() > 0)
    Serial.read();
  myXYZ.begin();
  myOLED.begin();
  myOLED.clearAll(); // Clears all of the segments


  //For all component
  for (int i = 0; i < 231; i++) {
    myOLED.AdjustIconLevel(i, j);
  }


}

void loop() {


  //myXYZ.setState(Measurement_state_Start_measurement);

  //Measure ouput
  uint16_t x_data;
  uint16_t y_data;
  uint16_t z_data;
  float x_ee_data;
  float y_ee_data;
  float z_ee_data;
  float temperature;


  myXYZ.color6_readXYZ(&x_data, &y_data, &z_data);

  x_ee_data = myXYZ.convertingToEe(_COLOR6_MREG_MEASUREMENT_X_CHANNEL, x_data);
  //  Serial.print("Ee_X: "); Serial.print(ee_data, DEC); Serial.print(" ");
  //  Serial.println(" ");

  y_ee_data = myXYZ.convertingToEe(_COLOR6_MREG_MEASUREMENT_Y_CHANNEL, y_data);
  //  Serial.print("Ee_Y: "); Serial.print(ee_data, DEC); Serial.print(" ");
  //  Serial.println(" ");

  z_ee_data = myXYZ.convertingToEe(_COLOR6_MREG_MEASUREMENT_Z_CHANNEL, z_data);
  //  Serial.print("Ee_Z: "); Serial.print(ee_data, DEC); Serial.print(" ");
  //  Serial.println(" ");

  //temperature = myXYZ.getTemperature();
  //  Serial.print("Temperature: "); Serial.print(temperature, DEC); Serial.print(" ");
  //  Serial.println(" ");





  // Matlab plot
  //  Serial.println(x_data);
  //  Serial.println(y_data);
  //  Serial.println(z_data);

  //    Serial.println(x_ee_data);
  //    Serial.println(y_ee_data);
  //    Serial.println(z_ee_data);


//  Serial.println('X');
//  Serial.println(x_data);
//  Serial.println('Y');
//  Serial.println(y_data);
//  Serial.println('Z');
//  Serial.println(z_data);


    Serial.println('X');
    Serial.println(x_ee_data);
    Serial.println('Y');
    Serial.println(y_ee_data);
    Serial.println('Z');
    Serial.println(z_ee_data);

  //delay(128);

  count++;
  if (count > Number) {
    while (1) {};
  }





}
