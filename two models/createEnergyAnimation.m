function createEnergyAnimation(t1, q1, t2, q2, fps, speed)
    % === 能量计算 ===
    [~, ~, E1, ~] = energy(q1, t1);
    [~, ~, E2, ~] = energy(q2, t2);

    % === 时间跳帧控制 ===
    tdiv = t1(2) - t1(1);
    tskip = round(speed * 1 / (fps * tdiv));
    idx_all = 1:tskip:min(length(t1), length(t2));  

  
    if ~exist('movie', 'dir'); mkdir('movie'); end
    video = VideoWriter('movie/CompareEnergyAnimation.mp4', 'MPEG-4');
    video.FrameRate = fps;
    video.Quality = 100;
    open(video);

    fig = figure('Name', 'Energy Comparison', 'NumberTitle', 'off', ...
                 'Units', 'pixels', 'Position', [100, 100, 640, 400]);
    fig.Color = [1 1 1];
    ax = axes(fig); hold(ax, 'on');

    p1 = plot(ax, t1(1), E1(1), 'Color', [0.85 0.33 0.1] , 'LineWidth', 2.0, 'DisplayName', 'No Clutch');
    p2 = plot(ax, t2(1), E2(1), 'Color', [0.15 0.45 0.8], 'LineWidth', 2.0, 'DisplayName', 'With Clutch');

    legend('Interpreter','latex', 'Location','northeast');
    xlabel('Time [s]', 'Interpreter','latex', 'FontSize', 16);
    ylabel('Mechanical Energy [J]', 'Interpreter','latex', 'FontSize', 16);
    ax.FontSize = 14;
    ax.FontName = 'Times New Roman';
    ax.LineWidth = 1.2;
    grid on;

    axis tight;
    ylim([min([E1; E2])*0.95, max([E1; E2])*1.05]);
    xlim([0, max(t1(end), t2(end))]);

    % === 动画帧循环 ===
    for k = idx_all
        set(p1, 'XData', t1(1:k), 'YData', E1(1:k));
        set(p2, 'XData', t2(1:k), 'YData', E2(1:k));
        % title(sprintf('\\bfMechanical Energy:  t = %.2f s', t1(k)), ...
        %       'FontSize', 16, 'Interpreter', 'tex');
        frame = getframe(fig);
        writeVideo(video, frame);
    end

    close(video);
    disp('Energy comparison animation saved to movie/CompareEnergyAnimation.mp4');
end