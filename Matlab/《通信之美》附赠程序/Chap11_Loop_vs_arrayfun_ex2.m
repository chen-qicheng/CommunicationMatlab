% �����ȵ�ѭ����죬��������ȵ�ѭ������������arrayfun + ���������
clear;
M = 1000;
N = 10000;
a = ones(M, N);
WirieIdxEnd = randi([20, N/2], M, 1); % �������ÿ�и�ֵ��ĩβ���к�

% ����һ��ѭ����������в���
b = a;
tic;
for i = 1 : M
    b(i, 1 : WirieIdxEnd(i)) = 99;
end
tElapsed1 = toc;
disp(['ѭ����������в�����ʱ��', num2str(tElapsed1), '�롣']);

% ��������arrayfun + ���������
c = a.';
tic;
BaseIdx = (1 : N : (M-1) * N + 1).'; % ÿ�е���ʼ��ַ
EndIdx = BaseIdx + WirieIdxEnd - 1;
IdxEachCol = arrayfun(@linspace, BaseIdx, EndIdx, WirieIdxEnd, 'UniformOutput', false);
IdxEachCol = cellfun(@transpose, IdxEachCol,'UniformOutput', false);
temp = cell2mat(IdxEachCol);
c(temp) = 99;
tElapsed2 = toc;
disp(['arrayfun + ��������̺�ʱ��', num2str(tElapsed2), '�롣']);
isequal(b, c.')

% ��������ѭ����������в���
d = a.';
tic;
for i = 1 : M
    d(1 : WirieIdxEnd(i), i) = 99;
end
tElapsed3 = toc;
disp(['ѭ����������в�����ʱ��', num2str(tElapsed3), '�롣']);
isequal(b, d.')
