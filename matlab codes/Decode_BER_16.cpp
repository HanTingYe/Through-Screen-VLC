/*Version 3.0*/
#include "mex.h" 
#include "RS-FEC.h"

/*************************************************************************/
/*the fabled myFunction                                                  */
/*************************************************************************/
void myFunction(unsigned int N, unsigned int siz, double* output, char* repaired)
{
    for(int ii=0; ii<siz; ++ii)
    {
        output[ii] = (double)(repaired[ii]);
    }

}

void  mexFunction( int  nlhs, mxArray *plhs[],  int  nrhs,  const  mxArray *prhs[]) 
{

//Modulation index
const int M = 16;
const int CSKlen = 4;


const int msglen = 8;  
const uint8_t ECC_LENGTH = 4;  //Max message lenght, and "gurdian bytes", Max corrected bytes ECC_LENGTH/2
char repaired[msglen];    
char encoded[msglen + ECC_LENGTH];
RS::ReedSolomon<msglen, ECC_LENGTH> rs;

//char message[] = "Hello World!";
char message_frame[msglen]; // The message size would be different, so need a container
char message_unit[8];




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
  
  
  
  message_unit[0] =  (char) 1;
  message_unit[1] =  (char) 35;
  message_unit[2] =  (char) 69;
  message_unit[3] =  (char) 103;
  message_unit[4] =  (char) 137;
  message_unit[5] =  (char) 171;
  message_unit[6] =  (char) 205;
  message_unit[7] =  (char) 239;
  
/*   char temp[M * CSKlen / 8];

  //  strcpy(temp, message_unit);

  for (int i = 0; i < M * CSKlen / 8; i++)
  {
    temp[i] = message_unit[i];
  }
  //  temp[M * CSKlen / 8] = '\0';

  for (int i = 0; i < (msglen / (M * CSKlen / 8) - 1); i++)
  {
    strcat(temp, message_unit);
  }
  for (int i = 0; i < msglen; i++)
  {
    message_frame[i] = temp[i];
  }

  //message_frame[msglen]='\0'; */
   

rs.Encode(message_frame, encoded);

double *dataCursor;
dataCursor = mxGetPr(prhs[0]);

for(int i = 0; i <= (msglen + ECC_LENGTH-1); i++) 
{    
encoded[i] = (char)dataCursor[i];    
} // Fill with the message
//encoded[msglen+ECC_LENGTH]='\0';


rs.Decode(encoded, repaired);

//repaired[msglen]='\0';

    plhs[0] = mxCreateDoubleMatrix(1,msglen,mxREAL); //让第一个输出参数指向一个1*1的矩阵
	myFunction(1, msglen, mxGetPr( plhs[0]), repaired );
	//double *y;
    //y = mxGetPr(plhs[0]); //获得矩阵的第一个元素的指针
    //*y = repaired; //将其赋值为10

//plhs[0] = mxCreateString(repaired);//使用mxCreateString创建mxArray输出   

return;

}