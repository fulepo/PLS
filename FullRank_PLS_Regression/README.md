# PLS
Full-Rank Partial Least Squares Regression

 Usage: RESULTS = pls(X, Y, prepro, NumFact, NumIter, Tol)
 
 X = data matrix
 Y = output data matrix
 prepro = type of matrix preprocessing (0,1 and 2 are: no prepro,
                 column-centering and autoscaling, respectively)
 NumFact = number of factors to extract. Give the min(X_rows, X_cols)
 NumIter = maximum number of iterations for the PLS convergence
 Tol = tolerance (given as 1e-n) for PLS convergence
 
 This function performs pls regression of X data on Y.
 The algorithm performs CrossValidation using 10% of all X rows.
 The cross-validation is repeated until all the X rows have been 
 used at least once.
 For each cross-validation iteration the value of RMSEP for each 
 PLS component is computed. The final RMSEP value is computed from the 
 average over all cross-validation iterations.
 
 The optimal number of PLS components is determined from the minimum
 value of RMSEP.
 
 The optimal number of PLS components is then used to build the final PLS
 model.
