load("data50.mat");
n_i=50;
n_j= 24;
nVar=n_i*n_j*2+n_i;

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
lb=zeros(1,nVars);
ub=[ones(n_i*n_j,1);Q(:);ones(n_i,1)];
    
% 设置options
opts=optimoptions('particleswarm', 'Display', 'iter' ...
    ,'SwarmSize', 100, 'MaxIterations' ,300, 'UseParallel', true);

[sol, fval]= particleswarm(@(vars) objectiveF(vars, t_j1), nVars, lb, ub,opts );

disp('Solution:');
x_solution = reshape(sol(1:n_i * n_j), n_i, n_j);
y_solution = reshape(sol(n_i * n_j + 1:2 * n_i * n_j), n_i, n_j);
u_solution = sol(2 * n_i * n_j + 1:end);
disp('x matrix:');
disp(x_solution);
disp('y matrix:');
disp(y_solution);
disp('u vector:');
disp(u_solution);
disp('Objective Function Value:');
disp(fval);


%% 设置目标函数
function f= objectiveF(vars, t)
    n_i=50;
    n_j=24;
    n=n_i*n_j;
    x=reshape( vars( 1: n),n_i,n_j);
    y=reshape( vars(n+1 : 2*n ), n_i, n_j);
    u=reshape( vars(2*n+1 : end), n_i, 1);

%     设置目标函数
    baseObjective= sum(u);
    penalty= penaltyCompu(x, y,u, t);
     
    f= baseObjective+ penalty;
end


function penalty=penaltyCompu(x,y,u, t)
    penaltyFactor=1e-2;

    columns1=sum(x.* y./ t,1);
    c1=max(0, 2e4-columns1);

    sumy=sum(y,2);
    columns2=sum(max(0, u-double(sumy ~=0)));
    penalty= penaltyFactor*( sum(c1)+ columns2);
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