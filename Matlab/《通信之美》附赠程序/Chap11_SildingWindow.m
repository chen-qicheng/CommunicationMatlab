close all
clear
LoopCnt = 1e1; % 循环次数，统计多次运行的结果以便更准确
SeqLen = 16; % 前导码中每个训练序列的长度
WindowSize = 1 * SeqLen; % 窗长
disp(['WindowSize = ', num2str(WindowSize/SeqLen), '*SeqLen.']);
Preamble = pregen; % 调用pregen函数，生成前导码
% 画出前导码的实部和虚部
figure;
subplot(211); plot((0 : 10*SeqLen - 1)', real(Preamble(1:10*SeqLen)));
grid on; xlim([0, 10*SeqLen-1]);
xlabel('Time index'); ylabel('Real');
subplot(212); plot((0 : 10*SeqLen - 1)', imag(Preamble(1:10*SeqLen)));
grid on; xlim([0, 10*SeqLen-1]);
xlabel('Time index'); ylabel('Imag');
txSeq = [zeros(100, 1); Preamble]; % 在前导码前加0，模拟信号还未到达
rxSeq = awgn(txSeq, 30, 20 * log10(52/64/8));

% 方法1：向量化编程
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
disp(['向量化编程耗时：', num2str(tElapsed1), '秒。']);

% 方法2：循环优化算法
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
disp(['循环优化算法耗时：', num2str(tElapsed2), '秒。']);

% 画相关值
figure;
plot((0 : SeqLen * 100 - 1).', abs(M1));
grid on; xlim([0, SeqLen * 100 - 1]);
xlabel('Time index'); ylabel('M(n)');
