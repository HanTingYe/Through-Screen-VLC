#ifndef AS73211_H_
#define AS73211_H_

#if ARDUINO >= 100
 #include <Arduino.h>
#else
 #include <WProgram.h>
#endif

#include <Wire.h>

/* I2C address */
#define AS73211_ADDRESS                      0x74   

  /* Register */
#define _COLOR6_REG_OPERATIONAL_STATE        0x00
#define _COLOR6_REG_API_GENERATION           0x02
#define _COLOR6_REG_CONFIGURATION_REGISTER_1 0x06
#define _COLOR6_REG_CONFIGURATION_REGISTER_2 0x07
#define _COLOR6_REG_CONFIGURATION_REGISTER_3 0x08
#define _COLOR6_REG_BREAK_TIME               0x09
#define _COLOR6_REG_EDGE_COUNT_VALUE         0x0A
#define _COLOR6_REG_OPTIONS_REGISTER         0x0B

/* Operational State Register – OSR */
#define _COLOR6_OSR_STOP_MEASUREMENT  		0x00
#define _COLOR6_OSR_START_MEASUREMENT 		0x80

#define _COLOR6_OSR_POWER_DOWN_SWITCHED_OFF 0x00
#define _COLOR6_OSR_POWER_DOWN_SWITCHED_ON  0x40

#define _COLOR6_OSR_SOFTWARE_RESET          0x08

#define _COLOR6_OSR_DOS_CONFIGURATION       0x02
#define _COLOR6_OSR_DOS_MEASUREMENT         0x03
#define _COLOR6_OSR_DOS_NO_CHANGE           0x00

typedef enum{
	Configuration_state_Power_Down_state_on=0x42,
	Configuration_state=0x02,
	Measurement_state=0x03,
	Measurement_state_Start_measurement=0x83,
	If_Measurement_state_Start_measurement=0x80,
	Measurement_state_Power_Down_state_on=0x43,
	Measurement_state_Start_measurement_and_internal_startup_Power_Down_state_on=0xC3,
	If_Measurement_state_Start_measurement_and_internal_startup_Power_Down_state_on=0xC0,
	Software_reset=0x0A //0x0A power down state OFF; 0x4A power down state ON
}OperationalState;

/* API Generation Register (AGEN) */
#define _COLOR6_AGEN_DEVICE_ID       0x01
#define _COLOR6_AGEN_MUTATION_NUMBER 0x02

/* Configuration Register - CREG1 */
/* GAIN */
#define _COLOR6_CREG1_GAIN_XYZ_2048 0x00
#define _COLOR6_CREG1_GAIN_XYZ_1024 0x10
#define _COLOR6_CREG1_GAIN_XYZ_512  0x20
#define _COLOR6_CREG1_GAIN_XYZ_256  0x30
#define _COLOR6_CREG1_GAIN_XYZ_128  0x40
#define _COLOR6_CREG1_GAIN_XYZ_64   0x50
#define _COLOR6_CREG1_GAIN_XYZ_32   0x60
#define _COLOR6_CREG1_GAIN_XYZ_16   0x70
#define _COLOR6_CREG1_GAIN_XYZ_8    0x80
#define _COLOR6_CREG1_GAIN_XYZ_4    0x90
#define _COLOR6_CREG1_GAIN_XYZ_2    0xA0
#define _COLOR6_CREG1_GAIN_XYZ_1    0xB0

typedef enum{
	Gain2048=0x00,
	Gain1024=0x10,
	Gain512 =0x20,
	Gain256 =0x30,
	Gain128 =0x40,
	Gain64  =0x50,
	Gain32  =0x60,
	Gain16  =0x70,
	Gain8   =0x80,
	Gain4   =0x90,
	Gain2   =0xA0,//default
	Gain1   =0xB0,
}IntegrationGain;

/* TIME */
#define _COLOR6_CREG1_TIME_1ms      0x00
#define _COLOR6_CREG1_TIME_2ms      0x01
#define _COLOR6_CREG1_TIME_4ms      0x02
#define _COLOR6_CREG1_TIME_8ms      0x03
#define _COLOR6_CREG1_TIME_16ms     0x04
#define _COLOR6_CREG1_TIME_32ms     0x05
#define _COLOR6_CREG1_TIME_64ms     0x06
#define _COLOR6_CREG1_TIME_128ms    0x07
#define _COLOR6_CREG1_TIME_256ms    0x08
#define _COLOR6_CREG1_TIME_512ms    0x09
#define _COLOR6_CREG1_TIME_1024ms   0x0A
#define _COLOR6_CREG1_TIME_2048ms   0x0B
#define _COLOR6_CREG1_TIME_4096ms   0x0C
#define _COLOR6_CREG1_TIME_8192ms   0x0D
#define _COLOR6_CREG1_TIME_16384ms  0x0E

typedef enum{
	Time1ms    =0x00,
	Time2ms    =0x01,
	Time4ms    =0x02,
	Time8ms    =0x03,
	Time16ms   =0x04,
	Time32ms   =0x05,
	Time64ms   =0x06,//default
	Time128ms  =0x07,
	Time256ms  =0x08,
	Time512ms  =0x09,
	Time1024ms =0x0A,
	Time2048ms =0x0B,
	Time4096ms =0x0C,
	Time8192ms =0x0D,
	Time16384ms=0x0E
}IntegrationTime;

/* Configuration Register - CREG2 */
#define _COLOR6_CREG2_EN_TM_DISABLE 0x00
#define _COLOR6_CREG2_EN_TM_ENABLE  0x40

// Different from color6.h

#define _COLOR6_CREG2_DIVIDER_1   0x00
#define _COLOR6_CREG2_DIVIDER_2   0x08
#define _COLOR6_CREG2_DIVIDER_4   0x09
#define _COLOR6_CREG2_DIVIDER_8   0x0A
#define _COLOR6_CREG2_DIVIDER_16  0x0B
#define _COLOR6_CREG2_DIVIDER_32  0x0C
#define _COLOR6_CREG2_DIVIDER_64  0x0D
#define _COLOR6_CREG2_DIVIDER_128 0x0E
#define _COLOR6_CREG2_DIVIDER_256 0x0F
typedef enum{
	Divider1  =0x00,//default
	Divider2  =0x08,
	Divider4  =0x09,
	Divider8  =0x0A,
	Divider16 =0x0B,
	Divider32 =0x0C,
	Divider64 =0x0D,
	Divider128=0x0E,
	Divider256=0x0F
}MeasurementDivider;

/* Configuration Register - CREG3 */
#define _COLOR6_CREG3_MMODE_CONT_MODE 0x00
#define _COLOR6_CREG3_MMODE_CMD_MODE  0x40
#define _COLOR6_CREG3_MMODE_SYNS_MODE 0x80
#define _COLOR6_CREG3_MMODE_SIND_MODE 0xC0
typedef enum{
	ModeContinous=0x00,
	ModeCommand=0x40,//default
	ModeSynchronizedStart=0x80,
	ModeSynchronizedStartStop=0xC0
}MeasurementMode;

#define _COLOR6_CREG3_SB_STANDBY_SWITCHED_OFF 0x00
#define _COLOR6_CREG3_SB_STANDBY_SWITCHED_ON  0x10
#define _COLOR6_CREG3_READY_PUSH_PULL_OUT     0x00
#define _COLOR6_CREG3_READY_OPEN_DRAIN_OUT    0x08
typedef enum{
	ModePushPull=0x00,//default
	ModeOpenDrain=0x08
}ReadyPinMode;
#define _COLOR6_CREG3_INTERNAL_CLOCK_1024MHZ  0x00
#define _COLOR6_CREG3_INTERNAL_CLOCK_2048MHZ  0x01
#define _COLOR6_CREG3_INTERNAL_CLOCK_4096MHZ  0x02
#define _COLOR6_CREG3_INTERNAL_CLOCK_8192MHZ  0x03
typedef enum{
	Clock1024MHz=0x00,//default
	Clock2048MHz=0x01,
	Clock4096MHz=0x02,
	Clock8192MHz=0x03
}InternalClockFrequency;

/* Output Result Register Bank */
#define _COLOR6_MREG_STATUS_REGISTER         0x00
#define _COLOR6_MREG_TEMPERATURE_MEASUREMENT 0x01
#define _COLOR6_MREG_MEASUREMENT_X_CHANNEL   0x02
#define _COLOR6_MREG_MEASUREMENT_Y_CHANNEL   0x03
#define _COLOR6_MREG_MEASUREMENT_Z_CHANNEL   0x04
#define _COLOR6_MREG_OUT_CONVERSION_LSB      0x05
#define _COLOR6_MREG_OUT_CONVERSION_MSB      0x06

/* Status Register */
#define _COLOR6_STATUS_OUTCONVOF 0x8000
#define _COLOR6_STATUS_MRESOF    0x4000
#define _COLOR6_STATUS_ADCOF     0x2000
#define _COLOR6_STATUS_LDATA     0x1000
#define _COLOR6_STATUS_NDATA     0x0800
#define _COLOR6_STATUS_NOTREADY  0x0400
#define _COLOR6_STATUS_STANDBY   0x0200
#define _COLOR6_STATUS_POWER     0x0100

/* Full Scale Range of detectable irradiance Ee [uW/cm2] */
//1024ms
/*
#define _COLOR6_X_FSR_OF_GAIN_2048 0.866F
#define _COLOR6_Y_FSR_OF_GAIN_2048 0.932F
#define _COLOR6_Z_FSR_OF_GAIN_2048 0.501F
#define _COLOR6_X_FSR_OF_GAIN_1024 1.732F
#define _COLOR6_Y_FSR_OF_GAIN_1024 1.865F
#define _COLOR6_Z_FSR_OF_GAIN_1024 1.002F
#define _COLOR6_X_FSR_OF_GAIN_512 3.463F
#define _COLOR6_Y_FSR_OF_GAIN_512 3.730F
#define _COLOR6_Z_FSR_OF_GAIN_512 2.003F
#define _COLOR6_X_FSR_OF_GAIN_256 6.927F
#define _COLOR6_Y_FSR_OF_GAIN_256 7.460F
#define _COLOR6_Z_FSR_OF_GAIN_256 4.006F
#define _COLOR6_X_FSR_OF_GAIN_128 13.854F
#define _COLOR6_Y_FSR_OF_GAIN_128 14.919F
#define _COLOR6_Z_FSR_OF_GAIN_128 8.012F
#define _COLOR6_X_FSR_OF_GAIN_64 27.707F
#define _COLOR6_Y_FSR_OF_GAIN_64 29.838F
#define _COLOR6_Z_FSR_OF_GAIN_64 16.024F
#define _COLOR6_X_FSR_OF_GAIN_32 55.414F
#define _COLOR6_Y_FSR_OF_GAIN_32 59.677F
#define _COLOR6_Z_FSR_OF_GAIN_32 32.048F
#define _COLOR6_X_FSR_OF_GAIN_16 110.828F
#define _COLOR6_Y_FSR_OF_GAIN_16 119.354F
#define _COLOR6_Z_FSR_OF_GAIN_16 64.097F
#define _COLOR6_X_FSR_OF_GAIN_8 221.657F
#define _COLOR6_Y_FSR_OF_GAIN_8 238.707F
#define _COLOR6_Z_FSR_OF_GAIN_8 128.194F
#define _COLOR6_X_FSR_OF_GAIN_4 443.314F
#define _COLOR6_Y_FSR_OF_GAIN_4 477.415F
#define _COLOR6_Z_FSR_OF_GAIN_4 256.387F
#define _COLOR6_X_FSR_OF_GAIN_2 886.628F
#define _COLOR6_Y_FSR_OF_GAIN_2 954.830F
#define _COLOR6_Z_FSR_OF_GAIN_2 512.774F
#define _COLOR6_X_FSR_OF_GAIN_1 1773.255F
#define _COLOR6_Y_FSR_OF_GAIN_1 1909.659F
#define _COLOR6_Z_FSR_OF_GAIN_1 1025.548F
*/

//1ms
#define _COLOR6_X_FSR_OF_GAIN_2048 13.854F
#define _COLOR6_Y_FSR_OF_GAIN_2048 14.919F
#define _COLOR6_Z_FSR_OF_GAIN_2048 8.012F
#define _COLOR6_X_FSR_OF_GAIN_1024 27.707F
#define _COLOR6_Y_FSR_OF_GAIN_1024 29.838F
#define _COLOR6_Z_FSR_OF_GAIN_1024 16.024F
#define _COLOR6_X_FSR_OF_GAIN_512 55.414F
#define _COLOR6_Y_FSR_OF_GAIN_512 59.677F
#define _COLOR6_Z_FSR_OF_GAIN_512 32.048F
#define _COLOR6_X_FSR_OF_GAIN_256 110.828F
#define _COLOR6_Y_FSR_OF_GAIN_256 119.354F
#define _COLOR6_Z_FSR_OF_GAIN_256 64.097F
#define _COLOR6_X_FSR_OF_GAIN_128 221.657F
#define _COLOR6_Y_FSR_OF_GAIN_128 238.707F
#define _COLOR6_Z_FSR_OF_GAIN_128 128.194F
#define _COLOR6_X_FSR_OF_GAIN_64 443.314F
#define _COLOR6_Y_FSR_OF_GAIN_64 477.415F
#define _COLOR6_Z_FSR_OF_GAIN_64 256.387F
#define _COLOR6_X_FSR_OF_GAIN_32 886.628F
#define _COLOR6_Y_FSR_OF_GAIN_32 954.830F
#define _COLOR6_Z_FSR_OF_GAIN_32 512.774F
#define _COLOR6_X_FSR_OF_GAIN_16 1773.255F
#define _COLOR6_Y_FSR_OF_GAIN_16 1909.659F
#define _COLOR6_Z_FSR_OF_GAIN_16 1025.548F
#define _COLOR6_X_FSR_OF_GAIN_8 3546.510F
#define _COLOR6_Y_FSR_OF_GAIN_8 3819.319F
#define _COLOR6_Z_FSR_OF_GAIN_8 2051.097F
#define _COLOR6_X_FSR_OF_GAIN_4 7093.020F
#define _COLOR6_Y_FSR_OF_GAIN_4 7638.637F
#define _COLOR6_Z_FSR_OF_GAIN_4 4102.193F
#define _COLOR6_X_FSR_OF_GAIN_2 14186.041F
#define _COLOR6_Y_FSR_OF_GAIN_2 15277.275F
#define _COLOR6_Z_FSR_OF_GAIN_2 8204.387F
#define _COLOR6_X_FSR_OF_GAIN_1 28372.081F
#define _COLOR6_Y_FSR_OF_GAIN_1 30554.549F
#define _COLOR6_Z_FSR_OF_GAIN_1 16408.773F

/* Number of clocks */
#define _COLOR6_NUMBER_OF_CLK_TIME_1ms     1024L
#define _COLOR6_NUMBER_OF_CLK_TIME_2ms     2048L
#define _COLOR6_NUMBER_OF_CLK_TIME_4ms     4096L
#define _COLOR6_NUMBER_OF_CLK_TIME_8ms     8192L
#define _COLOR6_NUMBER_OF_CLK_TIME_16ms    16384L
#define _COLOR6_NUMBER_OF_CLK_TIME_32ms    32768L
#define _COLOR6_NUMBER_OF_CLK_TIME_64ms    65536L
#define _COLOR6_NUMBER_OF_CLK_TIME_128ms   131072L
#define _COLOR6_NUMBER_OF_CLK_TIME_256ms   262144L
#define _COLOR6_NUMBER_OF_CLK_TIME_512ms   524288L
#define _COLOR6_NUMBER_OF_CLK_TIME_1024ms  1048576L
#define _COLOR6_NUMBER_OF_CLK_TIME_2048ms  2097152L
#define _COLOR6_NUMBER_OF_CLK_TIME_4096ms  4194304L
#define _COLOR6_NUMBER_OF_CLK_TIME_8192ms  8388608L
#define _COLOR6_NUMBER_OF_CLK_TIME_16384ms 16777216L

constexpr uint8_t _channel_time[15] =
{
    _COLOR6_CREG1_TIME_1ms,
    _COLOR6_CREG1_TIME_2ms,
    _COLOR6_CREG1_TIME_4ms,
    _COLOR6_CREG1_TIME_8ms,
    _COLOR6_CREG1_TIME_16ms,
    _COLOR6_CREG1_TIME_32ms,
    _COLOR6_CREG1_TIME_64ms,
    _COLOR6_CREG1_TIME_128ms,
    _COLOR6_CREG1_TIME_256ms,
    _COLOR6_CREG1_TIME_512ms,
    _COLOR6_CREG1_TIME_1024ms,
    _COLOR6_CREG1_TIME_2048ms,
    _COLOR6_CREG1_TIME_4096ms,
    _COLOR6_CREG1_TIME_8192ms,
    _COLOR6_CREG1_TIME_16384ms
};

constexpr uint32_t _number_of_clock[15] =
{
    _COLOR6_NUMBER_OF_CLK_TIME_1ms,
    _COLOR6_NUMBER_OF_CLK_TIME_2ms,
    _COLOR6_NUMBER_OF_CLK_TIME_4ms,
    _COLOR6_NUMBER_OF_CLK_TIME_8ms,
    _COLOR6_NUMBER_OF_CLK_TIME_16ms,
    _COLOR6_NUMBER_OF_CLK_TIME_32ms,
    _COLOR6_NUMBER_OF_CLK_TIME_64ms,
    _COLOR6_NUMBER_OF_CLK_TIME_128ms,
    _COLOR6_NUMBER_OF_CLK_TIME_256ms,
    _COLOR6_NUMBER_OF_CLK_TIME_512ms,
    _COLOR6_NUMBER_OF_CLK_TIME_1024ms,
    _COLOR6_NUMBER_OF_CLK_TIME_2048ms,
    _COLOR6_NUMBER_OF_CLK_TIME_4096ms,
    _COLOR6_NUMBER_OF_CLK_TIME_8192ms,
    _COLOR6_NUMBER_OF_CLK_TIME_16384ms
};

constexpr uint8_t _channel_gain[12] =
{
    _COLOR6_CREG1_GAIN_XYZ_2048,
    _COLOR6_CREG1_GAIN_XYZ_1024,
    _COLOR6_CREG1_GAIN_XYZ_512,
    _COLOR6_CREG1_GAIN_XYZ_256,
    _COLOR6_CREG1_GAIN_XYZ_128,
    _COLOR6_CREG1_GAIN_XYZ_64,
    _COLOR6_CREG1_GAIN_XYZ_32,
    _COLOR6_CREG1_GAIN_XYZ_16,
    _COLOR6_CREG1_GAIN_XYZ_8,
    _COLOR6_CREG1_GAIN_XYZ_4,
    _COLOR6_CREG1_GAIN_XYZ_2,
    _COLOR6_CREG1_GAIN_XYZ_1
};

constexpr float _X_channel_FSR[12] =
{
    _COLOR6_X_FSR_OF_GAIN_2048,
    _COLOR6_X_FSR_OF_GAIN_1024,
    _COLOR6_X_FSR_OF_GAIN_512,
    _COLOR6_X_FSR_OF_GAIN_256,
    _COLOR6_X_FSR_OF_GAIN_128,
    _COLOR6_X_FSR_OF_GAIN_64,
    _COLOR6_X_FSR_OF_GAIN_32,
    _COLOR6_X_FSR_OF_GAIN_16,
    _COLOR6_X_FSR_OF_GAIN_8,
    _COLOR6_X_FSR_OF_GAIN_4,
    _COLOR6_X_FSR_OF_GAIN_2,
    _COLOR6_X_FSR_OF_GAIN_1
};

constexpr float _Y_channel_FSR[12] =
{
    _COLOR6_Y_FSR_OF_GAIN_2048,
    _COLOR6_Y_FSR_OF_GAIN_1024,
    _COLOR6_Y_FSR_OF_GAIN_512,
    _COLOR6_Y_FSR_OF_GAIN_256,
    _COLOR6_Y_FSR_OF_GAIN_128,
    _COLOR6_Y_FSR_OF_GAIN_64,
    _COLOR6_Y_FSR_OF_GAIN_32,
    _COLOR6_Y_FSR_OF_GAIN_16,
    _COLOR6_Y_FSR_OF_GAIN_8,
    _COLOR6_Y_FSR_OF_GAIN_4,
    _COLOR6_Y_FSR_OF_GAIN_2,
    _COLOR6_Y_FSR_OF_GAIN_1
};

constexpr float _Z_channel_FSR[12] =
{
    _COLOR6_Z_FSR_OF_GAIN_2048,
    _COLOR6_Z_FSR_OF_GAIN_1024,
    _COLOR6_Z_FSR_OF_GAIN_512,
    _COLOR6_Z_FSR_OF_GAIN_256,
    _COLOR6_Z_FSR_OF_GAIN_128,
    _COLOR6_Z_FSR_OF_GAIN_64,
    _COLOR6_Z_FSR_OF_GAIN_32,
    _COLOR6_Z_FSR_OF_GAIN_16,
    _COLOR6_Z_FSR_OF_GAIN_8,
    _COLOR6_Z_FSR_OF_GAIN_4,
    _COLOR6_Z_FSR_OF_GAIN_2,
    _COLOR6_Z_FSR_OF_GAIN_1
};

class AS73211{
	public:
		//AS73211(uint8_t addr);
		AS73211();
		
		bool begin();
		void color6_writeByte(uint8_t reg, uint8_t _data);
		uint8_t color6_readByte(uint8_t reg);
		uint16_t color6_readData(uint8_t reg);
		uint16_t color6_readXYZ(uint16_t *X, uint16_t *Y, uint16_t *Z);
		
		float getTemperature();
		
		void softwareReset();
		bool setState(OperationalState state);
		OperationalState getState();
		
		uint8_t getDeviceID();
		
		bool setGainAndTime(IntegrationGain gain,IntegrationTime time);
		
		bool setGain(IntegrationGain gain);
		IntegrationGain getGain();
		uint16_t getGainValue();
		
		bool setTime(IntegrationTime time);
		IntegrationTime getTime();
		uint16_t getTimeValue();
		uint16_t getTimeValueBuffer();
		
		bool newDataAvailable();
		
		bool setConfiguration(bool measureTemperature,MeasurementDivider divider,
				MeasurementMode mmode,bool standby,ReadyPinMode readyMode,InternalClockFrequency freq);
		
		MeasurementDivider getDivider();
		uint16_t getDividerValue();
		bool setDivider(MeasurementDivider divider);
		
		InternalClockFrequency getClock();
		uint16_t getClockValue();
		bool setClock(InternalClockFrequency freq);
		
		float convertingToEe(uint8_t channel, uint16_t MRES_data);
	private:
		uint8_t getGainAndTime();
		uint8_t _slaveAddress;
		TwoWire *_wire;
		uint8_t _setGain;
		uint8_t _setTime;
		float   _FSR;
		uint32_t _numOfClk;
};
#endif
