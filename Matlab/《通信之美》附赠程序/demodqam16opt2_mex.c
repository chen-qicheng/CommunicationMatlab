#include <math.h>
#include <stdio.h>
#include "mex.h"

void demod(double Conste_I[], double Conste_Q[], int Len, double BitData[])
{
	//bool BIT[4][2] = {{0, 0}, {0, 1}, {1, 0}, {1, 1}};
	double BIT[4][2] = {{0.0, 0.0}, {0.0, 1.0}, {1.0, 0.0}, {1.0, 1.0}};
	int i;
	for ( i = 0; i < Len; i ++ )
	{
		Conste_I[i] = Conste_I[i] * sqrt(10.0);
		// �ж�ʵ��
		if (Conste_I[i] < 0)
		{
			if (Conste_I[i] < -2)
			{
				BitData[i*4]   = BIT[0][0];
				BitData[i*4+1] = BIT[0][1];
			}
			else // -2��0
			{
				BitData[i*4]   = BIT[1][0];
				BitData[i*4+1] = BIT[1][1];
			}
		}
		else
		{
			if (Conste_I[i] < 2) // 0��2
			{
				BitData[i*4]   = BIT[3][0];
				BitData[i*4+1] = BIT[3][1];
			}
			else
			{
				BitData[i*4]   = BIT[2][0];
				BitData[i*4+1] = BIT[2][1];
			}
		}
		// �ж��鲿
		Conste_Q[i] = Conste_Q[i] * sqrt(10.0);
		if (Conste_Q[i] < 0)
		{
			if (Conste_Q[i] < -2)
			{
				BitData[i*4+2] = BIT[2][0];
				BitData[i*4+3] = BIT[2][1];
			}
			else // -2��0
			{
				BitData[i*4+2] = BIT[3][0];
				BitData[i*4+3] = BIT[3][1];
			}
		}
		else
		{
			if (Conste_Q[i] < 2)// 0��2
			{
				BitData[i*4+2] = BIT[1][0];
				BitData[i*4+3] = BIT[1][1];
			}
			else // ����2
			{
				BitData[i*4+2] = BIT[0][0];
				BitData[i*4+3] = BIT[0][1];
			}
		}
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