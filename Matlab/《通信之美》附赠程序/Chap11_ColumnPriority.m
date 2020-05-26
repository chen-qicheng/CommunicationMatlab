% 列优先的循环最快，其次行优先的循环
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

% 方法二：循环，矩阵的行操作
h = linspace(1, L, L);
tic;
H2 = zeros(N, N+L-1);
for i = 1 : N
    H2(i, i : i + L - 1) = h;
end
tElapsed2 = toc;
disp(['矩阵的行操作耗时：', num2str(tElapsed2), '秒。']);
