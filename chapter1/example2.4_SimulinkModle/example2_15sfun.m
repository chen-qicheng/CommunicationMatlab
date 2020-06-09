function [sys,x0,str,ts] = example2_15sfun(t,x,u,flag)

A=[0 1 0; 0 0 1; -4 -6 -3];
B=[0; 0; 1];
C=[0 4 0];
D=0;

switch flag,
  case 0
    [sys,x0,str,ts]=mdlInitializeSizes(A,B,C,D);
  case 1
    sys=mdlDerivatives(t,x,u,A,B,C,D);
  case 3
    sys=mdlOutputs(t,x,u,A,B,C,D);
  case { 2,4,9 }
    sys=[];
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end


function [sys,x0,str,ts]=mdlInitializeSizes(A,B,C,D);
sizes = simsizes;
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 1;

sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % at least one sample time is needed
sys = simsizes(sizes);
x0  = [];
str = [0;0;0];
ts  = [0 0];


function sys=mdlDerivatives(t,x,u)
sys = A*x+B*u;

function sys=mdlOutputs(t,x,u)
sys =C*x;
