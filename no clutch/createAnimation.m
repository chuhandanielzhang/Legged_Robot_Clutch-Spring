function createAnimation(t, q, mode, fps, speed)

    [~, ~, ~, ~, ~, alpha, phi, L_0, ~, ~] = model_params;
    tdiv = t(2) - t(1);
    tskip = round(speed * 1 / (fps * tdiv));

    video = VideoWriter('movie/movie.mp4', 'MPEG-4');
    video.FrameRate = fps;
    video.Quality = 100;
    open(video);

    fig = figure('Name', 'Movie', 'NumberTitle', 'off');
    fig.Position = [150 150 640 400];
    fig.Color = [1.0 1.0 1.0];
    ax = axes(fig); hold(ax, 'on');

    % === 圆参数 ===
    r_circle = 0.15;
    theta_c = linspace(0, 2*pi, 100);

    for i = 1:tskip:length(t)

        x0 = q(i, 1) + q(i, 4) * sin(q(i, 3));
        z0 = q(i, 2) + q(i, 4) * cos(q(i, 3));
        X0 = x0 * cos(phi) + z0 * sin(phi);
        Z0 = z0 * cos(phi) - x0 * sin(phi);

        XRW = zeros(1, 8); ZRW = zeros(1, 8);

        for k = 1:3
            xrw = x0 + L_0 * sin(q(i, 3) + k * alpha);
            zrw = z0 + L_0 * cos(q(i, 3) + k * alpha);
            XRW(k) = xrw * cos(phi) + zrw * sin(phi);
            ZRW(k) = zrw * cos(phi) - xrw * sin(phi);
        end

        xrw = x0 + q(i, 4) * sin(q(i, 3) + 4 * alpha);
        zrw = z0 + q(i, 4) * cos(q(i, 3) + 4 * alpha);
        XRW(4) = xrw * cos(phi) + zrw * sin(phi);
        ZRW(4) = zrw * cos(phi) - xrw * sin(phi);

        for k = 5:7
            xrw = x0 - L_0 * sin(q(i, 3) + (9 - k) * alpha);
            zrw = z0 - L_0 * cos(q(i, 3) + (9 - k) * alpha);
            XRW(k) = xrw * cos(phi) + zrw * sin(phi);
            ZRW(k) = zrw * cos(phi) - xrw * sin(phi);
        end

        xrw = x0 - q(i, 5) * sin(q(i, 3) + alpha);
        zrw = z0 - q(i, 5) * cos(q(i, 3) + alpha);
        XRW(8) = xrw * cos(phi) + zrw * sin(phi);
        ZRW(8) = zrw * cos(phi) - xrw * sin(phi);

        if mode(i) == 1
            color_leg4 = [0.00 1.00 1.00];  
            color_leg8 = [0.00 0.00 1.00];
        else
            color_leg4 = [1.00 0.00 0.00];  
            color_leg8 = [1.00 0.00 0.00];
        end

        if i == 1
            annotation(fig, 'textbox', [0.85, 0.85, 0.1, 0.05], ...
                'String', ['\times', num2str(speed)], ...
                'FontSize', 18, 'EdgeColor', 'none');

            plot0 = plot(ax, [-(X0+3)*cos(phi) (X0+3)*cos(phi)], ...
                             [(X0+3)*sin(phi) -(X0+3)*sin(phi)], ...
                         'Color', [0.00 0.00 0.00], 'LineWidth', 1.5);

            plot1 = plot(ax, [X0 XRW(4)], [Z0 ZRW(4)], 'Color', color_leg4, 'LineWidth', 2.0);
            plot2 = plot(ax, [X0 XRW(5)], [Z0 ZRW(5)], 'Color', [0.00 0.00 1.00], 'LineWidth', 2.0);
            plot3 = plot(ax, [XRW(2) XRW(7)], [ZRW(2) ZRW(7)], 'Color', [0.00 0.00 1.00], 'LineWidth', 2.0);
            plot4 = plot(ax, [XRW(3) XRW(6)], [ZRW(3) ZRW(6)], 'Color', [0.00 0.00 1.00], 'LineWidth', 2.0);
            plot5 = plot(ax, [X0 XRW(8)], [Z0 ZRW(8)], 'Color', color_leg8, 'LineWidth', 2.0);
            plot6 = plot(ax, [X0 XRW(1)], [Z0 ZRW(1)], 'Color', [0.00 0.00 1.00], 'LineWidth', 2.0);
            plot7 = plot(X0, Z0, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');

            % 加圆（初始化）
            X_circle = X0 + r_circle * cos(theta_c);
            Z_circle = Z0 + r_circle * sin(theta_c);
            plot_circle = plot(X_circle, Z_circle, 'Color', [0.85 0.33 0.1], ...
                               'LineStyle', '-', 'LineWidth', 1.2);

            xlabel('$$X\ \rm[m]$$', 'Interpreter', 'latex');
            ylabel('$$Z\ \rm[m]$$', 'Interpreter', 'latex');
            box(ax, 'on');
            axis(ax, 'equal');
            ax.Position = [0.15 0.15 0.8 0.7];
            ax.FontName = 'Times New Roman';
            ax.FontSize = 16;
            ax.XLabel.FontSize = 20;
            ax.YLabel.FontSize = 20;
        else
            set(plot0, 'Xdata', [-(X0+3)*cos(phi) (X0+3)*cos(phi)], ...
                       'Ydata', [(X0+3)*sin(phi) -(X0+3)*sin(phi)]);
            set(plot1, 'Xdata', [X0 XRW(4)], 'Ydata', [Z0 ZRW(4)], 'Color', color_leg4);
            set(plot2, 'Xdata', [X0 XRW(5)], 'Ydata', [Z0 ZRW(5)]);
            set(plot3, 'Xdata', [XRW(2) XRW(7)], 'Ydata', [ZRW(2) ZRW(7)]);
            set(plot4, 'Xdata', [XRW(3) XRW(6)], 'Ydata', [ZRW(3) ZRW(6)]);
            set(plot5, 'Xdata', [X0 XRW(8)], 'Ydata', [Z0 ZRW(8)], 'Color', color_leg8);
            set(plot6, 'Xdata', [X0 XRW(1)], 'Ydata', [Z0 ZRW(1)]);
            set(plot7, 'XData', X0, 'YData', Z0);

            % 更新圆
            X_circle = X0 + r_circle * cos(theta_c);
            Z_circle = Z0 + r_circle * sin(theta_c);
            set(plot_circle, 'XData', X_circle, 'YData', Z_circle);
        end

        title(ax, {
            '\bf Viscoelastic-legged Rimless Wheel', ...
            sprintf('$$\\rm Time=%.2f\\ [s]$$', t(i))
            }, ...
            'Interpreter', 'latex', ...
            'FontName', 'Times New Roman', ...
            'FontSize', 20);

        ax.XLim = [X0 - 0.8, X0 + 0.8];
        ax.YLim = [-x0*tan(phi)-0.2, -x0*tan(phi)+0.6];

        frame = getframe(fig);
        writeVideo(video, frame);
    end

    close(video);
    disp('Movie saved!');
end