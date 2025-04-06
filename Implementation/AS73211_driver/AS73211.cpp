#include "Arduino.h"
#include "AS73211.h"

/*AS73211::AS73211(uint8_t slave){
  _slaveAddress =slave;
#if defined(ARDUINO_SAM_DUE)
  _wire = &Wire1;
#else
  _wire = &Wire;
#endif
}*/

AS73211::AS73211(){
  _slaveAddress = AS73211_ADDRESS;
  _wire = &Wire;

}

bool AS73211::begin(){
  
  /*
    Low speed mode
  */
  
  /*
  _wire->begin();
  _wire->setClock(400000);
  delay(100);
  softwareReset();
  setState(Configuration_state);
  setGainAndTime(Gain1,Time128ms);
  setConfiguration(
		false,
		Divider1,
		ModeContinous,//ModeCommand, ModeContinous, ModeSynchronizedStart, ModeSynchronizedStartStop
		false,
		ModePushPull,
		Clock8192MHz);
  color6_writeByte(_COLOR6_REG_BREAK_TIME, 0xff);
  setState(Measurement_state_Start_measurement);
  //Serial.println(getState(), BIN);//test
  */
  
  
  
  
  
  
  
  
  
  

  
  
  /*
    High speed mode
  */
  _wire->setClock(400000);
  _wire->begin(); 
  softwareReset();
  setState(Configuration_state);
  setConfiguration(
		false,
		Divider1,
		ModeContinous,//ModeCommand, ModeContinous, ModeSynchronizedStart, ModeSynchronizedStartStop
		false,
		ModePushPull,//ModePushPull, ModeOpenDrain
		Clock8192MHz);//Gain can only be set: 1x, 4x, 16x, 64x, 256x 
  setGainAndTime(Gain64,Time1ms);
  color6_writeByte(_COLOR6_REG_BREAK_TIME, 0x00); // the minimum break time from the datasheet is 3 clocks of fCLK
  //color6_writeByte(_COLOR6_REG_BREAK_TIME, 0x10); // break time 8us
  color6_writeByte(_COLOR6_REG_OPTIONS_REGISTER, 0x72); // 0x72, 0x73
  setState(Measurement_state_Start_measurement);
  //Serial.println(getState(), BIN);//test
  
  
  
  
  
  

  
}


bool AS73211::setState(OperationalState state){
	//delay(500);
	color6_writeByte(_COLOR6_REG_OPERATIONAL_STATE,(uint8_t)state);
	//delay(500);
	  
	return getState()== Measurement_state;
}

OperationalState AS73211::getState(){
	return (OperationalState)color6_readByte(_COLOR6_REG_OPERATIONAL_STATE);
}

uint8_t AS73211::getDeviceID(){
	return color6_readByte(_COLOR6_REG_API_GENERATION);
}

// Register 1 processing gain and integration time
bool AS73211::setGainAndTime(IntegrationGain gain,IntegrationTime time){
	uint8_t value=((uint8_t)gain)|((uint8_t)time);
	color6_writeByte(_COLOR6_REG_CONFIGURATION_REGISTER_1,value);
	return getGainAndTime()==value;
}

bool AS73211::setGain(IntegrationGain gain){
	uint8_t value=((uint8_t)gain)|((uint8_t)getTime());
	color6_writeByte(_COLOR6_REG_CONFIGURATION_REGISTER_1,value);
	return getGainAndTime()==value;
}

bool AS73211::setTime(IntegrationTime time){
	uint8_t value=((uint8_t)getGain())|((uint8_t)time);
	color6_writeByte(_COLOR6_REG_CONFIGURATION_REGISTER_1,value);
	return getGainAndTime()==value;
}

uint8_t AS73211::getGainAndTime(){
	return color6_readByte(_COLOR6_REG_CONFIGURATION_REGISTER_1);
}

IntegrationGain AS73211::getGain(){
	return (IntegrationGain)(getGainAndTime()&0xF0); //0xF0
}

uint16_t AS73211::getGainValue(){
	switch(getGain()){
		case Gain2048 : return 2048;
		case Gain1024 : return 1024;
		case Gain512  : return 512;
		case Gain256  : return 256;
		case Gain128  : return 128;
		case Gain64   : return 64;
		case Gain32   : return 32;
		case Gain16   : return 16;
		case Gain8    : return 8;
		case Gain4    : return 4;
		case Gain2    : return 2;
		case Gain1    : return 1;
		default: return 0;
	}
}

IntegrationTime AS73211::getTime(){
	return (IntegrationTime)(getGainAndTime()&0x0F); //0x0F
}

uint16_t AS73211::getTimeValue(){
	switch(getTime()){
		case Time1ms     : return 1;
		case Time2ms     : return 2;
		case Time4ms     : return 4;
		case Time8ms     : return 8;
		case Time16ms    : return 16;
		case Time32ms    : return 32;
		case Time64ms    : return 64;
		case Time128ms   : return 128;
		case Time256ms   : return 256;
		case Time512ms   : return 512;
		case Time1024ms  : return 1024;
		case Time2048ms  : return 2048;
		case Time4096ms  : return 4096;
		case Time8192ms  : return 8192;
		case Time16384ms : return 16384;
		default: return 0;
	}
}

uint16_t AS73211::getTimeValueBuffer(){
	switch((IntegrationTime)_setTime){
		case Time1ms     : return 1;
		case Time2ms     : return 2;
		case Time4ms     : return 4;
		case Time8ms     : return 8;
		case Time16ms    : return 16;
		case Time32ms    : return 32;
		case Time64ms    : return 64;
		case Time128ms   : return 128;
		case Time256ms   : return 256;
		case Time512ms   : return 512;
		case Time1024ms  : return 1024;
		case Time2048ms  : return 2048;
		case Time4096ms  : return 4096;
		case Time8192ms  : return 8192;
		case Time16384ms : return 16384;
		default: return 0;
	}
}

// Register 2 control temperature measurement and AD divider
// Register 3 configure measurement mode, standby mode(energy saving opinion), Pin READY, Clock freq
bool AS73211::setConfiguration(
		bool measureTemperature,
		MeasurementDivider divider,
		MeasurementMode mmode,
		bool standby,
		ReadyPinMode readyMode,
		InternalClockFrequency freq){
	uint8_t conf2=(measureTemperature?0x40:0x00)|(uint8_t)divider;//0x40
	uint8_t conf3=(uint8_t)mmode|(standby?0x10:0x00)|(uint8_t)readyMode|(uint8_t)freq;
	color6_writeByte(_COLOR6_REG_CONFIGURATION_REGISTER_2, conf2);
	color6_writeByte(_COLOR6_REG_CONFIGURATION_REGISTER_3, conf3);
	return  (0b01001111&color6_readByte(_COLOR6_REG_CONFIGURATION_REGISTER_2))==conf2 &&
			(0b11011011&color6_readByte(_COLOR6_REG_CONFIGURATION_REGISTER_3))==conf3;
}

MeasurementDivider AS73211::getDivider(){
	uint8_t value=color6_readByte(_COLOR6_REG_CONFIGURATION_REGISTER_2)&0x0F;
	if(value<0x8)
		value=0;
	return (MeasurementDivider)value;
}

bool AS73211::setDivider(MeasurementDivider divider){
	uint8_t value=color6_readByte(_COLOR6_REG_CONFIGURATION_REGISTER_2)&0xF0|((uint8_t)divider);
	color6_writeByte(_COLOR6_REG_CONFIGURATION_REGISTER_2,value);
	return color6_readByte(_COLOR6_REG_CONFIGURATION_REGISTER_2)==value;
}

uint16_t AS73211::getDividerValue(){
	switch(getDivider()){
		case Divider1   : return 1;
		case Divider2   : return 2;
		case Divider4   : return 4;
		case Divider8   : return 8;
		case Divider16  : return 16;
		case Divider32  : return 32;
		case Divider64  : return 64;
		case Divider128 : return 128;
		case Divider256 : return 256;
		default: return 0;
	}
}

InternalClockFrequency AS73211::getClock(){
	uint8_t value=color6_readByte(_COLOR6_REG_CONFIGURATION_REGISTER_3)&0x03; //0x03
	return (InternalClockFrequency)value;
}

uint16_t AS73211::getClockValue(){
	switch(getClock()){
		case Clock1024MHz : return 1024;
		case Clock2048MHz : return 2048;
		case Clock4096MHz : return 4096;
		case Clock8192MHz : return 8192;
		default: return 0;
	}
}

bool AS73211::setClock(InternalClockFrequency freq){
	uint8_t value=color6_readByte(_COLOR6_REG_CONFIGURATION_REGISTER_3)&0xFC|((uint8_t)freq);
	color6_writeByte(_COLOR6_REG_CONFIGURATION_REGISTER_3,value);
	return color6_readByte(_COLOR6_REG_CONFIGURATION_REGISTER_3)==value;
}

bool AS73211::newDataAvailable(){
	//return (((color6_readData(_COLOR6_MREG_STATUS_REGISTER)&_COLOR6_STATUS_NDATA)==_COLOR6_STATUS_NDATA) &&((color6_readData(_COLOR6_MREG_STATUS_REGISTER)&_COLOR6_STATUS_LDATA)!=_COLOR6_STATUS_LDATA));
	return color6_readData(_COLOR6_MREG_STATUS_REGISTER)&_COLOR6_STATUS_NDATA;
}

void AS73211::color6_writeByte(uint8_t reg, uint8_t _data)
{   
    _wire->beginTransmission(_slaveAddress);
    //_wire->write(writeReg, 2);   
	//Serial.println(reg);//test
    //Serial.println(_data);//test
	_wire->write(reg); 
	_wire->write(_data);
    _wire->endTransmission();
    
    if (reg == _COLOR6_REG_CONFIGURATION_REGISTER_1)
    {
        _setGain = (_data & 0xF0);
        _setTime = (_data & 0x0F);
    }
}

uint8_t AS73211::color6_readByte(uint8_t reg)
{
    uint8_t readReg=0;
   
    _wire->beginTransmission(_slaveAddress);
    _wire->write(reg);
	_wire->endTransmission();
	
    //_wire->beginTransmission(_slaveAddress);
    //_wire->endTransmission(1);
    _wire->requestFrom(_slaveAddress,1);
	//while(_wire->available())
//{
		readReg=_wire->read();
	//}
	//_wire->endTransmission();
    //_wire->endTransmission();
    return readReg;
}

uint16_t AS73211::color6_readData(uint8_t reg)
{
    uint16_t readData = 0;

    _wire->beginTransmission(_slaveAddress);
    _wire->write(reg);
	_wire->endTransmission();
	
    //_wire->beginTransmission(_slaveAddress);
	//_wire->endTransmission(1);
    _wire->requestFrom(_slaveAddress,2);
	//while(_wire->available())
	//{
		//readData = (_wire->read() << 8) | _wire->read();
		readData = (_wire->read() << 8) | _wire->read() ;
	//}	
	//_wire->endTransmission();
	/*t = _wire->read();
	readData = _wire->read();
	readData <<= 8;
    readData |= t;*/
	
    //_wire->endTransmission();
    return readData;
}

uint16_t AS73211::color6_readXYZ(uint16_t *X, uint16_t *Y, uint16_t *Z)
{

    _wire->beginTransmission(_slaveAddress);
    _wire->write(_COLOR6_MREG_MEASUREMENT_X_CHANNEL);
	_wire->endTransmission();
	
    //_wire->beginTransmission(_slaveAddress);
	//_wire->endTransmission(1);
    _wire->requestFrom(_slaveAddress,6);
	//while(_wire->available())
	//{
		//readData = (_wire->read() << 8) | _wire->read();
		//_wire->read() | (_wire->read() << 8);
		*X = (_wire->read() << 8) | _wire->read();
		*Y = (_wire->read() << 8) | _wire->read();
		*Z = (_wire->read() << 8) | _wire->read();
	//}	
	//_wire->endTransmission();
	/*t = _wire->read();
	readData = _wire->read();
	readData <<= 8;
    readData |= t;*/
	
    //_wire->endTransmission();
}

/*uint16_t AS73211::color6_readXYZ(uint16_t *X, uint16_t *Y, uint16_t *Z)
{
	//setState(Measurement_state_Start_measurement);
	//delay(200); 
	*X = color6_readData(_COLOR6_MREG_MEASUREMENT_X_CHANNEL);
	
	//delay(1);
	//setState(Measurement_state_Start_measurement);
	*Y = color6_readData(_COLOR6_MREG_MEASUREMENT_Y_CHANNEL);
	
	//delay(1);
	//setState(Measurement_state_Start_measurement);
	*Z = color6_readData(_COLOR6_MREG_MEASUREMENT_Z_CHANNEL);
	
	
	/* Set a delay for the integration time */
	/*switch ((IntegrationTime)_setTime)
  {  
	case Time1ms     : delay(1); break;
	case Time2ms     : delay(2); break;
	case Time4ms     : delay(4); break;
	case Time8ms     : delay(8); break;
	case Time16ms    : delay(16); break;
	case Time32ms    : delay(32); break;
	case Time64ms    : delay(64); break;
	case Time128ms   : delay(128); break;
	case Time256ms   : delay(256); break;
	case Time512ms   : delay(512); break;
	case Time1024ms  : delay(1024); break;
	case Time2048ms  : delay(2048); break;
	case Time4096ms  : delay(4096); break;
	case Time8192ms  : delay(8192); break;
	case Time16384ms : delay(16384); break;
  }*/

//}

float AS73211::getTemperature()
{
    uint16_t channelData;
    float floatData;
    
    channelData = color6_readData(_COLOR6_MREG_TEMPERATURE_MEASUREMENT);
    channelData = channelData & 0x0FFF;
    floatData = (channelData * 0.05F) - 66.9F;
    return floatData;
}


void AS73211::softwareReset()
{
    setState(Software_reset);
	//delay(500);
}

float AS73211::convertingToEe(uint8_t channel, uint16_t MRES_data)
{
    float dataValue;
    uint8_t cnt;
    
    for (cnt = 0; cnt < 12; cnt++)
    {
        if (_channel_gain[ cnt ] == _setGain)
        {
             if (channel == _COLOR6_MREG_MEASUREMENT_X_CHANNEL)
             {
                 _FSR = _X_channel_FSR[ cnt ];
             }
             else if (channel == _COLOR6_MREG_MEASUREMENT_Y_CHANNEL)
             {
                 _FSR = _Y_channel_FSR[ cnt ];
             }
             else if (channel == _COLOR6_MREG_MEASUREMENT_Z_CHANNEL)
             {
                 _FSR = _Z_channel_FSR[ cnt ];
             }
        }
        if (_channel_time[ cnt ] == _setTime)
        {
             _numOfClk = _number_of_clock[ cnt ];
        }
    }
    
    dataValue = (float)(_FSR / _numOfClk) * (float)MRES_data;

    return dataValue;
}
