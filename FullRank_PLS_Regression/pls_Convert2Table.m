
function [Xtable, Ytable] = pls_Convert2Table(X, Y)

[X_rows, ~] = size(X);

RowIndex = 1:1:X_rows;
RowIndex=RowIndex';
RowLabel = 'R';

for i=1:size(RowIndex,1)
    b = num2str(RowIndex(i));
    b = strcat(RowLabel,b);
    c = cellstr(b);
    RowNames(i) = c;
end

Xtable = array2table(X, 'RowNames', RowNames);
Ytable = array2table(Y, 'RowNames', RowNames);


