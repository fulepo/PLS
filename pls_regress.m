function RESULTS = pls_regress(X, Y, X_rows, X_cols, ...
        Y_rows, Y_cols, NumFact, NumIter, Tol)
    
% Eigenvalues

RESULTS.X_Eigenvalues = svd(X).^2;
RESULTS.Y_Eigenvalues = svd(Y).^2;
RESULTS.X_EigenVar = RESULTS.X_Eigenvalues./sum(...
        RESULTS.X_Eigenvalues)*100;
RESULTS.Y_EigenVar = RESULTS.Y_Eigenvalues./sum(...
        RESULTS.X_Eigenvalues)*100;

% Initialization

%RESULTS.X_Weights = zeros%(X_cols, NumFact);

    