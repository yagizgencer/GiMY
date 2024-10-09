function [database,songNames] = loadDatabase()
%Loads text files that correspond to constellations into matrix files
%database is a cell array that stores the constellations
%songNames is a cell array the stores the song names corresponding to the
%constellations
    tic
    %Gets names of all txt files in directory
    textInDir = dir('Data.txt');
    datafile = textInDir.name;
    textNamesDir = dir('SongNames.txt');
    namefile = textNamesDir.name;
    songNames = cell(1,100);
    if(length(textNamesDir)==0) 
        disp 'No Constellation files in current directory'
    else
        database = readmatrix(datafile,'Delimiter',' ');
        songNames = readcell(namefile,'Delimiter',',');                  
    end
    toc
end

