clear;
%cheby2ÐÍ ´ø×èÂË²¨Æ÷
fN=10000;
fp=[800,1800];
fs=[1000,1200];
rp=3;
rs=20;

wp=fp/(fN/2);
ws=fs/(fN/2);

[n,wn]=cheb2ord(wp,ws,rp,rs);
[b,a]=cheby2(n,rs,wn,'stop');

figure(1);
freqz(b,a,1000,fN);
subplot(2,1,1);
axis([0 5000 -40 3]);