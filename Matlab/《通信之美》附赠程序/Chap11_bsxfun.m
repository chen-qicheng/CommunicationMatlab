M = 1e4;
N = 1e4;
A = rand(M, N);
B = mean(A);

tic;
C1 = A - repmat(B, M, 1);
tElapsed1 = toc;
disp(['����repmat��ʱ��', num2str(tElapsed1), '�롣']);

tic;
C2 = bsxfun(@minus, A, B);
tElapsed2 = toc;
disp(['����bsxfun��ʱ��', num2str(tElapsed2), '�롣']);
isequal(C1, C2)
