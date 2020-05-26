function Chap12_ReductionCommutativity2
N = 5;

p3 = [1, 2; 3, 4];
for i = 1 : N
    p3 = p3 * [i, i + 1; i + 2, i + 3];
end

p4 = [1, 2; 3, 4];
parfor i = 1 : N
    p4 = p4 * [i, i + 1; i + 2, i + 3];
end

p3
p4

function Product = mymultiply(a, b)
Product = a * b;



