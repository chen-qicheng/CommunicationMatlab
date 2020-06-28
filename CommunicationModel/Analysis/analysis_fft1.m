
t = -1: 0.01: 10;
f_t = exp(-t).*(t>0);

subplot(3,1,1);plot(t,f_t);
axis([-1 10 -0.1 1.1]);
xlabel('time');

w=-40:0.1:40;
F_w=1./(1+1j*w);

subplot(3,1,2);plot(w,abs(F_w));
axis([-40 40 -0.1 1.1]);xlabel('freq');

subplot(3,1,3);plot(w,angle(F_w));
axis([-40 40 -pi/2 pi/2]);xlabel('freq');
