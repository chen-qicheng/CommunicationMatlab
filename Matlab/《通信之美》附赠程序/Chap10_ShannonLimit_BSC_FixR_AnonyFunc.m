clear
% BSC信道下，固定码率，误比特率为0时的香农限（包括最大转移概率Epsilon和最小信噪比Eb/N0）
R = [(0.05 : 0.05 : 0.95).'; 1/3; 2/3];
R = sort(R);
CBSC = @(pb) 1 - (-pb * log2(pb) - (1 - pb) * log2(1 - pb));
% 和AWGN信道不同，针对不同的R，如果fzero函数的初始解都固定不变，
% 则对于某些R无法求解，或者求得的解根本就是错的，
% 因此，将其初始解设为可变，如果由当前的初始解无法求得正确的解，
% 则改变初始解，再次调用fzero函数，直到得到正确的解为止
pb = @(r, x0) fzero(@(pb) (CBSC(pb) - r), x0);

Epsilon = zeros(length(R), 1, 'double');
ExitFlag = zeros(length(R), 1, 'double');
for i = 1 : length(R)
    InitialValue = 0.5;
    [Epsilon(i), ~, ExitFlag(i), ~] = pb(R(i), InitialValue);
    while ExitFlag(i) ~= 1
        InitialValue = InitialValue / 2;
        [Epsilon(i), ~, ExitFlag(i), ~] = pb(R(i), InitialValue);
    end
end
EbN0 = 1 ./ R .* erfcinv(2 * Epsilon) .^ 2;
EbN0dB = 10 * log10(EbN0);


