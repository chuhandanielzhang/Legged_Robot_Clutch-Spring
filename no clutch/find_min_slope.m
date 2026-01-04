% 寻找最小坡度（优化版）- 全角度表示
clear all;
close all;
clc;

% 全局变量用于传递坡度（弧度）
global phi_global;

% 模型参数
[m, m_h, I_c, a, g, alpha, ~, L_0, k, c, F_0] = model_params;

% === 扫描设置（全部使用角度表示）===
start_angle = 1.5;        % 起始坡度 (度)
step_angle = -0.01;        % 坡度递减步长 (度)
min_angle = 0.1;          % 最小坡度 (度)

% === 初始状态猜测 ===
Z0 = [L_0; 1.0; 0];      % [L1; dtheta; dL1]

% === 优化配置 ===
options = optimoptions('fsolve', ...
    'Algorithm', 'levenberg-marquardt', ...
    'Display', 'iter', ...
    'FunctionTolerance', 1e-5, ...
    'StepTolerance', 1e-5, ...
    'OptimalityTolerance', 1e-5, ...
    'MaxIterations', 100, ...
    'MaxFunctionEvaluations', 500, ...
    'FiniteDifferenceType', 'central', ...
    'FiniteDifferenceStepSize', 1e-6, ...
    'ScaleProblem', 'jacobian', ...
    'CheckGradients', false);

% === 坡度扫描 ===
min_viable_angle = [];    % 存储最小可行坡度（度）
solution = [];            % 存储周期解

% 角度扫描循环
current_angle = start_angle;
while current_angle >= min_angle
    % 转换为弧度（模型内部使用）
    phi_global = deg2rad(current_angle);
    
    fprintf('\n测试坡度: %.2f deg\n', current_angle);
    
    % 尝试求解不动点
    try
        [Z_sol, ~, exitflag] = fsolve(@fixed_point_eq, Z0, options);
        
        if exitflag > 0
            fprintf('>> 找到周期解!\n');
            fprintf('   L1=%.6f, dtheta=%.6f, dL1=%.6f\n', ...
                    Z_sol(1), Z_sol(2), Z_sol(3));
            
            % 保存结果
            min_viable_angle = current_angle;
            solution = Z_sol;
            Z0 = Z_sol; % 更新初始猜测
            
            % 减小坡度（使用角度步长）
            current_angle = current_angle + step_angle;
        else
            fprintf('>> 求解失败 (exitflag=%d)\n', exitflag);
            break;
        end
    catch ME
        fprintf('>> 求解错误: %s\n', ME.message);
        break;
    end
end

% === 输出结果 ===
if ~isempty(min_viable_angle)
    fprintf('\n===== 最小可行坡度: %.2f deg =====\n', min_viable_angle);
    fprintf('周期解: L1=%.6f, dtheta=%.6f, dL1=%.6f\n', ...
            solution(1), solution(2), solution(3));
    
    % 同时显示弧度值（供参考）
    fprintf('(弧度值: %.4f rad)\n', deg2rad(min_viable_angle));
else
    fprintf('\n未找到可行的周期解\n');
end

% === 不动点方程定义 ===
function F = fixed_point_eq(Z)
    % 计算庞加莱映射
    Z_map = Poincare_map(Z);
    
    % 检查是否发散
    if any(Z_map > 99)
        F = 1e6 * ones(size(Z)); % 大残差表示发散
    else
        F = Z_map - Z; % 不动点方程
    end
end