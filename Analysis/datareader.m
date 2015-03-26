clear all;
tic
Data = dlmread('gamedaytest.tsv', '\t',12,1);
[numrow,numcol] = size(Data);
nummarker = (numcol-1) /3;
% figure(1)
% plot3(Data(:,4),Data(:,2),Data(:,3));
% xlabel('X');ylabel('Y');zlabel('Z');

time=Data(:,1);
timespan=length(time);
dt=time(10)-time(1);
marker=zeros(nummarker,numrow,2); %3D array, first is marker number

for i=1:nummarker
    marker(i,:,1:2)=Data(:,(3*i-1):(3*i));
end
numrow1=floor(numrow/5);
velocity=zeros(numrow1,nummarker);

for p=1:nummarker
    q=1;
        for j=10:5:numrow

          if any(marker(p,j-9:j,:)==0)
       
          else
              dx=marker(p,(j-9:j-1),1)-marker(p,(j-8:j),1);
              dy=marker(p,(j-9:j-1),2)-marker(p,(j-8:j),2);
              distance=sqrt(dx.^2 + dy.^2);
              velocity(q,p)=sum(distance)/dt;
          end
          q=q+1;
        end
end

% Crowd Density
crowddensity=zeros(timespan,5); %6th column is non-counted space (rooms, etc)
% peoplecount=zeros(timespan,5);

for t=1:timespan
    %This will count the number of markers in each group area at each point
    %in time.
    
    grp1=0;grp2=0;grp3=0;grp4=0;grp5=0;
    
    for h=1:nummarker      %column 1 is x coord, and 2 is the y coord
        
        if marker(h,t,1)==0.0 && marker(h,t,2)==0.0;
            
            
        elseif marker(h,t,1)> -4164 && marker(h,t,1)< -1280 &&...
                marker(h,t,2)< 940 && marker(h,t,2)> -1460
            
        grp1=grp1+1;
        
        elseif marker(h,t,1)> -1280 && marker(h,t,1)< 1291 &...
                marker(h,t,2)< 978 && marker(h,t,2)> -1460
            
        grp2=grp2+1;
        
        elseif marker(h,t,1)> -1235 && marker(h,t,1)< 1334 &&...
                marker(h,t,2)< 3786 && marker(h,t,2)> 978
            
        grp3=grp3+1;
        
        elseif marker(h,t,1)> -1190 && marker(h,t,1)< 1378 &&...
                marker(h,t,2)< 6595 && marker(h,t,2)> 3786
            
         grp4=grp4+1;
            
        elseif marker(h,t,1)> 1291 && marker(h,t,1)< 4217 &&...
                marker(h,t,2)< 1031 && marker(h,t,2)> -1460
            
        grp5=grp5+1;
        
        end  % end of the if / else if statement
    end %end of iterating through all markers
    
    crowddensity(t,1)=grp1/6.9216; %All the densities are measured in people/m^2
    crowddensity(t,2)=grp2/6.2686;
    crowddensity(t,3)=grp3/7.2138;
    crowddensity(t,4)=grp4/7.212;
    crowddensity(t,5)=grp5/7.2887;
    
%     peoplecount(t,1)=grp1;  % These are the totals counted in each group.
%     peoplecount(t,2)=grp2;
%     peoplecount(t,3)=grp3;
%     peoplecount(t,4)=grp4;
%     peoplecount(t,5)=grp5;
%     
end

% Interpersonal Distance
% The goal of this function is to sweep out a radius and calculate the
% average distance to the subject marker from all the other markers within
% the swept radius. 

IPdistance=zeros(timespan, nummarker); % This array stores the interpersonal distance for each marker at each point in time.
IPstd=zeros(timespan, nummarker); % This array stores all the Std values for the interpersonal distance.
Closest=zeros(timespan,nummarker);
for a=1:timespan
    for b=1:nummarker
        alldist=NaN(nummarker,1);
        if marker(b,a,1)==0.0 && marker(b,a,2)==0.0;
            
        else
        posx=marker(b,a,1); % X-position of marker in q.
        posy=marker(b,a,2); % Y-Position of marker in q.
        for c=1:nummarker
            
            if marker(c,a,1)==0.0 && marker(c,a,2)==0.0;
                
            elseif c~=b
                alldist(c,1)=sqrt((posx-marker(c,a,1))^2+(posy-marker(c,a,2))^2);
            else
            end
        end
        alldist=sort(alldist);
        end
        avedist=(alldist(1)+alldist(2)+alldist(3)+alldist(4)+alldist(5))/5; % This is the average distance between our marker and the closest 5 markers.
        avestd=std(alldist(1:5)); % This is the stand. Dev. between the above markers.
        IPdistance(a, b)=avedist;
        IPstd(a,b)=avestd;
        Closest(a,b)=alldist(1);
    end
end
toc
