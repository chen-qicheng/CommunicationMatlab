A = 1;
f = @(x, sigma) 1 ./ sqrt(2 * pi) / sigma .* exp(-(x-A).^2 / (2*sigma^2)) .* log2(1 + exp(-2 * A .* x / sigma^2));
% RNum = [(0.05 : 0.05 : 0.95).'; 1/3; 2/3];
% RNum = sort(RNum);
RNum = [1/4; 1/3; 1/2; 2/3; 3/4; 4/5];
Pb = logspace(-2, -6, 5);
Rc = [RNum * (1 + Pb .* log2(Pb) + (1 - Pb) .* log2(1 - Pb)), RNum]; % ���֮�����ټ�һ��RNum������Ҫ���Pe=0ʱ����ũ�ޣ�ֻ�ܵ������ں��棬���ܰ�0ֱ�Ӹ�ֵ��Pe�У�����log2(0)=-inf
% ���ﱾ������ֱ����integral�����ģ���������f����������x�ܴ�ʱֵ��С��
% ���صĽ��ΪNaN��Ϊ�˱�֤�����޾�������ֲ�����NaN����ȡ���ַ����Ż�����
C = @(sigma) 1 - integraluserdefine(@(x) f(x, sigma), -1e5, 1e5); % ��x���֣�C��sigma�ĺ���
sigma = @(R) fzero(@(sigma) (C(sigma) - R), 1); % �ⷽ��C(sigma) = R�����sigma������R�ĺ�����sigma(R)

Sigma = arrayfun(sigma, Rc);
EbN0 = 1 ./ (2 * repmat(RNum, 1, length(Pb)+1) .* Sigma.^2);
EbN0dB = 10 * log10(EbN0);


%% plot figure
figure;
semilogy(EbN0dB(1, :), [Pb, 0], 'rs-', EbN0dB(3, :), [Pb, 0], 'k^-', EbN0dB(end, :), [Pb, 0], 'bv-'); grid on
legend('R = 0.05', 'R = 1/2', 'R = 0.95');
xlabel('E_b/N_0 (dB)'); ylabel('Pb');

