s1 = 0;
parfor i = 1 : 100
    s1 = s1 - i;
end
s1

s2 = 100;
parfor i = 1 : 100
    s2 = i - s2; 
end


% ����Ĵ���M-Lint�ᱨ�����ǿ�����ȷ����
% s2 = 100;
% parfor i = 1 : 100
%     s2 = i + (s2); 
% end