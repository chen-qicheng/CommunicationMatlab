N = 1e7;
A = linspace(1, N, N);

tic;
parfor i = 1 : N-1
   S(i) = A(i) + A(i+1);
end
tElapsed1 = toc;
disp(['A不是分段变量耗时：', num2str(tElapsed1), '秒。']);

B = A(2:end);
tic;
parfor i = 1 : N-1
   S(i) = A(i) + B(i);
end
tElapsed1 = toc;
disp(['A是分段变量耗时：', num2str(tElapsed1), '秒。']);


