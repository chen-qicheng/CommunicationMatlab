
s = rng(211);            % �������������

numFFT = 1024;           % FFT����
numGuards = 212;         % Guard bands on both sides
K = 4;                   % �ص�����, 2��3��4֮һ
numSymbols = 100;        % ģ�ⳤ�ȣ��Է���Ϊ��λ��
bitsPerSubCarrier = 4;   % 2: 4QAM, 4: 16QAM, 6: 64QAM, 8: 256QAM
snrdB = 12;              % �����dB

% ԭ�͹�����
switch K
    case 2
        HkOneSided = sqrt(2)/2;
    case 3
        HkOneSided = [0.911438 0.411438];
    case 4
        HkOneSided = [0.971960 sqrt(2)/2 0.235147];
    otherwise
        return
end
% �����Գƹ�����
Hk = [fliplr(HkOneSided) 1 HkOneSided];%���鷭ת

% QAM����ӳ����

qamMapper = comm.RectangularQAMModulator(...%QAM�ź�����ͼ����
    'ModulationOrder', 2^bitsPerSubCarrier, ...%����ͼ����2^2=4
    'BitInput', true, ...
    'NormalizationMethod', 'Average power');%����ͼ��һ������


 
%% ���Ͷ˴���
%   ��ʼ������
L = numFFT-2*numGuards;  % ÿ��OFDM���ŵĸ���������
KF = K*numFFT;
KL = K*L;
dataSubCar = zeros(L, 1);
dataSubCarUp = zeros(KL, 1);

sumFBMCSpec = zeros(KF*2, 1);
sumOFDMSpec = zeros(numFFT*2, 1);

numBits = bitsPerSubCarrier*L/2;    % 2��������
inpData = zeros(numBits, numSymbols); 
rxBits = zeros(numBits, numSymbols);
txSigAll = complex(zeros(KF, numSymbols));
symBuf = complex(zeros(2*KF, 1));

% Loop over symbols
for symIdx = 1:numSymbols
    
    % ����ӳ��ķ�������
    inpData(:, symIdx) = randi([0 1], numBits, 1);%α�������Χ0~1
    modData = qamMapper(inpData(:, symIdx));%QAM�ź�����ͼ����
    
    % OQAM��������ʵ�����鲿����
    if rem(symIdx,2)==1     % ����
        dataSubCar(1:2:L) = real(modData);
        dataSubCar(2:2:L) = 1i*imag(modData);
    else                    % ż��
        dataSubCar(1:2:L) = 1i*imag(modData);
        dataSubCar(2:2:L) = real(modData);
    end

    % Upsample by K, pad with guards, and filter with the prototype filter
    dataSubCarUp(1:K:end) = dataSubCar;
    dataBitsUpPad = [zeros(numGuards*K,1); dataSubCarUp; zeros(numGuards*K,1)];
    X1 = filter(Hk, 1, dataBitsUpPad);
    % Remove 1/2 filter length delay
    X = [X1(K:end); zeros(K-1,1)];

    % ������������ŵĳ���ΪKF��IFFT
    txSymb = fftshift(ifft(X));

    % ������ź����ӳٵ�ʵ������ŵ��ܺ�
    symBuf = [symBuf(numFFT/2+1:end); complex(zeros(numFFT/2,1))];
    symBuf(KF+(1:KF)) = symBuf(KF+(1:KF)) + txSymb;

    % ���㹦�����ܶȣ�PSD��
    currSym = complex(symBuf(1:KF));
    [specFBMC, fFBMC] = periodogram(currSym, hann(KF, 'periodic'), KF*2, 1);
    sumFBMCSpec = sumFBMCSpec + specFBMC;

    %  �洢���з��ŵĴ����ź�
    txSigAll(:,symIdx) = currSym;
end

% �������ܶȻ�ͼ
sumFBMCSpec = sumFBMCSpec/mean(sumFBMCSpec(1+K+2*numGuards*K:end-2*numGuards*K-K));
plot(fFBMC-0.5,10*log10(sumFBMCSpec));
grid on
axis([-0.5 0.5 -180 10]);
xlabel('��һ��Ƶ��'); 
ylabel('�������ܶ� PSD (dBW/Hz)')
title(['FBMC, K = ' num2str(K) ' overlapped symbols'])
set(gcf, 'Position', figposition([15 50 30 30]));

%% OFDM���Ƽ���
for symIdx = 1:numSymbols
    
    inpData2 = randi([0 1], bitsPerSubCarrier*L, 1);
    modData = qamMapper(inpData2);
        
    symOFDM = [zeros(numGuards,1); modData; zeros(numGuards,1)];
    ifftOut = sqrt(numFFT).*ifft(ifftshift(symOFDM));

    [specOFDM,fOFDM] = periodogram(ifftOut, rectwin(length(ifftOut)), ...
        numFFT*2, 1, 'centered'); 
    sumOFDMSpec = sumOFDMSpec + specOFDM;
end

% �����������ز��Ĺ������ܶȣ�PSD��
sumOFDMSpec = sumOFDMSpec/mean(sumOFDMSpec(1+2*numGuards:end-2*numGuards));
figure; 
plot(fOFDM,10*log10(sumOFDMSpec)); 
grid on
axis([-0.5 0.5 -180 10]);
xlabel('��һ��Ƶ��'); 
ylabel('�������ܶ� PSD (dBW/Hz)')
title(['OFDM, numFFT = ' num2str(numFFT)])
set(gcf, 'Position', figposition([46 50 30 30]));


%% QAM demodulator
qamDemod = comm.RectangularQAMDemodulator(...
    'ModulationOrder', 2^bitsPerSubCarrier, ...
    'BitOutput', true, ...
    'NormalizationMethod', 'Average power');
BER = comm.ErrorRate;

% Process symbol-wise
for symIdx = 1:numSymbols
    rxSig = txSigAll(:, symIdx);
     
    rxNsig = awgn(rxSig, snrdB, 'measured');  % ��Ӱ�������WGN��   
   
    rxf = fft(fftshift(rxNsig)); % FFT
    
    % HkƵ�ʽ���
    % ƥ���������ԭ�͹�����
    rxfmf = filter(Hk, 1, rxf);
    rxfmf = [rxfmf(K:end); zeros(K-1,1)];%�Ƴ�K-1���ӳ�  
    rxfmfg = rxfmf(numGuards*K+1:end-numGuards*K);  % Remove guards
    
    % OQAM ����2K�²�������ȡʵ�����鲿
    if rem(symIdx, 2)
        % �鲿��ʵ�����K��Ԫ��
        r1 = real(rxfmfg(1:2*K:end));
        r2 = imag(rxfmfg(K+1:2*K:end));
        rcomb = complex(r1, r2);
    else
        % ʵ�����������K��Ԫ��
        r1 = imag(rxfmfg(1:2*K:end));
        r2 = real(rxfmfg(K+1:2*K:end));
        rcomb = complex(r2, r1);
    end
    % ͨ���ϲ������ӽ��й�һ��
    rcomb = (1/K)*rcomb;   
    rxBits(:, symIdx) = qamDemod(rcomb); %��ӳ�� 
end

% Measure BER with appropriate delay
BER.ReceiveDelay = bitsPerSubCarrier*KL;
ber = BER(inpData(:), rxBits(:));
disp(['FBMC���գ�����K = ' num2str(K) ', BER = ' num2str(ber(1)) ...
    ' at SNR = ' num2str(snrdB) ' dB'])    % ��ʾ�����ʣ�BER��

% Restore RNG state
rng(s);


%displayEndOfDemoMessage(mfilename)
