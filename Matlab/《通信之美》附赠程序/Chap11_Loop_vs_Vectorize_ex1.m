% N�Ƚ�Сʱ����������̸��죬��N�Ƚϴ�ʱ����������̾ͱ�����
% �������겻clear���������ٴ�����ʱ��������������������̱�̾ͱ���ˡ�
% �о���MALTAB�Ѿ�����workspace������������ˣ�����H3 = zeros(N+L-1, N);��һ�е�����ʱ�����С
% �����ȵ�ѭ����죬�����������������
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

% �����������������
tic;
H3 = zeros(N+L-1, N);
Idx = (1 : L).';
ColIdx = 0 : N+L : (N+L)*(N-1);
MatIdx = repmat(Idx, 1, N) + repmat(ColIdx, L, 1);
H3(MatIdx) = repmat(h, N, 1);
tElapsed3 = toc;
disp(['��������̺�ʱ��', num2str(tElapsed3), '�롣']);
