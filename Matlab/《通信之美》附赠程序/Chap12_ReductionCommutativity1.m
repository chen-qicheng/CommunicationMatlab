function Chap12_parfor_Commutativity
N = 5;

p1 = [1, 2; 3, 4];
for i = 1 : N
    p1 = mymultiply(p1, [i, i + 1; i + 2, i + 3]);
end

p2 = [1, 2; 3, 4];
parfor i = 1 : N
    p2 = mymultiply(p2, [i, i + 1; i + 2, i + 3]);
end

p3
p4

function Product = mymultiply(a, b)
Product = a * b;



