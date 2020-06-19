clear;
%参数
fp=2500;
fs=5000;
rp=3;
rs=25;
%
[n,fn]=ellipord(fp,fs,rp,rs,'s');%n=3,3阶滤波器，fn为3dB截止频率
wn=2*pi*fn;
[b,a]=ellip(n,rp,rs,wn,'s');

figure(1);
freqs(b,a);

f=0:100:10000;
s=1j*2*pi*f;
Hs=polyval(b,s)./polyval(a,s);

figure(2);
subplot(2,1,1);plot(f,20*log10(abs(Hs)));
subplot(2,1,2);plot(f,angle(Hs));


