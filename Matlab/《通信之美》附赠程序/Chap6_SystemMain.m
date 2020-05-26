BitRate = 4e6;
M = 16;
l = log2(M);
R = 1/3;
SymbolRate = BitRate / l;
UpsampleTimes = 8;
SampleRate = SymbolRate * UpsampleTimes;
Fc = 2.5e6;
Fs = SampleRate;
SamplePerFrame = 4000;
SymbolPerFrame = SamplePerFrame / l;

load ShannonLimit_AWGN_R_1_3 % load AWGN下1/3码率的香农限
%%
SNRTable = 1 : 15;
BERNoChannelCoding = zeros(length(SNRTable), 1, 'double');
BERChannelCoding = zeros(length(SNRTable), 1, 'double');
for i = 1 : length(SNRTable)
    SNR = SNRTable(i);
    sim('Chap6_System'); % 调用Simulink模型
    BERNoChannelCoding(i) = ErrorVecNoChannelCoding(1);
    BERChannelCoding(i)   = ErrorVecChannelCoding(1);
end

%%
% 会造成误导的SNR曲线
figure;
semilogy(SNRTable, BERNoChannelCoding, 'bv-', ...
         SNRTable, BERChannelCoding, 'rs-');
grid on;
xlabel('S/N');
ylabel('Bit Error Rate');
legend('No Channel Coding', 'With Channel Coding');

% 更直观的EbN0曲线
EsN0 = SNRTable - 10 * log10(2) + 10 * log10(UpsampleTimes);
EbN0NoChannelCoding = EsN0 - 10 * log10(l);
EbN0ChannelCoding = EsN0 - 10 * log10(l*R);
ber = berawgn(EbN0NoChannelCoding, 'qam', M);
figure;
semilogy(ShannonLimit_AWGN_R_1_3, Pe, 'g*-', ...
         EbN0NoChannelCoding, ber, 'k^-', ...
         EbN0NoChannelCoding, BERNoChannelCoding, 'bv-', ...
         EbN0ChannelCoding, BERChannelCoding, 'rs-');
grid on;
xlabel('E_b/N_0');
ylabel('Bit Error Rate');
legend('AWGN Shannon limit', 'AWGN Theory BER', ...
       'No Channel Coding', 'With Channel Coding');