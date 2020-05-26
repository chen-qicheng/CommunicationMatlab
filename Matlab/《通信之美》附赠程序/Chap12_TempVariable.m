a = 99;
parfor i = 1 : 5 % i为循环变量
    a = i; % a为临时变量
    disp(a);
end
disp(a);