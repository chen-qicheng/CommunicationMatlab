
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
%
% F-OFDM���ʵ�������������������
%
% * ���Ӵ��е����ز���Ӧ����ƽ̹��ͨ��
% * Ӧ����һ�����͵Ĺ��ɴ�����С��������
% * Ӧ�����㹻�����˥��
%
% ���о���Ƶ����Ӧ������������Ӧ���˲���������Щ��׼��
% Ϊ�ˣ�ʹ�ô�����ʵ�ֵ�ͨ�˲������ô��ڿ�����Ч�ؽض�������Ӧ��
% ���������ṩƽ���Ĺ��ɵ���[<��11 3>]��

numDataCarriers = numRBs*rbSize;    % �Ӵ����������ز�������
halfFilt = floor(L/2);
n = -halfFilt:halfFilt;  

pb = sinc((numDataCarriers+2*toneOffset).*n./numFFT);% Sinc����ԭ�͹�����

w = (0.5*(1+cos(2*pi.*n/(L-1)))).^0.6;% ���ҽضϴ���

fnum = (pb.*w)/sum(pb.*w);% ��һ����ͨ�˲���ϵ��

% ����������Ӧ
h = fvtool(fnum, 'Analysis', 'impulse', ...
    'NormalizedFrequency', 'off', 'Fs', 15.36e6);
h.CurrentAxes.XLabel.String = 'Time (\mus)';
h.FigureToolbar = 'off';

% ʹ��dsp������������й���
filtTx = dsp.FIRFilter('Structure', 'Direct form symmetric', ...
    'Numerator', fnum);
filtRx = clone(filtTx); % ����ƥ����˲���

% QAM����ӳ����
qamMapper = comm.RectangularQAMModulator( ...
    'ModulationOrder', 2^bitsPerSubCarrier, 'BitInput', true, ...
    'NormalizationMethod', 'Average power');

% F-OFDM���ʹ���
%
% ��F-OFDM�У��Ӵ�CP-OFDM�ź�ͨ����Ƶ��˲�����
% �����˲�����ͨ�����źŵĴ������Ӧ����˽�Ӱ���Ե�����ļ������ز��� 
% �ؼ����������ǣ����������˲������ȳ���F-OFDM [<��11 1>]��ѭ��ǰ׺���ȡ� 
% ����ʹ���˿�������ضϣ����ܵ��˲�����ƣ������̶ȵؼ��ٷ��ż���š�
%
% �����F-OFDM������ͼ����ʾ�˷��Ͷ˴��������
%
% <<FOFDMTransmitDiagram.png>>

% ����Ƶ��ͼͼ
hFig = figure('Position', figposition([46 50 30 30]), 'MenuBar', 'none');
axis([-0.5 0.5 -200 -20]);
hold on; 
grid on
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')
title(['F-OFDM, ' num2str(numRBs) ' Resource blocks, '  ...
    num2str(rbSize) ' Subcarriers each'])

% �������ݷ���
bitsIn = randi([0 1], bitsPerSubCarrier*numDataCarriers, 1);
symbolsIn = qamMapper(bitsIn);

% �����ݴ����OFDM����
offset = (numFFT-numDataCarriers)/2; % for band center
symbolsInOFDM = [zeros(offset,1); symbolsIn; ...
                 zeros(numFFT-offset-numDataCarriers,1)];
ifftOut = ifft(ifftshift(symbolsInOFDM));

% ǰ��ѭ��ǰ׺
txSigOFDM = [ifftOut(end-cpLen+1:end); ifftOut]; 

% ��������������Գ�ϴβ�͡� ��ȡ�����ź�
txSigFOFDM = filtTx([txSigOFDM; zeros(L-1,1)]);

% ���ƹ������ܶȣ�PSD��
[psd,f] = periodogram(txSigFOFDM, rectwin(length(txSigFOFDM)), ...
                      numFFT*2, 1, 'centered'); 
plot(f,10*log10(psd)); 

% ���������ʱȣ�PAPR��
PAPR = comm.CCDF('PAPROutputPort', true, 'PowerUnits', 'dBW');
[~,~,paprFOFDM] = PAPR(txSigFOFDM);
disp(['Peak-to-Average-Power-Ratio for F-OFDM = ' num2str(paprFOFDM) ' dB']);

%������Ӧ������OFDM����
%
% Ϊ�˽��бȽϣ����ǻع������е�OFDM���Ƽ������ü���ʹ����������ռ�ô���������ͬ���ȵ�ѭ��ǰ׺��

% OFDM�źŵĹ������ܶȣ�PSD��ͼ
[psd,f] = periodogram(txSigOFDM, rectwin(length(txSigOFDM)), numFFT*2, ...
                      1, 'centered'); 
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

%
% �Ƚ�CP-OFDM��F-OFDM������Ƶ���ܶ�ͼ��F-OFDM���нϵ͵��԰ꡣ����������߷���Ƶ�׵������ʣ��Ӷ����Ƶ��Ч�ʡ�
%
% ��ο�<matlab��doc��'comm.OFDMModulator'��comm.OFDMModulator>ϵͳ���󣬸ö���Ҳ������ʵ��CP-OFDM���ơ�

%��ͨ��F-OFDM������
%
% ��������ʾ���ص�����˵���OFDM���ŵ�F-OFDM�Ļ������մ��� ���յ����ź�ͨ��ƥ����˲�����Ȼ������ͨ��CP-OFDM�������� ��������FFT����֮ǰ���˲��������ӳ١�
%
% �ڴ�ʾ���в�����˥���ŵ������ǽ�������ӵ������ź�����ʵ�������SNR��

% Add WGN
rxSig = awgn(txSigFOFDM, snrdB, 'measured');

%
% ���մ����������F-OFDM������ͼ����ʾ��
%
% <<FOFDMReceiveDiagram.png>>

% ����ƥ��Ĺ�����
rxSigFilt = filtRx(rxSig);

% ���ǹ������ӳ�
rxSigFiltSync = rxSigFilt(L:end);

% ɾ��ѭ��ǰ׺
rxSymbol = rxSigFiltSync(cpLen+1:end);

% ִ��FFT
RxSymbols = fftshift(fft(rxSymbol));

% ѡ�����ݸ��ز�
dataRxSymbols = RxSymbols(offset+(1:numDataCarriers));

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
    'Title', 'F-OFDM Demodulated Symbols', ...
    'Name', 'F-OFDM Reception', ...
    'XLimits', [-1.5 1.5], 'YLimits', [-1.5 1.5]);
constDiagRx(dataRxSymbols);

% �˴�����Ҫͨ�����⣬��Ϊû��ͨ����ģ

% ȥӳ���BER����
qamDemod = comm.RectangularQAMDemodulator('ModulationOrder', ...
    2^bitsPerSubCarrier, 'BitOutput', true, ...
    'NormalizationMethod', 'Average power');
BER = comm.ErrorRate;

% ִ�м��ѵľ�������������
rxBits = qamDemod(dataRxSymbols);
ber = BER(bitsIn, rxBits);

disp(['F-OFDM Reception, BER = ' num2str(ber(1)) ' at SNR = ' ...
    num2str(snrdB) ' dB']);

% Restore RNG state
rng(s);

%
% ��ͻ����ʾ��������F-OFDM�ڷ��ͺͽ��ն˶�Ϊ���е�CP-OFDM���������һ�����˼��� ��ʾ��Ϊ�û���ȫƵ�����佨ģ��������ͬ�ķ�������Ӧ����������·�첽�����Ķ��Ƶ����ÿ���û�һ������
%
% ��ο�<matlab��doc��'comm.OFDMDemodulator'��comm.OFDMDemodulator>ϵͳ���󣬸ö���������ڽ���ƥ����˲���ʵ��CP-OFDM�����

%�������һ��̽��
%
% ��ʾ��������ͨ��ϵͳ�ķ��ͺͽ��ն˵�F-OFDM���Ʒ����Ļ��������� ̽����ͬ��ϵͳ����ֵ�����˽���Դ���������ÿ��������ز����������˲������ȣ�����ƫ�ƺ�SNR��
%
% ͨ���˲����ز���UFMC�����Ʒ������Ӵ��˲�OFDM����һ�ַ������йظ�����Ϣ����μ�<OFDMvsUFMCExample.html UFMC vs. OFDM Modulation>ʾ������F-OFDMʾ��ʹ�õ����Ӵ�����UFMCʾ��ʹ�ö���Ӵ���
%
% F-OFDM��UFMC��ʹ��ʱ���˲������˲�������ƺ�Ӧ�÷�ʽ����ϸ΢��𡣶���UFMC���˲����ĳ��ȱ�����Ϊ����ѭ��ǰ׺���ȣ�������F-OFDM�����ĳ��ȿ��Գ���CP�ĳ��ȡ�
%
% ����F-OFDM���˲�����Ƶ��������������½����ϸ���˵�������Ӱ���Ե���ز���
%
% Refer to the 
% <matlab:web(['http://www.mathworks.com/matlabcentral/fileexchange/61585-5g-library-for-lte-system-toolbox'],'-browser')
% LTEϵͳ�����䣨TM����5G��>ʾ����˵����ν�F-OFDMӦ�õ�LTE������·��PDSCH���ŵ���

displayEndOfDemoMessage(mfilename)