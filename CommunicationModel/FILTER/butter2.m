clear;
fN=8000;%采样率
fp=2100;
fs=2500;
rp=3;
rs=25;

ws=fs/(fN/2);
wp=fp/(fN/2);

[n,wn]=buttord(wp,ws,rp,rs);
[b,a]=butter(n,wn);

figure(1);
freqz(b,a,1000,8000);%频率点数1000，采样速率fN=8000
subplot(2,1,1);
axis([0 4000 -30 3]);

f=0:40:4000;
z=exp(1j*2*pi*f./(fN));
Hz=polyval(b,z)./polyval(a,z);

figure(2);
subplot(2,1,1);plot(f,20*log10(abs(Hz)));
axis([0 4000 -30 3]);
grid on;

subplot(2,1,2);plot(f,angle(Hz));