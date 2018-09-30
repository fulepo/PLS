function RESULTS = pls_fullRank(X, Y, prepro, NumFact, NumIter, Tol)

% Written by: Filippo Amato, July 2015
% 
% Usage: RESULTS = pls_fullRank(X, Y, prepro, NumFact, NumIter, Tol)
% 
% X = data matrix
% Y = output data matrix
% prepro = code for data preprocessing (0,1 or 2 are: no prepro,
%                 column centering or autoscaling, respectively)
% NumFact = Number of PLS components to extract. If not given, the full-rank
%             model is built
% NumIter = maximum number of iteration for NIPALS decomposition. 
%             Default is 20000
% Tol = tolerance for NIPALS convergence. Default is 1e-6
%     
% This function builds the FULL-RANK PLS model concerning X and Y data 
% matrices.
% 
% No crossvalidation is implemented here. 
% For cross-validated, auto optimized PLS regression models use the function
% pls.m available at: https.//github.com/fulepo/PLS/PLS_Regression
%                 

set(0,'DefaultFigureWindowStyle','docked');

[X_rows, X_cols] = size(X);
[Y_rows, Y_cols] = size(Y);

if X_rows ~= Y_rows
    disp('ERROR! Matrix dimensions must agree')
    return
end

ExistTable_A = istable(X);
ExistTable_B = istable(Y);

if ExistTable_A == 1 && ExistTable_B ==1
    X_TABLE = X;
    Y_TABLE = Y;
    X = table2array(X);
    Y = table2array(Y);
elseif ExistTable_A == 0 && ExistTable_B == 0
    [X_TABLE, Y_TABLE] = pls_Convert2Table(X,Y);
    X = table2array(X_TABLE);
    Y = table2array(Y_TABLE);
else
    disp('Submit both X and Y as either MATRICES or TABLE variables');
end

run('pls_FRconditions.m');
run('pls_FRprepro.m');

RESULTS = pls_FRregress(X, Y, X_rows, X_cols, ...
        Y_rows, Y_cols, NumFact, NumIter, Tol, prepro, LargeX);

    
RESULTS.PLS_RegressCoeff = (RESULTS.PLS_Weights'*pinv(...
                       RESULTS.X_Loadings'*RESULTS.PLS_Weights'))*...
                       RESULTS.Y_Loadings';
                   
RESULTS.Y_PREDICTED = X*RESULTS.PLS_RegressCoeff;   
pls_FRfigures(RESULTS, X_TABLE, Y_TABLE);
    
    

