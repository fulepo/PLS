
function RESULTS = pls_regress(X, Y, ...
                       X_Train, Y_Train,...
                       PLS_Comp, NumIter, Tol, prepro, NumFact)

X_Train_Original = X_Train;
Y_Train_Original = Y_Train;
    
RESULTS.X = X;
RESULTS.Y = Y;
% if prepro == 0
%     RESULTS.X_Raw = X;
%     RESULTS.Y_Raw = Y;
% elseif prepro == 1
%     RESULTS.X_Centered = X;
%     RESULTS.Y_Centered = Y;
% elseif prepro == 2
%     RESULTS.X_Autoscaled = X;
%     RESULTS.Y_Autoscaled = Y;
% % end
 
% Eigenvalues of WHOLE X matrix

RESULTS.X_Eigenvalues = svd(X).^2;
RESULTS.Y_Eigenvalues = svd(Y).^2;
RESULTS.X_EigenVar = RESULTS.X_Eigenvalues./sum(...
        RESULTS.X_Eigenvalues)*100;
RESULTS.Y_EigenVar = RESULTS.Y_Eigenvalues./sum(...
        RESULTS.X_Eigenvalues)*100;
 
% Initialization
% 
RESULTS.X_Scores = zeros(size(X_Train,1), PLS_Comp);
RESULTS.Y_Scores = zeros(size(Y_Train,1), PLS_Comp);
RESULTS.X_Loadings = zeros(NumFact, size(X_Train,2));
RESULTS.Y_Loadings = zeros(NumFact, size(Y_Train,2)); 
RESULTS.PLS_Weights = zeros(NumFact, size(X_Train,2));
RESULTS.PLS_RegressCoeff = zeros(size(X_Train,1), size(Y_Train,2));
 
 Iter = 0;
 
% Decomposition 
for fact=1:PLS_Comp
    u_h = (Y_Train(:,1));
    u_h = normc(u_h);
    ende = false;
    
    while(~ende);
        Iter = Iter+1;
        u_h_old = u_h;
        w_h = (X_Train'*u_h/(u_h'*u_h));
        w_h = normc(w_h);
        t_h =       (X_Train*w_h);
        q_h = (Y_Train'*t_h/(t_h'*t_h));
        u_h =       (Y_Train*q_h/(q_h'*q_h)); 
        delta_u = u_h-u_h_old;
        prec = (delta_u'*delta_u);
            if prec <= Tol;
                ende = true;
            elseif NumIter <= Iter
                ende = true;
                 disp('Iterarion stops without convergence!')
            end
     end
    
    p_h = (X_Train'*t_h/(t_h'*t_h));
    X_Train = X_Train - t_h*p_h';
    Y_Train = Y_Train - t_h*q_h';
    
    RESULTS.X_Scores(:,fact) = t_h;
    RESULTS.Y_Scores(:,fact) = u_h;
    RESULTS.X_Loadings(fact,:) = p_h';
    RESULTS.Y_Loadings(fact,:) = q_h';  
    RESULTS.PLS_Weights(fact,:) = w_h';

end

RESULTS.PLS_RegressCoeff = (RESULTS.PLS_Weights'*pinv(...
                       RESULTS.X_Loadings*RESULTS.PLS_Weights'))*...
                       RESULTS.Y_Loadings;
                   
     RESULTS.X_Loadings = RESULTS.X_Loadings';
     RESULTS.Y_Loadings = RESULTS.Y_Loadings';
     RESULTS.X_ResidualMatrix = X_Train;
     RESULTS.Y_ResidualMatrix = Y_Train;

    RESULTS.Y_PREDICTED = X*RESULTS.PLS_RegressCoeff;

    
