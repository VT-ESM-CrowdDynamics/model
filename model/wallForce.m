function this_delta = wallForce(agent_num)
  global buffer;

  tminus2 = buffer(tminus(2), 3:end);
  tminus1 = buffer(tminus(1), 3:end);
  last_delta = tminus2-tminus1;
  
  this_last_position = tminus1(2*agent_num-1:2*agent_num);
  this_last_delta = last_delta(2*agent_num-1:2*agent_num);
  % this_delta = this_last_position+[agent_num,1];

  % adapter variables
  agentPosVector = this_last_position;
  agentVelVector = this_last_delta;

  global velocity_upper_limits;
  global configuration;
  maxDistance = velocity_upper_limits(agent_num)*configuration.dt;
  wall_forces = [0, 0];
  for wall = 1:length(configuration.wallPoints)/2
    wallPoint1 = configuration.wallPoints(wall*2 - 1,:);
    wallPoint2 = configuration.wallPoints(wall*2,:);

    %vector from all point to agent
    relative = agentPosVector - wallPoint1;
    %vector representing line segment
    lineVector = wallPoint2 - wallPoint1;
    %needed constants looked up formula online
    c1 = dot(relative, lineVector);
    c2 = dot(lineVector, lineVector);
    %length of line
    length = norm(lineVector);
    %dummy variables
    force = 0;
    forceMultiplyer = 5; %arbitrary const to balance
    forceFromWall = [0,0];
    %prjectionMagnitude = 0;
    %if (length > 0)
    %projectionMagnitude = dot(relative, lineVector)/length^2;
    %end
    if (c1 <= 0)
      %beyond wallPoint1
      distance = norm(agentPosVector-wallPoint1); %distance from wallPoint to person
      if (distance != 0)  
        direction = (agentPosVector - wallPoint1)/distance;
        if (distance <= 500)
          force = (1480 + 1000/((distance+200)/700)^2);
        elseif (distance <=1200)
        
          force = 40/((distance-100)/1000)^3; 
              
        end
        forceFromWall = force*direction*forceMultiplyer;
      else
        %the person is in the wall, this is bad
        
      end
    elseif (c2 <= c1)
      %beyond wallPoint2
      
      distance = norm(agentPosVector-wallPoint2); %distance from wallPoint to person
      if (distance != 0)  
        direction = (agentPosVector - wallPoint2)/distance;
        if (distance <= 500)
          force = (1480 + 1000/((distance+200)/700)^2);
        elseif (distance <=1200)
        
          force = 40/((distance-100)/1000)^3; 
              
        end
        forceFromWall = force*direction*forceMultiplyer;
      else
        %the person is in the wall, this is bad
        
      end
    else 
      %disp("in wall")
      %wallPoint1
      %wallPoint2
      %agentPosVector
      %closer
      %the distance matters here
      d = c1/c2;
      pb = wallPoint1 + d*lineVector; %point on line closest to person
      distance = norm(agentPosVector-pb); %distance from wall to person
      if (distance != 0)  
        %disp("distance isnt zero")
        direction = (agentPosVector - pb)/distance;
        if (distance <= 500)
          %disp("aa")
          force = 2*(1480 + 1000/((distance+200)/700)^2);
        elseif (distance <=1200)
          %disp("bb")
          force = 80/((distance-100)/1000)^3; %max around 900
              
        end
        forceFromWall = force*direction*forceMultiplyer;
      else
        %the person is in the wall, this is bad
        
      end
      
    end
    wall_forces = wall_forces + forceFromWall;
  end
  this_delta = wall_forces;
end



%!test % simple wall test
%!   disp(wallForce([-500,0],[0,0],[0,0],[0,5000]))
%! 

%!test % simple wall test
%!   disp(wallForce([500,0],[0,0],[0,-5000],[0,5000]))
%! 

%!test % simple wall test
%!   disp(wallForce([0,500],[0,0],[-5000,0],[5000,0]))
%!  

% test wallForce.m
