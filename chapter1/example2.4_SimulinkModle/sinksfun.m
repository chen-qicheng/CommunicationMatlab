function [sys,x0,str,ts] = sinksfun(t,x,u,flag,Amp,Freq,Phase)

switch flag
  case 0
    [sys,x0,str,ts]=mdlInitializeSizes;
  case 1
    sys=[];
  case 2
    sys=[];
  case 3
    sys=mdlOutputs(t,x,u);
  case 4
    sys=[];
  case 9
    sys=[];
  otherwise
    error(['Unhandled Flag= ', num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 0;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];

function sys=mdlOutputs(t,Amp,Freq,Phase)
sys = Amp*sin(2*pi*Freq*t+Phase);



