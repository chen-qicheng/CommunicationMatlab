clear
close all
BitCnt = 1e6; % 仿真的比特数
M = 16; % 16-QAM调制
if BitCnt / log2(M) ~= round(BitCnt / log2(M))
    error('比特数不符合要求');
end
rng(100 * sum(clock));
fprintf('仿真的比特数为：%g。\n', BitCnt);

SNR = 15; % 信噪比
% 生成星座映射的object
ModObject = modem.qammod('M', M, 'SymbolOrder', 'Gray', 'InputType', 'Bit');
DemodObject = modem.qamdemod(ModObject);

txBit = randi([0 1], BitCnt, 1);
txSig = modulate(ModObject, txBit) / sqrt(10);
rxSig = awgn(txSig, SNR, 'measured');

% MATLAB built-in 函数解调
tic;
rxBit1 = demodulate(DemodObject, rxSig * sqrt(10));
tElapsed1 = toc;
disp(['系统自带的解调函数耗时：', num2str(tElapsed1), '秒。']);

% 串行读取星座点
tic;
rxBit2 = demodqam16exhaust_serial(rxSig, 'Normalized');
tElapsed2 = toc;
disp(['串行读取星座点耗时：', num2str(tElapsed2), '秒。']);

% 并行读取星座点
tic;
rxBit3 = demodqam16exhaust_parfor(rxSig, 'Normalized');
tElapsed3 = toc;
disp(['并行读取星座点耗时：', num2str(tElapsed3), '秒。']);

% 计算误比特率
BER1 = biterr(txBit, rxBit1) / BitCnt;
BER2 = biterr(txBit, rxBit2) / BitCnt;
BER3 = biterr(txBit, rxBit3) / BitCnt;
