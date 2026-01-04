% Initialize
close all;
clear variables;
clc;

% Parameters
[m, m_h, I_c, a, g, alpha, phi, L_0, k, c, F_0] = model_params;

% Settings
q0 = [0 0 0  0.235927  L_0 0 0 0.850741 -0.061522 0]; %[x z theta L1 L2 dx dz dtheta dL1 dL2]
maxstep = 200;
tstt = 0.0;
tend = 20.0;
tdiv = 1e-5;

index = 1;
tspan = tstt:tdiv:tend;
time = zeros(length(tspan), 1);
result = zeros(length(tspan), 10);
phase = zeros(length(tspan), 1); 

% Simulation
single = 1; %% single:1 Double:0

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
    fprintf('[No Clutch]: step = %3d, time: %.2f\n', step, T(end));

    if step == 1
        time(index:index+length(T)-1, 1) = T;
        result(index:index+length(T)-1, :) = Q;
        phase(index:index+length(T)-1, 1) = single; 
        index = index + length(T);
    else
        time(index:index+length(T)-2, 1) = T(2:end);
        result(index:index+length(T)-2, :) = Q(2:end, :);
        phase(index:index+length(T)-2, 1) = single; 
        index = index + length(T) - 1;
    end

    if tend - fix(T(end)/tdiv)*tdiv <= tdiv
        fprintf('[SSP]: The time is limited to %.5f sec.\n\n', tend);
        time = time(1:index-1, 1);
        result = result(1:index-1, :);
        phase = phase(1:index-1, 1);
        break;
    elseif step == maxstep
        fprintf('[DSP]: The step number is limited to %d step.\n\n', maxstep);
        time = time(1:index-1, 1);
        result = result(1:index-1, :);
        phase = phase(1:index-1, 1);
        break;
    end

    tspan = T(end):tdiv:tend;

    if ~isempty(ie_single)
        if any(ie_single == 1)
            q0 = changeLeg(Q(end, :));
            single = 0;
        elseif any(ie_single == 2)
            fprintf('[EXIT]: left leg collision detected. Ending simulation.\n');
            time = time(1:index-1, 1);
            result = result(1:index-1, :);
            phase = phase(1:index-1, 1);
            break;
        end
    elseif ~isempty(ie_double)
        q0 = changeLegdouble(Q(end, :));
        single = 1;
    else
        break;
    end
end


%% Animation
fps = 30;
speed = 0.5;
createAnimation(time, result, phase, fps, speed);

%% Figure
createFigure(time, result, phase);

%%
plotEnergy(time, result);

