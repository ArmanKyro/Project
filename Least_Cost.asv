format short;
clc;
clear all;

C = [11 20 7 8; 21 16 10 12; 8 12 18 9];
S = [50 40 70];
D = [30 25 35 40];
LAST_R = size(C, 1);
LAST_C = size(C, 2);

if sum(S) == sum(D)
    fprintf('\nBALANCED TRANSPORTATION PROBLEM\n');
else
    fprintf('\nUNBALANCED TRANSPORTATION PROBLEM\n');
    if sum(S) > sum(D)
        C(:, LAST_C + 1) = zeros(LAST_R, 1);
        D(LAST_C + 1) = sum(S) - sum(D);
    else
        C(LAST_R + 1, :) = zeros(1, LAST_C);
        S(LAST_R + 1) = sum(D) - sum(S);
    end
end

C_NEW = C;
X = zeros(size(C));
[ROW, COL] = size(C);
BFS = ROW + COL - 1;

% FINDING MINIMUM COST
for i = 1 : size(C, 1)
    for j = 1 : size(C, 2)
        MIN_V = min(min(C));
        [MIN_R_IND, MIN_C_IND] = find(MIN_V == C);
        x11 = min(S(MIN_R_IND), D(MIN_C_IND));
        [MAX_V, MAX_IND] = max(x11);
        ii = MIN_R_IND(MAX_IND);
        jj = MIN_C_IND(MAX_IND);
        y11 = min(S(ii), D(jj));
        X(ii, jj) = y11;
        S(ii) = S(ii) - y11;
        D(jj) = D(jj) - y11;
        C(ii, jj) = Inf;
    end
end
fprintf('\n***********\n');
fprintf('INITIAL BFS');
fprintf('\n***********\n');
I_BFS = array2table(X);
I_BFS.Properties.VariableNames(1 : size(X, 2)) = {'X1', 'X2', 'X3', 'X4', 'X5'}

% CHECK DEGENERATE 
TOT_BFS = length(nonzeros(X));
if TOT_BFS == BFS
    fprintf('\nNON-DEGENERATE\n');
else
    fprintf('\nDEGENERATE\n');
end

% CALCULATING COST
TOT_C = sum(sum(C_NEW .* X));
fprintf('FINAL COST: %d', TOT_C);
