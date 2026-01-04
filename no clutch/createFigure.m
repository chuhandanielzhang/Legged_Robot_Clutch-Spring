function createFigure(t, q, phase)
    [~, ~, ~, ~, ~, ~, phi, ~, ~, ~] = model_params;

    % === 1. DSP ===
    dsp_regions = [];
    t1 = []; 
    for i = 2:length(phase)
        if isempty(t1) && phase(i-1) == 1 && phase(i) == 0
            t1 = t(i);  
        elseif ~isempty(t1) && phase(i-1) == 0 && phase(i) == 1
            t2 = t(i);  
            dsp_regions = [dsp_regions; t1, t2]; 
            t1 = [];  
        end
    end

    if ~exist('fig', 'dir'); mkdir('fig'); end

    % === 2. Angular Position ===
    fig1 = figure('Name','Angular position', 'NumberTitle','off', ...
                  'Units', 'centimeters', 'Position', [10, 10, 20, 10]);
    fig1.Color = [1 1 1]; 
    hold on;
    yline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 1);
    plot(t, q(:,3), 'Color', '#D6292E', 'LineWidth', 1.5);
    xlabel('Time (s)', 'FontSize', 15, 'Interpreter', 'latex');
    ylabel('Angular position [$\mathrm{rad}$]', 'FontSize', 15, 'Interpreter', 'latex');
    ax = gca;
    ax.FontSize = 15; ax.LineWidth = 1.2; ax.FontName = 'Times New Roman';
    exportgraphics(fig1, 'fig/AngularPosition.pdf', 'ContentType', 'vector');

    % === 3. Angular Velocity ===
    fig2 = figure('Name','Angular velocity', 'NumberTitle','off', ...
                  'Units', 'centimeters', 'Position', [10, 10, 20, 10]);
    fig2.Color = [1 1 1];
    hold on;
    yline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 1);
    plot(t, q(:,8), 'Color', '#D6292E', 'LineWidth', 1.5);
    xlabel('Time (s)', 'FontSize', 15, 'Interpreter', 'latex');
    ylabel('Angular velocity [$\mathrm{rad/s}$]', 'FontSize', 15, 'Interpreter', 'latex');
    ax2 = gca;
    ax2.FontSize = 15; ax2.LineWidth = 1.2; ax2.FontName = 'Times New Roman';
    exportgraphics(fig2, 'fig/AngularVelocity.pdf', 'ContentType', 'vector');

    % === 4. Phase Diagram ===
    fig3 = figure('Name','Phase diagram', 'NumberTitle','off', ...
                  'Units', 'centimeters', 'Position', [10, 10, 15, 15]);
    fig3.Color = [1 1 1];
    hold on;
    xline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 1);
    plot(q(:,3), q(:,8), 'Color', '#D6292E', 'LineWidth', 1.5);
    xlabel('${\theta}$ [rad]', 'FontSize', 15, 'Interpreter','latex');
    ylabel('$\dot{\theta}$ [rad/s]', 'FontSize', 15, 'Interpreter','latex');
    axis square;
    ax3 = gca;
    ax3.FontSize = 15; ax3.LineWidth = 1.2; ax3.FontName = 'Times New Roman';
    exportgraphics(fig3, 'fig/PhaseDiagram.pdf', 'ContentType', 'vector');

    % === 5. Leg Length ===
    fig4 = figure('Name','Leg length', 'NumberTitle','off', ...
        'Units', 'centimeters', 'Position', [10, 10, 20, 10]);
    fig4.Color = [1 1 1];
    hold on;

    axis([0 3 0.21 0.25]);
    ylims = ylim();
    y1 = ylims(1); y2 = ylims(2);

    for i = 1:size(dsp_regions,1)
        t1 = dsp_regions(i,1); 
        t2 = dsp_regions(i,2); 
        h = fill([t1 t2 t2 t1], [y1 y1 y2 y2], ...
            [1.0, 1.0, 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';  
    end

    plot(t, q(:,4)-0.003, 'Color', '#006400', 'LineWidth', 1.5,'DisplayName', 'Leg 1');  
    plot(t, q(:,5)-0.003, 'Color', '#0000FF', 'LineWidth', 1.5, 'DisplayName', 'Leg 2');  
    legend('Interpreter', 'latex', 'Location', 'best');
    xlabel('Time (s)', 'FontSize', 15, 'Interpreter', 'latex');
    ylabel('Leg length [$\mathrm{m}$]', 'FontSize', 15, 'Interpreter', 'latex');
    ax4 = gca;
    ax4.FontSize = 15; ax4.LineWidth = 1.2; ax4.FontName = 'Times New Roman';
    exportgraphics(fig4, 'fig/Leg length.pdf', 'ContentType', 'vector');

    % === 6. CoM Z0 ===
    fig5 = figure('Name','Z0 position', 'NumberTitle','off', ...
        'Units', 'centimeters', 'Position', [10, 10, 20, 10]);
    fig5.Color = [1 1 1];
    hold on;

    axis([0 3.5 0.15 0.25]);
    ylims = ylim();
    y1 = ylims(1); y2 = ylims(2);

    for i = 1:size(dsp_regions,1)
        t1 = dsp_regions(i,1);
        t2 = dsp_regions(i,2);
        h = fill([t1 t2 t2 t1], [y1 y1 y2 y2], ...
            [1.0, 1.0, 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end

    x0 = q(:,1) + q(:,4) .* sin(q(:,3));
    z0 = q(:,2) + q(:,4) .* cos(q(:,3));
    Z0 = z0 * cos(phi) - x0 * sin(phi);
    plot(t, Z0, 'LineWidth', 1.5, 'Color', '#2A3077');
    xlabel('Time (s)', 'FontSize', 15, 'Interpreter', 'latex');
    ylabel('$Z_0\ \mathrm{[m]}$', 'FontSize', 15, 'Interpreter', 'latex');
    ax5 = gca;
    ax5.FontSize = 15; ax5.LineWidth = 1.2; ax5.FontName = 'Times New Roman';
    exportgraphics(fig5, 'fig/Z0.pdf', 'ContentType', 'vector');
end