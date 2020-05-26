
A = [10 20 30; 40 50 60; 70 80 90]
B = A(2, 3)          % 下标索引，取出第2行第3列的1个元素
C = A(2 : 3, 2 : 3)  % 下标索引，取出第2、3行与第2、3列交叉的四个元素
D = A([4, 7, 8])     % 线性索引，取出序号为4、7、8的三个元素
LogiIdx = logical([0 1 0; 1 0 1; 0 0 1]);
E = A(LogiIdx)       % 逻辑索引，取出索引号为真的对应位置的A中的元素
F = A(A > 35)        % 逻辑索引，取出A中大于35的元素
