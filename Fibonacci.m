format short;
clc;
clear all;

% f = @(x) x.^ 2;
f = @(x)(x < 0.5) .* ((1 - x) ./ 2) + (x >= 0.5) .* (x .^ 2);
% f = @(x)(0.65 - [0.75 ./ (1 + x.^2)] - 0.65 * x .* atan(1 ./ x));

L = -1;
U = 1;
n = 6;

% PLOT THE GRAPH
t = linspace(L, U, 100);
plot(t, f(t), 'k', 'Linewidth', 2); 

% COMPUTE FIBONACCI SERIES
Fib = ones(1, n);
for i = 3 : n + 1
    Fib(i) = Fib(i - 1) + Fib(i - 2);
end

for k = 1 : n
    ratio = (Fib(n + 1 - k) ./ Fib(n + 2 - k));
    x2 = L + ratio .* (U - L);
    x1 = L + U - x2;
    fx1 = f(x1);
    fx2 = f(x2);
    TAB(k, :) = [L U x1 x2 fx1 fx2];

if fx1 < fx2
    U = x2;
elseif fx1 > fx2
    L = x1;
elseif fx1 == fx2
    if min(abs(x1), abs(L)) == abs(L)
        U = x2;
    else
        L = x1;
    end
end
end

Fib = array2table(TAB);
Fib.Properties.VariableNames(1 : size(TAB, 2)) = {'L', 'U', 'X1', 'X2', 'F(X1)', 'F(X2)'}

% OPTIMAL RESULT
XOPT = (L + U) / 2;
FOPT = f(XOPT);
fprintf('OPTIMAL VALUE OF X = %f \n', XOPT);
fprintf('OPTIMAL VALUE OF F(X) = %f \n', FOPT);