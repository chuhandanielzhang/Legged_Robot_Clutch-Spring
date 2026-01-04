clear all; clc;

[m, m_h, I_c, a, g, alpha, phi, L_0, k, c, F_0] = model_params;

%% Jacobian Calculation:
Z0_initial = [0.2289, 1.7134, -0.0232].'; %[x z theta L1 L2 dx dz dtheta dL1 dL2]

for i = 1:2
    [Z0_periodic, ~, ~, ~, jacobian_G] = fsolve(@(Z)(Poincare_map(Z) - Z), Z0_initial);
    Z0_initial = Z0_periodic;
end

format long
jacobian_Poincare = jacobian_G + eye(3);
eigen_values_Poincare = eig(jacobian_Poincare);
abs_eigen_values = abs(eigen_values_Poincare);
disp('Absolute values of the eigenvalues:');
disp(abs_eigen_values);