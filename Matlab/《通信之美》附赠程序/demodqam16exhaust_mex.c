#include <math.h>
#include <stdio.h>
#include "mex.h"

void demod(double Conste_I[], double Conste_Q[], int Len, double BitData[])
{
    // ��ӳ�����Ϊ��������Ĭ�Ϲ���
	double CONSTE_I[] = {-3,-3,-3,-3,-1,-1,-1,-1,3,3, 3, 3,1,1, 1, 1};
	double CONSTE_Q[] = { 3, 1,-3,-1, 3, 1,-3,-1,3,1,-3,-1,3,1,-3,-1};
	double BIT[][4] = {{0,0,0,0},
                    {0,0,0,1},
                    {0,0,1,0},
                    {0,0,1,1},
                    {0,1,0,0},
                    {0,1,0,1},
                    {0,1,1,0},
                    {0,1,1,1},
                    {1,0,0,0},
                    {1,0,0,1},
                    {1,0,1,0},
                    {1,0,1,1},
                    {1,1,0,0},
                    {1,1,0,1},
                    {1,1,1,0},
                    {1,1,1,1}};
	
	int BitCnt = Len * 4;
	int i, k, MinIdx;
	double Distance_I, Distance_Q, Distance, MinDistance;
	for ( i = 0; i < Len; i ++ )
	{
		Conste_I[i] = Conste_I[i] * sqrt(10.0);
		Conste_Q[i] = Conste_Q[i] * sqrt(10.0);
		MinDistance = 100000.0;
		for ( k = 0; k < 16; k ++ )
		{
			
			Distance_I = (Conste_I[i] - CONSTE_I[k]);
			Distance_Q = (Conste_Q[i] - CONSTE_Q[k]);
			Distance = Distance_I * Distance_I + Distance_Q * Distance_Q;
			if ( Distance < MinDistance )
			{
				MinDistance = Distance;
				MinIdx = k;
			}
		}
		BitData[i*4]     = BIT[MinIdx][0];
		BitData[i*4 + 1] = BIT[MinIdx][1];
		BitData[i*4 + 2] = BIT[MinIdx][2];
		BitData[i*4 + 3] = BIT[MinIdx][3];
	}
}



void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    size_t Len;
    double *inMatrix_I;
	double *inMatrix_Q;
    double *outMatrix;

  
    // ��ȡ��һ�����������ʵ�����鲿��ͷָ��
    inMatrix_I = mxGetPr(prhs[0]);
	inMatrix_Q = mxGetPi(prhs[0]);

    // ��ȡ��һ����������ĳ���
	Len = mxGetM(prhs[0]);

    // �����������
	plhs[0] = mxCreateDoubleMatrix((mwSize)Len * 4, 1, mxREAL);

    // ��ȡ��һ�����������ͷָ��
    outMatrix = mxGetPr(plhs[0]);

    // ���ý������demod
	demod(inMatrix_I,inMatrix_Q,(int)Len,outMatrix);
}