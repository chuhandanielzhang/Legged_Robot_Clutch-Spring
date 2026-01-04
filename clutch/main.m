% Initialize
close all;
clear variables;
clc;

% Parameters
[m, m_h, I_c, a, g, alpha, phi, L_0, k, c] = model_params;

% Settings
q0 = [0 0 0  0.2368 L_0 0 0 0 0 0];%%phi=2
phase = 1;

maxstep = 200;
tstt = 0.0;
tend = 4.0;
tdiv = 1e-5;

index = 1;
tspan = tstt:tdiv:tend;
time = zeros(length(tspan), 1);
result = zeros(length(tspan), 10);
phase_clutch = zeros(length(tspan), 1); 

% Simulation
global odetimes;
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
        time(index:index+length(T)-1, 1) = T;
        result(index:index+length(T)-1, :) = Q;
        phase_clutch(index:index+length(T)-1, 1) = phase; 
        index = index + length(T);
    else
        time(index:index+length(T)-2, 1) = T(2:end);
        result(index:index+length(T)-2, :) = Q(2:end, :);
        phase_clutch(index:index+length(T)-2, 1) = phase;  
        index = index + length(T) - 1;
    end

    fprintf('[Phase %d]: step = %3d, time: %.2f\n', phase, step, T(end));

    if tend - fix(T(end)/tdiv)*tdiv <= tdiv || step == maxstep
        time = time(1:index-1, 1);
        result = result(1:index-1, :);
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
                    time = time(1:index-1, 1);
                    result = result(1:index-1, :);
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


%% Animation
fps = 30;
speed = 0.5;

%%
createFigure(time, result);


createAnimation(time, result, fps, speed, phase_clutch);  
%%
plotEnergy(time, result);