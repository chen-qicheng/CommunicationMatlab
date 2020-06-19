clear;
%´øÍ¨ÂË²¨Æ÷
fN=10000;
fp=[1000,1500];
fs=[600,1900];
rp=3;
rs=30;

wp=fp/(fN/2);
ws=fs/(fN/2);

[n,wn]=ellipord(wp,ws,rp,rs);
[b,a]=ellip(n,rp,rs,wn);

freqz(b,a,1000,fN);
subplot(2,1,1);
axis([0 5000 -40 3]);
