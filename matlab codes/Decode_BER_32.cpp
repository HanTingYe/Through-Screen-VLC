/*Version 3.0*/
#include "mex.h" 
#include "RS-FEC.h"

void myFunction(unsigned int N, unsigned int siz, double* output, char* repaired)
{
    for(int ii=0; ii<siz; ++ii)
    {
        output[ii] = (double)(repaired[ii]);
    }

}

void  mexFunction( int  nlhs, mxArray *plhs[],  int  nrhs,  const  mxArray *prhs[]) 
{

const int msglen = 20;  
const uint8_t ECC_LENGTH = 10;  //Max message lenght, and "gurdian bytes", Max corrected bytes ECC_LENGTH/2
char repaired[msglen];    
char encoded[msglen + ECC_LENGTH];
RS::ReedSolomon<msglen, ECC_LENGTH> rs;

//char message[] = "Hello World!";
char message_frame[msglen]; // The message size would be different, so need a container
char message_unit[20];




  /* int a = 5;
  int b = 57;
  int c = 119;
  message_unit[0] =  (char) a;
  message_unit[1] =  (char) b;
  message_unit[2] =  (char) c;
  

  char temp[3];
  strcpy(temp, message_unit);

  for (int i = 0; i < (4-1); i++)
  {
    strcat(temp, message_unit);
  }
  strcpy(message_frame, temp);  */
  
  
  
/*   int data_unit[] = {5, 57, 119};

  for (int i = 0; i < 4; i++)
  {
	for (int j = 0; j < 3; i++)
		message_unit[3*i+j]=data_unit[j];
  } */
  
  
  
  message_unit[0] =  (char) 0;
  message_unit[1] =  (char) 68;
  message_unit[2] =  (char) 50;
  message_unit[3] =  (char) 20;
  message_unit[4] =  (char) 199;
  message_unit[5] =  (char) 66;
  message_unit[6] =  (char) 84;
  message_unit[7] =  (char) 182;
  message_unit[8] =  (char) 53;
  message_unit[9] =  (char) 207;
  message_unit[10] =  (char) 132;
  message_unit[11] =  (char) 101;
  message_unit[12] =  (char) 58;
  message_unit[13] =  (char) 86;
  message_unit[14] =  (char) 215;
  message_unit[15] =  (char) 198;
  message_unit[16] =  (char) 117;
  message_unit[17] =  (char) 190;
  message_unit[18] =  (char) 119;
  message_unit[19] =  (char) 223;

   

rs.Encode(message_frame, encoded);

double *dataCursor;
dataCursor = mxGetPr(prhs[0]);

for(int i = 0; i <= (msglen + ECC_LENGTH-1); i++) 
{    
encoded[i] = (char)dataCursor[i];    
} // Fill with the message

rs.Decode(encoded, repaired);


    plhs[0] = mxCreateDoubleMatrix(1,msglen,mxREAL); //让第一个输出参数指向一个1*1的矩阵
	myFunction(1, msglen, mxGetPr( plhs[0]), repaired );
	
//plhs[0] = mxCreateString(repaired);//使用mxCreateString创建mxArray输出   

return;

}