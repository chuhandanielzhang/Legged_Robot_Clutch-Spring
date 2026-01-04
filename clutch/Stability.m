clear all; clc;

[m, m_h, I_c, a, g, alpha, phi, L_0, ~, c, F_0] = model_params;

%% Jacobian Calculation:
Z0_initial = [0.2368, 1.0373].'; 

for i = 1:2
    [Z0_periodic, ~, ~, ~, jacobian_G] = fsolve(@(Z)(Poincare_map(Z) - Z), Z0_initial);
    Z0_initial = Z0_periodic;
end

format long
jacobian_Poincare = jacobian_G + eye(2);
eigen_values_Poincare = eig(jacobian_Poincare);
abs_eigen_values = abs(eigen_values_Poincare);
disp('Absolute values of the eigenvalues:');
disp(abs_eigen_values);

%%
Z0_initial = [0.2368, 1.0373].'; 
Z = Z0_initial;
n_iter = 20;
Z_hist = zeros(2, n_iter);

for k = 1:n_iter
    Z = Poincare_map(Z);
    Z_hist(:, k) = Z;
end

figure;
plot(Z_hist(1,:), Z_hist(2,:), 'ro-','LineWidth',1.5);
xlabel('$L_1$', 'Interpreter','latex');
ylabel('$\dot{\theta}$', 'Interpreter','latex');
title('Poincaré Section Mapping (2D)');
axis equal;
grid on;