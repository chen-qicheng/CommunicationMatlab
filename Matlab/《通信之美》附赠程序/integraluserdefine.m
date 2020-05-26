function q = integraluserdefine(fun, xmin, xmax)
Temp = integral(fun, xmin, xmax);
while isnan(Temp)
    xmin = xmin / 2;
    xmax = xmax / 2;
    Temp = integral(fun, xmin, xmax);
end
q = Temp;