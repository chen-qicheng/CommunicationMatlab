A = [10 20 30; 40 50 60; 70 80 90]; % 生成3*3的矩阵
for i = 1 : 9
    disp(['内存中第', num2str(i), '个元素为', num2str(A(i)), '。']);
end