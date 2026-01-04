function Znew = Poincare_map(Zold)
    % Zold: [L1, dtheta]
    [~, ~, ~, ~, ~, ~, ~, L_0, ~, ~, ~] = model_params;

    % 初始完整状态：theta = 0，L2 = L_0，其余为 0
    q0 = [0, 0, 0, Zold(1), L_0, 0, 0, Zold(2), 0, 0];
    phase = 1;

    maxstep = 200;
    t_total = 20.0;
    tdiv = 1e-5;
    t_remain = t_total;

    global odetimes;

    for step = 1:maxstep
        if t_remain <= 1e-6
            fprintf('[FAIL] Time exhausted.\n');
            Znew = 100 * ones(2,1);
            return;
        end

        tspan = 0:tdiv:t_remain;
        if length(tspan) < 2
            tspan = [0, tdiv];
        end

        ie_event = [];

        switch phase
            case 1  % 单支撑
                options = odeset('Events', @clutch_dl1, ...
                    'RelTol', 1e-12, 'AbsTol', 1e-13*ones(1,10), 'Refine', 15);
                [T, Q, ~, ~, ie_event] = ode45(@rimless_single, tspan, q0, options);

            case 2  % clutch
                options = odeset('Events', @detectCollision, ...
                    'RelTol', 1e-12, 'AbsTol', 1e-13*ones(1,10), 'Refine', 15);
                [T, Q, ~, ~, ie_event] = ode45(@rimless_clutch, tspan, q0, options);

            case 3  % 双支撑
                options = odeset('Events', @enddouble, ...
                    'RelTol', 1e-12, 'AbsTol', 1e-13*ones(1,10), 'Refine', 15);
                odetimes = 0;
                [T, Q, ~, ~, ie_event] = ode45(@rimless_double, tspan, q0, options);
        end

        if isempty(T)
            fprintf('[FAIL] Empty integration (phase %d).\n', phase);
            Znew = 100 * ones(2,1);
            return;
        end

        t_remain = t_remain - T(end);

        switch phase
            case 1
                if ~isempty(ie_event)
                    q0 = changeLegclutch(Q(end, :));
                    phase = 2;
                end

            case 2
                if ~isempty(ie_event)
                    if any(ie_event == 1)
                        q0 = changeLeg(Q(end, :));
                        phase = 3;
                    elseif any(ie_event == 2)
                        fprintf('[FAIL] Left leg collision.\n');
                        Znew = 100 * ones(2,1);
                        return;
                    end
                end

            case 3
                if ~isempty(ie_event)
                    q0 = changeLegdouble(Q(end, :));

                    % === 开始检测庞加莱截面 θ = 0 ===
                    options = odeset('Events', @thetaZeroEvent, ...
                        'RelTol', 1e-12, 'AbsTol', 1e-13*ones(1,10), 'Refine', 15);
                    [~, Q2, ~, ~, ie_theta] = ode45(@rimless_single, 0:tdiv:t_remain, q0, options);

                    if isempty(Q2) || isempty(ie_theta)
                        fprintf('[FAIL] No θ = 0 event.\n');
                        Znew = 100 * ones(2,1);
                    else
                        Znew = Q2(end, [4, 8])';  % [L1, dtheta]
                    end
                    return;
                end
        end
    end

    fprintf('[FAIL] Step limit exceeded.\n');
    Znew = 100 * ones(2,1);
end

function [value, isterminal, direction] = thetaZeroEvent(~, q)
    value = q(3);         % θ
    isterminal = 1;
    direction = 1;        % 从负到正
end