kc = 150e3;
omega_n = 2*pi*15e3/2.5;
K = 2*pi*(0.5*kc);
zeta = 1;
tau_1 = K/((omega_n).^2);
tau_2 = 2*zeta/omega_n-1/K;
freq = 0:10:100e3;

s = 1j*2*pi*freq;openExample('comm/Examine256QAMUsingSimulinkExample')
G_s=(1+tau_2*s)./(1+tau_1*s);

figure(1);semilogx(freq,(abs(G_s)));
title('环路滤波器幅频响应');
xlabel('Hz');ylabel('|G(s)|');
grid on;

b=[tau_2,1];
a=[tau_1,1];
H_s=(G_s*K./s)./(1+G_s*K./s);

figure(2);semilogx(freq,20*log10(abs(H_s)));
title('PLL线性相位模式闭环频率响应');
xlabel('Hz');ylabel('20logH(s)|(dB)');
grid on;