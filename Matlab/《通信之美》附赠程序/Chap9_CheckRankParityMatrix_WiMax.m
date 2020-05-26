%% 802.16 Wimax
clear
tic;

%% 
n = [576; 672; 768; 864; 960; 1056; 1152; 1248; 1344; 1440; 1536; 1632; 1728; 1824; 1920; 2016; 2112; 2208; 2304]; % 19���볤
CodeRate = [1/2; 2/3; 2/3; 3/4; 3/4; 5/6]; % 6������
RowCntH = round((1 - CodeRate) * n'); % �������round�Ļ�����Щ���ݻ�������в��죬��Ϊ1-CodeRate��������Щ������
RowCntH = reshape(RowCntH',[], 1); % 19*6=114��H������
Zf = n / 24; % 19���볤��Ӧ19����ͬ����չ���ӣ�expansion factor��
RowCntHc = [12, 8, 8, 6, 6, 4]; % 6�����ʵ�Hc������
Z0 = 96; % һ���������չ���ӣ�expansion factor��

% Rate: 1/2
Hc{1} = [-1 94 73 -1 -1 -1 -1 -1 55 83 -1 -1  7  0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1;
         -1 27 -1 -1 -1 22 79  9 -1 -1 -1 12 -1  0  0 -1 -1 -1 -1 -1 -1 -1 -1 -1;
         -1 -1 -1 24 22 81 -1 33 -1 -1 -1  0 -1 -1  0  0 -1 -1 -1 -1 -1 -1 -1 -1;
         61 -1 47 -1 -1 -1 -1 -1 65 25 -1 -1 -1 -1 -1  0  0 -1 -1 -1 -1 -1 -1 -1;
         -1 -1 39 -1 -1 -1 84 -1 -1 41 72 -1 -1 -1 -1 -1  0  0 -1 -1 -1 -1 -1 -1;
         -1 -1 -1 -1 46 40 -1 82 -1 -1 -1 79  0 -1 -1 -1 -1  0  0 -1 -1 -1 -1 -1;
         -1 -1 95 53 -1 -1 -1 -1 -1 14 18 -1 -1 -1 -1 -1 -1 -1  0  0 -1 -1 -1 -1;
         -1 11 73 -1 -1 -1  2 -1 -1 47 -1 -1 -1 -1 -1 -1 -1 -1 -1  0  0 -1 -1 -1;
         12 -1 -1 -1 83 24 -1 43 -1 -1 -1 51 -1 -1 -1 -1 -1 -1 -1 -1  0  0 -1 -1;
         -1 -1 -1 -1 -1 94 -1 59 -1 -1 70 72 -1 -1 -1 -1 -1 -1 -1 -1 -1  0  0 -1;
         -1 -1  7 65 -1 -1 -1 -1 39 49 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  0  0;
         43 -1 -1 -1 -1 66 -1 41 -1 -1 -1 26  7 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  0];


% Rate: 2/3A
Hc{2} = [ 3  0 -1 -1  2  0 -1  3  7 -1  1  1 -1 -1 -1 -1  1  0 -1 -1 -1 -1 -1 -1;
         -1 -1  1 -1 36 -1 -1 34 10 -1 -1 18  2 -1  3  0 -1  0  0 -1 -1 -1 -1 -1;
         -1 -1 12  2 -1 15 -1 40 -1  3 -1 15 -1  2 13 -1 -1 -1  0  0 -1 -1 -1 -1;
         -1 -1 19 24 -1  3  0 -1  6 -1 17 -1 -1 -1  8 39 -1 -1 -1  0  0 -1 -1 -1;
         20 -1  6 -1 -1 10 29 -1 -1 28 -1 14 -1 38 -1 -1  0 -1 -1 -1  0  0 -1 -1;
         -1 -1 10 -1 28 20 -1 -1  8 -1 36 -1  9 -1 21 45 -1 -1 -1 -1 -1  0  0 -1;
         35 25 -1 37 -1 21 -1 -1  5 -1 -1  0 -1  4 20 -1 -1 -1 -1 -1 -1 -1  0  0;
         -1  6  6 -1 -1 -1  4 -1 14 30 -1  3 36 -1 14 -1  1 -1 -1 -1 -1 -1 -1  0];

% Rate: 2/3B
Hc{3} = [ 2 -1 19 -1 47 -1 48 -1 36 -1 82 -1 47 -1 15 -1 95  0 -1 -1 -1 -1 -1 -1;
         -1 69 -1 88 -1 33 -1  3 -1 16 -1 37 -1 40 -1 48 -1  0  0 -1 -1 -1 -1 -1;
         10 -1 86 -1 62 -1 28 -1 85 -1 16 -1 34 -1 73 -1 -1 -1  0  0 -1 -1 -1 -1;
         -1 28 -1 32 -1 81 -1 27 -1 88 -1  5 -1 56 -1 37 -1 -1 -1  0  0 -1 -1 -1;
         23 -1 29 -1 15 -1 30 -1 66 -1 24 -1 50 -1 62 -1 -1 -1 -1 -1  0  0 -1 -1;
         -1 30 -1 65 -1 54 -1 14 -1  0 -1 30 -1 74 -1  0 -1 -1 -1 -1 -1  0  0 -1;
         32 -1  0 -1 15 -1 56 -1 85 -1  5 -1  6 -1 52 -1  0 -1 -1 -1 -1 -1  0  0;
         -1  0 -1 47 -1 13 -1 61 -1 84 -1 55 -1 78 -1 41 95 -1 -1 -1 -1 -1 -1  0];

% Rate: 3/4A
Hc{4} = [ 6 38  3 93 -1 -1 -1 30 70 -1 86 -1 37 38  4 11 -1 46 48  0 -1 -1 -1 -1;
         62 94 19 84 -1 92 78 -1 15 -1 -1 92 -1 45 24 32 30 -1 -1  0  0 -1 -1 -1;
         71 -1 55 -1 12 66 45 79 -1 78 -1 -1 10 -1 22 55 70 82 -1 -1  0  0 -1 -1;
         38 61 -1 66  9 73 47 64 -1 39 61 43 -1 -1 -1 -1 95 32  0 -1 -1  0  0 -1;
         -1 -1 -1 -1 32 52 55 80 95 22  6 51 24 90 44 20 -1 -1 -1 -1 -1 -1  0  0;
         -1 63 31 88 20 -1 -1 -1  6 40 56 16 71 53 -1 -1 27 26 48 -1 -1 -1 -1  0];

% Rate: 3/4B
Hc{5} = [-1 81 -1 28 -1 -1 14 25 17 -1 -1 85 29 52 78 95 22 92  0  0 -1 -1 -1 -1;
         42 -1 14 68 32 -1 -1 -1 -1 70 43 11 36 40 33 57 38 24 -1  0  0 -1 -1 -1;
         -1 -1 20 -1 -1 63 39 -1 70 67 -1 38  4 72 47 29 60  5 80 -1  0  0 -1 -1;
         64  2 -1 -1 63 -1 -1  3 51 -1 81 15 94  9 85 36 14 19 -1 -1 -1  0  0 -1;
         -1 53 60 80 -1 26 75 -1 -1 -1 -1 86 77  1  3 72 60 25 -1 -1 -1 -1  0  0;
         77 -1 -1 -1 15 28 -1 35 -1 72 30 68 85 84 26 64 11 89  0 -1 -1 -1 -1  0];

% Rate: 5/6
Hc{6} = [ 1 25 55 -1 47  4 -1 91 84  8 86 52 82 33  5  0 36 20 4  77 80  0 -1 -1;
         -1  6 -1 36 40 47 12 79 47 -1 41 21 12 71 14 72  0 44 49  0  0  0  0 -1;
         51 81 83  4 67 -1 21 -1 31 24 91 61 81  9 86 78 60 88 67 15 -1 -1  0  0;
         50 -1 50 15 -1 36 13 10 11 20 53 90 29 92 57 30 84 92 11 66 80 -1 -1  0];

p = cell(19 * 6, 1); % 114��H��p��ֵ�����pֵ������114��H�е�ÿ���Ӿ����ѭ����λ��λ��
H = cell(19 * 6, 1); % 114��H
Rank = zeros(19 * 6, 1, 'double'); % 114��H������
for CodeRateIdx = 2 : 2 % ��ʾ6������
    if CodeRateIdx == 2 % ���ݱ�׼��RateΪ2/3Aʱ��Ҫ��������
        for CodeLenIdx = 1 : 19 % ÿ�����ʰ���19���볤
            for RowIdx = 1 : 8 % �б꣬�������ʵ�Hc��8��
                for ColIdx = 1 : 24 % �б�
                    if Hc{CodeRateIdx}(RowIdx,ColIdx) <= 0
                        p{(CodeRateIdx-1)*19 + CodeLenIdx}(RowIdx, ColIdx) = Hc{CodeRateIdx}(RowIdx, ColIdx);
                    else
                        p{(CodeRateIdx-1)*19 + CodeLenIdx}(RowIdx, ColIdx) = mod(Hc{CodeRateIdx}(RowIdx, ColIdx), Zf(CodeLenIdx));
                    end
                    if p{(CodeRateIdx-1)*19 + CodeLenIdx}(RowIdx, ColIdx) == -1
                        H{(CodeRateIdx-1)*19 + CodeLenIdx}((RowIdx-1)*Zf(CodeLenIdx)+1 : RowIdx*Zf(CodeLenIdx), (ColIdx-1)*Zf(CodeLenIdx)+1 : ColIdx*Zf(CodeLenIdx)) = zeros(Zf(CodeLenIdx));
                    else
                        H{(CodeRateIdx-1)*19 + CodeLenIdx}((RowIdx-1)*Zf(CodeLenIdx)+1 : RowIdx*Zf(CodeLenIdx), (ColIdx-1)*Zf(CodeLenIdx)+1 : ColIdx*Zf(CodeLenIdx)) = circshift(eye(Zf(CodeLenIdx)), p{(CodeRateIdx-1)*19 + CodeLenIdx}(RowIdx, ColIdx));
                    end
                end
            end
            Rank((CodeRateIdx-1)*19 + CodeLenIdx) = rank(gf(H{(CodeRateIdx-1)*19 + CodeLenIdx}));
            if Rank((CodeRateIdx-1)*19 + CodeLenIdx) == RowCntH((CodeRateIdx-1)*19 + CodeLenIdx)
                disp(['The ', num2str((CodeRateIdx-1)*19 + CodeLenIdx), 'th parity matrix''s rank is ',num2str(Rank((CodeRateIdx-1)*19 + CodeLenIdx)),'. It''s full row-rank.']);
            else
                disp(['The ', num2str((CodeRateIdx-1)*19 + CodeLenIdx), 'th parity matrix''s rank is ',num2str(Rank((CodeRateIdx-1)*19 + CodeLenIdx)),'. It''s not full row-rank.']);
            end
        end
    else
        for CodeLenIdx = 1 : 19 % ÿ�����ʰ���19���볤
            for RowIdx = 1 : RowCntHc(CodeRateIdx) % �б�
                for ColIdx = 1 : 24 % �б�
                    if Hc{CodeRateIdx}(RowIdx,ColIdx) <= 0
                        p{(CodeRateIdx-1)*19 + CodeLenIdx}(RowIdx, ColIdx) = Hc{CodeRateIdx}(RowIdx, ColIdx);
                    else
                        p{(CodeRateIdx-1)*19 + CodeLenIdx}(RowIdx, ColIdx) = floor(Hc{CodeRateIdx}(RowIdx, ColIdx) * Zf(CodeLenIdx) / Z0);
                    end
                    if p{(CodeRateIdx-1)*19 + CodeLenIdx}(RowIdx, ColIdx) == -1
                        H{(CodeRateIdx-1)*19 + CodeLenIdx}((RowIdx-1)*Zf(CodeLenIdx)+1 : RowIdx*Zf(CodeLenIdx), (ColIdx-1)*Zf(CodeLenIdx)+1 : ColIdx*Zf(CodeLenIdx)) = zeros(Zf(CodeLenIdx));
                    else
                        H{(CodeRateIdx-1)*19 + CodeLenIdx}((RowIdx-1)*Zf(CodeLenIdx)+1 : RowIdx*Zf(CodeLenIdx), (ColIdx-1)*Zf(CodeLenIdx)+1 : ColIdx*Zf(CodeLenIdx)) = circshift(eye(Zf(CodeLenIdx)), p{(CodeRateIdx-1)*19 + CodeLenIdx}(RowIdx, ColIdx));
                    end
                end
            end
            Rank((CodeRateIdx-1)*19 + CodeLenIdx) = rank(gf(H{(CodeRateIdx-1)*19 + CodeLenIdx}));
            if Rank((CodeRateIdx-1)*19 + CodeLenIdx) == RowCntH((CodeRateIdx-1)*19 + CodeLenIdx)
                disp(['The ', num2str((CodeRateIdx-1)*19 + CodeLenIdx), 'th parity matrix''s rank is ',num2str(Rank((CodeRateIdx-1)*19 + CodeLenIdx)),'. It''s full row-rank.']);
            else
                disp(['The ', num2str((CodeRateIdx-1)*19 + CodeLenIdx), 'th parity matrix''s rank is ',num2str(Rank((CodeRateIdx-1)*19 + CodeLenIdx)),'. It''s not full row-rank.']);
            end
        end
    end
end
		 
%%
toc