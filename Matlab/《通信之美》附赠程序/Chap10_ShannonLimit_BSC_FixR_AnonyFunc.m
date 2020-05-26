clear
% BSC�ŵ��£��̶����ʣ��������Ϊ0ʱ����ũ�ޣ��������ת�Ƹ���Epsilon����С�����Eb/N0��
R = [(0.05 : 0.05 : 0.95).'; 1/3; 2/3];
R = sort(R);
CBSC = @(pb) 1 - (-pb * log2(pb) - (1 - pb) * log2(1 - pb));
% ��AWGN�ŵ���ͬ����Բ�ͬ��R�����fzero�����ĳ�ʼ�ⶼ�̶����䣬
% �����ĳЩR�޷���⣬������õĽ�������Ǵ�ģ�
% ��ˣ������ʼ����Ϊ�ɱ䣬����ɵ�ǰ�ĳ�ʼ���޷������ȷ�Ľ⣬
% ��ı��ʼ�⣬�ٴε���fzero������ֱ���õ���ȷ�Ľ�Ϊֹ
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


