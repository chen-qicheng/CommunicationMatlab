close all
clear
LoopCnt = 1e1; % ѭ��������ͳ�ƶ�����еĽ���Ա��׼ȷ
SeqLen = 16; % ǰ������ÿ��ѵ�����еĳ���
WindowSize = 1 * SeqLen; % ����
disp(['WindowSize = ', num2str(WindowSize/SeqLen), '*SeqLen.']);
Preamble = pregen; % ����pregen����������ǰ����
% ����ǰ�����ʵ�����鲿
figure;
subplot(211); plot((0 : 10*SeqLen - 1)', real(Preamble(1:10*SeqLen)));
grid on; xlim([0, 10*SeqLen-1]);
xlabel('Time index'); ylabel('Real');
subplot(212); plot((0 : 10*SeqLen - 1)', imag(Preamble(1:10*SeqLen)));
grid on; xlim([0, 10*SeqLen-1]);
xlabel('Time index'); ylabel('Imag');
txSeq = [zeros(100, 1); Preamble]; % ��ǰ����ǰ��0��ģ���źŻ�δ����
rxSeq = awgn(txSeq, 30, 20 * log10(52/64/8));

% ����1�����������
tic;
for Idx = 1 : LoopCnt
    P1 = zeros(SeqLen * 100, 1, 'double');
    R1 = zeros(SeqLen * 100, 1, 'double');
    for i = 1 : SeqLen * 100
        P1(i) = rxSeq(i : i + WindowSize - 1)' * ...
                rxSeq(i + WindowSize : i + 2*WindowSize - 1);
        R1(i) = rxSeq(i + WindowSize : i + 2*WindowSize - 1)' * ...
                rxSeq(i + WindowSize : i + 2*WindowSize - 1);
    end
    M1 = abs(P1).^2 ./ R1.^2;
end
tElapsed1 = toc;
disp(['��������̺�ʱ��', num2str(tElapsed1), '�롣']);

% ����2��ѭ���Ż��㷨
tic;
for Idx = 1 : LoopCnt
    P2 = zeros(SeqLen * 100, 1, 'double');
    R2 = zeros(SeqLen * 100, 1, 'double');
    P2(1) = rxSeq(1 : WindowSize)' * rxSeq(1 + WindowSize : 2*WindowSize);
    R2(1) = rxSeq(1 + WindowSize : 2*WindowSize)' * ...
            rxSeq(1 + WindowSize : 2*WindowSize);
    for i = 2 : SeqLen * 100
        P2(i) = P2(i - 1) - rxSeq(i - 1)' * rxSeq(i + WindowSize - 1) + ...
                rxSeq(i + WindowSize - 1)' * rxSeq(i + 2*WindowSize - 1);
        R2(i) = R2(i - 1) - abs(rxSeq(i + WindowSize - 1))^2 + ...
                abs(rxSeq(i + 2*WindowSize - 1))^2;
    end
    M2 = abs(P2).^2 ./ R2.^2;
end
tElapsed2 = toc;
disp(['ѭ���Ż��㷨��ʱ��', num2str(tElapsed2), '�롣']);

% �����ֵ
figure;
plot((0 : SeqLen * 100 - 1).', abs(M1));
grid on; xlim([0, SeqLen * 100 - 1]);
xlabel('Time index'); ylabel('M(n)');
