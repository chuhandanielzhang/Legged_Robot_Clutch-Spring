function [dq,lambda] = rimless_double(~, q)
global odetimes;
odetimes=odetimes+1;
    [~, ~, ~, ~, ~, alpha, ~, ~, ~, ~] = model_params;
    [M, h] = dynamics_mat(q);

    J33 = q(4)*cos(q(3))-q(5)*cos(alpha+q(3));
    J35 = -sin(q(3)+alpha);
    J43 = -q(4)*sin(q(3))+q(5)*sin(alpha+q(3));%%
    J45 = -cos(q(3)+alpha);

    dJ33 = q(9)*cos(q(3))-q(4)*sin(q(3))*q(8)-q(10)*cos(alpha+q(3))+q(5)*sin(alpha+q(3))*q(8);
    dJ35 = -cos(q(3)+alpha)*q(8);
    dJ43 = -q(9)*sin(q(3))-q(4)*cos(q(3))*q(8)+q(10)*sin(alpha+q(3))+q(5)*cos(alpha+q(3))*q(8);
    dJ45 = sin(q(3)+alpha)*q(8);
	J = [ 1 0 0 0 0;
		  0 1 0 0 0;
          1 0 J33 sin(q(3)) J35;
          0 1 J43 cos(q(3)) J45];
    dJ = [0 0 0 0 0;
          0 0 0 0 0;
          0 0 dJ33 cos(q(3))*q(8) dJ35;
          0 0 dJ43 -sin(q(3))*q(8) dJ45];




	lambda = (J*(M\J')) \ (J*(M\h) - dJ*q(6:10));


	dq = zeros(10, 1);
	dq(1:5) = q(6:10);
	dq(6:10) = M\(J'*lambda - h);
end

