s1 = 0;
parfor i = 1 : 100
    s1 = s1 - i;
end
s1

s2 = 100;
parfor i = 1 : 100
    s2 = i - s2; 
end


% 下面的代码M-Lint会报错，但是可以正确运行
% s2 = 100;
% parfor i = 1 : 100
%     s2 = i + (s2); 
% end