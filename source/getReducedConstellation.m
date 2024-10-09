function [reduced_constellation, spec_t, fs] = getReducedConstellation(peak_magnitudes, spec_f, spec_t, fs, window)
% Among the peak_magnitudes, this function selects top N peaks from each
% interval. The peak_magnitudes matrix is further updated to have 0 if
% peak magnitudes are not in top N. 
% Inputs:
% peak_magnitudes               The peak magnitude matrix obtained from
%                               getConstellation function.
%
% spec_t                        The corresponding time instants to
%                               peak_magnitudes columns.
%
% spec_f                        The corresponding frequency components to 
%                               peak_magnitudes rows.
%
% fs                            The sampling rate of the spectrogram
%
% window                        Number of samples in a window of
%                               spectrogram.
% Outputs:
% reduced_constellation         Constellation with reduced the number of
%                               peaks in peak_magnitudes that is more uniform.
%
% spec_t                        The corresponding time instants to
%                               peak_magnitudes columns.
%
% fs                            The sampling rate of the spectrogram


% Number of top peaks to survive.
NtopPeaks = 30; % 30;
% Updated and more uniform spectrogram, initialization with zero
reduced_constellation = zeros(length(spec_f), length(spec_t));

% Interval length
index_interval = floor((fs/(window/4))*1);

for i = 0:ceil(length(spec_t)/index_interval)-1

    % At the end of the time array we must get whatever is left regardless
    % of the interval length
    if i == ceil(length(spec_t)/index_interval)-1
        % Choosing the last sub interval of the peak spectrogram
        relevant_spect = peak_magnitudes(:,i*index_interval+1:length(spec_t));
        % Update the NtopPeaks according to the size of the last interval
        % updated_NtopPeaks is scaled according to last_interval/interval
        updated_NtopPeaks = ceil(size(relevant_spect,2)/index_interval * NtopPeaks);
        % Choosing the maximum updated_NtopPeaks number of values to later
        % use the last one as a value for threshold
        temp = maxk(relevant_spect(:),updated_NtopPeaks);
    else
        % Choosing the given interval of the peak spectrogram
        relevant_spect = peak_magnitudes(:,i*index_interval+1:(i+1)*index_interval);
        % Choosing the maximum NtopPeaks to later use as a threshold
        temp = maxk(relevant_spect(:), NtopPeaks);
    end
    relevant_spect(relevant_spect < temp(end)) = 0;

    % Assign values to the reduced_spect
    if i == ceil(length(spec_t)/index_interval)-1
        reduced_constellation(:,i*index_interval+1:length(spec_t)) = relevant_spect;
    else
        reduced_constellation(:,i*index_interval+1:(i+1)*index_interval) = relevant_spect;
    end
end
end

