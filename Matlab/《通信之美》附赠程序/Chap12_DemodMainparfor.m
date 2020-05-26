clear
close all
BitCnt = 1e6; % ����ı�����
M = 16; % 16-QAM����
if BitCnt / log2(M) ~= round(BitCnt / log2(M))
    error('������������Ҫ��');
end
rng(100 * sum(clock));
fprintf('����ı�����Ϊ��%g��\n', BitCnt);

SNR = 15; % �����
% ��������ӳ���object
ModObject = modem.qammod('M', M, 'SymbolOrder', 'Gray', 'InputType', 'Bit');
DemodObject = modem.qamdemod(ModObject);

txBit = randi([0 1], BitCnt, 1);
txSig = modulate(ModObject, txBit) / sqrt(10);
rxSig = awgn(txSig, SNR, 'measured');

% MATLAB built-in �������
tic;
rxBit1 = demodulate(DemodObject, rxSig * sqrt(10));
tElapsed1 = toc;
disp(['ϵͳ�Դ��Ľ��������ʱ��', num2str(tElapsed1), '�롣']);

% ���ж�ȡ������
tic;
rxBit2 = demodqam16exhaust_serial(rxSig, 'Normalized');
tElapsed2 = toc;
disp(['���ж�ȡ�������ʱ��', num2str(tElapsed2), '�롣']);

% ���ж�ȡ������
tic;
rxBit3 = demodqam16exhaust_parfor(rxSig, 'Normalized');
tElapsed3 = toc;
disp(['���ж�ȡ�������ʱ��', num2str(tElapsed3), '�롣']);

% �����������
BER1 = biterr(txBit, rxBit1) / BitCnt;
BER2 = biterr(txBit, rxBit2) / BitCnt;
BER3 = biterr(txBit, rxBit3) / BitCnt;
