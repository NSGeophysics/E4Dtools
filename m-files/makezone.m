function makezone(xpoints,ypoints,zpoints,zpoints2,startnumber,filename,topsurface,bnum)
% makezone(xpoints,ypoints,zpoints,zpoints2,startnumber,filename,topsurface,bnum)
%
% Writes out the points and internal planes to define a zone in the .cfg
% file for E4D mesh generation
%
% INPUT:
%
% xpoints       x-coordinates for the points on the (shallow or surface) 
%               top face [vector, clockwise orientation]
% ypoints       y-coordinates for the points on the (shallow or surface)
%               top face [vector, same length as xpoints]
% zpoints       z-coordinates for the points on the (shallow or surface)
%               top face [vector, same length as xpoints]
% zpoints2      z-coordinates for each deeper point [vector, same length 
%               as xpoints, or a single number]. 
%               zpoints2 < zpoints  !!!!!! 
% startnumber   number of first point. All other points will be in
%               consecutive numbers
% filename      textfile name to save the output in
% topsurface    are the shallow points on the surface or at depth?
%               1 on the surface [default]
%               0 at depth
% bnum          boundary number [default 10]
%
% Last modified by plattner-at-alumni.ethz.ch, 1/18/2017

if nargin<7
    topsurface=1;
    bnum=10;
end

% If depth is a single number, then we want all points to be at that depth
% underneath their shallow point
if length(zpoints2)==1
    zpoints2=zpoints2*ones(size(xpoints));
end

n=length(xpoints);

fout=fopen(filename,'w');

s=startnumber-1;

% First write the points
% nr x y z type. Type: 1=surface, 0=depth
for i=1:n
    fprintf(fout,'%d %f %f %f %d \n',s+i,xpoints(i),ypoints(i),zpoints(i),topsurface);
end
fprintf(fout,'\n');
for i=1:n
    fprintf(fout,'%d %f %f %f %d \n',s+i+n,xpoints(i),ypoints(i),zpoints2(i),0);
end
fprintf(fout,'\n');

% Now write the faces
if topsurface
    nfaces=n+1;
else
    nfaces=n+2;
end
fprintf(fout,'%d number of internal planes\n',nfaces);
for i=1:n-1
    fprintf(fout,'4 %d\n',bnum);
    fprintf(fout,'%d %d %d %d\n',s+i,s+i+1,s+i+1+n,s+i+n);
end
% The last one reconnects with the first point
fprintf(fout,'4 %d\n',bnum);
fprintf(fout,'%d %d %d %d\n',s+1,s+n,s+2*n,s+1+n);

% Now bottom
fprintf(fout,'%d %d\n',n,bnum);
for i=1:n
    fprintf(fout,'%d ',s+i+n);
end
fprintf(fout,'\n');

% Now top if not surface
if ~topsurface
    fprintf(fout,'%d %d\n',n,bnum);
    for i=1:n
        fprintf(fout,'%d ',s+i);
    end
    fprintf(fout,'\n');   
end

