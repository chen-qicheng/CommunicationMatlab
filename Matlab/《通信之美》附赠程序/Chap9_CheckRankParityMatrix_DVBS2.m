%% DVB-S2

fp = fopen('程序运行日志.txt', 'w');
t = clock;
fprintf('Program running begin: %d/%d/%d %02d:%02d:%02d\n',t(1),t(2),t(3),t(4),t(5),round(t(6)));
fprintf(fp, 'Program running begin: %d/%d/%d %02d:%02d:%02d\n',t(1),t(2),t(3),t(4),t(5),round(t(6)));

%%
tic;
CodeID = [
%     4/5, 64800;
%     5/6, 64800;
%     8/9, 64800;
%     9/10, 64800;

%     1/5, 16200;
%     1/3, 16200;
%     2/5, 16200;
%     4/9, 16200;
%     3/5, 16200;
%     2/3, 16200;
%     11/15, 16200;
%     7/9, 16200;
%     37/45, 16200;
    8/9, 16200];
CodeRateCnt = size(CodeID, 1);
RowCnt = round((1 - CodeID(:,1)) .* CodeID(:,2));
Rank = zeros(CodeRateCnt, 1, 'single');
for i = 1 : CodeRateCnt
    H = ldpcdvbs2(CodeID(i, 1), CodeID(i, 2));
    Rank(i) = rank(gf(single(full(H))));
end

%%
tElapsed = toc;
t = clock;

fprintf('Program run end: %d/%d/%d %02d:%02d:%02d\n',t(1),t(2),t(3),t(4),t(5),round(t(6)));
fprintf(fp, 'Program run end: %d/%d/%d %02d:%02d:%02d\n',t(1),t(2),t(3),t(4),t(5),round(t(6)));
fprintf('Elapsed time is %f seconds.\n', tElapsed);
fprintf(fp, 'Elapsed time is %f seconds.\n\n\n', tElapsed);
fclose(fp);

clear H
save(['Rank_',num2str(t(1)), '_', num2str(t(2), '%02d'), '_', num2str(t(3), '%02d'), ...
    '_', num2str(t(4), '%02d'), 'hour_', num2str(t(5), '%02d'), 'min.mat']);
