format short;
clear all;
clc;


% INPUT PARAMETERS
C = [-3 1 2];
COEFF = [3 -1 2; -2 4 0; -4 3 8];
B = [7; 12; 10];

% C = [3 2 5];
% COEFF = [1 2 1; 1 4 0; 3 0 2];
% B = [430; 460; 420];

% MANUAL-QUESTIONS
% C = [1 2];
% COEFF = [-1 1; 1 1];
% B = [1; 2];

% C = [4 6 3 1 -1];
% COEFF = [1 4 8 6 -6; 4 1 2 1 -1; 2 3 1 2 -2];
% B = [11; 7; 2];

% C = [3/4 -20 1/2 -6];
% COEFF = [1 0 0 1/4 -8 -1 9; 0 1 0 1/2 -12 -1/6 3; 0 0 1 0 0 1 0];
% B = [0; 0; 1];

% C = [4 6];
% COEFF = [-1 1; 1 1; 2 5];
% B = [11; 27; 90];

% SURPLUS VARIABLES
S = eye(size(COEFF, 1));

% NSV = 2;
NSV = 3;
% NSV = 4;

A = [COEFF S B]
% A = [COEFF B];
LAST = size(A, 2);
Cost_N = zeros(1, size(A, 2));
Cost_N([1 : NSV]) = C;
% Cost_N([NSV : LAST - 1]) = C;

% BASIC VARIABLES
BV = NSV + 1 : size(A, 2) - 1;
% BV = 1 : NSV - 1;

% CALCULATE Zj - Cj 
ZjCj = Cost_N(BV) * A - Cost_N;

% PRINT TABLE
TAB = [ZjCj ; A];
Simp_Tab = array2table(TAB);
% Simp_Tab.Properties.VariableNames(1 : LAST) = {'x_1', 'x_2', 's_1', 's_2', 'Sol'}
Simp_Tab.Properties.VariableNames(1 : LAST) = {'x_1', 'x_2', 'x_3', 's_1', 's_2', 's_3', 'Sol'}
% Simp_Tab.Properties.VariableNames(1 : LAST) = {'x_1', 'x_2', 'x_3', 'x_4', 'x_5' ,'x_6', 'x_7', 'Sol'}

% CHECK OPTIMALITY
RUN = true;
while RUN
    if any(ZjCj < 0)
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
%         Simp_Tab.Properties.VariableNames(1 : LAST) = {'x_1', 'x_2', 's_1', 's_2', 'Sol'}
        Simp_Tab.Properties.VariableNames(1 : LAST) = {'x_1', 'x_2', 'x_3', 's_1', 's_2', 's_3', 'Sol'}
%         Simp_Tab.Properties.VariableNames(1 : LAST) = {'x_1', 'x_2', 'x_3', 'x_4', 'x_5' ,'x_6', 'x_7', 'Sol'}
        
        BFS = zeros(1, size(A, 2));
        BFS(BV) = A(:, LAST);
        BFS(LAST) = sum(BFS .* Cost_N);

        BFS_Tab = array2table(BFS);
%         BFS_Tab.Properties.VariableNames(1 : LAST) = {'x_1', 'x_2', 's_1', 's_2', 'Sol'}
        BFS_Tab.Properties.VariableNames(1 : LAST) = {'x_1', 'x_2', 'x_3', 's_1', 's_2', 's_3', 'Sol'}
%         BFS_Tab.Properties.VariableNames(1 : LAST) = {'x_1', 'x_2', 'x_3', 'x_4', 'x_5', 'x_6', 'x_7', 'Sol'}
        end
    else
        RUN = false;
        fprintf('\n============================\n');
        fprintf('CURRENT BFS IS OPTIMAL\n');
        fprintf('============================\n');
        
    end
end