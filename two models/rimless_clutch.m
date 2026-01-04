function dq = rimless_clutch(~, q)
    
    [M, h] = dynamics_mat(q);
	
	J = [ 1 0 0 0 0;
		  0 1 0 0 0;
          0 0 0 1 0];
	lambda = (J/M*J')\(J/M*h);
	
	dq = zeros(10, 1);
	dq(1:5) = q(6:10);
	dq(6:10) = M\(J'*lambda - h);
end