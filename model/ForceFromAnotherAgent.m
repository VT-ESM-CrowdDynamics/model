% 1;


% do we want equal and opposite forces?
% line of sight, sweep out an arc would be ideal...
function ForceVector = ForceFromAnotherAgent(AgentPosVector, AgentVelVector, OtherPosVector, VelOther)
  % lets assume distances are calculated in mm
  % a person is about... 500mm wide (so radius is 250mm)
  %disp('in force function')
  % maybe this function shouldnt be called for 2 people in a group, and they should have their own function, each agent could hold a list of other agents they are 'grouped' with or something
  distence = norm(AgentPosVector-OtherPosVector);
  %distence = sqrt((AgentPosVector(1)-OtherPosVector(1))^2 + (AgentPosVector(2)-OtherPosVector(2))^2)
  relativePosOfOther = OtherPosVector - AgentPosVector;
  % relativePosOfOther = [OtherPosVector(1)-AgentPosVector(1) , OtherPosVector(2)-AgentPosVector(2)]
  % we may want to specify persons size in the config files? (ie let user change it)
  % maybe each agent has a diff number here in if statement for size 
  angleOfSight = 1;
  if (norm(AgentVelVector) > 0)
    % calculate angle between vel and other's pos, assume agent is looking in direction of velocity 
    % line of sight
  angleOfSignt = dot(AgentVelVector,OtherPosVector)/norm(AgentVelVector)/norm(OtherPosVector);
  end
  
  if (distence <= 500)
    %disp('colision')
    %people would bump, special handeling? 
    %force should be "infinite" bc agents cannot move closer 
    % should we output # of collisions for user data?
    if (distence < 200 ) % if two points are exactly on top it breaks... this should never happen but
      ForceVector = [(rand - 0.5)*1000, (rand - 0.5)*1000];
    else 
      ForceVector = relativePosOfOther*1000/distence;
    end
  
  % probably want another elseif here to check line of sight (theta = acos( v1.v2) / |v1||v2|).  we still want to check if people hit bc line of sight doesnt effect that.  but if people dont see each other these forces dont matter... unless talking group stuff... 
  % should groups be handled in this function or another function designed spcifically for groups?
  elseif (angleOfSight > 0) % person has 180 view
    if (distence <= 1500)
      %disp('repel')
      % the repulsion zone
      % if forming a group this distence is too large probably 
      % this is less then a meter shoulder to shoulder
      force = 1/((distence-300)/1200)^3; %min 1, mid 5, max 212
      ForceVector = force*relativePosOfOther*-1/distence;
      
      % something should be done here with velocity so people moving towords each other 'prepare' to dodge, and someone can 'pass' another person if v in same direction etc
      % determine probability of wanting to 'dodge' right or left (culture) (should user set this?)
    elseif (distence <= 10000)
      %disp('flock')
      %flocking
      %potentially form group? 
      if (norm(VelOther) > 0.1)
        
        ForceVector = 20*VelOther/norm(VelOther);
      else 
        ForceVector = [0,0];
      end
    else
      ForceVector = [0,0];
    end
    % adjust for line of sight
    ForceVector = ForceVector*angleOfSight;
  end
  
  
  
end

%!test % tests the force function for simple case flocking zone
%! assert( ForceFromAnotherAgent([0,0],[0,0],[3000,0],[1,0]) ,[20,0], 0.00001 )

%!test % tests the force function for repulsion zone, make 3,4,5 triangle for ez math
%! assert( ForceFromAnotherAgent([1100,1800],[0,0],[500,1000],[0,0]) ,[1/((1000-300)/1200)^3*3/5,1/((1000-300)/1200)^3*4/5], 0.00001 )

%!test % tests the force function for repulsion zone, make 3,4,5 triangle for ez math
%! assert( ForceFromAnotherAgent([500,1000],[0,0],[1100,1800],[0,0]) ,[-1/((1000-300)/1200)^3*3/5,-1/((1000-300)/1200)^3*4/5], 0.00001 )

%!test % tests the force function for simple case repulsion zone
%! assert( ForceFromAnotherAgent([0,0],[0,0],[1500,0],[0,0]) ,[-1/((1500-300)/1200)^3,0], 0.00001 )

%!test % tests the force function for simple case repulsion zone
%! assert( ForceFromAnotherAgent([0,0],[0,0],[1000,0],[0,0]) , [-1/((1000-300)/1200)^3,0] , 0.00001)

%!test % tests the force function for simple case repulsion zone
%! assert( ForceFromAnotherAgent([0,0],[0,0],[501,0],[0,0]) , [-1/((501-300)/1200)^3,0] , 0.00001)

% test ForceFromAnotherAgent.m