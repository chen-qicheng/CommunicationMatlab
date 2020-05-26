N = 1e6;
A.x = linspace(1, N, N);
B = linspace(1, N, N);
C = num2cell(linspace(1, N, N));

tic;
parfor i = 1 : N
    p1(i) = 2 * A.x(i);
end
tElapsed1 = toc;
disp(['�ײ�����Ϊ�ṹ������ʱ��', num2str(tElapsed1), '�롣']);

tic;
parfor i = 1 : N
    p2(i) = 2 * B(i);
end
tElapsed2 = toc;
disp(['�ײ�����Ϊ[ ]��ʱ��', num2str(tElapsed2), '�롣']);

tic;
parfor i = 1 : N
    p3(i) = 2 * C{i};
end
tElapsed3 = toc;
disp(['�ײ�����Ϊ{ }��ʱ��', num2str(tElapsed3), '�롣']);

