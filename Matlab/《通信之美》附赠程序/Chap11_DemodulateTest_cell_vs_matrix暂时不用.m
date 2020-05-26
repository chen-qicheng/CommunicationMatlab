clear
close all
BitCnt = 4e5;
M = 16;
if BitCnt / log2(M) ~= round(BitCnt / log2(M))
    error('������������Ҫ��');
end
rng(100 * sum(clock));
fprintf('����ı�����Ϊ��%g��\n', BitCnt);

SNR = 15;
ModObject = modem.qammod('M', M, 'SymbolOrder', 'Gray', 'InputType', 'Bit'); % ����ӳ��object
DemodObject = modem.qamdemod(ModObject);

txBit = randi([0 1], BitCnt, 1);
txSig = modulate(ModObject, txBit) / sqrt(10);

% ����������һ
% Tx_Power=mean(abs(txSig).^2);
% NoisePower = Tx_Power / (10 ^ (SNR/10));
% NoisePower = Tx_Power - SNR;
% Noise = wgn(BitCnt/4, 1, NoisePower, 'complex');
% rxSig = txSig + Noise;

% ������������
% NoiseStandardDeviation = sqrt(10 ^ (NoisePower/10));
% Noise = 1/sqrt(2) * NoiseStandardDeviation * (randn(BitCnt/4, 1) + 1j * randn(BitCnt/4, 1));
% rxSig = txSig + Noise;

% ������������
rxSig = awgn(txSig, SNR, 'measured');

tic;
rxBit1 = demodulate(DemodObject, rxSig * sqrt(10));
tElapsed1 = toc;
disp(['ϵͳ�Դ��Ľ��������ʱ��', num2str(tElapsed1), '�롣']);

tic;
rxBit2 = demodqam16opt1_cell(rxSig, 'Normalized');
tElapsed2 = toc;
disp(['��ٷ���ʱ��', num2str(tElapsed2), '�롣']);

% tic;
% rxBit3 = demodqam16opt1(rxSig, 'Normalized');
% temp = qfunc(2*sqrt(10^(SNR/10)/5)) + qfunc(4*sqrt(10^(SNR/10)/5)) + qfunc(6*sqrt(10^(SNR/10)/5));
% MeanMultiCntOpt1Theory = -1/2 * temp^2 - 3/2 * temp + 27/8;
% MeanAddCntOpt1Theory = -1/2 * temp^2 - 7/2 * temp + 51/8;
% MeanCompareCntOpt1Theory = 1/4 * temp^2 - 7/4 * temp + 1/2 * qfunc(4*sqrt(10^(SNR/10)/5)) + 109/16;
% tElapsed3 = toc;
% disp(['�Ż��㷨��һ����ʱ', num2str(tElapsed3), '�롣']);

tic;
rxBit4 = demodqam16opt2(rxSig, 'Normalized');
MeanCompareCntOpt2Theory = 4;
tElapsed4 = toc;
disp(['�Ż��㷨��������ʱ��', num2str(tElapsed4), '�롣']);

BER1 = biterr(txBit, rxBit1) / BitCnt;
BER2 = biterr(txBit, rxBit2) / BitCnt;
% BER3 = biterr(txBit, rxBit3) / BitCnt;
BER4 = biterr(txBit, rxBit4) / BitCnt;
