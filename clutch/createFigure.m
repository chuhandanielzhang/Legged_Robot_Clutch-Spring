function createFigure(t, q)
    [~, ~, ~, ~, ~, ~, phi, ~, ~, ~] = model_params;

    
    if ~exist('fig', 'dir'); mkdir('fig'); end
    
   
    % === 6. CoM Z0 ===
    fig5 = figure('Name','Z0 position', 'NumberTitle','off', ...
        'Units', 'centimeters', 'Position', [10, 10, 20, 10]);
    fig5.Color = [1 1 1];
    hold on;
    
    data = readtable('0608wk 14.csv'); 
    frame = data.Frame;
    TZ = data.TZ / 1000; 
    time_ext = (frame - frame(1)) * 0.01;  
    range = 1086:1349;
    time_ext = time_ext(range);
    TZ = TZ(range);
    time_ext = time_ext - time_ext(1);



    x0 = q(:,1) + q(:,4) .* sin(q(:,3));
    z0 = q(:,2) + q(:,4) .* cos(q(:,3));
    Z0 = z0 * cos(phi) - x0 * sin(phi);
    plot(time_ext+1.56, TZ-TZ(1)+0.195, 'r--', 'LineWidth', 1.5);
    plot(t, Z0, 'LineWidth', 1.5, 'Color', '#2A3077');
    xlabel('Time (s)', 'FontSize', 15, 'Interpreter', 'latex');
    ylabel('$Z_0\ \mathrm{[m]}$', 'FontSize', 15, 'Interpreter', 'latex');
    ax5 = gca;
    ax5.FontSize = 15; ax5.LineWidth = 1.2; ax5.FontName = 'Times New Roman';
    exportgraphics(fig5, 'fig/Z0.pdf', 'ContentType', 'vector');
end