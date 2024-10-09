function [database] = load_database_fingerprint()
%loads previously constructed hashes and song IDs database from txt files
%as an 2x(songs_in_database)cell. database(1,:) stores hashes  and 

    hashes_txt_dirs = dir('*.txt');
    hashes_txt_names = {hashes_txt_dirs.name};
    
    database = cell(2,length(hashes_txt_names)); %to store hashes and name of the songs
    
    for i=1:length(hashes_txt_names)
        
        hashes_txt_name = char(hashes_txt_names(i));
        database{1,i}=readmatrix(hashes_txt_name);                   %hash of the corresponding song
       
        database{2,i} = hashes_txt_name(1:length(hashes_txt_name)-4); % names of the songs
                    
    end
end