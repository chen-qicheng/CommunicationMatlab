clear
close all
BitCnt = 4e7; % 仿真的比特数
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

% 穷举法解调
tic;
rxBit2 = demodqam16exhaust(rxSig, 'Normalized');
tElapsed2 = toc;
disp(['穷举法MATLAB耗时：', num2str(tElapsed2), '秒。']);

% 优化算法（二）解调
tic;
rxBit3 = demodqam16opt2(rxSig, 'Normalized');
tElapsed3 = toc;
disp(['优化算法（二）MATLAB耗时：', num2str(tElapsed3), '秒。']);

% 优化算法（二）解调
tic;
rxBit4 = demodqam16exhaust_mex(rxSig, 'Normalized');
tElapsed4 = toc;
disp(['穷举法C编程耗时：', num2str(tElapsed4), '秒。']);

% 优化算法（二）解调
tic;
rxBit5 = demodqam16opt2_mex(rxSig, 'Normalized');
tElapsed5 = toc;
disp(['优化算法（二）C编程耗耗时：', num2str(tElapsed5), '秒。']);

disp(['穷举法：C语言耗时是MATLAB的',num2str(tElapsed4 /tElapsed2 * 100), '%']);
disp(['优化算法（二）：C语言耗时是MATLAB的',num2str(tElapsed5 /tElapsed3 * 100), '%']);

% 计算误比特率
BER1 = biterr(txBit, rxBit1) / BitCnt;
BER2 = biterr(txBit, rxBit2) / BitCnt;
BER3 = biterr(txBit, rxBit3) / BitCnt;
BER4 = biterr(txBit, rxBit4) / BitCnt;
BER5 = biterr(txBit, rxBit5) / BitCnt;