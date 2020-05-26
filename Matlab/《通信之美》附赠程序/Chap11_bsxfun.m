M = 1e4;
N = 1e4;
A = rand(M, N);
B = mean(A);

tic;
C1 = A - repmat(B, M, 1);
tElapsed1 = toc;
disp(['采用repmat耗时：', num2str(tElapsed1), '秒。']);

tic;
C2 = bsxfun(@minus, A, B);
tElapsed2 = toc;
disp(['采用bsxfun耗时：', num2str(tElapsed2), '秒。']);
isequal(C1, C2)
