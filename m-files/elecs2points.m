function elecs2points(xpos,ypos,zpos,outfile,shiftpointnr,depth,surf)
% elecs2points(xpos,ypos,zpos,outfile,shiftpointnr,depth)
%
% Writes the electrode position values into a format that can be
% incorporated into an E4D .cfg file
%
% INPUT:
%
% xpos          X-coordinates of the electrodes
% ypos          Y-coordinates of the electrodes
% zpos          Z-coordinates of the electrodes
% outfile       name for export file
% shiftpointnr  shift all the point numbers by this number (e.g. to allow
%               for incorporation of surrounding mesh, etc)
% depth         Depth at which to place points underneath electrodes to 
%               enforce refinement around electrodes
% surf          are the top electrodes on the surface? 1 for yes, 0 for no  
%
% Last modified by plattner-at-alumni.ethz.ch, 12/28/2017

%depth=0.05; % Depth at which to place points underneath electrodes to 
% enforce refinement around electrodes

if nargin < 7
  surf=1;
end
  
fout=fopen(outfile,'w');

counter=shiftpointnr+1;
% Put the surface points for the electrodes
pointtype=surf;
for i=1:length(xpos)
    fprintf(fout,'%d %f %f %f %d    electrode surface\n',counter,xpos(i),ypos(i),zpos(i),pointtype);
    counter=counter+1;
end

fprintf(fout,'\n');

% Now the points underneath the electrodes 
pointtype=0;
for i=1:length(xpos)
    fprintf(fout,'%d %f %f %f %d    electrode depthpoint\n',counter,xpos(i),ypos(i),zpos(i)-depth,pointtype);
    counter=counter+1;
end

fclose(fout);
