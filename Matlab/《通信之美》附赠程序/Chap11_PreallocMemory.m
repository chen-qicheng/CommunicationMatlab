clear
Len = 1e8;
tic;
for k = 1 : Len
	a(k) = k;
end
tElapsed1 = toc;
disp(['���鳤��Ϊ', num2str(Len, '%g'), 'ʱ��', ...
     '��Ԥ�����ڴ��ʱ��', num2str(tElapsed1), '�롣']);

tic;
b = zeros(1, Len, 'double');
for k = 1 : Len
	b(k) = k;
end
tElapsed2 = toc;
disp(['���鳤��Ϊ', num2str(Len, '%g'), 'ʱ��', ...
      'Ԥ�����ڴ��ʱ��', num2str(tElapsed2), '�롣']);
