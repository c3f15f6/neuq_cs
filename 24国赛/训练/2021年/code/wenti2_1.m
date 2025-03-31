%% 定义变量
load('data50.mat');
n_i = 50;
n_j = 24;
global nVars;
nVars=n_i*n_j+n_i;





% 计算t_j
t_j = zeros(n_i, 1);
for i = 1:n_i
    t_j(i) = T(i);
end
t_j1 = repmat(t_j, 1, size(z, 2));

% 计算 Q 值
Q = zeros(n_i, n_j);
for i = 1:n_i
    for j = 1:n_j
        Q(i, j) = Qcompu(i, j);
    end
end
lb =[zeros(nVars, 1)] ; % x和u的下界为0, y的下界为0
ub = [Q(:);ones(n_i,1)];


% 求解问题

opts = optimoptions('ga', 'Display', 'iter','UseParallel', true, ...
    'PopulationSize', 100, 'MaxGenerations', 100);
% sol = solve(prob, 'Options', opts);
[sol, fval]= ga(@(vars) objectiveF(vars),nVars, [],[],[],[], lb, ub, @(vars) nonlcon(vars,t_j1),opts);

% 获取解
% x_solution = sol.x;
y_solution = reshape(sol(n_i*n_j),n_i,n_j);
% u_solution = sol.u;

%% 目标函数
function f = objectiveF(vars)
    %提取变量x,y,u
    n_i=50;
    n_j=24;
    el=1e-10;
%     y=reshape(vars(),n_i,n_j);
    u=reshape(vars(n_i*n_j+1:end),n_i,1);
    f=sum(u);
end
%% 非线性约束
function [c, ceq] = nonlcon(vars,t_j)
    global nVars;
    % 变量调整
    if length(vars) ~= nVars
        error('The length of vars does not match the expected length.');
    end
    n_i=50;
    n_j=24;
    y=reshape(vars(1:n_i*n_j),n_i,n_j);
    u=reshape(vars(n_i*n_j+1: end),n_i,1);
    c1=-sum(sum(y./t_j))+(2.82e4)*n_j;
    c=[c1(:)];
    % 线性等式约束
    row_sumx=sum(y,2);
    u_temp=double(row_sumx>0);
    ceq= u-u_temp;

end

%% 计算t.Q
function result=T(a)
    global t id_abcs;
    result=t(id_abcs(a));
end

function result=Qcompu(i,j)
    global supply_50;
    max=supply_50(i,j);
    for b=1:9
        if max< supply_50(i,b*24+j)
            max=supply_50(i,b*24+j);
        end
    end
    result=max;
end


 %% 定义变量
% load('data50.mat');
% n_i = 50;
% n_j = 24;
% global nVars;
% nVars=n_i*n_j*2+n_i;
% 
% % % 二进制数据 x
% % x = optimvar('x', n_i, n_j, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
% % y = optimvar('y', n_i, n_j, 'LowerBound', 0);
% % u = optimvar('u', n_i, 1, 'Type', 'integer', 'LowerBound', 0, 'UpperBound',1);
% % f=sum(u);
% 
% % 计算t_j
% t_j = zeros(n_i, 1);
% for i = 1:n_i
%     t_j(i) = T(i);
% end
% t_j1 = repmat(t_j, 1, size(z, 2));
% 
% % 计算 Q 值
% Q = zeros(n_i, n_j);
% for i = 1:n_i
%     for j = 1:n_j
%         Q(i, j) = Qcompu(i, j);
%     end
% end
% lb = [zeros(n_i*n_j, 1); zeros(n_i*n_j, 1); zeros(n_i, 1)]; % x和u的下界为0, y的下界为0
% ub = [ones(n_i*n_j, 1); Q(:); ones(n_i, 1)];
% 
% % % 创建优化问题并添加目标函数和约束条件
% % prob = optimproblem('Objective', f);
% % prob.Constraints.cons1 = constraint1;
% % prob.Constraints.cons2 = constraint2;
% % prob.Constraints.cons3 = constraint3;
% % prob.Constraints.cons4 = constraint4;
% % prob.Constraints.cons5 = constraint5;
% 
% % 求解问题
% 
% opts = optimoptions('ga', 'Display', 'iter','MaxTime', 300,'UseParallel', true, ...
%     'PopulationSize', 50, 'MaxGenerations', 30);
% % sol = solve(prob, 'Options', opts);
% [sol, fval]= ga(@(vars) objectiveF(vars),nVars, [],[],[],[], lb, ub, @(vars) nonlcon(vars,t_j1,Q),opts);
% 
% % 获取解
% x_solution = sol.x;
% y_solution = sol.y;
% u_solution = sol.u;
% 
% %% 目标函数
% function f = objectiveF(vars)
%     %提取变量x,y,u
%     n_i=50;
%     n_j=24;
% %     x=reshape(vars(1:n_i*n_j),n_i,n_j);
% %     y=reshape(vars(n_i*n_j+1 : 2*n_i*n_j),n_i,n_j);
%     u=reshape(vars(2*n_i*n_j+1 : end),n_i,1);
%     f=sum(u);
% end
% %% 非线性约束
% function [c, ceq] = nonlcon(vars,t_j,Q)
%     global nVars;
%     % 变量调整
%     if length(vars) ~= nVars
%         error('The length of vars does not match the expected length.');
%     end
%     n_i=50;
%     n_j=24;
%     x=reshape(vars(1:n_i*n_j),n_i,n_j);
%     y=reshape(vars(n_i*n_j + 1 : 2*n_i*n_j),n_i,n_j);
%     u=vars((2* n_i* n_j +1) : end);
%     
%     c1=-sum(x.*y./t_j,1)+2e4;
% %     c2=sum(x,2)-n_j*u;
%     c=[c1(:)];
%     
%     % 线性等式约束
% %     row_sumx=sum(x,2);
% %     u_temp=double(row_sumx>0);
% %     ceq= u-u_temp;
%     ceq=[];
% end
% 
% %% 计算t.Q
% function result=T(a)
%     global t id_abcs;
%     result=t(id_abcs(a));
% end
% 
% function result=Qcompu(i,j)
%     global supply_50;
%     max=supply_50(i,j);
%     for b=1:9
%         if max< supply_50(i,b*24+j)
%             max=supply_50(i,b*24+j);
%         end
%     end
%     result=max;
% end

