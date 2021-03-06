function [BitData, MeanCompareCnt] = demodqam16opt2calccomplexity(Conste, Normalized)
% 函数描述：对接收到的星座图进行硬判决，采用自己的优化算法（二）
%
% called by：各种需要进行星座解调硬判决的m文件
% 输入参数：
%   Conste：接收到的星座点（已功率归一化）
%   Normalized: 指定功率是否归一化，字符串形式，
%               只能为Normalized或者NonNormalized，否则报错
% 输出参数
%   BitData：输出的0、1比特信息
%
%               Last Version : 1.0
%               This Version : 2.0
%     This File generated by : 张力
%       This File updated by : 张力
%
% Revision History ：
%     时间            具体工作
%     20120719        v1.0的输入参数只能为标量，该版本可以为向量
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

if strcmp(Normalized, 'Normalized')
    Conste = Conste * sqrt(10); % 去归一化
elseif strcmp(Normalized, 'NonNormalized')
    % do nothing
else
    error('第二个参数必须为Normalized或者NonNormalized');
end

BitData = false(4, length(Conste));
BIT = logical([0,0; 0,1; 1,0; 1,1]');
CompareCnt_I = 0;
CompareCnt_Q = 0;
for i = 1 : length(Conste)
    Conste_I = real(Conste(i));
    Conste_Q = imag(Conste(i));

    % 判断实部
    if Conste_I < 0
        CompareCnt_I = CompareCnt_I + 1;
        if Conste_I < -2
            CompareCnt_I = CompareCnt_I + 1;
            BitData_I = BIT(:,1);
        else % -2到0
            CompareCnt_I = CompareCnt_I + 1;
            BitData_I = BIT(:,2);
        end
    else
        CompareCnt_I = CompareCnt_I + 1;
        if Conste_I < 2 % 0到2
            CompareCnt_I = CompareCnt_I + 1;
            BitData_I = BIT(:,4);
        else % 大于2
            CompareCnt_I = CompareCnt_I + 1;
            BitData_I = BIT(:,3);
        end
    end
    % 判断虚部
    if Conste_Q < 0
        CompareCnt_Q = CompareCnt_Q + 1;
        if Conste_Q < -2
            CompareCnt_Q = CompareCnt_Q + 1;
            BitData_Q = BIT(:,3);
        else % -2到0
            CompareCnt_Q = CompareCnt_Q + 1;
            BitData_Q = BIT(:,4);
        end
    else
        CompareCnt_Q = CompareCnt_Q + 1;
        if Conste_Q < 2 % 0到2
            CompareCnt_Q = CompareCnt_Q + 1;
            BitData_Q = BIT(:,2);
        else % 大于2
            CompareCnt_Q = CompareCnt_Q + 1;
            BitData_Q = BIT(:,1);
        end
    end

    BitData(:, i) = [BitData_I; BitData_Q];
end
BitData = double(reshape(BitData, [], 1));
MeanCompareCnt = (CompareCnt_I + CompareCnt_Q) / length(Conste);

