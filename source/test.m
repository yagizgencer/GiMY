hashRecording = hashing('mic.wav');
hashRecording = [zeros(1,size(hashRecording,2)); hashRecording];
%%
th_f1 = 1;
th_f2 = 1;
th_delta_t = 0.030;
matches_diff = []; % Matching hashes
% Search for the matching hashes
tic
for i = 1:size(hashRecording,2)
    % Take the difference of each hash in the recording with
    % the who data.
    difference = abs(database - hashRecording(:,i));
    % Logical index = 1 if the difference satisfies threshold
    % conditions. The indices represent the indices of the
    % matching hashes inside the difference matrix.
    indices = difference(1,:) > 0 & difference(2,:) < th_f1 & ...
        difference(3,:) < th_f2 & difference(4,:) < th_delta_t;

    % Hold the values of time diffs and track ids
    matches_diff = [matches_diff, difference([1,5],indices)];
end
toc
%%
 
% Among the matching hashes we will look into the absolute time
% differences, we expect to observe a constant absolute time difference
% between the mathing hashes if the song is detected correctly.

% We will hold the maximum bin. We expect a bin to be highly prominent.
max_bins = zeros(1,length(songNames));
for i = 1:length(songNames)
    % Select the matches from matches_diff from each track ID.
    time_diff_track_i = matches_diff(2,matches_diff(1,:) == i);
    % Group the time diffs into bins. Each time diff is shifted by a little
    % amount so that we wont have values at the edges of the bins.
    [bin_counts, edges] = histcounts(time_diff_track_i,'BinWidth',0.040);
    max_bins(i) = sum(maxk(bin_counts,2));
end

%%
[max_max_bins, track_ids] = maxk(max_bins,5);
%Find location (index) of the five songs with most matches and
%their corresponding matches.

% Calculate the probabilites
percentages = max_max_bins/sum(max_max_bins);
