function BitData = demodqam16exhaust_parfor(Conste, Normalized)
% 16QAM�������ٷ�
% ���룺SampleDataΪ����������������ΪSampleCnt
% �����BitDataΪ������0��1���У�����ΪBitCnt

% ��ӳ�����Ϊ��������Ĭ�Ϲ���
CONSTE = [-3+3j;-3+1j;-3-3j;-3-1j;-1+3j;-1+1j;-1-3j;-1-1j;...
           3+3j; 3+1j; 3-3j; 3-1j; 1+3j; 1+1j; 1-3j; 1-1j].';
if strcmp(Normalized, 'Normalized')
    Conste = Conste * sqrt(10); % ȥ��һ��
elseif strcmp(Normalized, 'NonNormalized')
    % do nothing
else
    error('�ڶ�����������ΪNormalized����NonNormalized');
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
