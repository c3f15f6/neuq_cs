
optimize_with_ga();
function optimize_with_ga()
    % 设置变量数量和约束条件
    nVars = 120;  % 变量数量
    nConstraints = 24;  % 非线性不等式约束的数量
    
    % 设置优化问题的上下界
    lb = zeros(nVars, 1);  % 下界，所有变量的下界为0
    ub = ones(nVars, 1);   % 上界，所有变量的上界为1

    % 定义遗传算法选项
    opts = optimoptions('ga', 'Display', 'iter', ...
        'MaxGenerations', 100, 'PopulationSize', 100, ...
        'UseParallel', true, 'FunctionTolerance', 1e-1);

    % 求解问题
    [sol, fval] = ga(@objectiveF, nVars, [], [], [], [], lb, ub, ...
        @nonlcon, opts);

    % 显示结果
    disp('Solution:');
    disp(sol);
    disp('Objective Function Value:');
    disp(fval);
end

% 目标函数
function f = objectiveF(vars)
    % 计算目标函数，这里是所有变量的总和
    f = sum(vars);
end

% 非线性不等式约束函数
function [c, ceq] = nonlcon(vars)
    % 设置约束矩阵
    n_i = 5;  % 行数
    n_j = 24;  % 列数

    % 重新定义变量 x 和 y
    x = reshape(vars, n_i, n_j);

    % 计算约束条件
    % 约束条件：每列的和大于 2.82e4
    threshold = 2.82e4;
    colSum = sum(x, 1);  % 计算每列的和
    c = threshold - colSum;  % 非线性不等式约束

    % 非线性等式约束为空
    ceq = [];
end
