


if nargin == 1
    disp('ERROR! Submit the Y matrix');
    return
elseif nargin == 2
    prepro = 0;
    NumFact = min(size(X,1),size(X,2));
    NumIter = 20000;
    Tol = 1e-6;
elseif nargin == 3
    NumFact = min(size(X,1), size(X,2));
    NumIter = 20000;
    Tol = 1e-6;
elseif nargin == 4;
    NumIter = 20000;
    Tol = 1e-6;
elseif nargin == 5;
    Tol = 1e-6;
end
    
    