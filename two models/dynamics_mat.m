function [M, h] = dynamics_mat(q)
    [m, m_h, I_c, a, g, alpha, phi, L_0, k, c, F_0] = model_params;
    theta = q(3);
    L_1 = q(4);
    L_2 = q(5);
    dtheta = q(8);
    dL_1 = q(9);
    dL_2 = q(10);
    M = [8*m + m_h 0 L_1*m*cos(4*alpha + theta) - L_0*m*cos(4*alpha + theta) + L_0*m*cos(alpha + theta) - L_2*m*cos(alpha + theta) + 8*L_1*m*cos(theta) + L_1*m_h*cos(theta) 8*m*sin(theta) + m_h*sin(theta) + m*sin(4*alpha + theta) -m*sin(alpha + theta); 0 8*m + m_h L_0*m*sin(4*alpha + theta) - L_1*m_h*sin(theta) - 8*L_1*m*sin(theta) - L_1*m*sin(4*alpha + theta) - L_0*m*sin(alpha + theta) + L_2*m*sin(alpha + theta) 8*m*cos(theta) + m_h*cos(theta) + m*cos(4*alpha + theta) -m*cos(alpha + theta); L_1*m*cos(4*alpha + theta) - L_0*m*cos(4*alpha + theta) + L_0*m*cos(alpha + theta) - L_2*m*cos(alpha + theta) + 8*L_1*m*cos(theta) + L_1*m_h*cos(theta) L_0*m*sin(4*alpha + theta) - L_1*m_h*sin(theta) - 8*L_1*m*sin(theta) - L_1*m*sin(4*alpha + theta) - L_0*m*sin(alpha + theta) + L_2*m*sin(alpha + theta) I_c + 6*L_0^2*m + 9*L_1^2*m + L_2^2*m + L_1^2*m_h + 8*a^2*m - 12*L_0*a*m - 2*L_1*a*m - 2*L_2*a*m + 2*L_1^2*m*cos(4*alpha) + 2*L_0*L_1*m*cos(alpha) - 2*L_1*L_2*m*cos(alpha) - 2*L_0*L_1*m*cos(4*alpha) m*(L_2*sin(alpha) - L_0*sin(alpha) + L_0*sin(4*alpha)) -L_1*m*sin(alpha); 8*m*sin(theta) + m_h*sin(theta) + m*sin(4*alpha + theta) 8*m*cos(theta) + m_h*cos(theta) + m*cos(4*alpha + theta) m*(L_2*sin(alpha) - L_0*sin(alpha) + L_0*sin(4*alpha)) 9*m + m_h + 2*m*cos(4*alpha) -m*cos(alpha); -m*sin(alpha + theta) -m*cos(alpha + theta) -L_1*m*sin(alpha) -m*cos(alpha) m];
    B = [16*dL_1*dtheta*m*cos(theta) - 2*dL_2*dtheta*m*cos(alpha + theta) + 2*dL_1*dtheta*m_h*cos(theta) - L_0*dtheta^2*m*sin(alpha + theta) + L_2*dtheta^2*m*sin(alpha + theta) + 2*dL_1*dtheta*m*cos(4*alpha + theta) - 8*L_1*dtheta^2*m*sin(theta) - L_1*dtheta^2*m_h*sin(theta) + L_0*dtheta^2*m*sin(4*alpha + theta) - L_1*dtheta^2*m*sin(4*alpha + theta); 2*dL_2*dtheta*m*sin(alpha + theta) - L_0*dtheta^2*m*cos(alpha + theta) + L_2*dtheta^2*m*cos(alpha + theta) - 16*dL_1*dtheta*m*sin(theta) - 2*dL_1*dtheta*m_h*sin(theta) - 2*dL_1*dtheta*m*sin(4*alpha + theta) - 8*L_1*dtheta^2*m*cos(theta) - L_1*dtheta^2*m_h*cos(theta) + L_0*dtheta^2*m*cos(4*alpha + theta) - L_1*dtheta^2*m*cos(4*alpha + theta); 2*dtheta*(9*L_1*dL_1*m + L_2*dL_2*m + L_1*dL_1*m_h - a*dL_1*m - a*dL_2*m + L_0*dL_1*m*cos(alpha) - L_1*dL_2*m*cos(alpha) - L_2*dL_1*m*cos(alpha) - L_0*dL_1*m*cos(4*alpha) + 2*L_1*dL_1*m*cos(4*alpha)); c*dL_1 - 9*L_1*dtheta^2*m - L_1*dtheta^2*m_h + a*dtheta^2*m + L_0*dtheta^2*m*cos(4*alpha) - 2*L_1*dtheta^2*m*cos(4*alpha) + 2*dL_2*dtheta*m*sin(alpha) - L_0*dtheta^2*m*cos(alpha) + L_2*dtheta^2*m*cos(alpha); c*dL_2 - dtheta*m*(L_2*dtheta - a*dtheta + 2*dL_1*sin(alpha) - L_1*dtheta*cos(alpha))];
    G = [-g*sin(phi)*(8*m + m_h); 
        g*cos(phi)*(8*m + m_h); 
        L_2*g*m*sin(alpha + phi + theta) - L_1*g*m_h*sin(phi + theta) - L_0*g*m*sin(alpha + phi + theta) - 8*L_1*g*m*sin(phi + theta) + L_0*g*m*sin(4*alpha + phi + theta) - L_1*g*m*sin(4*alpha + phi + theta); 
        L_1*k - L_0*k - F_0 + g*m*cos(4*alpha + phi + theta) + 8*g*m*cos(phi + theta) + g*m_h*cos(phi + theta); 
        - F_0 - (k*(2*L_0 - 2*L_2))/2 - g*m*cos(alpha + phi + theta)];
    h = B+G;
end
