
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
%
% F-OFDM的适当过滤满足以下条件：
%
% * 在子带中的子载波上应具有平坦的通带
% * 应该有一个陡峭的过渡带以最小化保护带
% * 应具有足够的阻带衰减
%
% 具有矩形频率响应即正弦脉冲响应的滤波器满足这些标准。
% 为此，使用窗口来实现低通滤波器，该窗口可以有效地截断脉冲响应，
% 并在两端提供平滑的过渡到零[<＃11 3>]。

numDataCarriers = numRBs*rbSize;    % 子带中数据子载波的数量
halfFilt = floor(L/2);
n = -halfFilt:halfFilt;  

pb = sinc((numDataCarriers+2*toneOffset).*n./numFFT);% Sinc函数原型过滤器

w = (0.5*(1+cos(2*pi.*n/(L-1)))).^0.6;% 正弦截断窗口

fnum = (pb.*w)/sum(pb.*w);% 归一化低通滤波器系数

% 过滤脉冲响应
h = fvtool(fnum, 'Analysis', 'impulse', ...
    'NormalizedFrequency', 'off', 'Fs', 15.36e6);
h.CurrentAxes.XLabel.String = 'Time (\mus)';
h.FigureToolbar = 'off';

% 使用dsp过滤器对象进行过滤
filtTx = dsp.FIRFilter('Structure', 'Direct form symmetric', ...
    'Numerator', fnum);
filtRx = clone(filtTx); % 接收匹配的滤波器

% QAM符号映射器
qamMapper = comm.RectangularQAMModulator( ...
    'ModulationOrder', 2^bitsPerSubCarrier, 'BitInput', true, ...
    'NormalizationMethod', 'Average power');

% F-OFDM发送处理
%
% 在F-OFDM中，子带CP-OFDM信号通过设计的滤波器。
% 由于滤波器的通带与信号的带宽相对应，因此仅影响边缘附近的几个子载波。 
% 关键考虑因素是，可以允许滤波器长度超过F-OFDM [<＃11 1>]的循环前缀长度。 
% 由于使用了开窗（软截断）功能的滤波器设计，可最大程度地减少符号间干扰。
%
% 下面的F-OFDM发送器图中显示了发送端处理操作。
%
% <<FOFDMTransmitDiagram.png>>

% 设置频谱图图
hFig = figure('Position', figposition([46 50 30 30]), 'MenuBar', 'none');
axis([-0.5 0.5 -200 -20]);
hold on; 
grid on
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')
title(['F-OFDM, ' num2str(numRBs) ' Resource blocks, '  ...
    num2str(rbSize) ' Subcarriers each'])

% 产生数据符号
bitsIn = randi([0 1], bitsPerSubCarrier*numDataCarriers, 1);
symbolsIn = qamMapper(bitsIn);

% 将数据打包成OFDM符号
offset = (numFFT-numDataCarriers)/2; % for band center
symbolsInOFDM = [zeros(offset,1); symbolsIn; ...
                 zeros(numFFT-offset-numDataCarriers,1)];
ifftOut = ifft(ifftshift(symbolsInOFDM));

% 前置循环前缀
txSigOFDM = [ifftOut(end-cpLen+1:end); ifftOut]; 

% 过滤器，零填充以冲洗尾巴。 获取发射信号
txSigFOFDM = filtTx([txSigOFDM; zeros(L-1,1)]);

% 绘制功率谱密度（PSD）
[psd,f] = periodogram(txSigFOFDM, rectwin(length(txSigFOFDM)), ...
                      numFFT*2, 1, 'centered'); 
plot(f,10*log10(psd)); 

% 计算峰均功率比（PAPR）
PAPR = comm.CCDF('PAPROutputPort', true, 'PowerUnits', 'dBW');
[~,~,paprFOFDM] = PAPR(txSigFOFDM);
disp(['Peak-to-Average-Power-Ratio for F-OFDM = ' num2str(paprFOFDM) ' dB']);

%具有相应参数的OFDM调制
%
% 为了进行比较，我们回顾了现有的OFDM调制技术，该技术使用了完整的占用带宽，具有相同长度的循环前缀。

% OFDM信号的功率谱密度（PSD）图
[psd,f] = periodogram(txSigOFDM, rectwin(length(txSigOFDM)), numFFT*2, ...
                      1, 'centered'); 
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

%
% 比较CP-OFDM和F-OFDM方案的频谱密度图，F-OFDM具有较低的旁瓣。这样可以提高分配频谱的利用率，从而提高频谱效率。
%
% 请参考<matlab：doc（'comm.OFDMModulator'）comm.OFDMModulator>系统对象，该对象也可用于实现CP-OFDM调制。

%无通道F-OFDM接收器
%
% 接下来的示例重点介绍了单个OFDM符号的F-OFDM的基本接收处理。 接收到的信号通过匹配的滤波器，然后是普通的CP-OFDM接收器。 它考虑了FFT操作之前的滤波上升和延迟。
%
% 在此示例中不考虑衰落信道，但是将噪声添加到接收信号中以实现所需的SNR。

% Add WGN
rxSig = awgn(txSigFOFDM, snrdB, 'measured');

%
% 接收处理操作如下F-OFDM接收器图中所示。
%
% <<FOFDMReceiveDiagram.png>>

% 接收匹配的过滤器
rxSigFilt = filtRx(rxSig);

% 考虑过滤器延迟
rxSigFiltSync = rxSigFilt(L:end);

% 删除循环前缀
rxSymbol = rxSigFiltSync(cpLen+1:end);

% 执行FFT
RxSymbols = fftshift(fft(rxSymbol));

% 选择数据副载波
dataRxSymbols = RxSymbols(offset+(1:numDataCarriers));

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
    'Title', 'F-OFDM Demodulated Symbols', ...
    'Name', 'F-OFDM Reception', ...
    'XLimits', [-1.5 1.5], 'YLimits', [-1.5 1.5]);
constDiagRx(dataRxSymbols);

% 此处不需要通道均衡，因为没有通道建模

% 去映射和BER计算
qamDemod = comm.RectangularQAMDemodulator('ModulationOrder', ...
    2^bitsPerSubCarrier, 'BitOutput', true, ...
    'NormalizationMethod', 'Average power');
BER = comm.ErrorRate;

% 执行艰难的决定并衡量错误
rxBits = qamDemod(dataRxSymbols);
ber = BER(bitsIn, rxBits);

disp(['F-OFDM Reception, BER = ' num2str(ber(1)) ' at SNR = ' ...
    num2str(snrdB) ' dB']);

% Restore RNG state
rng(s);

%
% 如突出显示的那样，F-OFDM在发送和接收端都为现有的CP-OFDM处理添加了一个过滤级。 该示例为用户的全频带分配建模，但是相同的方法可以应用于上行链路异步操作的多个频带（每个用户一个）。
%
% 请参考<matlab：doc（'comm.OFDMDemodulator'）comm.OFDMDemodulator>系统对象，该对象可用于在接收匹配的滤波后实现CP-OFDM解调。

%结论与进一步探索
%
% 该示例介绍了通信系统的发送和接收端的F-OFDM调制方案的基本特征。 探索不同的系统参数值，以了解资源块的数量，每个块的子载波的数量，滤波器长度，音调偏移和SNR。
%
% 通用滤波多载波（UFMC）调制方案是子带滤波OFDM的另一种方法。有关更多信息，请参见<OFDMvsUFMCExample.html UFMC vs. OFDM Modulation>示例。该F-OFDM示例使用单个子带，而UFMC示例使用多个子带。
%
% F-OFDM和UFMC都使用时域滤波，但滤波器的设计和应用方式存在细微差别。对于UFMC，滤波器的长度被限制为等于循环前缀长度，而对于F-OFDM，它的长度可以超过CP的长度。
%
% 对于F-OFDM，滤波器设计导致正交性略有下降（严格来说），这仅影响边缘子载波。
%
% Refer to the 
% <matlab:web(['http://www.mathworks.com/matlabcentral/fileexchange/61585-5g-library-for-lte-system-toolbox'],'-browser')
% LTE系统工具箱（TM）的5G库>示例，说明如何将F-OFDM应用到LTE下行链路（PDSCH）信道。

displayEndOfDemoMessage(mfilename)