function createFigure(t1, q1, t2, q2)
    [~, ~, ~, ~, ~, ~, phi, ~, ~, ~] = model_params;

    if ~exist('fig', 'dir'); mkdir('fig'); end

    %% 1. Angular Position
    fig1 = figure('Name','Angular position', 'NumberTitle','off', ...
                  'Units', 'centimeters', 'Position', [10, 10, 20, 10]);
    fig1.Color = [1 1 1];
    hold on;
    yline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 1, 'HandleVisibility', 'off');
    plot(t1, q1(:,3), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Without Clutch');
    plot(t2, q2(:,3), 'b-', 'LineWidth', 1.5, 'DisplayName', 'With Clutch');
    axis([0 10 -0.8 0.5]);
    xlabel('Time (s)', 'Interpreter', 'latex');
    ylabel('Angular position [$\mathrm{rad}$]', 'Interpreter', 'latex');
    legend('Interpreter','latex','Location','southeast');
    ax = gca; ax.FontSize = 15; ax.LineWidth = 1.2; ax.FontName = 'Times New Roman';
    exportgraphics(fig1, 'fig/AngularPosition_Compare.pdf', 'ContentType', 'vector');

    %% 2. Angular Velocity
    fig2 = figure('Name','Angular velocity', 'NumberTitle','off', ...
                  'Units', 'centimeters', 'Position', [10, 10, 20, 10]);
    fig2.Color = [1 1 1]; hold on;
    yline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 1, 'HandleVisibility', 'off');
    plot(t1, q1(:,8), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Without Clutch');
    plot(t2, q2(:,8), 'b-', 'LineWidth', 1.5, 'DisplayName', 'With Clutch');
    axis([0 5 0.5 3]);
    xlabel('Time (s)', 'Interpreter', 'latex');
    ylabel('Angular velocity [$\mathrm{rad/s}$]', 'Interpreter', 'latex');
    legend('Interpreter','latex','Location','southeast');
    ax = gca; ax.FontSize = 15; ax.LineWidth = 1.2; ax.FontName = 'Times New Roman';
    exportgraphics(fig2, 'fig/AngularVelocity_Compare.pdf', 'ContentType', 'vector');

    % 3. Phase Diagram
    fig3 = figure('Name','Phase diagram', 'NumberTitle','off', ...
                  'Units', 'centimeters', 'Position', [10, 10, 15, 15]);
    fig3.Color = [1 1 1]; hold on;
    xline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 1, 'HandleVisibility', 'off');
    plot(q1(:,3), q1(:,8), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Without Clutch');
    plot(q2(:,3), q2(:,8), 'b-', 'LineWidth', 1.5, 'DisplayName', 'With Clutch');
    xlabel('${\theta}$ [rad]', 'Interpreter','latex');
    ylabel('$\dot{\theta}$ [rad/s]', 'Interpreter','latex');
    legend('Interpreter','latex','Location','best');
    axis square;
    ax = gca; ax.FontSize = 15; ax.LineWidth = 1.2; ax.FontName = 'Times New Roman';
    exportgraphics(fig3, 'fig/PhaseDiagram_Compare.pdf', 'ContentType', 'vector');
    % 
    % %% 4. Leg Length
    % fig4 = figure('Name','Leg length', 'NumberTitle','off', ...
    %               'Units', 'centimeters', 'Position', [10, 10, 20, 10]);
    % fig4.Color = [1 1 1]; hold on;
    % plot(t1, q1(:,4)-0.003, 'Color', [0 0.5 0],  'LineWidth', 1.5, 'DisplayName', 'Leg1 w/ Clutch');
    % plot(t1, q1(:,5)-0.003, 'Color', [0 0.7 0],  'LineWidth', 1.5, 'DisplayName', 'Leg2 w/ Clutch');
    % plot(t2, q2(:,4)-0.003, 'Color', [0 0 0.7], 'LineWidth', 1.5, 'DisplayName', 'Leg1 w/o Clutch');
    % plot(t2, q2(:,5)-0.003, 'Color', [0 0 1],   'LineWidth', 1.5, 'DisplayName', 'Leg2 w/o Clutch');
    % xlabel('Time (s)', 'Interpreter', 'latex');
    % ylabel('Leg length [$\mathrm{m}$]', 'Interpreter', 'latex');
    % axis([0 3 0.21 0.25]);
    % legend('Interpreter','latex','Location','best');
    % ax = gca; ax.FontSize = 15; ax.LineWidth = 1.2; ax.FontName = 'Times New Roman';
    % exportgraphics(fig4, 'fig/LegLength_Compare.pdf', 'ContentType', 'vector');
    % 
    % %% 5. Z0 CoM
    % x0_1 = q1(:,1) + q1(:,4) .* sin(q1(:,3));
    % z0_1 = q1(:,2) + q1(:,4) .* cos(q1(:,3));
    % Z0_1 = z0_1 * cos(phi) - x0_1 * sin(phi);
    % 
    % x0_2 = q2(:,1) + q2(:,4) .* sin(q2(:,3));
    % z0_2 = q2(:,2) + q2(:,4) .* cos(q2(:,3));
    % Z0_2 = z0_2 * cos(phi) - x0_2 * sin(phi);
    % 
    % fig5 = figure('Name','Z0 comparison', 'NumberTitle','off', ...
    %               'Units', 'centimeters', 'Position', [10, 10, 20, 10]);
    % fig5.Color = [1 1 1]; hold on;
    % plot(t1, Z0_1, 'r-', 'LineWidth', 1.5, 'DisplayName', 'With Clutch');
    % plot(t2, Z0_2, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Without Clutch');
    % xlabel('Time (s)', 'Interpreter', 'latex');
    % ylabel('$Z_0\ \mathrm{[m]}$', 'Interpreter', 'latex');
    % legend('Interpreter','latex','Location','best');
    % ax = gca; ax.FontSize = 15; ax.LineWidth = 1.2; ax.FontName = 'Times New Roman';
    % exportgraphics(fig5, 'fig/Z0_Compare.pdf', 'ContentType', 'vector');
end