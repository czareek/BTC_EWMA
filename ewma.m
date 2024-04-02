function ewma(trainFile, testFile)

    % Load training and testing data
    trainData = loadBitcoinData(trainFile);
    testData = loadBitcoinData(testFile);

    % Calculate EWMA for the testing data
    window = 20; % Window size for EWMA
    alpha = 0.4; % Smoothing factor
    EWMA = zeros(size(testData.Close));
    EWMA(1) = testData.Close(1); % Initialize with the first data point
    for t = 2:length(testData.Close)
        EWMA(t) = alpha * testData.Close(t) + (1 - alpha) * EWMA(t-1);
    end

    % Calculate the standard deviation of the residuals
    residuals = testData.Close - EWMA;
    std_residuals = std(residuals);

    % Calculate confidence intervals for EWMA forecast
    z = 1.96; % 95% confidence interval
    upper_bound = EWMA + z * std_residuals;
    lower_bound = EWMA - z * std_residuals;

    % Plot Bitcoin price, EWMA, and confidence intervals
    figure;
    plot(testData.Date, testData.Close, 'k-', 'LineWidth', 1.5); 
    hold on;
    plot(testData.Date, EWMA, 'r-', 'LineWidth', 1.5);
    plot(testData.Date, upper_bound, 'b--', 'LineWidth', 1);
    plot(testData.Date, lower_bound, 'b--', 'LineWidth', 1);
    hold off;
    xlabel('Date');
    ylabel('Price');
    title('Bitcoin Price vs. Exponential Weighted Moving Average (EWMA) with Confidence Intervals');
    legend('Bitcoin Price', 'EWMA', '95% Confidence Intervals', 'Location', 'Best');
    datetick('x', 'yyyy-mm', 'keeplimits'); % Format x-axis ticks
    grid on;

    % Save plot
    saveas(gcf, 'bitcoin_ewma_prediction_with_intervals.png');
end
