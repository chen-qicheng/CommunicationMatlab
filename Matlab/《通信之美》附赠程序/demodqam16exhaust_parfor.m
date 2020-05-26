function BitData = demodqam16exhaust_parfor(Conste, Normalized)
% 16QAM解调，穷举法
% 输入：SampleData为复数列向量，长度为SampleCnt
% 输出：BitData为解调后的0、1序列，长度为BitCnt

% 此映射规则为星座调制默认规则
CONSTE = [-3+3j;-3+1j;-3-3j;-3-1j;-1+3j;-1+1j;-1-3j;-1-1j;...
           3+3j; 3+1j; 3-3j; 3-1j; 1+3j; 1+1j; 1-3j; 1-1j].';
if strcmp(Normalized, 'Normalized')
    Conste = Conste * sqrt(10); % 去归一化
elseif strcmp(Normalized, 'NonNormalized')
    % do nothing
else
    error('第二个参数必须为Normalized或者NonNormalized');
end
SampleCnt = length(Conste);
BitCnt = SampleCnt * 4;
BitDataMatrix = zeros(4, SampleCnt);
parfor SampleIdx = 1 : SampleCnt
    Distance = zeros(16, 1);
    for Idx = 1 : 16
        Distance(Idx) = abs(Conste(SampleIdx) - CONSTE(Idx));
    end
    [~, MinIdx] = min(Distance);
    BinaryNumber = de2bi(MinIdx - 1, 'left-msb').';
    if length(BinaryNumber) < 4
        BitDataMatrix(:, SampleIdx) = ...
            [zeros(4 - length(BinaryNumber), 1); BinaryNumber];
    else
        BitDataMatrix(:, SampleIdx) = BinaryNumber;
    end
end
BitData = reshape(BitDataMatrix, BitCnt, 1);
end
