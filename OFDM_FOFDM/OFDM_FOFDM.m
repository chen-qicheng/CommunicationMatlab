
s = rng(211);       % ����RNG״̬��ȷ�����ظ���

%ϵͳ����
numFFT = 1024;           % FFT����
numRBs = 50;             % ��Դ����
rbSize = 12;             % ÿ����Դ������ز���
cpLen = 72;              % �����е�ѭ��ǰ׺����
bitsPerSubCarrier = 6;   % 2: QPSK, 4: 16QAM, 6: 64QAM, 8: 256QAM
snrdB = 18;              % SNR in dB
toneOffset = 2.5;        % ����ƫ�ƻ������������ز��У�
L = 513;                 % ���������ȣ�= filterOrder + 1��������

%�˲����OFDM�˲������
numDataCarriers = numRBs*rbSize;    % �Ӵ����������ز�������
halfFilt = floor(L/2);
n = -halfFilt:halfFilt;  

pb = sinc((numDataCarriers+2*toneOffset).*n./numFFT);   % Sinc����ԭ�͹�����
w = (0.5*(1+cos(2*pi.*n/(L-1)))).^0.6;                  % ���ҽضϴ���
fnum = (pb.*w)/sum(pb.*w);                              % ��һ����ͨ�˲���ϵ��

% ����������Ӧ
h = fvtool(fnum, 'Analysis', 'impulse','NormalizedFrequency', 'off', 'Fs', 15.36e6);
h.CurrentAxes.XLabel.String = 'Time (\mus)';
h.FigureToolbar = 'off';

% ʹ��dsp������������й���
filtTx = dsp.FIRFilter('Structure', 'Direct form symmetric','Numerator', fnum);
filtRx = clone(filtTx); % ����ƥ����˲���

% QAM����ӳ����
qamMapper = comm.RectangularQAMModulator( ...
    'ModulationOrder', 2^bitsPerSubCarrier, 'BitInput', true, ...
    'NormalizationMethod', 'Average power');

% ����F-OFDMƵ��ͼ
hFig = figure('Position', figposition([46 50 30 30]), 'MenuBar', 'none');
axis([-0.5 0.5 -200 -20]);
hold on; 
grid on
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')
title(['F-OFDM, ' num2str(numRBs) ' Resource blocks, ' num2str(rbSize) ' Subcarriers each'])

% �������ݷ���
bitsIn = randi([0 1], bitsPerSubCarrier*numDataCarriers, 1);
symbolsIn = qamMapper(bitsIn);

% �����ݴ����OFDM����
offset = (numFFT-numDataCarriers)/2; % for band center
symbolsInOFDM = [zeros(offset,1); symbolsIn; ...
                 zeros(numFFT-offset-numDataCarriers,1)];
ifftOut = ifft(ifftshift(symbolsInOFDM));

txSigOFDM = [ifftOut(end-cpLen+1:end); ifftOut];    % ǰ��ѭ��ǰ׺
txSigFOFDM = filtTx([txSigOFDM; zeros(L-1,1)]);     % ������������䣬��ȡ�����ź�

[psd,f] = periodogram(txSigFOFDM, rectwin(length(txSigFOFDM)),numFFT*2, 1, 'centered');
plot(f,10*log10(psd));                              % ���ƹ������ܶȣ�PSD��

% ���������ʱȣ�PAPR��
PAPR = comm.CCDF('PAPROutputPort', true, 'PowerUnits', 'dBW');
[~,~,paprFOFDM] = PAPR(txSigFOFDM);
disp(['Peak-to-Average-Power-Ratio for F-OFDM = ' num2str(paprFOFDM) ' dB']);

% OFDM�źŵĹ������ܶ�ͼ��PSD��
[psd,f] = periodogram(txSigOFDM, rectwin(length(txSigOFDM)), numFFT*2,1, 'centered'); 
hFig1 = figure('Position', figposition([46 15 30 30])); 
plot(f,10*log10(psd)); 
grid on
axis([-0.5 0.5 -100 -20]);
xlabel('Normalized frequency'); 
ylabel('PSD (dBW/Hz)')
title(['OFDM, ' num2str(numRBs*rbSize) ' Subcarriers'])

% ���������ʱȣ�PAPR��
PAPR2 = comm.CCDF('PAPROutputPort', true, 'PowerUnits', 'dBW');
[~,~,paprOFDM] = PAPR2(txSigOFDM);
disp(['Peak-to-Average-Power-Ratio for OFDM = ' num2str(paprOFDM) ' dB']);

rxSig = awgn(txSigFOFDM, snrdB, 'measured');    % Add WGN
rxSigFilt = filtRx(rxSig);                      % ����ƥ��Ĺ�����
rxSigFiltSync = rxSigFilt(L:end);               % ���ǹ������ӳ�
rxSymbol = rxSigFiltSync(cpLen+1:end);          % ɾ��ѭ��ǰ׺
RxSymbols = fftshift(fft(rxSymbol));            % ִ��FFT
dataRxSymbols = RxSymbols(offset+(1:numDataCarriers));% ѡ�����ݸ��ز�

% ���ƽ��շ�������ͼ
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
    'Title', 'F-OFDM�������', ...
    'Name', 'F-OFDM Reception', ...
    'XLimits', [-1.5 1.5], 'YLimits', [-1.5 1.5]);
constDiagRx(dataRxSymbols);

% ȥӳ���BER����
qamDemod = comm.RectangularQAMDemodulator('ModulationOrder', ...
    2^bitsPerSubCarrier, 'BitOutput', true, ...
    'NormalizationMethod', 'Average power');
BER = comm.ErrorRate;

% ִ��Ӳ���ľ�������������
rxBits = qamDemod(dataRxSymbols);
ber = BER(bitsIn, rxBits);

disp(['F-OFDM Reception, BER = ' num2str(ber(1)) ' at SNR = ' num2str(snrdB) ' dB']);
rng(s);% Restore RNG state

