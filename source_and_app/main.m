%% 
%createDatabase();
%%
global database
global songNames
[database,songNames] = loadDatabase();
%%
run('GiMY.mlapp');
