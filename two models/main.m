close all;
clear variables;
clc;

% === no clutch ===
[m, m_h, I_c, a, g, alpha, phi, L_0, k, c, F_0] = model_params;
% q0 = [0 0 -0.3745 0.2325 0.2360 0 0 2.4838 -0.2516 0.2304];
q0 = [0 0 0  0.2289  L_0 0 0 1.7134 -0.0232 0];

maxstep = 200;
tstt = 0.0;
tend = 20.0;
tdiv = 1e-5;

index = 1;
tspan = tstt:tdiv:tend;
time1 = zeros(length(tspan), 1);
result1 = zeros(length(tspan), 10);
phase_no = zeros(length(tspan), 1); 

single = 1;
global odetimes;

for step = 1:maxstep
    ie_single = [];
    ie_double = [];

    if single == 1
        options = odeset('Events', @detectCollision, 'RelTol', 1e-12, 'AbsTol', 1e-13*ones(1, 10), 'Refine', 15);
        [T, Q, ~, ~, ie_single] = ode45(@rimless_single, tspan, q0, options);
    else
        options = odeset('Events', @enddouble, 'RelTol', 1e-12, 'AbsTol', 1e-13*ones(1, 10), 'Refine', 15);
        odetimes=0;
        [T, Q, ~, ~, ie_double] = ode45(@rimless_double, tspan, q0, options);
    end

    if step == 1
        time1(index:index+length(T)-1, 1) = T;
        result1(index:index+length(T)-1, :) = Q;
        phase_no(index:index+length(T)-1, 1) = single; 
        index = index + length(T);
    else
        time1(index:index+length(T)-2, 1) = T(2:end);
        result1(index:index+length(T)-2, :) = Q(2:end, :);
        phase_no(index:index+length(T)-2, 1) = single; 
        index = index + length(T) - 1;
    end

    fprintf('NO: [Phase %d]: step = %3d, time = %.2f\n', single, step, T(end));

    if tend - fix(T(end)/tdiv)*tdiv <= tdiv
        fprintf('[SSP]: The time1 is limited to %.5f sec.\n\n', tend);
        time1 = time1(1:index-1, 1);
        result1 = result1(1:index-1, :);
        phase_no = phase_no(1:index-1, 1);
        break;
    elseif step == maxstep
        fprintf('[DSP]: The step number is limited to %d step.\n\n', maxstep);
        time1 = time1(1:index-1, 1);
        result1 = result1(1:index-1, :);
        phase_no = phase_no(1:index-1, 1);
        break;
    end

    tspan = T(end):tdiv:tend;

    if ~isempty(ie_single)
        if any(ie_single == 1)
            q0 = changeLeg(Q(end, :));
            single = 0;
        elseif any(ie_single == 2)
            fprintf('[EXIT]: left leg collision detected. Ending simulation.\n');
            time1 = time1(1:index-1, 1);
            result1 = result1(1:index-1, :);
            phase_no = phase_no(1:index-1, 1);
            break;
        end
    elseif ~isempty(ie_double)
        q0 = changeLegdouble(Q(end, :));
        single = 1;
    else
        break;
    end
end

% === with clutch ===
% q0 = [0 0 -0.3724 0.2304 0.2343 0 0 2.2454 -0.2267 0.2055];
q0 = [0 0 0  0.2368 L_0 0 0 1.0373 0 0];
phase = 1;

maxstep = 200;
tstt = 0.0;
tend = 20.0;
tdiv = 1e-5;

index = 1;
tspan = tstt:tdiv:tend;
time2 = zeros(length(tspan), 1);
result2 = zeros(length(tspan), 10);
phase_clutch = zeros(length(tspan), 1); 

for step = 1:maxstep
    ie_event = [];

    switch phase
        case 1
            options = odeset('Events', @clutch_dl1, 'RelTol', 1e-12, ...
                'AbsTol', 1e-13*ones(1, 10), 'Refine', 15);
            [T, Q, ~, ~, ie_event] = ode45(@rimless_single, tspan, q0, options);

        case 2
            options = odeset('Events', @detectCollision, 'RelTol', 1e-12, ...
                'AbsTol', 1e-13*ones(1, 10), 'Refine', 15);
            [T, Q, ~, ~, ie_event] = ode45(@rimless_clutch, tspan, q0, options);

        case 3
            options = odeset('Events', @enddouble, 'RelTol', 1e-12, ...
                'AbsTol', 1e-13*ones(1, 10), 'Refine', 15);
            odetimes=0;
            [T, Q, ~, ~, ie_event] = ode45(@rimless_double, tspan, q0, options);
    end

    if step == 1
        time2(index:index+length(T)-1, 1) = T;
        result2(index:index+length(T)-1, :) = Q;
        phase_clutch(index:index+length(T)-1, 1) = phase; 
        index = index + length(T);
    else
        time2(index:index+length(T)-2, 1) = T(2:end);
        result2(index:index+length(T)-2, :) = Q(2:end, :);
        phase_clutch(index:index+length(T)-2, 1) = phase;  
        index = index + length(T) - 1;
    end

    fprintf('Clutch: [Phase %d]: step = %3d, time2: %.2f\n', phase, step, T(end));

    if tend - fix(T(end)/tdiv)*tdiv <= tdiv || step == maxstep
        time2 = time2(1:index-1, 1);
        result2 = result2(1:index-1, :);
        phase_clutch = phase_clutch(1:index-1, 1); 
        break;
    end

    tspan = T(end):tdiv:tend;

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
                    fprintf('[EXIT]: left leg collision detected. Ending simulation.\n');
                    time2 = time2(1:index-1, 1);
                    result2 = result2(1:index-1, :);
                    phase_clutch = phase_clutch(1:index-1, 1); 
                    break;
                end
            end

        case 3
            if ~isempty(ie_event)
                q0 = changeLegdouble(Q(end, :));
                phase = 1;
            end
    end
end

%%
fps = 30;
speed = 0.5;
createEnergyAnimation(time1, result1, time2, result2, fps, speed);
%%
createFigure(time1, result1, time2, result2);


%%
plotEnergyComparison(time1, result1, time2, result2)


