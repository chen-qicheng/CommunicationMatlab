clear
R = [1/4; 1/3; 1/2; 2/3; 3/4; 4/5];
Pb = logspace(-2, -6, 5);
Rc = [R * (1 + Pb .* log2(Pb) + (1 - Pb) .* log2(1 - Pb)), R]; % 最后之所以再加一列RNum，是想要算出Pb=0时的香农限，只能单独串在后面，不能把0直接赋值到Pb中，否则log2(0)=-inf
CAWGN = @(sigma) 0.5 * log2(1 + 1 ./ sigma.^2);
sigma = @(R) fzero(@(sigma) (CAWGN(sigma) - R), 1); % 解方程C(sigma) = R，解得sigma是码率R的函数：sigma(R)
Sigma = arrayfun(sigma, Rc);
EbN0 = 1 ./ (2 * repmat(R, 1, length(Pb)+1) .* Sigma.^2);
EbN0dB = 10 * log10(EbN0);







