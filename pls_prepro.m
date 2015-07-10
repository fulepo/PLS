
if prepro == 1
    % MATRIX CENTERED about column means
    [rows, cols] = size(X);
    Z = (X-repmat(mean(X),rows, 1));
    a = cols;
elseif prepro == 2
    % MATRIX autoscaled
    [rows, cols] = size(X);
    Z = (X-repmat(mean(X),rows, 1))*diag(1./std(X,0,1));
    a = cols;
end