clear; clc;

[m, m_h, I_c, a, g, alpha, phi, L_0, k, c, F_0] = model_params;

%
Z0_initial = [L_0; 0];  
Z = Z0_initial;
for i = 1:10
    Znext = Poincare_map(Z);
    disp(norm(Znext - Z)); 
    Z = Znext;           
end

[Z0_periodic, jacobian] = PM_periodic_sol(Z); 
disp('周期点：');
disp(Z0_periodic.');

Z_ret = Poincare_map(Z0_periodic);
fprintf('庞加莱映射误差：%.6e\n', norm(Z_ret - Z0_periodic));

