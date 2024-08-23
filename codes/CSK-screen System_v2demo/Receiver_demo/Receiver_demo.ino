/*
  Receiver in system v1.0
  By: Hanting Ye
  TU Delft
  Date: March 1, 2020
  License: This code is public domain but you buy me a beer if you use this and we meet someday (Beerware license).
*/

#include <WiseChipHUD.h>
#include <AS73211.h>


int Number = 10000; //The number of symbols

int fadeAmount = 5;
int Tx = 0; // Symbol
int count = 1; // Number of symbol
int seed = 6;
int clock_value = 0;

AS73211 myXYZ;
//WiseChipHUD myOLED;
//int j = 1; //screen intensity 0-31

//Measure ouput
uint16_t x_data[10000] = {0};
uint16_t y_data[10000] = {0};
uint16_t z_data[10000] = {0};

uint16_t x_temp;
uint16_t y_temp;
uint16_t z_temp;

uint16_t *x_cnt = x_data;
uint16_t *y_cnt = y_data;
uint16_t *z_cnt = z_data;
float x_ee_data;
float y_ee_data;
float z_ee_data;
float temperature;
unsigned int timecnt;
unsigned int timecnt1;



void setup() {

  Serial.begin(115200);
  while (Serial.available() > 0)
    Serial.read();
  myXYZ.begin();


  //clock_value = myXYZ.getClockValue();
  //Serial.println('clock_value');



  //  myOLED.begin();
  //  myOLED.clearAll(); // Clears all of the segments
  //
  //  //For all component
  //  for (int i = 0; i < 231; i++) {
  //    myOLED.AdjustIconLevel(i, j);
  //  }

  //randomSeed(seed);


}

void loop() {


  //myXYZ.setState(Measurement_state_Start_measurement);


  //delayMicroseconds(125);
  //delay(1);

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

    
//    timecnt = micros() - timecnt;
//    Serial.println(timecnt);

  }

//  while (1) {};



  //  x_ee_data = myXYZ.convertingToEe(_COLOR6_MREG_MEASUREMENT_X_CHANNEL, x_data);
  //  //  Serial.print("Ee_X: "); Serial.print(ee_data, DEC); Serial.print(" ");
  //  //  Serial.println(" ");
  //
  //  y_ee_data = myXYZ.convertingToEe(_COLOR6_MREG_MEASUREMENT_Y_CHANNEL, y_data);
  //  //  Serial.print("Ee_Y: "); Serial.print(ee_data, DEC); Serial.print(" ");
  //  //  Serial.println(" ");
  //
  //  z_ee_data = myXYZ.convertingToEe(_COLOR6_MREG_MEASUREMENT_Z_CHANNEL, z_data);
  //  //  Serial.print("Ee_Z: "); Serial.print(ee_data, DEC); Serial.print(" ");
  //  //  Serial.println(" ");

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




  //while(1){}

  //delayMicroseconds(125);


  //  Serial.println('D');
  //  Serial.println(random(0, 8));


  //  Serial.println('X');
  //  Serial.println(x_ee_data);
  //  Serial.println('Y');
  //  Serial.println(y_ee_data);
  //  Serial.println('Z');
  //  Serial.println(z_ee_data);

  //delay(128);

  //total time:10833170 us; for loop time: 10830091; oneloop time: 63 us;

  if (count > Number) {

    for (int i = 1; i <= Number; i++)
    { 
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
