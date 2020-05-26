clear
close all
BitCnt = 1e6;
M = 16;
if BitCnt / log2(M) ~= round(BitCnt / log2(M))
    error('比特数不符合要求');
end
rng(100 * sum(clock));
fprintf('仿真的比特数为：%g。\n', BitCnt);

SNR = 15;
% 生成星座映射的object
ModObject = modem.qammod('M', M, 'SymbolOrder', 'Gray', 'InputType', 'Bit');
DemodObject = modem.qamdemod(ModObject);

txBit = randi([0 1], BitCnt, 1);
txSig = modulate(ModObject, txBit) / sqrt(10);

rxSig = awgn(txSig, SNR, 'measured');

% 计算两种算法的仿真复杂度
[rxBit1, MeanMultiCntOpt1, MeanAddCntOpt1, MeanCompareCntOpt1] = ...
    demodqam16opt1calccomplexity(rxSig, 'Normalized');
[rxBit2, MeanCompareCntOpt2] = demodqam16opt2calccomplexity(rxSig, 'Normalized');
BER1 = biterr(txBit, rxBit1) / BitCnt;
BER2 = biterr(txBit, rxBit2) / BitCnt;

% 计算两种算法的理论复杂度
temp = qfunc(2*sqrt(10^(SNR/10)/5)) + ...
       qfunc(4*sqrt(10^(SNR/10)/5)) + ...
       qfunc(6*sqrt(10^(SNR/10)/5));
MeanMultiCntOpt1Theory   = -1/2 * temp^2 - 3/2 * temp + 27/8;
MeanAddCntOpt1Theory     = -1/2 * temp^2 - 7/2 * temp + 51/8;
MeanCompareCntOpt1Theory = 1/4 * temp^2 - 7/4 * temp + ...
                           1/2 * qfunc(4*sqrt(10^(SNR/10)/5)) + 109/16;
MeanCompareCntOpt2Theory = 4;

% 计算复杂度的仿真值和理论值的差异
MSEMultiCntOpt1   = (MeanMultiCntOpt1 - MeanMultiCntOpt1Theory) ^ 2 / ...
                     MeanMultiCntOpt1Theory;
MSEAddCntOpt1     = (MeanAddCntOpt1 - MeanAddCntOpt1Theory) ^ 2 / ...
                     MeanAddCntOpt1Theory;
MSECompareCntOpt1 = (MeanCompareCntOpt1 - MeanCompareCntOpt1Theory) ^ 2 / ...
                     MeanCompareCntOpt1Theory;
MSECompareCntOpt2 = (MeanCompareCntOpt2 - MeanCompareCntOpt2Theory) ^ 2 / ...
                     MeanCompareCntOpt2Theory;
