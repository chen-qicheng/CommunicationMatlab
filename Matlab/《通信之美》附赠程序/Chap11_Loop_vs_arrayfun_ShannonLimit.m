R = [(0.05 : 0.05 : 0.95).'; 1/3; 2/3];
R = sort(R);
CAWGN = @(r, EbN0) 0.5 * log2(1 + 2 * r * EbN0);
ebn0 = @(r) fzero(@(EbN0) CAWGN(r, EbN0) - r, 1);

tic;
EbN01 = arrayfun(ebn0, R);
EbN01dB = 10 * log10(EbN01);
tElapsed1 = toc;
disp(['采用arrayfun耗时：', num2str(tElapsed1), '秒。']);
  
tic;
EbN02 = zeros(length(R), 1, 'double');
for i = 1 : length(R)
    EbN02(i) = ebn0(R(i));
end
EbN02dB = 10 * log10(EbN02);
tElapsed2 = toc;
disp(['采用for循环耗时：', num2str(tElapsed2), '秒。']);
