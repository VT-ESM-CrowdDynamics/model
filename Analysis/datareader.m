clear;

Data = dlmread('gamedaytest.tsv', '\t',12,1);
[numrow,numcol] = size(Data);
nummarker = (numcol-1) /3;
% figure(1)
% plot3(Data(:,4),Data(:,2),Data(:,3));
% xlabel('X');ylabel('Y');zlabel('Z');

time=Data(:,1);
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

crowddensity=zeros(length(time),5); %6th column is non-counted space (rooms, etc)
% peoplecount=zeros(length(time),5);

for t=1:length(time)
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
    
    crowddensity(t,1) =grp1/6.9216; %All the densities are measured in people/m^2
    crowddensity(t,2)=grp2/6.2686;
    crowddensity(t,3)=grp3/7.2138;
    crowddensity(t,4)=grp4/7.212;
    crowddensity(t,5)=grp5/7.2887;
    
%     peoplecount(t,1)=grp1;
%     peoplecount(t,2)=grp2;
%     peoplecount(t,3)=grp3;
%     peoplecount(t,4)=grp4;
%     peoplecount(t,5)=grp5;
%     
end
