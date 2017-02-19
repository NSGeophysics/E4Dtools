function E4Dbound(topofile,depth,dist2out,outfile,percoffset)
% E4Dbound(topofile,depth,dist2out,outfile,percoffset)
%
% Calculates bounding points depending on topography given in topo file.
% 
% INPUT:
%
% topofile      name of file containing topography points (x,y,z)
% depth         depth below minimum point
% dist2out      how far away should the outer points be?
% outfile       name for output text file
% percoffset    how far do you want to move the bounding points from the
%               closest point (increase if problems with meshing) in
%               percent
%
% Last modified by plattner-at-alumni.ethz.ch, 12/19/2016

topo=textread(topofile);



minx=min(topo(:,1));
miny=min(topo(:,2));

maxx=max(topo(:,1));
maxy=max(topo(:,2));

xdiff=percoffset/100*(maxx-minx);
ydiff=percoffset/100*(maxy-miny);

% minx miny
boundpoints(1,:)=[minx-xdiff,miny-ydiff];
outpoints(1,:)=[minx-dist2out,miny-dist2out];

% maxx miny
boundpoints(2,:)=[maxx+xdiff,miny-ydiff];
outpoints(2,:)=[maxx+dist2out,miny-dist2out];

% maxx maxy
boundpoints(3,:)=[maxx+xdiff,maxy+ydiff];
outpoints(3,:)=[maxx+dist2out,maxy+dist2out];

% minx maxy
boundpoints(4,:)=[minx-xdiff,maxy+ydiff];
outpoints(4,:)=[minx-dist2out,maxy+dist2out];

% Now find topovalues from interpolation
boundtopo=griddata(topo(:,1),topo(:,2),topo(:,3),...
    boundpoints(:,1),boundpoints(:,2),'nearest');
boundpoints=[boundpoints,boundtopo];
outpoints=[outpoints,boundtopo];

% Now boundary points
fout=fopen(outfile,'w');

% Outer boundary points
flag=2;
for i=1:4
    fprintf(fout,'%d %f %f %f %d    Outer Zone boundary Surface\n',i,outpoints(i,1),outpoints(i,2),outpoints(i,3),flag);
end

fprintf(fout,'\n');
% Inner On surface
flag=1;
for i=1:4
    fprintf(fout,'%d %f %f %f %d    Inner Zone control point Surface\n',i+4,boundpoints(i,1),boundpoints(i,2),boundpoints(i,3),flag);
end

fprintf(fout,'\n');
% Inner At depth
mintopo=min(boundtopo);
flag=0;
for i=1:4
    fprintf(fout,'%d %f %f %f %d    Inner Zone control depth point\n',i+8,boundpoints(i,1),boundpoints(i,2),mintopo-depth,flag);
end


% These are the planes
fprintf(fout,'\n');
% Case 1

fprintf(fout,'5   number of internal planes\n');
fprintf(fout,'4 10   number of points, boundary number\n');
fprintf(fout,'%d %d %d %d\n',5,6,10,9);
fprintf(fout,'4 10   number of points, boundary number\n');
fprintf(fout,'%d %d %d %d\n',6,7,11,10);
fprintf(fout,'4 10   number of points, boundary number\n');
fprintf(fout,'%d %d %d %d\n',7,8,12,11);
fprintf(fout,'4 10   number of points, boundary number\n');
fprintf(fout,'%d %d %d %d\n',8,5,9,12);
fprintf(fout,'4 10   number of points, boundary number\n');
fprintf(fout,'%d %d %d %d',9,10,11,12);


