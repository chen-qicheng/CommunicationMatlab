Lx = 1e5;
Lh = 1e3;
x = rand(Lx, 1); % ��������������ź�
h = rand(Lh, 1); % ����������ŵ��弤��Ӧ

tic;
y1 = conv(x,h);
tElapsed1 = toc;
disp(['MATLAB built-in����conv��ʱ��', num2str(tElapsed1), '�롣']);

tic;
y2 = zeros(Lx + Lh - 1, 1, 'double');
for n = 1 : Lx + Lh - 1
    Low = max(1, n+1-Lh);
    High = min(Lx, n);
    for k = Low : High 
        y2(n) = y2(n) + x(k) * h(n+1-k);
    end
end
tElapsed2 = toc;
disp(['MATLAB forѭ����ʱ��', num2str(tElapsed2), '�롣']);

tic;
y3 = conv_mex(x,h);
tElapsed3 = toc;
disp(['C���Ժ�ʱ��', num2str(tElapsed3), '�롣']);
 
% isequal(y1, y2)
sum(abs((y1 - y2)))
 
sum(abs((y1 - y3)))
