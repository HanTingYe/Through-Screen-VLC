/*
  Receiver for calibration in system v1.0
  By: Hanting Ye
  TU Delft
  Date: March 1, 2020
  License: This code is public domain but you buy me a beer if you use this and we meet someday (Beerware license).
*/


#include <WiseChipHUD.h>
#include <AS73211.h>


int Number = 1000; //The number of symbols

int fadeAmount = 5;
int data[100];
int *cnt = data;
int Tx = 0; // Symbol
int count = 0; // Number of symbol


//Measure ouput
uint16_t x_data[1000] = {0};
uint16_t y_data[1000] = {0};
uint16_t z_data[1000] = {0};

uint16_t *x_cnt = x_data;
uint16_t *y_cnt = y_data;
uint16_t *z_cnt = z_data;

float x_ee_data[1000] = {0};
float y_ee_data[1000] = {0};
float z_ee_data[1000] = {0};
unsigned int timecnt;

AS73211 myXYZ;



void setup() {

  Serial.begin(115200);
  while (Serial.available() > 0)
    Serial.read();
  myXYZ.begin();

}

void loop() {


  //myXYZ.setState(Measurement_state_Start_measurement);



  while (count <= Number)
  {
    //timecnt = micros();
    
    //delayMicroseconds(125);
     delayMicroseconds(25);
    //    myXYZ.color6_readXYZ(&x_temp, &y_temp, &z_temp);
    //    x_data[count]=x_temp;
    //    y_data[count]=y_temp;
    //    z_data[count]=z_temp;


    myXYZ.color6_readXYZ(x_cnt, y_cnt, z_cnt);

    x_cnt++;
    y_cnt++;
    z_cnt++;
    //delayMicroseconds(250);//150
    //delay(2);
    count++;

    
    //timecnt = micros() - timecnt;
    //Serial.println(timecnt);
    //while(1){};

  }





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

  //  Test channel attenuation


  if (count > Number) {

    for (int i = 1; i <= Number; i++)
    { 
//      x_ee_data[i] = myXYZ.convertingToEe(_COLOR6_MREG_MEASUREMENT_X_CHANNEL, x_data[i]);
//      y_ee_data[i] = myXYZ.convertingToEe(_COLOR6_MREG_MEASUREMENT_Y_CHANNEL, y_data[i]);
//      z_ee_data[i] = myXYZ.convertingToEe(_COLOR6_MREG_MEASUREMENT_Z_CHANNEL, z_data[i]);
      Serial.println('X');
      Serial.println(x_data[i]);
      Serial.println('Y');
      Serial.println(y_data[i]);
      Serial.println('Z');
      Serial.println(z_data[i]);

    }
    while (1) {};
    x_cnt = x_data;
    y_cnt = y_data;
    z_cnt = z_data;
  }



}
