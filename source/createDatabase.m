function [] = createDatabase()
%Creates constellations for all mp3 files in the current directory with
%specified freq spacing and binsize in
%create_constellation_adaptive_threshold
%Saves them to .txt files, where the data in the text file is the
%constellation corresponding to the hash type [f1,f2,deltaT]
% To read the .txt files into a matrix use dlmread()
    
    %Gets names of all mp3 files in current directory
    tic
    audioInDir = dir('../audioFiles/*.mp3');
    audioNames = {audioInDir.name};
    hashes = []; % To hold all the hashes of stored songs
    filenames = cell(1,length(audioNames));
    if(isempty(audioNames))
        disp 'No Audio Files in Current Directory'
    else
        %Audio files are present in the directory
        for i=1:length(audioNames)
            
            filename = char(audioNames(i));
                        
            hash = hashing(filename);
            % Append song ID at the beginning. 
            hashes = [hashes, [repmat(i,[1,size(hash,2)]);hash]];
            filenames{i} = filename;
        end
         % Write the songs whose hashes extracted to a single matrix.
         writematrix(hashes,'Data.txt','Delimiter',' ');
         % Keep the name of the songs in a txt file.
         writecell(filenames,'SongNames.txt','Delimiter',',');
    end
    toc
end

