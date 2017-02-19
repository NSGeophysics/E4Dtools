function topodata2grid(toponame,gridname,reduction,counter)
% topodata2grid(toponame,gridname,reduction,counter)
%
% Reads in a topo data point cloud file generated by 
% http://opentopo.sdsc.edu/ and turns it into the point cloud part for an
% E4D .cfg file.
%
% INPUT:
%
% toponame      Name of the point cloud file (including .txt extension)
% gridname      Name of the output file (including extension)
% reduction     Only use every xxth point to reduce file and grid size
% counter       First point number  
%
% Last modified by plattner-at-alumni.ethz.ch, 12/31/2015

fin=fopen(toponame,'r');
fout=fopen(gridname,'w');

% Skip the first line
strin=fgets(fin);

% Now read
strin=1;
pointtype=1; % Means it's on the surface
%counter=1;
strin=fgets(fin);
while ischar(strin)  
    red=sscanf(strin,'%f,%f,%f,%d,%f,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d');
    fprintf(fout,'%d %f %f %f %d    topo point\n',counter,red(1),red(2),red(3),pointtype);
    if nargin>2
        for skip=1:(reduction-1)
            strin=fgets(fin);
        end
    end
    counter=counter+1;
    strin=fgets(fin);
end

fclose(fout);
fclose(fin);
