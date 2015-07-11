
if prepro == 1
    % MATRIX CENTERED about column means
    [rows, cols] = size(X);
    X = (X-repmat(mean(X),rows, 1));
    [rows, cols] = size(Y);
    Y = (Y-repmat(mean(Y),rows, 1));
elseif prepro == 2
    % MATRIX autoscaled
    [rows, cols] = size(X);
    X = (X-repmat(mean(X),rows, 1))*diag(1./std(X,0,1));
    [rows, cols] = size(Y);
    Y = (Y-repmat(mean(Y),rows, 1))*diag(1./std(Y,0,1));
end