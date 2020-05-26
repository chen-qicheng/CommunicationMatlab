clear
% BSC�ŵ��£��������ʣ�������������µ���ũ��
R = [1/4; 1/3; 1/2; 2/3; 3/4; 4/5];
Pb = logspace(-2, -6, 5);
Rc = [R * (1 + Pb .* log2(Pb) + (1 - Pb) .* log2(1 - Pb)), R]; % ���֮�����ټ�һ��RNum������Ҫ���Pe=0ʱ����ũ�ޣ�ֻ�ܵ������ں��棬���ܰ�0ֱ�Ӹ�ֵ��Pe�У�����log2(0)=-inf
CBSC = @(pb) 1 - (-pb * log2(pb) - (1 - pb) * log2(1 - pb));

% ��AWGN�ŵ���ͬ����Բ�ͬ��R�����fzero�����ĳ�ʼ�ⶼ�̶����䣬
% �����ĳЩR�޷���⣬������õĽ�������Ǵ�ģ�
% ��ˣ������ʼ����Ϊ�ɱ䣬����ɵ�ǰ�ĳ�ʼ���޷������ȷ�Ľ⣬
% ��ı��ʼ�⣬�ٴε���fzero������ֱ���õ���ȷ�Ľ�Ϊֹ
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











