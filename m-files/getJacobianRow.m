function getJacobianRow(inpath,outname,measnr)
% getJacobianRow(inpath,outname,measnr)
% 
% Reads the measnr measurement from the ascii file jacobian.txt and writes
% it out in the style of sigma.0 to be loaded into an exodus file using bx.
%
% INPUT:
%
% inpath    directory to where the jacobian.txt file is located
% outname   name for the out file
% measnr    measurement index number for which you want to show the
%           sensitivities
%
% Last modified by plattner-at-alumni.ethz.ch, 11/2/2016

% Create file name from path
fname=fullfile(inpath,'jacobian.txt');

% Open input file
fin=fopen(fname);

% Read the measnr-th line buy only reading one line and treating the lines
% above it as header lines
str=textscan(fin, '%s', 1, 'delimiter', '\n', 'headerlines', measnr);
fclose(fin);

% Transform the line into a vector
row=str2num(cell2mat(str{1}));

% Write out the vector
fout=fopen(outname,'w');
fprintf(fout,'%d\t1\t%g\n',length(row),0.0);
fprintf(fout,'%g\n',row);
fclose(fout);
