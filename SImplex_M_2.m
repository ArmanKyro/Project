format short
clear all
clc

% INPUT PHASE
C = [-3 1 2 0 0 0];
COEFF = [3 -1 2; -2 4 0; -4 3 8];
B = [7; 12; 10];

NSV = 3;
S = eye(NSV);
A = [COEFF S B];
Cost = [C 0];

% FINDING BASIC VARIABLE
BV = [];
for i = 1 : size(S, 2)
    for j = 1 : size(A, 2)
        if A(:, j) == S(:, i)
            BV = [BV j];
        end
    end
end

% COMPUTE VALUE OF TABLE
B_1 = A(:, BV);
A = B_1 \ A;

ZjCj = Cost(BV) * A - Cost;

Tab = [ZjCj; A];
Simp_Tab = array2table(Tab);
Simp_Tab.Properties.VariableNames(1 : size(Tab, 2)) = {'x_1', 'x_2', 'x_3', 's_1', 's_2', 's_3', 'Sol'}


RUN = true;
while RUN

    % SIMPLEX METHOD START
    M = Tab(1, :);

    if any(M < 0)
        fprintf('\n-----------------------');
        fprintf('\nCURRENT BFS IS NOT OPTIMAL.\n');
        fprintf('-----------------------\n');

    %   ENTERING COLUMN
        [MIN_C_V, MIN_C_IND] = min(M);
        fprintf('\nENTERING COLUMN: %d\n', MIN_C_IND);

    %   LEAVING ROW
        Curr_Col = A(:, MIN_C_IND);
        Sol_Col = A(:, size(A, 2));
        for i = 1 : size(A, 1)
            if Curr_Col(i) >  0
                ratio(i) = Sol_Col(i) ./ Curr_Col(i);
            else
                ratio(i) = Inf;
            end
        end
        [MIN_R_V, MIN_R_IND] = min(ratio);
        fprintf('\nLEAVING ROW: %d\n', MIN_R_IND);

    %   UPDATING BV
        BV(MIN_R_IND) = MIN_C_IND;

    %   UPDATING TABLE
        B = A(:, BV);
        A = B \ A;
        ZjCj = Cost(BV) * A - Cost;

        Tab = [ZjCj; A];
        Simp_Tab = array2table(Tab);
        Simp_Tab.Properties.VariableNames(1 : size(Tab, 2)) = {'x_1', 'x_2', 'x_3', 's_1', 's_2', 's_3', 'Sol'}
    
    else
        RUN = false;
        fprintf('\n-----------------------');
        fprintf('\nCURRENT BFS IS OPTIMAL.');
        fprintf('\n-----------------------\n');

        fprintf('------FINAL BFS-----\n');
        Tab_2 = zeros(1, size(Tab, 2) - 1);
        Tab_2(BV) = A(:, size(A, 2));
        Tab_2(size(A, 2)) = Tab(1, size(Tab, 2));
        Simp_Tab_2 = array2table(Tab_2);
        Simp_Tab_2.Properties.VariableNames(1 : size(Tab, 2)) = {'x_1', 'x_2', 'x_3', 's_1', 's_2', 's_3', 'Sol'}
    end
end

