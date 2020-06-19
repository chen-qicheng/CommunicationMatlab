clear;
fN=8000;
fp=1000;fs=700;rp=5;rs=30;
ws=fs/(fN/2);
wp=fp/(fN/2);

[n,wn]=cheb1ord(wp,ws,rp,rs);
[b,a]=cheby1(n,rp,wn,'high');%¸ßÍ¨ÂË²¨Æ÷

freqz(b,a,1000,fN);
subplot(2,1,1);
axis([0 4000 -40 3]);
