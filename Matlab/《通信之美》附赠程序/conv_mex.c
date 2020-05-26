#include <math.h>
#include <stdio.h>
#include "mex.h"

void conv(double x[], double h[], int Lx, int Lh, double y[])
{

	int n, k, Low, High;
	memset(y, 0, Lx + Lh - 1);
	for ( n = 0; n < Lx + Lh - 1; n ++ )
	{
		Low = max(0, n - Lh + 1);
		High = min(Lx - 1, n);
		for ( k = Low; k <= High; k ++ )
			y[n] = y[n] + x[k] * h[n - k];
	}
}



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    size_t Lx, Lh;
    double *x;
	double *h;
    double *outMatrix;

  
    // 获取第1个和第2个输入变量的头指针
    x = mxGetPr(prhs[0]);
	h = mxGetPr(prhs[1]);

    // 获取第1个和第2个输入变量的长度
	Lx = mxGetM(prhs[0]);
	Lh = mxGetM(prhs[1]);

    // 创建输出矩阵
	plhs[0] = mxCreateDoubleMatrix((mwSize)(Lx+Lh-1), 1, mxREAL);

    // 获取第1个输出变量的头指针
    outMatrix = mxGetPr(plhs[0]);

    // 调用卷积函数conv
	conv(x,h,(int)Lx,(int)Lh, outMatrix);
}