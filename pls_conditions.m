
if nargin == 1
    disp('ERROR! Submit the Y matrix');
    break
elseif nargin == 2
    prepro = 0;
    NumFact = min(X_rows,X_cols);
    NumIter = 10000;
    Tol = 1e-5;
elseif nargin == 3
    NumFact = min(X_rows, X_cols);
    NumIter = 10000;
    Tol = 1e-5;
elseif nargin == 4;
    NumIter = 10000;
    Tol = 1e-5;
elseif nargin == 5;
    Tol = 1e-5;
end
    
    