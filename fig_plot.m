function  fig = fig_plot(constellation, spec_t, spec_f)
%FİG_PLOT Summary of this function goes here
%   Detailed explanation goes here
    fig = figure();
    [rows, columns] = find(constellation);
    scatter(spec_t(columns), spec_f(rows),'Marker','x');
    title('Constellation');
    ylabel('Frequency');
    xlabel('Time');
end

