R = [(0.05 : 0.05 : 0.95).'; 1/3; 2/3];
R = sort(R);
CAWGN = @(r, EbN0) 0.5 * log2(1 + 2 * r * EbN0);

ebn0 = @(r) fzero(@(EbN0) CAWGN(r, EbN0) - r, 1);
EbN0 = arrayfun(ebn0, R);
EbN0dB = 10 * log10(EbN0);
