function xdot = rcstateequation(t,x,flag,par)
R=par(1);
C=par(2);
xdot=(-1./(R*C).*x+(1/(R*C))).*f(t);%״̬����

function inputsignal =f(t)
inputsignal=(t>=0);%��λ��Ծ����
 