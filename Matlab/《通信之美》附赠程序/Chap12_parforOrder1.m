PoolObj = parpool(2);
parfor i = 1 : 5
    A1(i) = i;
end
delete(PoolObj);

A2 = zeros(1, 5, 'double');
for i = 1 : 5
    A2(i) = i;
end

[A1;A2]