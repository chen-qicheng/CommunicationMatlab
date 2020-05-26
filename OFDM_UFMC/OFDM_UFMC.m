% UFMC vs. OFDM Modulation

s = rng(211);       % Set RNG state for repeatability

% 系统参数
% 定义示例的系统参数,可以修改这些参数以探索它们对系统的影响。

numFFT = 512;        % number of FFT points
subbandSize = 20;    % must be > 1 
numSubbands = 10;    % numSubbands*subbandSize <= numFFT     
subbandOffset = 156; % numFFT/2-subbandSize*numSubbands/2 for band center

%切比雪夫窗口设计参数
filterLen = 43;      % 类似于循环前缀长度
slobeAtten = 40;     % 旁瓣衰减，dB

bitsPerSubCarrier = 4;   % 2: 4QAM, 4: 16QAM, 6: 64QAM, 8: 256QAM
snrdB = 15;              % 信噪比（dB）

% 具有指定衰减的设计窗口
prototypeFilter = chebwin(filterLen, slobeAtten);

% QAM符号映射器
qamMapper = comm.RectangularQAMModulator('ModulationOrder', ...
    2^bitsPerSubCarrier, 'BitInput', true, ...
    'NormalizationMethod', 'Average power');

% 发送端处理
%  初始化数组
inpData = zeros(bitsPerSubCarrier*subbandSize, numSubbands);
txSig = complex(zeros(numFFT+filterLen-1, 1));

hFig = figure;
axis([-0.5 0.5 -100 20]);
hold on; 
grid on

xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')
title(['UFMC, ' num2str(numSubbands) ' Subbands, '  ...
    num2str(subbandSize) ' Subcarriers each'])

%  遍历每个子带
for bandIdx = 1:numSubbands

    bitsIn = randi([0 1], bitsPerSubCarrier*subbandSize, 1);
    symbolsIn = qamMapper(bitsIn);
    inpData(:,bandIdx) = bitsIn; % log bits for comparison
    
    % 将子带数据打包为OFDM符号
    offset = subbandOffset+(bandIdx-1)*subbandSize; 
    symbolsInOFDM = [zeros(offset,1); symbolsIn; ...
                     zeros(numFFT-offset-subbandSize, 1)];
    ifftOut = ifft(ifftshift(symbolsInOFDM));
    
    % 每个子带的滤波器频率偏移
    bandFilter = prototypeFilter.*exp( 1i*2*pi*(0:filterLen-1)'/numFFT* ...
                 ((bandIdx-1/2)*subbandSize+0.5+subbandOffset+numFFT/2) );    
    filterOut = conv(bandFilter,ifftOut);
    
    % 每个子带的功率谱密度（PSD）图
    [psd,f] = periodogram(filterOut, rectwin(length(filterOut)), ...
                          numFFT*2, 1, 'centered'); 
    plot(f,10*log10(psd)); 
    
    % 对滤波后的子带响应求和以形成合计发射
    % signal
    txSig = txSig + filterOut;     
end
set(hFig, 'Position', figposition([20 50 25 30]));
hold off;

% 计算峰均功率比（PAPR）
PAPR = comm.CCDF('PAPROutputPort', true, 'PowerUnits', 'dBW');
[~,~,paprUFMC] = PAPR(txSig);
disp(['Peak-to-Average-Power-Ratio (PAPR) for UFMC = ' num2str(paprUFMC) ' dB']);

symbolsIn = qamMapper(inpData(:));

% 一起处理所有子带
offset = subbandOffset; 
symbolsInOFDM = [zeros(offset, 1); symbolsIn; ...
                 zeros(numFFT-offset-subbandSize*numSubbands, 1)];
ifftOut = sqrt(numFFT).*ifft(ifftshift(symbolsInOFDM));

% 在所有子载波上绘制功率谱密度（PSD）
[psd,f] = periodogram(ifftOut, rectwin(length(ifftOut)), numFFT*2, ...
                      1, 'centered'); 
hFig1 = figure; 
plot(f,10*log10(psd)); 
grid on
axis([-0.5 0.5 -100 20]);
xlabel('Normalized frequency'); 
ylabel('PSD (dBW/Hz)')
title(['OFDM, ' num2str(numSubbands*subbandSize) ' Subcarriers'])
set(hFig1, 'Position', figposition([46 50 25 30]));

% 计算峰均功率比（PAPR）
PAPR2 = comm.CCDF('PAPROutputPort', true, 'PowerUnits', 'dBW');
[~,~,paprOFDM] = PAPR2(ifftOut);
disp(['Peak-to-Average-Power-Ratio (PAPR) for OFDM = ' num2str(paprOFDM) ' dB']);

% Add WGN
rxSig = awgn(txSig, snrdB, 'measured');

%
% The receive-end processing is shown in the following diagram.
%
% <<UFMCReceiveDiagram.png>>

% Pad接收向量为FFT长度的两倍（请注意使用txSig作为输入）
%   没有开窗或采用其他过滤
yRxPadded = [rxSig; zeros(2*numFFT-numel(txSig),1)];

% Perform FFT and downsample by 2
RxSymbols2x = fftshift(fft(yRxPadded));
RxSymbols = RxSymbols2x(1:2:end);

% 执行FFT和2下采样
dataRxSymbols = RxSymbols(subbandOffset+(1:numSubbands*subbandSize));

% 绘制接收符号星座图
constDiagRx = comm.ConstellationDiagram('ShowReferenceConstellation', ...
    false, 'Position', figposition([20 15 25 30]), ...
    'Title', 'UFMC Pre-Equalization Symbols', ...
    'Name', 'UFMC Reception', ...
    'XLimits', [-150 150], 'YLimits', [-150 150]);
constDiagRx(dataRxSymbols);

% OFDM解调后使用迫零均衡器
rxf = [prototypeFilter.*exp(1i*2*pi*0.5*(0:filterLen-1)'/numFFT); ...
       zeros(numFFT-filterLen,1)];
prototypeFilterFreq = fftshift(fft(rxf));
prototypeFilterInv = 1./prototypeFilterFreq(numFFT/2-subbandSize/2+(1:subbandSize));

% 均衡每个子带-消除滤波器失真
dataRxSymbolsMat = reshape(dataRxSymbols,subbandSize,numSubbands);
EqualizedRxSymbolsMat = bsxfun(@times,dataRxSymbolsMat,prototypeFilterInv);
EqualizedRxSymbols = EqualizedRxSymbolsMat(:);

% 绘制均衡符号星座图
constDiagEq = comm.ConstellationDiagram('ShowReferenceConstellation', ...
    false, 'Position', figposition([46 15 25 30]), ...
    'Title', 'UFMC Equalized Symbols', ...
    'Name', 'UFMC Equalization');
constDiagEq(EqualizedRxSymbols);

% 去映射和BER计算
qamDemod = comm.RectangularQAMDemodulator('ModulationOrder', ...
    2^bitsPerSubCarrier, 'BitOutput', true, ...
    'NormalizationMethod', 'Average power');
BER = comm.ErrorRate;

% Perform hard decision and measure errors
rxBits = qamDemod(EqualizedRxSymbols);
ber = BER(inpData(:), rxBits);

disp(['UFMC Reception, BER = ' num2str(ber(1)) ' at SNR = ' ...
    num2str(snrdB) ' dB']);

% 恢复RNG状态
rng(s);

displayEndOfDemoMessage(mfilename)