function [peak_magnitudes, spec_f, spec_t, new_fs, window] = getConstellation(song_file)
% Takes a .mp3 or .wav file and returns the peak spectrum points.
% Inputs:
% song_file                 An audio file containing the song.
% Outputs:
% peak_magnitudes           Spectrogram matrix containing peak magnitude in
%                           each local neighbourhood.
% spec_f                    Frequencies
% spec_t                    Time instants
% new_fs                    New sampling rate
% window                    Number of samples per window of spectrogram



new_fs = 8192; % 8192 is new sampling rate of signal. Corresponds to the highest note on a piano.


[song, Fs] = audioread(song_file);
% Since the songs read are stereo, we average the two columns and get a one
% dimensional column vector, we later convert it to a row vector.
if length(song(1,:))>1
    song_mono = ((song(:,1)+song(:,2))./2)';
else
    song_mono=song';
end
song_mono = song_mono - mean(song_mono); % Remove DC component

% Resampling the mono song so that the sequence length is decreased and
% high frequencies are excluded. This results in not taking high
% frequencies into account and might reduce the probability of detecting
% a song correctly. However, we also reduce time and memory complexity.
song_rs = resample(song_mono, new_fs,Fs); 

% We also do not want to account for low frequencies since it reduces
% reliablity.
frequencies = 400:2:2700;%500:2:2700; %500:2:new_fs/2; % We can represent up to newfs/2 frequency.

timePerWindow = 0.1; % Window time duration for spectrogram

window = round(timePerWindow*new_fs); % Number of samples per window
nOverlap = round(0.6*window); %0.5 de iyi %round(0.75*window); % Number of samples overlapping while sliding the window

% Spectrogram takes window-point dft at every slice of the song. 
% spec_f is the corresponding frequencies to row indices of the spec_song
% spec_t is the corresponding time instants to column indices of the
% spec_song
[spect_song,spec_f,spec_t] = spectrogram(song_rs,window,nOverlap,frequencies,new_fs,'yaxis'); 

spec_magnitude = abs(spect_song); % Magnitude of the spectrogram

%% Finding Peak Magnitudes

% One side length of the local window. The local window will be a
% (len_localWindow + 1) x (len_localWindow + 1) window. Each element in
% spec_magnitude will be compared with (len_localWindow + 1)^2 - 1 elements
% around it. If a specific element is greater than all of others, the 
% mask_peaks matrix will still contain 1 in the corresponding index,
% otherwise we update it to 0.
len_localWindow = 7; % 3; 

mask_peaks = ones(size(spec_magnitude)); % The boolean mask containing ones, will be updated.

% For comparing each of the element to neighbors, an efficent way is to
% make use of the circular shifts. For each element in the spec_magnitude
% we start comparing starting from the bottom right up to top left of the
% local window and update mask_peaks.
for shift_hor = -len_localWindow:len_localWindow
    for shift_ver = -len_localWindow:len_localWindow
        if(shift_ver ~= 0 || shift_hor ~= 0) % Avoid comparing to self
            mask_peaks = mask_peaks.*( spec_magnitude > circshift(spec_magnitude,[shift_hor,shift_ver]) );
        end
    end
end
% The actual values of peak magnitudes will be used for choosing local
% maximum peaks. The peaks will be further reduced.
peak_magnitudes = mask_peaks.*spec_magnitude;