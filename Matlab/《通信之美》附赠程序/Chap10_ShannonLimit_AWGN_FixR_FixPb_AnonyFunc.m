clear
R = [1/4; 1/3; 1/2; 2/3; 3/4; 4/5];
Pb = logspace(-2, -6, 5);
Rc = [R * (1 + Pb .* log2(Pb) + (1 - Pb) .* log2(1 - Pb)), R]; % ���֮�����ټ�һ��RNum������Ҫ���Pb=0ʱ����ũ�ޣ�ֻ�ܵ������ں��棬���ܰ�0ֱ�Ӹ�ֵ��Pb�У�����log2(0)=-inf
CAWGN = @(sigma) 0.5 * log2(1 + 1 ./ sigma.^2);
sigma = @(R) fzero(@(sigma) (CAWGN(sigma) - R), 1); % �ⷽ��C(sigma) = R�����sigma������R�ĺ�����sigma(R)
Sigma = arrayfun(sigma, Rc);
EbN0 = 1 ./ (2 * repmat(R, 1, length(Pb)+1) .* Sigma.^2);
EbN0dB = 10 * log10(EbN0);







