function BitData = demodqam16exhaust_minserial(SampleData, Normalized)
% 16QAM解调，穷举法
% 输入：SampleData为复数列向量，长度为SampleCnt
% 输出：BitData为解调后的0、1序列，长度为BitCnt

Constellation = [-3+3j;-3+1j;-3-3j;-3-1j;-1+3j;-1+1j;-1-3j;-1-1j;...
    3+3j;3+1j;3-3j;3-1j;1+3j;1+1j;1-3j;1-1j]; % 此映射规则为星座调制默认规则
if strcmp(Normalized, 'Normalized')
    SampleData = SampleData * sqrt(10); % 去归一化
elseif strcmp(Normalized, 'NonNormalized')
    % do nothing
else
    error('第二个参数必须为Normalized或者NonNormalized');
end
SampleCnt = length(SampleData);
BitCnt = SampleCnt * 4;
MinDistance = repmat([1e10, 1], SampleCnt, 1);
for Idx = 1 : 16
    Distance = abs(SampleData - Constellation(Idx));
    MinDistance = mymin(MinDistance, [Distance, repmat(Idx, SampleCnt, 1)]);
end
BitDataMatrix = de2bi(MinDistance(:, 2) - 1, 'left-msb').';
if size(BitDataMatrix, 2) < 4
    BitDataMatrix = [zeros(SampleCnt, 4 - size(BitDataMatrix, 2)), BitDataMatrix];
end
BitData = reshape(BitDataMatrix, BitCnt, 1);



function NewMinValue = mymin(Value, CurrentMinValue)
Dis1 = Value(:, 1);
Dis2 = CurrentMinValue(:, 1);
NewDis = CurrentMinValue(:, 1);
NewDis(Dis1 < Dis2) = Dis1(Dis1 < Dis2);

Idx1 = Value(:, 2);
NewIdx = CurrentMinValue(:, 2);
NewIdx(Dis1 < Dis2) = Idx1(Dis1 < Dis2);

NewMinValue = [NewDis, NewIdx];

