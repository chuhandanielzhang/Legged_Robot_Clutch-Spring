clear; clc;
global phi_global;
phi_global = deg2rad(0.010061); 

% === 参数初始化 ===
[m, m_h, I_c, a, g, alpha, phi, L_0, k, c, F_0] = model_params;

Z0_initial = [L_0; 0.0; 0.0];  
Z = Z0_initial;

% === 预热迭代（推荐）===
for i = 1:10
    Znext = Poincare_map(Z);
    fprintf('Step %2d: ‖P(Z) - Z‖ = %.2e\n', i, norm(Znext - Z)); 
    Z = Znext;           
end

% === 精确周期解求解 ===
[Z0_periodic, jacobian] = PM_periodic_sol(Z); 
disp('周期点 Z = [L1, dtheta, dL1]：');
disp(Z0_periodic.');

Z_ret = Poincare_map(Z0_periodic);
fprintf('庞加莱映射误差：%.6e\n', norm(Z_ret - Z0_periodic));