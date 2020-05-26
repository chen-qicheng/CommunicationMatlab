% BI-AWGN信道下，固定码率，误比特率为0时的香农限
A = 1;
f = @(x, sigma) 1 ./ sqrt(2 * pi) / sigma .* exp(-(x-A).^2 / (2*sigma^2)) .* log2(1 + exp(-2 * A .* x / sigma^2));
R = [(0.05 : 0.05 : 0.95).'; 1/3; 2/3];
R = sort(R);
% 这里本来可以直接用integral函数的，但是由于f函数本身在x很大时值很小，
% 返回的结果为NaN，为了保证积分限尽量宽而又不返回NaN，采取二分法缩放积分限
C = @(sigma) 1 - integraluserdefine(@(x) f(x, sigma), -1e5, 1e5); % 对x积分，C是sigma的函数
sigma = @(R) fzero(@(sigma) (C(sigma) - R), 1); % 解方程C(sigma) = R，解得sigma是码率R的函数：sigma(R)

Sigma = arrayfun(sigma, R); % 将码率的具体数值R代入函数sigma(R)，得到Sigma的具体数值
NoisePwr = Sigma .^2;
EbN0 = 1 ./ (2 * R .* Sigma.^2);
EbN0dB = 10 * log10(EbN0);
