function current_frame = update(MainForceVector, current_frame)
  global fileID;
  global configuration;
  global buffer;
  global agentStruct;
  global wallPoints;
  global goalArray; 
  % add in all the forces calculated before
  if (configuration.goal == 3)
    
    structSize = length(agentStruct);
    for theAgent = 1:structSize
      %theAgent
      %is the agent still active and need forces?
      if (agentStruct(theAgent).inModel)
        %disp("GG");
        %get this agents force
        Force = [MainForceVector(theAgent * 2 - 1), MainForceVector(theAgent * 2)];
        
        % dummy variable for velocity below
        previousPos = agentStruct(theAgent).pos;
        % calculate the new position att + vt + x
        agentStruct(theAgent).pos = agentStruct(theAgent).pos + Force * (configuration.dt) ^ 2 + agentStruct(theAgent).vel * configuration.dt;
        % calculate new velocity (current pos - previous pos) / t
        agentStruct(theAgent).vel = (agentStruct(theAgent).pos - previousPos) / configuration.dt;
        
        %disp(agentStruct(theAgent).vel)
        %this movement exceeded the max allowed velocity
        if (norm(agentStruct(theAgent).vel) > agentStruct(theAgent).maxVel)
          %disp("adjust vel")
          % get direction of movement
          direction = agentStruct(theAgent).vel/norm(agentStruct(theAgent).vel);
          % set velocity in that direction to be max velocity
          agentStruct(theAgent).vel = agentStruct(theAgent).maxVel*direction;
          % calculate new position with max velocity
          agentStruct(theAgent).pos = previousPos + agentStruct(theAgent).vel*configuration.dt;
          %disp(previousPos);
          %disp(agentStruct(theAgent).pos);
        end
        % get position for file
        Xpos = agentStruct(theAgent).pos(1);
        Ypos = agentStruct(theAgent).pos(2);
        % update frame to put in file later
        current_frame = [current_frame Xpos Ypos];
        % update the array
        %disp("HH");
      else
        %disp("99");
        %disp(theAgent);
        % the agent is no longer in the hallways, filler for output
        current_frame = [current_frame 9999 9999];
        agentStruct(theAgent).pos = [9999 9999];
      end
      
    end
    for needZeros = 1:(configuration.agents - structSize)
      current_frame = [current_frame 9999 9999];
    end
  end
end