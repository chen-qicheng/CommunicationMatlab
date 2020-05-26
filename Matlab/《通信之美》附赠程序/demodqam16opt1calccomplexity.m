function [BitData, MeanMultiCnt, MeanAddCnt, MeanCompareCnt] = ...
           demodqam16opt1calccomplexity(Conste, Normalized)
% 函数描述：对接收到的星座图进行硬判决，计算所需的乘法次数、加法次数
%           和比较次数。采用自己的优化算法（一）
%
% called by：各种需要进行星座解调硬判决的m文件
% 输入参数：
%   Conste：接收到的星座点（已功率归一化）
%   Normalized: 指定功率是否归一化，字符串形式，
%               只能为Normalized或者NonNormalized，否则报错
% 输出参数
%   BitData：输出的0、1比特信息
%   MeanMultiCnt：乘法次数的统计平均
%   MeanAddCnt：加法次数的统计平均
%   MeanCompareCnt：比较次数的统计平均
%
%               Last Version : 1.0
%               This Version : 2.0
%     This File generated by : 张力
%       This File updated by : 张力
%
% Revision History ：
%     时间            具体工作
%     20150719        v1.0的输入参数只能为标量，该版本可以为向量
%
% Email: larlyii@outlook.com


% 星座映射的规则按照MATLAB默认的Gray映射规则，16个星座点分别如下
% 十进制表示如下
% 0   4   12   8
% 1   5   13   9
% 3   7   15  11
% 2   6   14  10
% 二进制表示如下
% 0000    0100    1100    1000
% 0001    0101    1101    1001
% 0011    0111    1111    1011
% 0010    0110    1110    1010

% 25个区域的序号如下
%   5 | 10 | 15 | 20 | 25
% ----|----|----|----|----
%   4 |  9 | 14 | 19 | 24
% ----|----|----|----|----
%   3 |  8 | 13 | 18 | 23
% ----|----|----|----|----
%   2 |  7 | 12 | 17 | 22
% ----|----|----|----|----
%   1 |  6 | 11 | 16 | 21

% 首先列出一张表，4行16列，每列代表二进制比特串，16列代表16个星座点
temp = (0 : 15)';
MAP = de2bi(temp, 'left-msb')';
BITTABLE = [ ...
    % 16*25的矩阵，每一列对应每个区域，而每一列中的每4行对应区域中的星座点，
    % 一共4个星座点，若区域中没有4个星座点，用0填充
    % 每个区域的星座点排列顺序如下：
    % 只包含1个星座点的区域：略
    % 包含2个星座点的区域：从下到上
    % 包含4个星座点的区域：左下，左上，右下，右上
    % 第1列如下
    [MAP(:,2+1); zeros(12, 1)], ... % 2
    [MAP(:,2+1); MAP(:,3+1); zeros(8, 1)], ... % 2,3
    [MAP(:,3+1); MAP(:,1+1); zeros(8, 1)], ... % 3,1
    [MAP(:,1+1); MAP(:,0+1); zeros(8, 1)], ... % 1,0
    [MAP(:,0+1); zeros(12, 1)], ... % 0
    ... % 第2列如下
    [MAP(:,2+1); MAP(:,6+1); zeros(8, 1)], ... % 2,6
    [MAP(:,2+1); MAP(:,3+1); MAP(:,6+1); MAP(:,7+1)], ... % 2,3,6,7
    [MAP(:,3+1); MAP(:,1+1); MAP(:,7+1); MAP(:,5+1)], ... % 3,1,7,5
    [MAP(:,1+1); MAP(:,0+1); MAP(:,5+1); MAP(:,4+1)], ... % 1,0,5,4
    [MAP(:,0+1); MAP(:,4+1); zeros(8, 1)], ... % 0,4
    ... % 第3列如下
    [MAP(:,6+1); MAP(:,14+1); zeros(8, 1)], ... % 6,14
    [MAP(:,6+1); MAP(:,7+1); MAP(:,14+1); MAP(:,15+1)], ... % 6,7,14,15
    [MAP(:,7+1); MAP(:,5+1); MAP(:,15+1); MAP(:,13+1)], ... % 7,5,15,13
    [MAP(:,5+1); MAP(:,4+1); MAP(:,13+1); MAP(:,12+1)], ... % 5,4,13,12
    [MAP(:,4+1); MAP(:,12+1); zeros(8, 1)], ... % 4,12
    ... % 第4列如下
    [MAP(:,14+1); MAP(:,10+1); zeros(8, 1)], ... % 14,10
    [MAP(:,14+1); MAP(:,15+1); MAP(:,10+1); MAP(:,11+1)], ... % 14,15,10,11
    [MAP(:,15+1); MAP(:,13+1); MAP(:,11+1); MAP(:,9+1)], ... % 15,13,11,9
    [MAP(:,13+1); MAP(:,12+1); MAP(:,9+1); MAP(:,8+1)], ... % 13,12,9,8
    [MAP(:,12+1); MAP(:,8+1); zeros(8, 1)], ... % 12,8
    ... % 第5列如下
    [MAP(:,10+1); zeros(12, 1)], ... % 10
    [MAP(:,10+1); MAP(:,11+1); zeros(8, 1)], ... % 10,11
    [MAP(:,11+1); MAP(:,9+1); zeros(8, 1)], ... % 11,9
    [MAP(:,9+1); MAP(:,8+1); zeros(8, 1)], ... % 9,8
    [MAP(:,8+1); zeros(12, 1)], ... % 8
    ];

if strcmp(Normalized, 'Normalized')
    Conste = Conste * sqrt(10); % 去归一化
elseif strcmp(Normalized, 'NonNormalized')
    % do nothing
else
    error('第二个参数必须为Normalized或者NonNormalized');
end

CompareCnt_I = 0; % 判定接收到的星座点所处的区域需要的同相分量的比较次数
CompareCnt_Q = 0; % 判定接收到的星座点所处的区域需要的正交分量的比较次数
AddCnt_I = 0; % 处理实部需要的加法次数
AddCnt_Q = 0; % 处理虚部需要的加法次数
MultiCnt_I = 0; % 处理实部需要的乘法次数
MultiCnt_Q = 0; % 处理虚部需要的乘法次数
Cc = 0; % 计算了欧氏距离后求最小值的比较次数
for i = 1 : length(Conste)
    Conste_I = real(Conste(i));
    Conste_Q = imag(Conste(i));

    % 判断实部
    if Conste_I < -1
        CompareCnt_I = CompareCnt_I + 1;
        if Conste_I < -3
            CompareCnt_I = CompareCnt_I + 1;
            RegionIdx_I = 1; % 处于最左边的一列
            Dis_I = (Conste_I + 3) ^ 2;
            AddCnt_I = AddCnt_I + 1;
            MultiCnt_I = MultiCnt_I + 1;
        else
            CompareCnt_I = CompareCnt_I + 1;
            RegionIdx_I = 2; % 处于左边第2列
            Dis_I = (Conste_I - [-3; -1]) .^ 2;
            AddCnt_I = AddCnt_I + 2;
            MultiCnt_I = MultiCnt_I + 2;
        end
    else
        CompareCnt_I = CompareCnt_I + 1;
        if Conste_I < 1
            CompareCnt_I = CompareCnt_I + 1;
            RegionIdx_I = 3; % 处于左边第3列
            Dis_I = (Conste_I - [-1; 1]) .^ 2;
            AddCnt_I = AddCnt_I + 2;
            MultiCnt_I = MultiCnt_I + 2;
        else
            CompareCnt_I = CompareCnt_I + 1;
            if Conste_I < 3
                CompareCnt_I = CompareCnt_I + 1;
                RegionIdx_I = 4; % 处于左边第4列
                Dis_I = (Conste_I - [1; 3]) .^ 2;
                AddCnt_I = AddCnt_I + 2;
                MultiCnt_I = MultiCnt_I + 2;
            else
                CompareCnt_I = CompareCnt_I + 1;
                RegionIdx_I = 5; % 处于左边第5列
                Dis_I = (Conste_I - 3) ^ 2;
                AddCnt_I = AddCnt_I + 1;
                MultiCnt_I = MultiCnt_I + 1;
            end
        end
    end
    % 判断虚部
    if Conste_Q < -1
        CompareCnt_Q = CompareCnt_Q + 1;
        if Conste_Q < -3
            CompareCnt_Q = CompareCnt_Q + 1;
            RegionIdx_Q = 1; % 处于最下边的一行
            Dis_Q = (Conste_Q + 3) ^ 2;
            AddCnt_Q = AddCnt_Q + 1;
            MultiCnt_Q = MultiCnt_Q + 1;
        else
            CompareCnt_Q = CompareCnt_Q + 1;
            RegionIdx_Q = 2; % 处于从下数第2行
            Dis_Q = (Conste_Q - [-3; -1]) .^ 2;
            AddCnt_Q = AddCnt_Q + 2;
            MultiCnt_Q = MultiCnt_Q + 2;
        end
    else
        CompareCnt_Q = CompareCnt_Q + 1;
        if Conste_Q < 1
            CompareCnt_Q = CompareCnt_Q + 1;
            RegionIdx_Q = 3; % 处于从下数第3行
            Dis_Q = (Conste_Q - [-1; 1]) .^ 2;
            AddCnt_Q = AddCnt_Q + 2;
            MultiCnt_Q = MultiCnt_Q + 2;
        else
            CompareCnt_Q = CompareCnt_Q + 1;
            if Conste_Q < 3
                CompareCnt_Q = CompareCnt_Q + 1;
                RegionIdx_Q = 4; % 处于从下数第4行
                Dis_Q = (Conste_Q - [1; 3]) .^ 2;
                AddCnt_Q = AddCnt_Q + 2;
                MultiCnt_Q = MultiCnt_Q + 2;
            else
                CompareCnt_Q = CompareCnt_Q + 1;
                RegionIdx_Q = 5; % 处于从下数第5行
                Dis_Q = (Conste_Q - 3) ^ 2;
                AddCnt_Q = AddCnt_Q + 1;
                MultiCnt_Q = MultiCnt_Q + 1;
            end
        end
    end

    if isscalar(Dis_I)|| isscalar(Dis_Q)
        Dis = Dis_I + Dis_Q;
        if isscalar(Dis_I) && isscalar(Dis_Q)
            % 如果星座点处于4个角上，是不需要计算星座点间的距离的，
            % 但是由于为了代码本身的简洁，上面的代码将加法和乘法次数加了1，
            % 所以这里要减1
            AddCnt_I = AddCnt_I - 1;
            AddCnt_Q = AddCnt_Q - 1;
            MultiCnt_I = MultiCnt_I - 1;
            MultiCnt_Q = MultiCnt_Q - 1;
        else
            % 如果其中一个是向量（即接收到的星座点处于四条边外）时，
            % 虽然MATLAB语法看似是做了一次加法，实际是长度为2的向量的加法，
            % 相当于2次加法运算
            AddCnt_I = AddCnt_I + 1;
            AddCnt_Q = AddCnt_Q + 1;
        end
    else
        % 如果两个都是向量（即接收到的星座点处于星座图中间）时，
        % 虽然MATLAB语法看似是做了2次加法，实际是长度为2的向量的加法，
        % 相当于4次加法运算
        Dis = [Dis_I(1) + Dis_Q; Dis_I(2) + Dis_Q];
        AddCnt_I = AddCnt_I + 2;
        AddCnt_Q = AddCnt_Q + 2;
    end


    [~, Idx] = min(Dis);
    if isscalar(Dis)
        % 如果Dis为标量（即接收到的星座点处于四个角上）时，是不需要比较运算的
    elseif length(Dis) == 2
        % 如果Dis长度为2（即接收到的星座点处于四个边上）时，需要1次比较运算
        Cc = Cc + 1;
    else
        % 如果Dis长度为4（即接收到的星座点处于星座图中间）时，需要3次比较运算
        Cc = Cc + 3;
    end
    BitData((i-1)*4+1:i*4, :) = ...
        BITTABLE((Idx-1) * 4 + 1 : Idx * 4, (RegionIdx_I-1) * 5 + RegionIdx_Q);
    % 行数：(Idx-1) * 4 + 1 : Idx * 4;
    % 列数：(RegionIdx_I-1) * 5 + RegionIdx_Q;
end
MeanMultiCnt = (MultiCnt_I + MultiCnt_Q) / length(Conste);
MeanAddCnt = (AddCnt_I + AddCnt_Q) / length(Conste);
MeanCompareCnt = (CompareCnt_I + CompareCnt_Q + Cc) / length(Conste);


