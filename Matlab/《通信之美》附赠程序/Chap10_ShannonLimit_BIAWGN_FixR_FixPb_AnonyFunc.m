A = 1;
f = @(x, sigma) 1 ./ sqrt(2 * pi) / sigma .* exp(-(x-A).^2 / (2*sigma^2)) .* log2(1 + exp(-2 * A .* x / sigma^2));
% RNum = [(0.05 : 0.05 : 0.95).'; 1/3; 2/3];
% RNum = sort(RNum);
RNum = [1/4; 1/3; 1/2; 2/3; 3/4; 4/5];
Pb = logspace(-2, -6, 5);
Rc = [RNum * (1 + Pb .* log2(Pb) + (1 - Pb) .* log2(1 - Pb)), RNum]; % 最后之所以再加一列RNum，是想要算出Pe=0时的香农限，只能单独串在后面，不能把0直接赋值到Pe中，否则log2(0)=-inf
% 这里本来可以直接用integral函数的，但是由于f函数本身在x很大时值很小，
% 返回的结果为NaN，为了保证积分限尽量宽而又不返回NaN，采取二分法缩放积分限
C = @(sigma) 1 - integraluserdefine(@(x) f(x, sigma), -1e5, 1e5); % 对x积分，C是sigma的函数
sigma = @(R) fzero(@(sigma) (C(sigma) - R), 1); % 解方程C(sigma) = R，解得sigma是码率R的函数：sigma(R)

Sigma = arrayfun(sigma, Rc);
EbN0 = 1 ./ (2 * repmat(RNum, 1, length(Pb)+1) .* Sigma.^2);
EbN0dB = 10 * log10(EbN0);


%% plot figure
figure;
semilogy(EbN0dB(1, :), [Pb, 0], 'rs-', EbN0dB(3, :), [Pb, 0], 'k^-', EbN0dB(end, :), [Pb, 0], 'bv-'); grid on
legend('R = 0.05', 'R = 1/2', 'R = 0.95');
xlabel('E_b/N_0 (dB)'); ylabel('Pb');

