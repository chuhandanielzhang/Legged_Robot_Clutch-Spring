function plotEnergy(t, q)
    [T, V, E_total, E_dissipated] = energy(q, t);
    fig = figure('Name','Total Energy', 'NumberTitle','off', ...
                  'Units', 'centimeters', 'Position', [10, 10, 20, 10]);
    fig.Color = [1 1 1];
    hold on;
    % plot(t, T, 'LineWidth', 2, 'DisplayName', 'Kinetic Energy');
    % plot(t, V, 'LineWidth', 2, 'DisplayName', 'Potential Energy');
    plot(t, E_total, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Mechanical Energy');
    % plot(t, E_dissipated, '--', 'LineWidth', 2, 'DisplayName', 'Dissipation');
   
    xlabel('Time [s]', 'Interpreter','latex');
    ylabel('Energy [J]', 'Interpreter','latex');
    legend('Location','northeast');
    grid on;
    ax = gca;
    ax.FontSize = 15; ax.LineWidth = 1.2; ax.FontName = 'Times New Roman';
    exportgraphics(fig, 'fig/TotalEnergy.pdf', 'ContentType', 'vector');
   
end

