function E4D_prep_procedure(step)
% Procedures to prepare all the parts needed for the E4D inversion
% including: 
%
% - create .srv file from .ohm file (step=1)
% - finding a good inner-region boundary (step=2)
% - preparing the inner-region bounding points and planes (step=3)
% - writing electrodes and electrode refinement depth points (step=4)
% - writing points for outer-zone boundary (step=5)


addpath('/home/aplattner/Desktop/Git/E4Dfunctions/m-files')

startout=1;
startinnerb=5;
startelec=13;
%starttopo=13+2*length(electrodes)+1;



switch step
    case 1
        % Prepare E4D data file  
        electrodes=OHM2E4D('ELCL1_coords.ohm','ELCL1_coords',10);%,5);%,2);
        save('electrodes','electrodes')      
      
    case 2
        clf
        % Show electrodes and internal boundary I want to use.
        % This can be more than 4 boundary points if you want!!
        load electrodes
        minx=min(electrodes(:,1));
        miny=min(electrodes(:,2));

        plot(electrodes(:,1)-minx,electrodes(:,2)-miny,'x-')

        p(1,:)=[65 -15];
        p(2,:)=[-20 315];
        p(3,:)=[20 315];
        p(4,:)=[100 -10];
        pp=[p;p(1,:)];
        hold on
        plot(pp(:,1),pp(:,2),'ro-')
        hold off

        axis equal
    case 3
        % Prepare boundary for inner region for E4D .cfg file

        % Selected boundary points for inner region from previous step
        load electrodes
        minx=min(electrodes(:,1));
        miny=min(electrodes(:,2));

        p(1,:)=[65 -15] + [minx miny];
        p(2,:)=[-20 315] + [minx miny];
        p(3,:)=[20 315] + [minx miny];
        p(4,:)=[100 -10] + [minx miny];
        
        % Just to check that shift is right
        if 0
            plot(electrodes(:,1),electrodes(:,2),'x-')
            pp=[p;p(1,:)];
            hold on
            plot(pp(:,1),pp(:,2),'ro-')
            hold off
            axis equal
        end
        
        % Find the right topography for the boundary points
        surfdat=load('points_ground_100.xyz');
        zvals=griddata(surfdat(:,1),surfdat(:,2),surfdat(:,3),p(:,1),p(:,2));
        depthheight=1185;
        makezone(p(:,1),p(:,2),zvals,depthheight,startinnerb,'innerzone.txt',1,10);
        
    case 4
        % Turn electrodes into points
        load electrodes
        elecs2points(electrodes(:,1),electrodes(:,2),electrodes(:,3),...
            'elecpoints.txt',startelec-1,0.1);
       
    case 5
        % Find outer boundary
        load electrodes
        distx = 500;
        disty = 500;
        minx=min(electrodes(:,1))-distx;
        maxx=max(electrodes(:,1))+distx;
        miny=min(electrodes(:,2))-disty;
        maxy=max(electrodes(:,2))+disty;        
        outpoints=[minx,miny;minx,maxy;maxx,maxy;maxx,miny];
        
        surfdat=load('points_ground_100.xyz');
        zvals=griddata(surfdat(:,1),surfdat(:,2),surfdat(:,3),...
            outpoints(:,1),outpoints(:,2),'nearest');
        
        fout=fopen('outbound.txt','w');
        for i=1:4
            fprintf(fout,'%d %f %f %f %d \n',startout-1+i,...
                outpoints(i,1),outpoints(i,2),zvals(i),2);
        end
        fclose(fout);
        
        
    %case 6        
        % Prepare electrode points part for E4D .cfg file
        %topodata2grid('points_ground_100.xyz','topopoints.txt',1,starttopo);
      
end