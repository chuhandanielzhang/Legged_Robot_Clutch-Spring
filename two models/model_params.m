function [m, m_h, I_c, a, g, alpha, phi, L_0, k, c, F_0] = model_params
    m = 37.8*0.001;
    m_h = 1892.3 * 0.001;
    I_c = 0.036;
    a = 20 * 0.001;
    g = 9.8;
    alpha = pi/4;
    L_0 = 237 * 0.001;
    k = 3035;
    c = 8;
    phi = deg2rad(2);
    F_0 = 0.003 * k;
end

