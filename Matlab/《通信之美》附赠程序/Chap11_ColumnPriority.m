% �����ȵ�ѭ����죬��������ȵ�ѭ��
clear
L = 500;
h = linspace(1, L, L).';
N = 4096+1024;

% ����һ��ѭ����������в���
tic;
H1 = zeros(N+L-1, N);
for i = 1 : N
    H1(i : i + L - 1, i) = h;
end
tElapsed1 = toc;
disp(['������в�����ʱ��', num2str(tElapsed1), '�롣']);

% ��������ѭ����������в���
h = linspace(1, L, L);
tic;
H2 = zeros(N, N+L-1);
for i = 1 : N
    H2(i, i : i + L - 1) = h;
end
tElapsed2 = toc;
disp(['������в�����ʱ��', num2str(tElapsed2), '�롣']);
