N = 1e6;
A.x = linspace(1, N, N);
B = linspace(1, N, N);
C = num2cell(linspace(1, N, N));

tic;
parfor i = 1 : N
    p1(i) = 2 * A.x(i);
end
tElapsed1 = toc;
disp(['首层索引为结构体的域耗时：', num2str(tElapsed1), '秒。']);

tic;
parfor i = 1 : N
    p2(i) = 2 * B(i);
end
tElapsed2 = toc;
disp(['首层索引为[ ]耗时：', num2str(tElapsed2), '秒。']);

tic;
parfor i = 1 : N
    p3(i) = 2 * C{i};
end
tElapsed3 = toc;
disp(['首层索引为{ }耗时：', num2str(tElapsed3), '秒。']);

