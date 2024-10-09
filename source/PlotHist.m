function fig = PlotHist(time_neg, time_pos)
subplot(2,1,1)
histogram(time_neg, 'BinWidth',0.040);
grid on;
title('Absolute Time Differences with the Wrong Song');
xlabel('Time Differences');
ylabel('Bin Counts')
subplot(2,1,2)
histogram(time_pos, 'BinWidth',0.040);
title('Absolute Time Differences with the Correct Song');
xlabel('Time Differences');
ylabel('Bin Counts')
grid on;
end