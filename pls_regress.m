function RESULTS = pls_regress(X, Y, X_rows, X_cols, ...
        Y_rows, Y_cols, NumFact, NumIter, Tol, prepro)

if prepro == 1
    RESULTS.X_Centered = X;
    RESULTS.Y_Centered = Y;
elseif prepro == 2
    RESULTS.X_Autoscaled = X;
    RESULTS.Y_Autoscaled = Y;
end

% Eigenvalues

RESULTS.X_Eigenvalues = svd(X).^2;
RESULTS.Y_Eigenvalues = svd(Y).^2;
RESULTS.X_EigenVar = RESULTS.X_Eigenvalues./sum(...
        RESULTS.X_Eigenvalues)*100;
RESULTS.Y_EigenVar = RESULTS.Y_Eigenvalues./sum(...
        RESULTS.X_Eigenvalues)*100;

% Initialization

RESULTS.X_Scores = zeros(X_rows, NumFact);
RESULTS.Y_Scores = zeros(Y_rows, NumFact);
RESULTS.X_Loadings = zeros(NumFact, X_cols);
RESULTS.Y_Loadings = zeros(NumFact, Y_cols); 
RESULTS.PLS_Weights = zeros(NumFact, X_cols);
RESULTS.PLS_RegressCoeff = zeros(X_cols, Y_cols);

Iter = 0;

% Decomposition 
for fact=1:NumFact
    u_h = normc(Y(:,1));
    ende = false;
    
    while(~ende);
        Iter = Iter+1;
        u_h_old = u_h;
        w_h = (X'*u_h/(u_h'*u_h));
        w_h = normc(w_h);
        t_h = (X*w_h);
        q_h = normc(Y'*t_h/(t_h'*t_h));
        u_h = (Y*q_h/(q_h'*q_h));  
        prec = (u_h-u_h_old)'*(u_h-u_h_old);
  
        if prec <= Tol^2;
           ende = true;
        elseif NumIter <= Iter
          ende = true;
          disp('Iterarion stops without convergence!')
        end
    end
    
    p_h = X'*t_h/(t_h'*t_h);
    X = X - t_h*p_h';
    Y = Y - t_h*q_h';
    
    RESULTS.X_Scores(:,fact) = t_h;
    RESULTS.Y_Scores(:,fact) = u_h;
    RESULTS.X_Loadings(fact,:) = p_h';
    RESULTS.Y_Loadings(fact,:) = q_h';  
    RESULTS.PLS_Weights(fact,:) = w_h;
 
        
end


RESULTS.PLS_RegressCoeff = transpose(RESULTS.PLS_Weights*inv(...
    RESULTS.X_Loadings'*RESULTS.PLS_Weights))*...
    RESULTS.Y_Loadings;

    RESULTS.X_Loadings = RESULTS.X_Loadings';
    RESULTS.Y_Loadings = RESULTS.Y_Loadings';


    