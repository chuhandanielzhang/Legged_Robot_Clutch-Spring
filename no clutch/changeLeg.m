function q0 = changeLeg(q)

	[~, ~, ~, ~, ~, alpha, ~, L_0, ~, ~] = model_params;
    
    qm(1) = q(1) + q(4)*sin(q(3)) + L_0*sin(alpha-q(3));
    qm(2) = q(2) + q(4)*cos(q(3)) - L_0*cos(alpha-q(3));
	qm(3) = q(3) - alpha;
    qm(4) = L_0;
    qm(5) = q(4);
	qm(6) = q(6)+(q(4)*cos(q(3))-L_0*cos(alpha-q(3)))*q(8)+q(9)*sin(q(3));
	qm(7) = q(7)-(q(4)*sin(q(3))+L_0*sin(alpha-q(3)))*q(8)+q(9)*cos(q(3));
	qm(8) = q(8);
    qm(9) = 0;
    qm(10) = q(9);


	[M, ~] = dynamics_mat(qm);

    J33 = qm(4)*cos(qm(3))-qm(5)*cos(alpha+qm(3));
    J35 = -sin(qm(3)+alpha);
    J43 = -qm(4)*sin(qm(3))+qm(5)*sin(alpha+qm(3));%%
    J45 = -cos(qm(3)+alpha);
    Ji = [1 0 0 0 0;
		  0 1 0 0 0;
          1 0 J33 sin(qm(3)) J35;
          0 1 J43 cos(qm(3)) J45];

    q_min = [q(6)+(q(4)*cos(q(3))-L_0*cos(alpha-q(3)))*q(8)+q(9)*sin(q(3)); 
             q(7)-(q(4)*sin(q(3))+L_0*sin(alpha-q(3)))*q(8)+q(9)*cos(q(3));
             q(8);
             0;
             q(9)]';

	Qp = (eye(5) - M\Ji'/(Ji/M*Ji')*Ji)*q_min';

    q0(1) = q(1) + q(4)*sin(q(3)) + L_0*sin(alpha-q(3));
    q0(2) = q(2) + q(4)*cos(q(3)) - L_0*cos(alpha-q(3));
	q0(3) = q(3) - alpha;
    q0(4) = L_0;
    q0(5) = q(4);
	q0(6) = 0;
	q0(7) = 0;
	q0(8) = Qp(3);
    q0(9) = Qp(4);
    q0(10) = Qp(5);
end

