
s = rng(211);       % 设置RNG状态以确保可重复性

%系统参数
numFFT = 1024;           % FFT点数
numRBs = 50;             % 资源块数
rbSize = 12;             % 每个资源块的子载波数
cpLen = 72;              % 样本中的循环前缀长度
bitsPerSubCarrier = 6;   % 2: QPSK, 4: 16QAM, 6: 64QAM, 8: 256QAM
snrdB = 18;              % SNR in dB
toneOffset = 2.5;        % 音调偏移或多余带宽（在子载波中）
L = 513;                 % 过滤器长度（= filterOrder + 1），奇数

%滤波后的OFDM滤波器设计
numDataCarriers = numRBs*rbSize;    % 子带中数据子载波的数量
halfFilt = floor(L/2);
n = -halfFilt:halfFilt;  

pb = sinc((numDataCarriers+2*toneOffset).*n./numFFT);   % Sinc函数原型过滤器
w = (0.5*(1+cos(2*pi.*n/(L-1)))).^0.6;                  % 正弦截断窗口
fnum = (pb.*w)/sum(pb.*w);                              % 归一化低通滤波器系数

% 过滤脉冲响应
h = fvtool(fnum, 'Analysis', 'impulse','NormalizedFrequency', 'off', 'Fs', 15.36e6);
h.CurrentAxes.XLabel.String = 'Time (\mus)';
h.FigureToolbar = 'off';

% 使用dsp过滤器对象进行过滤
filtTx = dsp.FIRFilter('Structure', 'Direct form symmetric','Numerator', fnum);
filtRx = clone(filtTx); % 接收匹配的滤波器

% QAM符号映射器
qamMapper = comm.RectangularQAMModulator( ...
    'ModulationOrder', 2^bitsPerSubCarrier, 'BitInput', true, ...
    'NormalizationMethod', 'Average power');

% 设置F-OFDM频谱图
hFig = figure('Position', figposition([46 50 30 30]), 'MenuBar', 'none');
axis([-0.5 0.5 -200 -20]);
hold on; 
grid on
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')
title(['F-OFDM, ' num2str(numRBs) ' Resource blocks, ' num2str(rbSize) ' Subcarriers each'])

% 产生数据符号
bitsIn = randi([0 1], bitsPerSubCarrier*numDataCarriers, 1);
symbolsIn = qamMapper(bitsIn);

% 将数据打包成OFDM符号
offset = (numFFT-numDataCarriers)/2; % for band center
symbolsInOFDM = [zeros(offset,1); symbolsIn; ...
                 zeros(numFFT-offset-numDataCarriers,1)];
ifftOut = ifft(ifftshift(symbolsInOFDM));

txSigOFDM = [ifftOut(end-cpLen+1:end); ifftOut];    % 前置循环前缀
txSigFOFDM = filtTx([txSigOFDM; zeros(L-1,1)]);     % 过滤器，零填充，获取发射信号

[psd,f] = periodogram(txSigFOFDM, rectwin(length(txSigFOFDM)),numFFT*2, 1, 'centered');
plot(f,10*log10(psd));                              % 绘制功率谱密度（PSD）

% 计算峰均功率比（PAPR）
PAPR = comm.CCDF('PAPROutputPort', true, 'PowerUnits', 'dBW');
[~,~,paprFOFDM] = PAPR(txSigFOFDM);
disp(['Peak-to-Average-Power-Ratio for F-OFDM = ' num2str(paprFOFDM) ' dB']);

% OFDM信号的功率谱密度图（PSD）
[psd,f] = periodogram(txSigOFDM, rectwin(length(txSigOFDM)), numFFT*2,1, 'centered'); 
hFig1 = figure('Position', figposition([46 15 30 30])); 
plot(f,10*log10(psd)); 
grid on
axis([-0.5 0.5 -100 -20]);
xlabel('Normalized frequency'); 
ylabel('PSD (dBW/Hz)')
title(['OFDM, ' num2str(numRBs*rbSize) ' Subcarriers'])

% 计算峰均功率比（PAPR）
PAPR2 = comm.CCDF('PAPROutputPort', true, 'PowerUnits', 'dBW');
[~,~,paprOFDM] = PAPR2(txSigOFDM);
disp(['Peak-to-Average-Power-Ratio for OFDM = ' num2str(paprOFDM) ' dB']);

rxSig = awgn(txSigFOFDM, snrdB, 'measured');    % Add WGN
rxSigFilt = filtRx(rxSig);                      % 接收匹配的过滤器
rxSigFiltSync = rxSigFilt(L:end);               % 考虑过滤器延迟
rxSymbol = rxSigFiltSync(cpLen+1:end);          % 删除循环前缀
RxSymbols = fftshift(fft(rxSymbol));            % 执行FFT
dataRxSymbols = RxSymbols(offset+(1:numDataCarriers));% 选择数据副载波

% 绘制接收符号星座图
switch bitsPerSubCarrier
    case 2  % QPSK
        refConst = qammod((0:3).', 4, 'UnitAveragePower', true);
    case 4  % 16QAM
        refConst = qammod((0:15).', 16,'UnitAveragePower', true);
    case 6  % 64QAM
        refConst = qammod((0:63).', 64,'UnitAveragePower', true);
    case 8  % 256QAM
        refConst = qammod((0:255).', 256,'UnitAveragePower', true);
end
constDiagRx = comm.ConstellationDiagram( ...
    'ShowReferenceConstellation', true, ...
    'ReferenceConstellation', refConst, ...
    'Position', figposition([20 15 30 40]), ...
    'EnableMeasurements', true, ...
    'MeasurementInterval', length(dataRxSymbols), ...
    'Title', 'F-OFDM解调符号', ...
    'Name', 'F-OFDM Reception', ...
    'XLimits', [-1.5 1.5], 'YLimits', [-1.5 1.5]);
constDiagRx(dataRxSymbols);

% 去映射和BER计算
qamDemod = comm.RectangularQAMDemodulator('ModulationOrder', ...
    2^bitsPerSubCarrier, 'BitOutput', true, ...
    'NormalizationMethod', 'Average power');
BER = comm.ErrorRate;

% 执行硬件的决定并衡量错误
rxBits = qamDemod(dataRxSymbols);
ber = BER(bitsIn, rxBits);

disp(['F-OFDM Reception, BER = ' num2str(ber(1)) ' at SNR = ' num2str(snrdB) ' dB']);
rng(s);% Restore RNG state

