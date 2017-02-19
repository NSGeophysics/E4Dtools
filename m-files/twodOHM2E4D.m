function twodOHM2E4D(inputname,outputname,esterror,xpos,ypos,zpos,elecnumshift,measnumshift)
% twodOHM2E4D(inputname,outputname,esterror,xpos,ypos,zpos,elecnumshift,measnumshift)
%
% Transforms a file in Thomas Gunther's .ohm format 
% (see www.resistivity.net) into a .srv file that can be read by E4D
%
% INPUT:
%
% inputname     Filename (including extension) of the .ohm or .dat file
% outputname    Filename for the .srv file (no extension)
% esterror      estimated error in percent (e.g. 1 = 1%)
% xpos          x-coordinates of the electrodes
% ypos          y-coordinates of the electrodes
% zpos          z-coordinates of the electrodes
% elecnumshift  set counter for first electrode if you want to combine 
%               these measurements with other measurements
% measnumshift  set counter for first measurement if you want to combine 
%               these measurements with other measurements
% 
%
% Last modified by plattner-at-alumni.ethz.ch, 1/10/2015


outputname = [outputname '.srv'];

fin=fopen(inputname,'r');
fout=fopen(outputname,'w');

% Read and write number of electrodes

strin=fgets(fin);
red=sscanf(strin,'%d%s');
nelec=red(1);
fprintf(fout,'%d    Number of electrodes\n',nelec);
electrodes=nan(nelec,3);


% Skip the next line in .ohm
strin=fgetl(fin);

% Now the electrodes
% Assuming all electrodes on the surface (flag 1). For burried electrodes:
% flag 0
for counter=1:nelec
    eleflag=1;
    strin=fgets(fin);
    red=sscanf(strin,'%f %f');
    fprintf(fout,'%d %f %f %f %d\n',counter+elecnumshift,xpos(counter),ypos(counter),zpos(counter),eleflag);
    %fprintf(fout,'%d %f %f %f %d\n',counter,red(1),yvals(counter),red(2),eleflag);
    % Also store the electrodes here for calculations further down
    % electrodes(counter,:)=[xpos(counter),ypos(counter),zpos(counter)];
end

% Skip a line in the .srv file
fprintf(fout,'\n');

% Now the measurements
strin=fgets(fin);
red=sscanf(strin,'%d%s');
nmeas=red(1);
fprintf(fout,'%d    Number of data\n',nmeas);

% Skip the line in the input file
strin=fgetl(fin);

for counter=1:nmeas    
    strin=fgets(fin);
    %red=sscanf(strin,'%d %d %d %d %g');
    red=sscanf(strin,'%d %d %d %d %f %f');        
    VdI=red(5);
    if esterror
        stdd=VdI*esterror/100;
    else
        stdd=red(6);
    end
    % Now write it into the outfile
    %fprintf(fout,'%d %d %d %d %d %g %g\n',...
    %    counter,red(1),red(2),red(3),red(4),VdI,stdd);
    fprintf(fout,'%d %d %d %d %d %f %f\n',...
        counter+measnumshift,red(1)+elecnumshift,red(2)+elecnumshift,red(3)+elecnumshift,red(4)+elecnumshift,VdI,stdd);
end
    

fclose(fout);
fclose(fin);



% I think appres=0 is the right setting. Meaning that we don't have to
% multiply with a factor to go from .ohm to .srv
% appres=0;
% Removed because it was wrong:
% Calculate the geometry factor
% if appres
%         AM=norm(electrodes(red(1))-electrodes(red(3)));
%         BM=norm(electrodes(red(2))-electrodes(red(3)));
%         AN=norm(electrodes(red(1))-electrodes(red(4)));
%         BN=norm(electrodes(red(2))-electrodes(red(4)));
%         VdI=red(5)/(2*pi)*(1/AM - 1/BM - 1/AN + 1/BN);
%     else
% end


