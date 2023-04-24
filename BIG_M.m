format short;
clear all;
clc;


% INPUT PARAMETERS
M = 1000;
C = [-2 -1 0 0 -M -M 0];
COEFF = [3 1 0 0 1 0 3;
        4 3 -1 0 0 1 6;
        1 2 0 1 0 0 3];

% FINDING BASIC VARIABLES
S = eye(3);
BV = [];
for i = 1 : size(S, 2)
    for j = 1 : size(COEFF, 2)
        if COEFF(:, j) == S(:, i)
            BV = [BV j];
        end
    end
end
A = COEFF;
LAST = size(A, 2);

% CALCULATE Zj - Cj 
ZjCj = C(BV) * A - C;

% PRINT TABLE
TAB = [ZjCj ; A];
Simp_Tab = array2table(TAB);
Simp_Tab.Properties.VariableNames(1 : LAST) = {'x_1', 'x_2', 'x_3', 's_1', 's_2', 's_3', 'Sol'}

% CHECK OPTIMALITY
RUN = true;
while RUN
    Z = ZjCj(1 : size(C, 2) - 1);
    if any(Z < 0)
        fprintf('Current BFS is NOT OPTIMAL. \n');
        fprintf('\n===========NEXT ITERNATION============\n');

        fprintf('\nOld BV: ');
        disp(BV);

        % FINDING ENTERING VARIABLE
        X = ZjCj(1 : size(ZjCj, 2) - 1);
        [min_V, min_Ind] = min(X);
    
        fprintf('Smallest Value of ZjCj is %d & Column is %d\n', min_V, min_Ind);

        Sol_Col = A(:, LAST);
        Curr_Col = A(:, min_Ind);

        if all(A(:, min_Ind) <= 0)
            error('LPP is Unbounded. All enteries <= 0 in column %d\n', Curr_Col);
        else
        for i = 1 : size(A, 1)
            if Curr_Col(i) >  0
                ratio(i) = Sol_Col(i) ./ Curr_Col(i);
            else
                ratio(i) = Inf;
            end
        end

        % FINDING SMALLEST RATIO
        [min_R_V, min_R_Row] = min(ratio);
        fprintf('Smallest Ratio is %d & respective row is %d\n', min_R_V, min_R_Row);

        BV(min_R_Row) = min_Ind;
        fprintf('\nNew BV: ');
        disp(BV);

        % UPADTING THE TABLE
        PVT_V = A(min_R_Row, min_Ind);
        A(min_R_Row, :) = A(min_R_Row, :) ./ PVT_V;
    
        for i = 1:size(A, 1)
            if i ~= min_R_Row
                A(i, :) = A(i, :) - A(min_R_Row, :) .* A(i, min_Ind);
            end
        end
        ZjCj = ZjCj - A(min_R_Row, :) .* X(1, min_Ind);
    
        % Printing Table    
        TAB = [ZjCj ; A];
        Simp_Tab = array2table(TAB);
        Simp_Tab.Properties.VariableNames(1 : LAST) = {'x_1', 'x_2', 'x_3', 's_1', 's_2', 's_3', 'Sol'}
        
        BFS = zeros(1, size(A, 2));
        BFS(BV) = A(:, LAST);
        BFS(LAST) = sum(BFS .* C);

        BFS_Tab = array2table(BFS);
        BFS_Tab.Properties.VariableNames(1 : LAST) = {'x_1', 'x_2', 'x_3', 's_1', 's_2', 's_3', 'Sol'}
        end
    else
        RUN = false;
        fprintf('\n============================\n');
        fprintf('CURRENT BFS IS OPTIMAL\n');
        fprintf('============================\n');
        
    end
end