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
		// 判断实部
		if (Conste_I[i] < 0)
		{
			if (Conste_I[i] < -2)
			{
				BitData[i*4]   = BIT[0][0];
				BitData[i*4+1] = BIT[0][1];
			}
			else // -2到0
			{
				BitData[i*4]   = BIT[1][0];
				BitData[i*4+1] = BIT[1][1];
			}
		}
		else
		{
			if (Conste_I[i] < 2) // 0到2
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
		// 判断虚部
		Conste_Q[i] = Conste_Q[i] * sqrt(10.0);
		if (Conste_Q[i] < 0)
		{
			if (Conste_Q[i] < -2)
			{
				BitData[i*4+2] = BIT[2][0];
				BitData[i*4+3] = BIT[2][1];
			}
			else // -2到0
			{
				BitData[i*4+2] = BIT[3][0];
				BitData[i*4+3] = BIT[3][1];
			}
		}
		else
		{
			if (Conste_Q[i] < 2)// 0到2
			{
				BitData[i*4+2] = BIT[1][0];
				BitData[i*4+3] = BIT[1][1];
			}
			else // 大于2
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

  
    // 获取第一个输入变量的实部和虚部的头指针
    inMatrix_I = mxGetPr(prhs[0]);
	inMatrix_Q = mxGetPi(prhs[0]);

    // 获取第一个输入变量的长度
	Len = mxGetM(prhs[0]);

    // 创建输出矩阵
	plhs[0] = mxCreateDoubleMatrix((mwSize)Len * 4, 1, mxREAL);

    // 获取第一个输出变量的头指针
    outMatrix = mxGetPr(plhs[0]);

    // 调用解调函数demod
	demod(inMatrix_I,inMatrix_Q,(int)Len,outMatrix);
}