clc
Pcw = 1e-4;
load SigmaTable_BIAWGN
Sigma = SigmaTab(11); % 选择1/2码率对应的Simga
f = @(u, y) 1/sqrt(2*pi)/Sigma * exp(-(y.^2 + 1) / (2*Sigma^2)) .*  ...
            cosh(y ./ (Sigma^2*(1+u))).^(1+u);
E0 = @(u) -log2(integraluserdefine(@(y) f(u, y), -1e5, 1e5));

R = [(0.05 : 0.05 : 0.45).'; 1/3; 0.49];
R = sort(R);
Nmin = zeros(length(R), 1, 'double');
for Idx = 1 : length(R)
    [~, Temp] = fminbnd(@(u) -(E0(u) - u*R(Idx)), 0, 1);
    ER = -Temp;
    Nmin(Idx) = ceil(log2(Pcw) / -ER);
end

figure;
semilogy(R, Nmin, 's-');
grid on; 
xlabel('Code rate'); ylabel('Minimum codeword length');
xlabel('R');