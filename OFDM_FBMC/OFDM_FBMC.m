
s = rng(211);            % 控制随机数生成

numFFT = 1024;           % FFT点数
numGuards = 212;         % Guard bands on both sides
K = 4;                   % 重叠因子, 2、3或4之一
numSymbols = 100;        % 模拟长度（以符号为单位）
bitsPerSubCarrier = 4;   % 2: 4QAM, 4: 16QAM, 6: 64QAM, 8: 256QAM
snrdB = 12;              % 信噪比dB

% 原型过滤器
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
% 建立对称过滤器
Hk = [fliplr(HkOneSided) 1 HkOneSided];%数组翻转

% QAM符号映射器

qamMapper = comm.RectangularQAMModulator(...%QAM信号星座图调制
    'ModulationOrder', 2^bitsPerSubCarrier, ...%星座图点数2^2=4
    'BitInput', true, ...
    'NormalizationMethod', 'Average power');%星座图归一化方法


 
%% 发送端处理
%   初始化数组
L = numFFT-2*numGuards;  % 每个OFDM符号的复数符号数
KF = K*numFFT;
KL = K*L;
dataSubCar = zeros(L, 1);
dataSubCarUp = zeros(KL, 1);

sumFBMCSpec = zeros(KF*2, 1);
sumOFDMSpec = zeros(numFFT*2, 1);

numBits = bitsPerSubCarrier*L/2;    % 2倍过采样
inpData = zeros(numBits, numSymbols); 
rxBits = zeros(numBits, numSymbols);
txSigAll = complex(zeros(KF, numSymbols));
symBuf = complex(zeros(2*KF, 1));

% Loop over symbols
for symIdx = 1:numSymbols
    
    % 生成映射的符号数据
    inpData(:, symIdx) = randi([0 1], numBits, 1);%伪随机数范围0~1
    modData = qamMapper(inpData(:, symIdx));%QAM信号星座图调制
    
    % OQAM调制器：实部和虚部交替
    if rem(symIdx,2)==1     % 奇数
        dataSubCar(1:2:L) = real(modData);
        dataSubCar(2:2:L) = 1i*imag(modData);
    else                    % 偶数
        dataSubCar(1:2:L) = 1i*imag(modData);
        dataSubCar(2:2:L) = real(modData);
    end

    % Upsample by K, pad with guards, and filter with the prototype filter
    dataSubCarUp(1:K:end) = dataSubCar;
    dataBitsUpPad = [zeros(numGuards*K,1); dataSubCarUp; zeros(numGuards*K,1)];
    X1 = filter(Hk, 1, dataBitsUpPad);
    % Remove 1/2 filter length delay
    X = [X1(K:end); zeros(K-1,1)];

    % 计算所传输符号的长度为KF的IFFT
    txSymb = fftshift(ifft(X));

    % 传输的信号是延迟的实、虚符号的总和
    symBuf = [symBuf(numFFT/2+1:end); complex(zeros(numFFT/2,1))];
    symBuf(KF+(1:KF)) = symBuf(KF+(1:KF)) + txSymb;

    % 计算功率谱密度（PSD）
    currSym = complex(symBuf(1:KF));
    [specFBMC, fFBMC] = periodogram(currSym, hann(KF, 'periodic'), KF*2, 1);
    sumFBMCSpec = sumFBMCSpec + specFBMC;

    %  存储所有符号的传输信号
    txSigAll(:,symIdx) = currSym;
end

% 功率谱密度画图
sumFBMCSpec = sumFBMCSpec/mean(sumFBMCSpec(1+K+2*numGuards*K:end-2*numGuards*K-K));
plot(fFBMC-0.5,10*log10(sumFBMCSpec));
grid on
axis([-0.5 0.5 -180 10]);
xlabel('归一化频率'); 
ylabel('功率谱密度 PSD (dBW/Hz)')
title(['FBMC, K = ' num2str(K) ' overlapped symbols'])
set(gcf, 'Position', figposition([15 50 30 30]));

%% OFDM调制技术
for symIdx = 1:numSymbols
    
    inpData2 = randi([0 1], bitsPerSubCarrier*L, 1);
    modData = qamMapper(inpData2);
        
    symOFDM = [zeros(numGuards,1); modData; zeros(numGuards,1)];
    ifftOut = sqrt(numFFT).*ifft(ifftshift(symOFDM));

    [specOFDM,fOFDM] = periodogram(ifftOut, rectwin(length(ifftOut)), ...
        numFFT*2, 1, 'centered'); 
    sumOFDMSpec = sumOFDMSpec + specOFDM;
end

% 覆盖所有子载波的功率谱密度（PSD）
sumOFDMSpec = sumOFDMSpec/mean(sumOFDMSpec(1+2*numGuards:end-2*numGuards));
figure; 
plot(fOFDM,10*log10(sumOFDMSpec)); 
grid on
axis([-0.5 0.5 -180 10]);
xlabel('归一化频率'); 
ylabel('功率谱密度 PSD (dBW/Hz)')
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
     
    rxNsig = awgn(rxSig, snrdB, 'measured');  % 添加白噪声（WGN）   
   
    rxf = fft(fftshift(rxNsig)); % FFT
    
    % Hk频率解扩
    % 匹配过滤器与原型过滤器
    rxfmf = filter(Hk, 1, rxf);
    rxfmf = [rxfmf(K:end); zeros(K-1,1)];%移除K-1个延迟  
    rxfmfg = rxfmf(numGuards*K+1:end-numGuards*K);  % Remove guards
    
    % OQAM 后处理，2K下采样，提取实部和虚部
    if rem(symIdx, 2)
        % 虚部是实数后的K个元素
        r1 = real(rxfmfg(1:2*K:end));
        r2 = imag(rxfmfg(K+1:2*K:end));
        rcomb = complex(r1, r2);
    else
        % 实部是虚数后的K个元素
        r1 = imag(rxfmfg(1:2*K:end));
        r2 = real(rxfmfg(K+1:2*K:end));
        rcomb = complex(r2, r1);
    end
    % 通过上采样因子进行归一化
    rcomb = (1/K)*rcomb;   
    rxBits(:, symIdx) = qamDemod(rcomb); %解映射 
end

% Measure BER with appropriate delay
BER.ReceiveDelay = bitsPerSubCarrier*KL;
ber = BER(inpData(:), rxBits(:));
disp(['FBMC接收，对于K = ' num2str(K) ', BER = ' num2str(ber(1)) ...
    ' at SNR = ' num2str(snrdB) ' dB'])    % 显示误码率（BER）

% Restore RNG state
rng(s);


%displayEndOfDemoMessage(mfilename)
