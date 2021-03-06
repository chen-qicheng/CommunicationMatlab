function Preamble = pregen()
ShortTrainingSymbols = sqrt(13/6) * ... % ��Ƶ��Ƶ������
                       [0 0  1+1j 0 ...
                        0 0 -1-1j 0 ...
                        0 0  1+1j 0 ...
                        0 0 -1-1j 0 ...
                        0 0 -1-1j 0 ...
                        0 0  1+1j 0 ...
                        0 0  0    0 ...
                        0 -1-1j 0 0 ...
                        0 -1-1j 0 0 ...
                        0  1+1j 0 0 ...
                        0  1+1j 0 0 ...
                        0  1+1j 0 0 ...
                        0  1+1j 0 0].';
UsedSubcIdx = [7:32 34:59]; % ��Ч���ز����
ReMappingIdx=[33:64 1:32]; % ���°������ز��������
FreqDomain = zeros(64, 1);
FreqDomain(UsedSubcIdx) = ShortTrainingSymbols;
IFFTIn = zeros(64, 1);
IFFTIn(ReMappingIdx) = FreqDomain;
ShortTrainingTime = ifft(IFFTIn);
Preamble = repmat([ShortTrainingTime(49:64); ShortTrainingTime], 100, 1);


