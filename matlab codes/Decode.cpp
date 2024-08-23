/*Version 3.0*/
#include "mex.h" 
#include "RS-FEC.h"



void  mexFunction( int  nlhs, mxArray *plhs[],  int  nrhs,  const  mxArray *prhs[]) 
{

const int msglen = 12;  
const uint8_t ECC_LENGTH = 6;  //Max message lenght, and "gurdian bytes", Max corrected bytes ECC_LENGTH/2
char repaired[msglen];    
char encoded[msglen + ECC_LENGTH];
RS::ReedSolomon<msglen, ECC_LENGTH> rs;

char message[] = "Hello World!";
char message_frame[msglen]; // The message size would be different, so need a container
memset(message_frame, 0, sizeof(message_frame));        // Clear the array
for(int i = 0; i <= msglen; i++) {    message_frame[i] = message[i];     } // Fill with the message 
rs.Encode(message_frame, encoded);

double *dataCursor;
dataCursor = mxGetPr(prhs[0]);

for(int i = 0; i <= (msglen + ECC_LENGTH-1); i++) 
{    
encoded[i] = (char)dataCursor[i];    
} // Fill with the message

rs.Decode(encoded, repaired);

plhs[0] = mxCreateString(repaired);//使用mxCreateString创建mxArray输出   

return;

}