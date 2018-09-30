


if nargin == 1
    disp('ERROR! Submit the Y matrix');
    return
elseif nargin == 2
    prepro = 0;
    NumFact = min(size(X,1),size(X,2));
    NumIter = 20000;
    Tol = 1e-5;
elseif nargin == 3
    NumFact = min(size(X,1), size(X,2));
    NumIter = 20000;
    Tol = 1e-5;
elseif nargin == 4;
    while NumFact > min(size(X,1),size(X,2));
        disp('ERROR! Too many components. Max mumber is:');
        min(size(X,1),size(X,2))
        disp('The optimal no. of PLS will be searched by Cross-validation.');
        NumFact = input('Enter MAX no. of PLS components: ')
    end
    NumIter = 20000;
    Tol = 1e-5;
elseif nargin == 5;
    Tol = 1e-5;
end
    
    