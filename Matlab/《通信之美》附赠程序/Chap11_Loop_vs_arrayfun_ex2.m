% 列优先的循环最快，其次行优先的循环，最慢的是arrayfun + 向量化编程
clear;
M = 1000;
N = 10000;
a = ones(M, N);
WirieIdxEnd = randi([20, N/2], M, 1); % 随机生成每行赋值的末尾的列号

% 方法一：循环，矩阵的行操作
b = a;
tic;
for i = 1 : M
    b(i, 1 : WirieIdxEnd(i)) = 99;
end
tElapsed1 = toc;
disp(['循环，矩阵的行操作耗时：', num2str(tElapsed1), '秒。']);

% 方法二：arrayfun + 向量化编程
c = a.';
tic;
BaseIdx = (1 : N : (M-1) * N + 1).'; % 每列的起始地址
EndIdx = BaseIdx + WirieIdxEnd - 1;
IdxEachCol = arrayfun(@linspace, BaseIdx, EndIdx, WirieIdxEnd, 'UniformOutput', false);
IdxEachCol = cellfun(@transpose, IdxEachCol,'UniformOutput', false);
temp = cell2mat(IdxEachCol);
c(temp) = 99;
tElapsed2 = toc;
disp(['arrayfun + 向量化编程耗时：', num2str(tElapsed2), '秒。']);
isequal(b, c.')

% 方法三：循环，矩阵的列操作
d = a.';
tic;
for i = 1 : M
    d(1 : WirieIdxEnd(i), i) = 99;
end
tElapsed3 = toc;
disp(['循环，矩阵的列操作耗时：', num2str(tElapsed3), '秒。']);
isequal(b, d.')
