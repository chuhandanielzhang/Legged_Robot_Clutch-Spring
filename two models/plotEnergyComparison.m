function plotEnergyComparison(t1, q1, t2, q2)
    [~, ~, E_total1, ~] = energy(q1, t1);
    [~, ~, E_total2, ~] = energy(q2, t2);

    if ~exist('fig', 'dir')
        mkdir('fig');
    end

    fig = figure('Name','Energy Comparison', 'NumberTitle','off', ...
                 'Units','centimeters', 'Position', [5, 5, 20, 10]);
    fig.Color = [1 1 1];
    hold on;

    plot(t1, E_total1, 'Color', [0.15 0.45 0.8], 'LineWidth', 2, 'DisplayName', 'With Clutch');
    plot(t2, E_total2, 'Color', [0.85 0.33 0.1], 'LineWidth', 2, 'DisplayName', 'Without Clutch');

    xlim([0 20]);
    xlabel('Time [s]', 'Interpreter','latex');
    ylabel('Mechanical Energy [J]', 'Interpreter','latex');
    legend('Location','best');
    grid on;

    ax = gca;
    ax.FontSize = 14;
    ax.LineWidth = 1.2;
    ax.FontName = 'Times New Roman';

    exportgraphics(fig, 'fig/CompareEnergy.pdf', 'ContentType', 'vector');
end