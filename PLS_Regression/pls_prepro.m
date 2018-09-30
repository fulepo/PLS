function [X_prepro, Y_prepro] = pls_prepro(X, Y, prepro,...
                                            X_TABLE, Y_TABLE)

       if prepro == 0
            X_prepro = X;
            Y_prepro = Y;
        elseif prepro == 1
            func = @(data) data-repmat(mean(data), size(data,1), 1);
            X_prepro = varfun(func, X);
            X_prepro.Properties.RowNames = X_TABLE.Properties.RowNames;
            X_prepro.Properties.VariableNames = X_TABLE.Properties.VariableNames;
            
            Y_prepro = varfun(func, Y);
            Y_prepro.Properties.RowNames = Y_TABLE.Properties.RowNames;
            Y_prepro.Properties.VariableNames = Y_TABLE.Properties.VariableNames;
            
        elseif prepro == 2
            func = @(data) (data-repmat(mean(data), size(data,1), 1))*...
                diag(1./std(data,0,1));
            X_prepro = varfun(func, X);
            X_prepro.Properties.RowNames = X_TABLE.Properties.RowNames;
            X_prepro.Properties.VariableNames = X_TABLE.Properties.VariableNames;
            
            Y_prepro = varfun(func, Y);
            Y_prepro.Properties.RowNames = Y_TABLE.Properties.RowNames;
            Y_prepro.Properties.VariableNames = Y_TABLE.Properties.VariableNames;
        end

