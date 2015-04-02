clear all;
tic
Data = dlmread('gamedaytest.tsv', '\t',12,1);
[numrow,numcol] = size(Data);
nummarker = (numcol-1) /3;

time=Data(:,1);
timespan=length(time);
dt=time(10)-time(1);
marker=zeros(nummarker,numrow,2); %3D array, first is marker number
%Read in all the data from tsv file
for i=1:nummarker
    marker(i,:,1:2)=Data(:,(3*i-1):(3*i));
end

%replace any 0.0 value with NaN
marker(marker==0)=NaN;

numrow1=floor(numrow/5);
velocity=zeros(numrow1,nummarker);

%Velocity
for p=1:nummarker
    q=1;
        for j=10:5:numrow

          if any(isnan(marker(p,j-9:j,:)))
       
          else
              dx=marker(p,(j-9:j-1),1)-marker(p,(j-8:j),1);
              dy=marker(p,(j-9:j-1),2)-marker(p,(j-8:j),2);
              distance=sqrt(dx.^2 + dy.^2);
              velocity(q,p)=sum(distance)/dt;
          end
          q=q+1;
        end
end

% Crowd Density and interpsersonal distance
crowddensity=zeros(timespan,5); 
% peoplecount=zeros(timespan,5);

IPdistance=NaN(timespan, nummarker); % This array stores the interpersonal distance for each marker at each point in time.
IPstd=NaN(timespan, nummarker); % This array stores all the Std values for the interpersonal distance.
Closest=NaN(timespan,nummarker);

parfor t=1:timespan
    %This will count the number of markers in each group area at each point
    %in time.
    
    grp1=0;grp2=0;grp3=0;grp4=0;grp5=0;
    
    for h=1:nummarker      %column 1 is x coord, and 2 is the y coord
        % The numbers in the elseif statements below refer to the x,y
        % positions of the sections we have defined. See paper for more
        % details. 
        if isnan(marker(h,t,1));
            
            
        elseif marker(h,t,1)> -4164 && marker(h,t,1)< -1280 &&...
                marker(h,t,2)< 940 && marker(h,t,2)> -1460
            
        grp1=grp1+1;
        
        elseif marker(h,t,1)> -1280 && marker(h,t,1)< 1291 &&...
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
    
%     peoplecount(t,1)=grp1;  % These are the totals counted in each group.
%     peoplecount(t,2)=grp2;
%     peoplecount(t,3)=grp3;
%     peoplecount(t,4)=grp4;
%     peoplecount(t,5)=grp5;

% Interpersonal Distance
% The goal of this function is to determine the five closest markers and
% then determine the average distance from our goal marker to its 5 nearest
% friends. 

        alldist=NaN(nummarker,1);
        if isnan(marker(h,t,1));
            
        else
        posx=marker(h,t,1); % X-position of marker in q.
        posy=marker(h,t,2); % Y-Position of marker in q.
        
        %Compute all the distances
        alldist(:,1)=sqrt((posx-marker(:,t,1)).^2+(posy-marker(:,t,2)).^2);

        alldist=sort(alldist);
        
        avedist=(alldist(2)+alldist(3)+alldist(4)+alldist(5)+alldist(6))/5; % This is the average distance between our marker and the closest 5 markers.
        % Below is the st. Dev. between the above markers.
        sum=0;
        for j=2:6
          sum=sum+(avedist-alldist(j))^2; 
        end; 
        IPstd(t,h)=sqrt(sum/(j-2));
        IPdistance(t,h)=avedist;
        Closest(t,h)=alldist(1);
        end
        
    end %end of iterating through all markers
 
    crowddensity(t,:)=[grp1/6.9216, grp2/6.286, grp3/7.2138, grp4/7.212, grp5/7.2287]; %All the densities are measured in people/m^2
    
end


% Flux
% This function will calculate the flux of people across a pre-determined
% boundary. 
interval=floor(timespan/120); %this way we get the flux per second, recording at 120 fps.
Fluxarray=zeros(interval,3,3); % The columns are flux lines; the trays are pos, neg, gross. 
% The X_i and Y_i below are the established flux boundaries. See paper for
% greater detail. 
X_i=-2722;
Y_ii=3786.5;
X_iii=2754;


for tt=0:interval-1
   posflux_i=0;
   negflux_i=0;
   posflux_ii=0;
   negflux_ii=0;
   posflux_iii=0;
   negflux_iii=0;
   t1=tt*120+1;
   t2=(tt+1)*120+1;
   for C=1:nummarker
   
   if isnan(marker(C,t1,1))
       
   elseif marker(C,t1,2)< 978 && marker(C,t1,2)> -1460
       
      if marker(C, t1, 1) < X_i && X_i < marker(C, t2,1)
       posflux_i=posflux_i+1;
      elseif marker(C, t1, 1) > X_i && X_i > marker(C, t2,1)
       negflux_i=negflux_i+1;
      elseif marker(C, t2, 1) < X_iii && X_iii < marker(C, t1,1)
       posflux_iii=posflux_iii+1;
      elseif marker(C, t2, 1) > X_iii && X_iii > marker(C, t1,1)
       negflux_iii=negflux_iii+1;
      end
      
    
   elseif marker(C,t1,1) > -1235 && marker(C,t1,1)< 1334
       if marker(C,t2,2)< Y_ii && marker(C, t1, 2) > Y_ii
           posflux_ii=posflux_ii+1;
       elseif marker(C,t2,2)> Y_ii && marker(C, t1, 2) < Y_ii
           negflux_ii=negflux_ii+1;
       end
   end
   end
   Fluxarray(tt+1,:,:)=[posflux_i, negflux_i, posflux_i+negflux_i;...
       posflux_ii, negflux_ii, posflux_ii+negflux_ii;...
       posflux_iii, negflux_iii, posflux_iii+negflux_iii];
       
end
toc
