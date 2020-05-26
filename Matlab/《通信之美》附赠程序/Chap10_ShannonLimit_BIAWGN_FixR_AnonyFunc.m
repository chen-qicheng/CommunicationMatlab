% BI-AWGN�ŵ��£��̶����ʣ��������Ϊ0ʱ����ũ��
A = 1;
f = @(x, sigma) 1 ./ sqrt(2 * pi) / sigma .* exp(-(x-A).^2 / (2*sigma^2)) .* log2(1 + exp(-2 * A .* x / sigma^2));
R = [(0.05 : 0.05 : 0.95).'; 1/3; 2/3];
R = sort(R);
% ���ﱾ������ֱ����integral�����ģ���������f����������x�ܴ�ʱֵ��С��
% ���صĽ��ΪNaN��Ϊ�˱�֤�����޾�������ֲ�����NaN����ȡ���ַ����Ż�����
C = @(sigma) 1 - integraluserdefine(@(x) f(x, sigma), -1e5, 1e5); % ��x���֣�C��sigma�ĺ���
sigma = @(R) fzero(@(sigma) (C(sigma) - R), 1); % �ⷽ��C(sigma) = R�����sigma������R�ĺ�����sigma(R)

Sigma = arrayfun(sigma, R); % �����ʵľ�����ֵR���뺯��sigma(R)���õ�Sigma�ľ�����ֵ
NoisePwr = Sigma .^2;
EbN0 = 1 ./ (2 * R .* Sigma.^2);
EbN0dB = 10 * log10(EbN0);
