# PLS
Auto-optimial Partial Least Squares Regression

Usage: RESULTS = pls(X, Y, prepro, NumFact, NumIter, Tol)

X = data matrix
Y = output data matrix
prepro = type of matrix preprocessing (0,1 and 2 are: no prepro,
                column-centering and autoscaling, respectively)
NumFact = number of factors to extract. Give the min(X_rows, X_cols)
NumIter = maximum number of iterations for the PLS convergence
Tol = tolerance (given as 1e-n) for PLS convergence

This function performs pls regression of X data on Y.
The algorithm performs CrossValidation by leave-one-out method.
The cross-validation is repeated until all the X rows have been 
used at least once.
For each cross-validation iteration the value of RMSEP for each 
PLS component is computed. The final RMSEP value is computed from the 
average over all cross-validation iterations and plotted as function of
the number of PLS components.

The optimal number of PLS components is determined from the GLOBAL MINIMUM
value of RMSEP and highlighted in RED in the RMSEP plot.
In order to avoid overfitting, it is highly recommended to provide the 
NumFact variable and check the red point indicating the 'OPTIMAL' number 
of PLS components. In this way the user has full control on the model. 

The optimal number of PLS components is then used to build the final PLS
model.
The weights and regression coefficients of the model are stored in proper
variables. They can be used with PRE-PROCESSED data.
