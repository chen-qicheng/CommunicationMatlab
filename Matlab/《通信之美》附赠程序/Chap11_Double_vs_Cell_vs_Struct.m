AccessCnt = 1e6;
a = magic(2);
b{1} = magic(2);
c.data = magic(2);

tic;
for i = 1 : AccessCnt
    a;
end
tElapsed1 = toc;
disp(['����double�ͱ���', num2str(AccessCnt, '%.1e'), '�Σ�', ...
      '����ʱ��', num2str(tElapsed1), '�롣']);

tic;
for i = 1 : AccessCnt
    b{1};
end
tElapsed2 = toc;
disp(['����cell�ͱ���', num2str(AccessCnt, '%.1e'), '�Σ�', ...
      '����ʱ��', num2str(tElapsed2), '�롣']);

tic;
for i = 1 : AccessCnt
    c.data;
end
tElapsed3 = toc;
disp(['����struct�ͱ���', num2str(AccessCnt, '%.1e'), '�Σ�', ...
      '����ʱ��', num2str(tElapsed3), '�롣']);

