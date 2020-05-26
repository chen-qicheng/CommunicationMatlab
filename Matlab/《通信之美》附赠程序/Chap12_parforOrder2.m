for i = 1 : 5
    disp(num2str(i));
end

PoolObj = parpool(2);
parfor i = 1 : 5
    disp(num2str(i));
end
delete(PoolObj);
