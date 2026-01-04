function Znew = Poincare_map(Zold)
    [~, ~, ~, ~, ~, ~, ~, L_0, ~, ~, ~] = model_params;
    q0 = [0, 0, 0, Zold(1), L_0, 0, 0, Zold(2), Zold(3), 0];

    maxstep = 200;
    t_total = 20.0;
    tdiv = 1e-5;
    t_remain = t_total;

    single = 1;  
    global odetimes;
    

    for step = 1:maxstep
        tspan = 0:tdiv:t_remain;
        ie_single = [];
        ie_double = [];

        if single == 1
            options = odeset('Events', @detectCollision, ...
                'RelTol', 1e-12, 'AbsTol', 1e-13 * ones(1,10), 'Refine', 15);
            [T, Q, ~, ~, ie_single] = ode45(@rimless_single, tspan, q0, options);
        else
            options = odeset('Events', @enddouble, ...
                'RelTol', 1e-12, 'AbsTol', 1e-13 * ones(1,10), 'Refine', 15);
            odetimes = 0;
            [T, Q, ~, ~, ie_double] = ode45(@rimless_double, tspan, q0, options);
        end

        t_remain = t_remain - T(end);
        if t_remain <= 0
            Znew = ones(3, 1) * 100;
            return;
        end

        if ~isempty(ie_single)
            if any(ie_single == 1)
                q0 = changeLeg(Q(end,:));
                single = 0;
            elseif any(ie_single == 2)
                Znew = ones(3, 1) * 100;
                return;
            end

        elseif ~isempty(ie_double)
            q0 = changeLegdouble(Q(end,:));

            options = odeset('Events', @thetaZeroEvent, ...
                'RelTol', 1e-12, 'AbsTol', 1e-13 * ones(1,10), 'Refine', 15);
            [~, Q2, ~, ~, ~] = ode45(@rimless_single, 0:tdiv:t_remain, q0, options);

            if isempty(Q2)
                Znew = ones(3, 1) * 100;
            else
                Znew = Q2(end, [4, 8, 9])';  % [L1, dtheta, dL1]
            end
            return;

        else
            Znew = ones(3, 1) * 100;
            return;
        end
    end

    % === 超出最大步数仍未返回 ===
    Znew = ones(3, 1) * 100;
end

% === 显式定义 θ = 0 作为庞加莱截面 ===
function [value, isterminal, direction] = thetaZeroEvent(~, q)
    value = q(3);        % 事件变量：θ
    isterminal = 1;      % 命中后终止积分
    direction = 1;       % 只接受 θ 从负到正穿越 0
end