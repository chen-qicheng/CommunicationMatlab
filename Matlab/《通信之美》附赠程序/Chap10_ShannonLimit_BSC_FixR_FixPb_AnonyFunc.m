clear
% BSC信道下，非零码率，非零误比特率下的香农限
R = [1/4; 1/3; 1/2; 2/3; 3/4; 4/5];
Pb = logspace(-2, -6, 5);
Rc = [R * (1 + Pb .* log2(Pb) + (1 - Pb) .* log2(1 - Pb)), R]; % 最后之所以再加一列RNum，是想要算出Pe=0时的香农限，只能单独串在后面，不能把0直接赋值到Pe中，否则log2(0)=-inf
CBSC = @(pb) 1 - (-pb * log2(pb) - (1 - pb) * log2(1 - pb));

% 和AWGN信道不同，针对不同的R，如果fzero函数的初始解都固定不变，
% 则对于某些R无法求解，或者求得的解根本就是错的，
% 因此，将其初始解设为可变，如果由当前的初始解无法求得正确的解，
% 则改变初始解，再次调用fzero函数，直到得到正确的解为止
pb = @(r, x0) fzero(@(pb) (CBSC(pb) - r), x0);

Epsilon = zeros(size(Rc), 'double');
ExitFlag = zeros(size(Rc), 'double');
for i = 1 : size(Rc, 1)
    for j = 1 : size(Rc, 2)
        InitialValue = 0.5;
        [Epsilon(i, j), ~, ExitFlag(i, j), ~] = pb(Rc(i, j), InitialValue);
        while ExitFlag(i, j) ~= 1
            InitialValue = InitialValue / 2;
            [Epsilon(i, j), ~, ExitFlag(i, j), ~] = pb(Rc(i, j), InitialValue);
        end
    end
end

EbN0 = 1 ./ repmat(R, 1, length(Pb)+1) .* erfcinv(2 * Epsilon) .^ 2;
EbN0dB = 10 * log10(EbN0);











