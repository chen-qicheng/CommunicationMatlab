function Chap12_ReductionAssociativity

N = 10;

s1 = 0;
for i = 1 : N
    s1 = myadd(s1, i);
end

s2 = 0;
parfor i = 1 : N
    s2 = myadd(s2, i);
end

s3 = 0;
for i = 1 : N
    s3 = mysub(s3, i);
end

s4 = 0;
parfor i = 1 : N
    s4 = mysub(s4, i);
end

s1
s2
s3
s4


function Sub = mysub(a, b)
Sub = a - b;

function Sum = myadd(a, b)
Sum = a + b;

