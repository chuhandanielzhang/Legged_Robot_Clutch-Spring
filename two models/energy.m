function [T_all, V_all, E_total, E_dissipated] = energy(q, t)
    [m, m_h, I_c, a, g, alpha, phi, L_0, k, c, F0] = model_params;

    % 单位向量
    e1 = [1; 0];
    e2 = [0; 1];
    gravity_direction = sin(phi)*e1 - cos(phi)*e2;

    % 初始化能量数组
    N = size(q, 1);
    T_all = zeros(N, 1);
    V_all = zeros(N, 1);
    D_all = zeros(N, 1);

    for i = 1:N
        x = q(i, 1); z = q(i, 2); theta = q(i, 3); L1 = q(i, 4); L2 = q(i, 5);
        dx = q(i, 6); dz = q(i, 7); dtheta = q(i, 8); dL1 = q(i, 9); dL2 = q(i, 10);

        % com
        rH = (x + L1*sin(theta))*e1 + (z + L1*cos(theta))*e2;
        vH = [dx + dL1*sin(theta) + L1*dtheta*cos(theta);
              dz + dL1*cos(theta) - L1*dtheta*sin(theta)];

        % 显式定义 r1 ~ r8
        r1 = rH + (L_0-a)*sin(theta+alpha)*e1 + (L_0-a)*cos(theta+alpha)*e2;
        r2 = rH + (L_0-a)*sin(theta+2*alpha)*e1 + (L_0-a)*cos(theta+2*alpha)*e2;
        r3 = rH + (L_0-a)*sin(theta+3*alpha)*e1 + (L_0-a)*cos(theta+3*alpha)*e2;
        r4 = rH + (L1 -a)*sin(theta+4*alpha)*e1 + (L1 -a)*cos(theta+4*alpha)*e2;
        r5 = rH - (L2 -a)*sin(theta+alpha)*e1   - (L2 -a)*cos(theta+alpha)*e2;
        r6 = rH - (L_0-a)*sin(theta+2*alpha)*e1 - (L_0-a)*cos(theta+2*alpha)*e2;
        r7 = rH - (L_0-a)*sin(theta+3*alpha)*e1 - (L_0-a)*cos(theta+3*alpha)*e2;
        r8 = rH - (L_0-a)*sin(theta+4*alpha)*e1 - (L_0-a)*cos(theta+4*alpha)*e2;

        % 显式定义 v1 ~ v8
        v1 = vH + (L_0-a)*cos(theta+alpha)*dtheta*e1 - (L_0-a)*sin(theta+alpha)*dtheta*e2;
        v2 = vH + (L_0-a)*cos(theta+2*alpha)*dtheta*e1 - (L_0-a)*sin(theta+2*alpha)*dtheta*e2;
        v3 = vH + (L_0-a)*cos(theta+3*alpha)*dtheta*e1 - (L_0-a)*sin(theta+3*alpha)*dtheta*e2;
        v4 = vH + (L1 -a)*cos(theta+4*alpha)*dtheta*e1 - (L1 -a)*sin(theta+4*alpha)*dtheta*e2;
        v5 = vH - (L2 -a)*cos(theta+alpha)*dtheta*e1 + (L2 -a)*sin(theta+alpha)*dtheta*e2;
        v6 = vH - (L_0-a)*cos(theta+2*alpha)*dtheta*e1 + (L_0-a)*sin(theta+2*alpha)*dtheta*e2;
        v7 = vH - (L_0-a)*cos(theta+3*alpha)*dtheta*e1 + (L_0-a)*sin(theta+3*alpha)*dtheta*e2;
        v8 = vH - (L_0-a)*cos(theta+4*alpha)*dtheta*e1 + (L_0-a)*sin(theta+4*alpha)*dtheta*e2;
        T_i = 0.5 * m_h * (vH.' * vH) + 0.5 * I_c * dtheta^2;
        T_i = T_i + 0.5 * m * (v1.'*v1 + v2.'*v2 + v3.'*v3 + v4.'*v4 + ...
                               v5.'*v5 + v6.'*v6 + v7.'*v7 + v8.'*v8);
        T_all(i) = T_i;
        V_i = -m_h * g * (rH.' * gravity_direction);
        V_i = V_i - m * g * (r1.'*gravity_direction + r2.'*gravity_direction + ...
                             r3.'*gravity_direction + r4.'*gravity_direction + ...
                             r5.'*gravity_direction + r6.'*gravity_direction + ...
                             r7.'*gravity_direction + r8.'*gravity_direction);
        %V_i = V_i + 0.5 * k * (L_0 - L1)^2 + 0.5 * k * (L_0 - L2)^2;
        V_i = V_i + 0.5 * k * (L_0 - L1)^2 + F0 * (L_0 - L1) + 0.5 * k * (L_0 - L2)^2 + F0 * (L_0 - L2);
        V_all(i) = V_i;
        D_all(i) = 0.5 * c * (dL1^2 + dL2^2);
    end

    E_dissipated = cumtrapz(t, D_all);
    E_total = T_all + V_all;
end