function [value, isterminal, direction] = detectCollision(~, q)

	[~, ~, ~, ~, ~, alpha, phi, L_0, ~, ~] = model_params;
	x = q(4)*sin(q(3))+L_0*sin(alpha-q(3));
    z = q(4)*cos(q(3))-L_0*cos(alpha-q(3));
    Z = z*cos(phi)-x*sin(phi);
    Z1 = -sqrt(L_0^2+q(4)^2-2*L_0*q(4)*cos(alpha))*sin(phi);
    value(1) = Z-Z1;
	isterminal(1) = 1;
	direction(1) = -1;

    xl = q(4)*sin(q(3))-L_0*sin(alpha+q(3));
    zl = q(4)*cos(q(3))-L_0*cos(alpha+q(3));
    Zl = zl*cos(phi)-xl*sin(phi);
    Z1l = sqrt(L_0^2+q(4)^2-2*L_0*q(4)*cos(alpha))*sin(phi);
    value(2) = Zl-Z1l;
	isterminal(2) = 1;
	direction(2) = -1;
end

