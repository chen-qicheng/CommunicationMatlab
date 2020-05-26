% N比较小时，向量化编程更快，但N比较大时，向量化编程就变慢了
% 当运行完不clear掉变量便再次运行时，本来更慢的向量化编程编程就变快了。
% 感觉是MALTAB已经发现workspace中有这个变量了，所以H3 = zeros(N+L-1, N);这一行的运行时间大大减小
% 列优先的循环最快，最慢的是向量化编程
clear
L = 500;
h = linspace(1, L, L).';
N = 4096+1024;

% 方法一：循环，矩阵的列操作
tic;
H1 = zeros(N+L-1, N);
for i = 1 : N
    H1(i : i + L - 1, i) = h;
end
tElapsed1 = toc;
disp(['矩阵的列操作耗时：', num2str(tElapsed1), '秒。']);

% 方法三：向量化编程
tic;
H3 = zeros(N+L-1, N);
Idx = (1 : L).';
ColIdx = 0 : N+L : (N+L)*(N-1);
MatIdx = repmat(Idx, 1, N) + repmat(ColIdx, L, 1);
H3(MatIdx) = repmat(h, N, 1);
tElapsed3 = toc;
disp(['向量化编程耗时：', num2str(tElapsed3), '秒。']);
