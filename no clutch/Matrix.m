syms I_c alpha l theta x z dx dz dtheta g L_1 L_2 L_0 a phi m_h m dL_1 dL_2 k c F_0 real
q = [x; z; theta; L_1; L_2];
dq = [dx; dz; dtheta; dL_1; dL_2];
e1 = [1; 0];
e2 = [0; 1];

% com
rH = (x + L_1*sin(theta))*e1 + (z + L_1*cos(theta))*e2;
vH = jacobian(rH, q) * dq;


r1 = rH + (L_0-a)*sin(theta+alpha)*e1 + (L_0-a)*cos(theta+alpha)*e2;
v1 = jacobian(r1, q) * dq;

r2 = rH + (L_0-a)*sin(theta+2*alpha)*e1 + (L_0-a)*cos(theta+2*alpha)*e2;
v2 = jacobian(r2, q) * dq;

r3 = rH + (L_0-a)*sin(theta+3*alpha)*e1 + (L_0-a)*cos(theta+3*alpha)*e2;
v3 = jacobian(r3, q) * dq;

r4 = rH + (L_1-a)*sin(theta+4*alpha)*e1 + (L_1-a)*cos(theta+4*alpha)*e2;
v4 = jacobian(r4, q) * dq;

% r4 = (x+a*sin(theta))*e1 + (z+a*cos(theta))*e2;
% v4 = jacobian(r4, q) * dq;

r5 = rH - (L_2-a)*sin(theta+alpha)*e1 - (L_2-a)*cos(theta+alpha)*e2;
v5 = jacobian(r5, q) * dq;

r6 = rH - (L_0-a)*sin(theta+2*alpha)*e1 - (L_0-a)*cos(theta+2*alpha)*e2;
v6 = jacobian(r6, q) * dq;

r7 = rH - (L_0-a)*sin(theta+3*alpha)*e1 - (L_0-a)*cos(theta+3*alpha)*e2;
v7 = jacobian(r7, q) * dq;

r8 = rH - (L_0-a)*sin(theta+4*alpha)*e1 - (L_0-a)*cos(theta+4*alpha)*e2;
v8 = jacobian(r8, q) * dq;

% 
% Energy
T = (1/2)*m_h*(vH.'*vH) + (1/2)*m*(v1.'*v1) + ...
    (1/2)*m*(v2.'*v2) + (1/2)*m*(v3.'*v3) + ...
    (1/2)*m*(v4.'*v4) + (1/2)*m*(v5.'*v5) + ...
    (1/2)*m*(v6.'*v6) + (1/2)*m*(v7.'*v7) + (1/2)*m*(v8.'*v8) + ...
    (1/2)*I_c*(dtheta)^2;

% 
gravity_direction = sin(phi)*e1 - cos(phi)*e2;
V = -m_h * g * (rH.' * gravity_direction) - ...
    m * g * (r1.' * gravity_direction) - ...
    m * g * (r2.' * gravity_direction) - ...
    m * g * (r3.' * gravity_direction) - ...
    m * g * (r4.' * gravity_direction) - ...
    m * g * (r5.' * gravity_direction) - ...
    m * g * (r6.' * gravity_direction) - ...
    m * g * (r7.' * gravity_direction) - ...
    m * g * (r8.' * gravity_direction) + ...
    (1/2)*k*(L_0 - L_1)^2 + F_0 * (L_0 - L_1) + ...
    (1/2)*k*(L_0 - L_2)^2 + F_0 * (L_0 - L_2);


D = (c/2)*(dL_1^2+dL_2^2);
Pd = jacobian(D, dq).';
M = simplify(jacobian(jacobian(T, dq), dq));
B = simplify(jacobian(jacobian(T, dq), q) * dq - jacobian(T, q).');
G = simplify(jacobian(V, q).');
B = Pd + B;

[n, m] = size(M);
for i = 1:n
    for j = 1:m
        latex_str = M(i,j); 
        fprintf('$$ M_{%d%d} = %s $$\n', i, j, latex_str);
    end
end

% 
[n, m] = size(B);
for i = 1:n
    for j = 1:m
        latex_str = B(i,j); 
        fprintf('$$ B_{%d%d} = %s $$\n', i, j, latex_str);
    end
end

[n, m] = size(G);
for i = 1:n
    for j = 1:m
        latex_str = G(i,j); 
        fprintf('$$ G_{%d%d} = %s $$\n', i, j, latex_str);
    end
end

print_matrix('M', M);
print_matrix('B', B);
print_matrix('G', G);


