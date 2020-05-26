clear
close all
BitCnt = 4e7; % ����ı�����
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

% ��ٷ����
tic;
rxBit2 = demodqam16exhaust(rxSig, 'Normalized');
tElapsed2 = toc;
disp(['��ٷ�MATLAB��ʱ��', num2str(tElapsed2), '�롣']);

% �Ż��㷨���������
tic;
rxBit3 = demodqam16opt2(rxSig, 'Normalized');
tElapsed3 = toc;
disp(['�Ż��㷨������MATLAB��ʱ��', num2str(tElapsed3), '�롣']);

% �Ż��㷨���������
tic;
rxBit4 = demodqam16exhaust_mex(rxSig, 'Normalized');
tElapsed4 = toc;
disp(['��ٷ�C��̺�ʱ��', num2str(tElapsed4), '�롣']);

% �Ż��㷨���������
tic;
rxBit5 = demodqam16opt2_mex(rxSig, 'Normalized');
tElapsed5 = toc;
disp(['�Ż��㷨������C��̺ĺ�ʱ��', num2str(tElapsed5), '�롣']);

disp(['��ٷ���C���Ժ�ʱ��MATLAB��',num2str(tElapsed4 /tElapsed2 * 100), '%']);
disp(['�Ż��㷨��������C���Ժ�ʱ��MATLAB��',num2str(tElapsed5 /tElapsed3 * 100), '%']);

% �����������
BER1 = biterr(txBit, rxBit1) / BitCnt;
BER2 = biterr(txBit, rxBit2) / BitCnt;
BER3 = biterr(txBit, rxBit3) / BitCnt;
BER4 = biterr(txBit, rxBit4) / BitCnt;
BER5 = biterr(txBit, rxBit5) / BitCnt;