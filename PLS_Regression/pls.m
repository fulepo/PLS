
function RESULTS_PLS = pls(X, Y, prepro, NumFact, NumIter, Tol)

% 
% 
% Usage: RESULTS = pls(X, Y, prepro, NumFact, NumIter, Tol)
% 
% X = data matrix
% Y = output data matrix
% prepro = type of matrix preprocessing (0,1 and 2 are: no prepro,
%                 column-centering and autoscaling, respectively)
% NumFact = number of factors to extract. Use this parameter to help
%             the function in finding the optimal minimum for the 
%             Cross-Validation and therefore, the optimal number of 
%             PLS components necessary to build the model.
% NumIter = maximum number of iterations for the PLS convergence
% Tol = tolerance (given as 1e-n) for PLS convergence
% 
% This function performs pls regression of X data on Y.
% The algorithm performs CrossValidation using leave-one-out method.
% The cross-validation is repeated until all the X rows have been 
% used at least once.
% For each cross-validation iteration the value of RMSEP for each 
% PLS component is computed. The final RMSEP value is computed from the 
% average over all cross-validation iterations and plotted as function of
% the number of PLS components.
% 
% The optimal number of PLS components is determined from the GLOBAL MINIMUM
% value of RMSEP and highlighted in RED in the RMSEP plot.
% In order to avoid overfitting, it is highly recommended to provide the 
% NumFact variable and check the red point indicating the 'OPTIMAL' number 
% of PLS components. In this way the user has full control on the model. 
% 
% The optimal number of PLS components is then used to build the final PLS
% model.
% The weights and regression coefficients of the model are stored in proper
% variables. They can be used with PRE-PROCESSED data.
%%

set(0,'DefaultFigureWindowStyle','docked');

run('pls_conditions.m');

if size(X,1) ~= size(Y,1)
    disp('ERROR! Matrix dimensions must agree')
    return
elseif NumFact == 0;
    disp('ERROR! The no. of PLS components cannot be zero')
    NumFact = input('Number of PLS components: ')
end

ExistTable_A = istable(X);
ExistTable_B = istable(Y);

if ExistTable_A == 1 && ExistTable_B ==1
    
    Table_permuted_Index = randperm(size(X,1))';
    
        X_TABLE = X(Table_permuted_Index,:);
        Y_TABLE = Y(Table_permuted_Index,:);
        X = X(Table_permuted_Index,:);
        Y = Y(Table_permuted_Index,:);
elseif ExistTable_A == 0 && ExistTable_B == 0
    [X, Y] = pls_Convert2Table(X,Y);
    Table_permuted_Index = randperm(size(X,1))';
    
        X_TABLE = X(Table_permuted_Index,:);
        Y_TABLE = Y(Table_permuted_Index,:);
        X = X(Table_permuted_Index,:);
        Y = Y(Table_permuted_Index,:);
else
    disp('Submit both X and Y as either MATRICES or TABLE variables');
end

RESULTS_PLS.X_TABLE_Perm = X_TABLE;
RESULTS_PLS.Y_TABLE_Perm = Y_TABLE;

% PREPROCESSING WHOLE TABLES
        
    [X, Y] = pls_prepro(X, Y, prepro, X_TABLE, Y_TABLE);

    RESULTS_PLS.X_TABLE_PermPrepro = X;
    RESULTS_PLS.Y_TABLE_PermPrepro = Y;
    
    X_TABLE_Train_old = X;
    Y_TABLE_Train_old = Y;
    X_TABLE_CrossVal_old = X;
    Y_TABLE_CrossVal_old = Y;
    X = table2array(X);
    Y = table2array(Y);

    RowIndex = [1:1:size(X,1)]';       
    CV_ERROR_tot = zeros(NumFact, 2);
    
    %% 
    %   DATA SPLIT FOR Cross-Validation (15% each run)
   
    finish = false;
    iteration = 1;
    
CrossValIndex = 1;
while (~finish);  
clc;
iteration
    RowIndex(CrossValIndex,1) = 0;
    
    X_TABLE_Train = X_TABLE_Train_old;
    Y_TABLE_Train = Y_TABLE_Train_old;
    
    X_TABLE_CrossVal = X_TABLE_CrossVal_old;
    Y_TABLE_CrossVal = Y_TABLE_CrossVal_old;

    
    X_TABLE_CrossVal = X_TABLE_CrossVal(CrossValIndex,:);                                 
    Y_TABLE_CrossVal = Y_TABLE_CrossVal(CrossValIndex,:);                               
    
    X_TABLE_Train(CrossValIndex,:) = [];                                  
    Y_TABLE_Train(CrossValIndex,:) = [];                                  

    X_Train = table2array(X_TABLE_Train);                                   
    Y_Train = table2array(Y_TABLE_Train); 

    X_CrossVal = table2array(X_TABLE_CrossVal);
    Y_CrossVal = table2array(Y_TABLE_CrossVal);

    EndCrossVal = any(RowIndex);

%%
%   SIZE OF DATA MATRICES

[~, ~] = size(X);
[~, ~] = size(Y);
[~, ~] = size(X_Train);
[~, ~] = size(Y_Train);
[~, ~] = size(X_CrossVal);
[Y_CrossVal_rows, ~] = size(Y_CrossVal);

%%
%   EXECUTION for the determination of PLS components

 CV_ERROR = zeros(NumFact, 2);
 for PLS_Comp = 1:NumFact 
     RESULTS_PLS.PLS_CrossVal = pls_regress(X, Y, ...
                       X_Train, Y_Train,...
                       PLS_Comp, NumIter, Tol, prepro, NumFact);

    Y_CrossVal_Hat = X_CrossVal*RESULTS_PLS.PLS_CrossVal.PLS_RegressCoeff;
    ressq = (Y_CrossVal-Y_CrossVal_Hat).^2;
    RMSPE_cv = sqrt(sum(ressq(:))/Y_CrossVal_rows);
    CV_ERROR(PLS_Comp,:) = [PLS_Comp, RMSPE_cv];
 end     

 CV_ERROR_tot =  (CV_ERROR_tot + CV_ERROR);
 

    if EndCrossVal == 0
        finish = true;
    end
    
iteration = iteration+1;
CrossValIndex = CrossValIndex+1;
end % while cycle for CrossVal

iteration = iteration-1;

CV_ERROR_tot = CV_ERROR_tot./iteration;
RESULTS_PLS.PLS_CrossVal.CV_ERROR_tot = CV_ERROR_tot;

    [Min_RMSEP, PLS_NumComp] = min(CV_ERROR_tot(:,2));

 figure
 plot(CV_ERROR_tot(:,1), (CV_ERROR_tot(:,2)), 'o-', ...
     'MarkerFaceColor', 'blue');
 title('Prediction Error - Average over all CrossVal iter.');
 xlabel('PLS component');
 ylabel('RMSEP');
 hold on
 plot(PLS_NumComp,Min_RMSEP, 'o-', 'MarkerFaceColor', 'red');

%%
%       BUILDING FINAL PLS MODEL

X_Train = X;
Y_Train = Y;
NumFact = PLS_NumComp;

RESULTS_PLS.PLS_Model = pls_regress(X, Y, ...
                       X_Train, Y_Train,...
                       PLS_NumComp, NumIter, Tol, prepro, NumFact);
    
RESULTS_PLS.PLS_Model.OUTCOME = table(iteration, Min_RMSEP, PLS_NumComp, ...
        'RowNames', {'PARAMETERS'}, ...
        'VariableNames', {'NumIter', 'Min_RMSEP', 'PLS_CompNum'});

    RESULTS_PLS.PLS_Model.OUTCOME

 pls_figures(RESULTS_PLS.PLS_Model, PLS_NumComp,X_TABLE, Y_TABLE,...
     Table_permuted_Index);
 



