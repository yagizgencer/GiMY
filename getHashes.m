function [hashes] = getHashes(reduced_constellation, spec_t, spec_f)
% For each anchor point in the reduced constellation getHashes function
% returns the hashes. Hashes are created by pairing each anchor point with
% points in its target zone. The hashes are translation invariant. A hash
% consist of frequency of the anchor point, f1; frequency of target point,
% f2; time difference of these two points, delta t. We use each nonzero
% constellation point (peak) as anchor points.

[size_rowsCons, size_colsCons] = size(reduced_constellation); % Dimensions of constellation
[i_rowPeak, i_colPeak] = find(reduced_constellation); % Indices of nonzero constellation points (peaks)
nPeaks = nnz(reduced_constellation); % Number of peaks

 
width_TargetZone = 40; % Width of the target zone in terms of time instant indices, right of the anchor point
height_TargetZone = 50; % Height of the target zone in terms of frequency indices. Must be an even integer.
initial_HorDist = 5; % Initial horizontal distance from anchor point to target zone. 

nMaxPairs = 5; % Number of points in target zone to pair for each anchor point.

f1=[]; 
f2=[];
delta_t=[];
t1 = [];

% Each peak is considered an anchor point so we will loop over them.
for i = 1:nPeaks
    % The frequency and time indices of the current anchor point
    i_row_anchor = i_rowPeak(i);
    i_col_anchor = i_colPeak(i);
    
    % If the target zone right end is outside of the indices, update the
    % target zone right limit
    if i_col_anchor + width_TargetZone + initial_HorDist > size_colsCons
        target_right_end = size_colsCons;
    % Otherwise assign the target zone right end
    else 
        target_right_end = i_col_anchor + width_TargetZone + initial_HorDist;
    end

    % If the target zone left end is outside of the indices update the left
    % target zone limit
    if i_col_anchor + initial_HorDist > size_colsCons
        target_left_end = size_colsCons;
    % Otherwise assign the target zone left end
    else
        target_left_end = i_col_anchor + initial_HorDist;
    end
    
    % If the target zone top end is outside of the indices, update the
    % target zone top limit
    if i_row_anchor - height_TargetZone/2 < 1
        target_top_end = 1; % Row 1
    % Otherwise assign the target zone top end
    else
        target_top_end = i_row_anchor - height_TargetZone/2;
    end
    
    % If the target zone bottom end is outside of the indices, update the
    % target zone bottom limit
    if i_row_anchor + height_TargetZone/2 > size_rowsCons
        target_bottom_end = size_rowsCons;
    % Otherwise assign the target zone bottom end
    else
        target_bottom_end = i_row_anchor + height_TargetZone/2;
    end

    nPairings = 0; % Number of current pairs for the anchor points
    
    % Find the peaks inside of the target zone
    target_zone = reduced_constellation(target_top_end:target_bottom_end,...
        target_left_end:target_right_end);
    [j_row_targets, j_col_targets] = find(target_zone);
   for j = 1:length(j_row_targets)
            % Complying with the nMaxPairs constraint and not pairing with
            % anchor point itself
            if (nPairings < nMaxPairs && spec_t(j_col_targets(j) + target_left_end - 1) - spec_t(i_col_anchor) > 0)
                f1 = [f1, spec_f(i_row_anchor)'];
                f2 = [f2, spec_f(j_row_targets(j) + target_top_end - 1)'];
                delta_t = [delta_t, spec_t(j_col_targets(j) + target_left_end - 1) - spec_t(i_col_anchor)];
                t1 = [t1, spec_t(i_col_anchor)];
                nPairings = nPairings + 1;
            end
    end


end
hashes = [f1; f2; delta_t; t1];
end


