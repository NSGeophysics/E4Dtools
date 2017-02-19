function sigma2rho(inputfile,outputfile)
% sigma2rho(inputfile,outputfile)
%
% Transforms conductivity output file from E4D into resistivity file. 
% Can then be put into an exodus file using bx:
%
% bx -f gridname.1 rho.x resistivity.exo 0
%
% INPUT:
%
% inputfile     name of conductivity file
% outputfile    name of resistivity file yo0u want to create
%
% Trick: this also transforms resistivity into conductivity, should you
% want to do that.

fin=fopen(inputfile);
fout=fopen(outputfile,'w');
% Copy header line
header=fgetl(fin);
fprintf(fout,[header '\n']);

% Reading the vector
%str=textscan(fin, '%s\n');
str=textscan(fin, '%f\n');
sigma=str{1};
fclose(fin);
%sigma=str2num(cell2mat(str{1}));
    

% Transforming
rho=1./sigma;

% Writing rho
fprintf(fout,'%g\n',rho);
fclose(fout);



