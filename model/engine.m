% octave --eval 'test engine.m' 2>&1 | grep -v /usr/share/octave/3.8.1
% trick to allow multiple functions
1;

% TODO: refactor output generation to wrap a step function in a loop to generate
%       tracks matrix for assertion to keep tests but be able to stream tsv out
% TODO: refactor force function applications to modular design
% TODO: beautify everything with base-n.de/matlab/code_beautifier.html

addpath('../lib/jsonlab');
addpath('../lib/catstruct');

global configuration;

function init (config)
  global configuration;
  defaults = loadjson('defaults.json');
  % if passed a filename, parse as JSON and use for config
  if (ischar(config) && exist(config, 'file'))
    config = loadjson(config);
  end
  configuration = catstruct(defaults, config);
  % disp(configuration);
  global fileID = fopen("log","w")
end

function tracks = looptest
  global wallPoints;
  global goalArray;
  global configuration;
  global fileID;
  % tracks = [[1, 0]];
  % TODO: init stuff needs to move to init
  global buffer;
  buffer = zeros(configuration.buffer_size, configuration.agents * 2 + 2);
  buffer(1, 1) = 1; % frame 1 is time 0
  global agentStruct;
  spawn_init();
  tracks = buffer(1,:);
  tsv_out(tracks);
  for frame = 2 : configuration.frames
    % disp('looping!')
    % disp(frame)
    % disp(buffer)
    current_frame = timestep(frame);
    tsv_out(current_frame);
    tracks = [tracks; current_frame];
    % disp('-------')
  end
end

function tsv_out(frame)
  disp(sprintf('%d\t', frame)(1:end-1))
end

function new_index = tminus(n, buffer_zero)
  global configuration;
  new_index = mod(buffer_zero - n - 1, configuration.buffer_size) + 1;
end

% pass in agentstruct? is deprecated - remove when possible
function current_frame = timestep(buffer_zero)
    global fileID;
    global configuration;
    global buffer;
    global agentStruct;
    global wallPoints;
    global goalArray;
    % TODO: change to timestep
    % if configuration.frames == 2
    % disp("poop");
    extraStructSpots(1) = 0;
    %SPAWN DEM DUDES
    %flux from each entrance per second
    spawnRate1 = 1;
    spawnRate2 = 1;
    spawnRate3 = 1;
    % get an array of three random numbers [a, b, c] 
    random = 0 + (1/configuration.dt)*rand(3,1);
    structSize = length((agentStruct));
    %disp("aa")
    if (random(1) <= spawnRate1 && structSize < configuration.agents)
      %spawn a dude at 1
      %disp("11111")
      structSize = structSize+1;
      agentStruct(structSize) = spawnDude(1);
     
    end
    if (random(2) <= spawnRate2 && structSize < configuration.agents)
      %spawn a dude at 2
      %disp("2222222")
      structSize = structSize+1;
      agentStruct(structSize) = spawnDude(2);
    end
    if (random(3) <= spawnRate3 && structSize < configuration.agents)
      %spawn a dude at 3
      %disp("3333333")
      structSize = structSize+1;
      agentStruct(structSize) = spawnDude(3);
    end
    %disp("PAST");
    % disp(configuration);

    % build current_frame to have frame # and time
    current_frame = [buffer(tminus(1, buffer_zero), 1) + 1, buffer(tminus(1, buffer_zero), 2) + configuration.dt];
    
    MainForceVector = zeros(1, configuration.agents * 2);
    %disp("AA");
    % for over each agent in the model
    for agent = 1:structSize
    maxDistence = agentStruct(agent).maxVel*configuration.dt;
      % disp('agent')
      % disp(agent)
      currentAgentFileSpot = agent * 2;
      %if (configuration.goal == 1)
        %Xpos = buffer(tminus(1, buffer_zero), agent + 2) + 100;
        %Ypos = buffer(tminus(1, buffer_zero), agent + 3) + 100;
        %current_frame = [current_frame Xpos Ypos];
      %elseif (configuration.goal == 2)
        %if (buffer(tminus(1, buffer_zero), 1) == NaN)
%
          %InitialXvelocity = 50;
          %InitialYvelocity = 50;
          %Xforce = 0;
          %Yforce = 0;
%
          %Xpos = buffer(tminus(1, buffer_zero), currentAgentFileSpot + 1) + Xforce * (configuration.dt) ^ 2 + InitialXvelocity;
          %Ypos = buffer(tminus(1, buffer_zero), currentAgentFileSpot + 2) + Yforce * (configuration.dt) ^ 2 + InitialYvelocity;
          %current_frame = [current_frame Xpos Ypos];
        %else
          %% velocity is current position - last position / dt
          %Xvel = (buffer(tminus(1, buffer_zero), currentAgentFileSpot + 1) - buffer(tminus(2, buffer_zero), currentAgentFileSpot + 1)) / configuration.dt;
          %Yvel = (buffer(tminus(1, buffer_zero), currentAgentFileSpot + 2) - buffer(tminus(2, buffer_zero), currentAgentFileSpot + 2)) / configuration.dt;
          %Xforce = 5;
          %Yforce = 5;
          %Xpos = buffer(tminus(1, buffer_zero), currentAgentFileSpot + 1) + Xforce * (configuration.dt) ^ 2 + Xvel;
          %Ypos = buffer(tminus(1, buffer_zero), currentAgentFileSpot + 2) + Yforce * (configuration.dt) ^ 2 + Yvel;
          %current_frame = [current_frame Xpos Ypos];
        %end
      % Calculate all the forces
      if (agentStruct(agent).inModel)
        % initialise a force vector for the method return
        %disp("BB");
        ForceVector = [0, 0];
        ForceVector = ForceVector + frictionForce(agentStruct(agent).vel);
        ForceVector = ForceVector + 100*(-0.5 + rand(1,2));
        %included in goal force for reasons
        %ForceVector = ForceVector + goRight(agentStruct(agent).vel);
        % itterate over each other agent
        for otherAgent = 1:structSize
          if (otherAgent != agent && agentStruct(agent).inModel)
            % calculate the force vector, and add it to the current running force total
            Force = ForceFromAnotherAgent(agentStruct(agent).pos, agentStruct(agent).vel, agentStruct(otherAgent).pos, agentStruct(otherAgent).vel);
            ForceVector = ForceVector + Force;
            %fprintf(fileID,'Agent: %3.0f from agent: %3.0f -> x is %8.0f , y is %8.0f\n', agent, otherAgent, Force);
          end
        end
        %disp("CC");
        % iterate over each wall
        for wall = 1:5 %configuration.walls
        	Force = wallForce(agentStruct(agent).pos, agentStruct(agent).vel, wallPoints(wall*2 - 1,:), wallPoints(wall*2,:), maxDistence);
          ForceVector = ForceVector + Force;
          %fprintf(fileID,'Agent: %3.0f from wall: %3.0f -> x is %8.0f , y is %8.0f\n', agent, wall, Force);
        end
        % iterate over each goal
        %disp("GOALS");
        %disp("DD");
        G = goalArray(agentStruct(agent).goalPath(agentStruct(agent).goalNum),:); %get the goal array
        forceFromGoal = goalForce(agentStruct(agent).pos, [G(1),G(2)],[G(3),G(4)], maxDistence, agentStruct(agent).vel); % get goal force from function
        %fprintf(fileID,'Agent: %3.0f forceGoal1 -> x is %8.0f , y is %8.0f\n', agent, forceFromGoal);
        % while the goal force is zero and there are more goals in the path calc a new force with the next goal 
        %disp(agentStruct(agent).goalNum)
        %agentStruct(agent).pos
        % if the agent is close to a goal then make the next goal active
        % the agent could possibly satisfy multiple goals at once -> while loop
        while(norm(forceFromGoal) < 1 && agentStruct(agent).goalNum < agentStruct(agent).pathLength)
        %disp("in the goal loop")
        fprintf(fileID,'Agent:%2.0f forceGoalLOOP -> # %5.0f\n', agent, agentStruct(agent).goalNum );
          agentStruct(agent).goalNum = agentStruct(agent).goalNum + 1;
          G = goalArray(agentStruct(agent).goalPath(agentStruct(agent).goalNum),:);
          fprintf(fileID,'Agent:%2.0f G = %4.0f %4.0f %4.0f %4.0f\n', agent, G );
          forceFromGoal = goalForce(agentStruct(agent).pos, [G(1),G(2)],[G(3),G(4)], maxDistence, agentStruct(agent).vel);
          fprintf(fileID,'Agent:%2.0f forceGoalLOOP -> x %5.0f , y %5.0f\n , norm =%5.0f\n', agent, forceFromGoal, norm(forceFromGoal));
        end
        %disp("EE");
        if (norm(forceFromGoal) < 1)
        	%disp("REMOVE")
          %remove agent they are at the final goal
          agentStruct(agent).inModel = false;
          fprintf(fileID,'Agent:%2.0f REMOVED!! -> x%5.0f , y%5.0f\n , norm =%5.0f\n', agent, forceFromGoal, norm(forceFromGoal));
        end
        ForceVector = ForceVector + forceFromGoal; 
        %fprintf(fileID,'Agent: %3.0f forceGoalAPPLIED -> x is %8.0f , y is %8.0f\n', agent, forceFromGoal);
        MainForceVector(agent * 2 - 1) = ForceVector(1);
        MainForceVector(agent * 2) = ForceVector(2);

        % dummy variable for velocity below
        % previousPos = agentStruct(agent).pos
        % calculate the new position att + vt + x
        % agentStruct(agent).pos = agentStruct(agent).pos + ForceVector*(configuration.dt)^2 + agentStruct(agent).vel*configuration.dt
        % calculate new velocity (current pos - previous pos) / t
        % agentStruct(agent).vel = (agentStruct(agent).pos - previousPos)/configuration.dt
        % get position for file
        % Xpos = agentStruct(agent).pos(1);
        % Ypos = agentStruct(agent).pos(2);
        % update file
        % current_frame = [current_frame Xpos Ypos];
      end
    end
    %disp("FF");
    % add in all the forces calculated before
    if (configuration.goal == 3)
      
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
    %put frame in file
    %disp("II");
    buffer_slot = tminus(0, buffer_zero);
    %disp("JJ");
    buffer(buffer_slot,:) = current_frame;
    
    % disp('loop end')
end


%!test % increment with some force and velocity
%!  init ( struct("dt", 0.1, "frames", 20, "agents", 2, "goal", 3,"initialAgents","0") )
%!  disp(looptest)

%!test % previous test, "move to three frames", but from JSON config
%!  init ( 'testfiles/config_read_test.json' )
%!  results = looptest;
%!  assert ( results, [1 0; 2 2; 3 4] )

%%!test % increment with some force and velocity
%%!  init ( struct("dt", 1, "frames", 4, "agents", 2, "goal", 2) )
%%!  assert ( looptest, [1 0 0 0 0 0; 2 1 50 50 50 50; 3 2 105 105 105 105; 4 3 165 165 165 165]  )

%%!test % tests 2 agents with changing position
%%!  init ( struct("dt", 2, "frames", 3, "agents", 2, "goal", 1) )
%%!  assert ( looptest, [1 0 0 0 0 0; 2 2 100 100 100 100; 3 4 200 200 200 200] )

%%!test % tests 2 agents
%%!  init ( struct("dt", 2, "frames", 3, "agents", 2, "goal",0) )
%%!  assert ( looptest, [1 0 0 0 0 0; 2 2 0 0 0 0; 3 4 0 0 0 0] )

%%!test
%%!  init ( struct("dt", 2, "frames", 3, "agents", 1, "goal",0) )
%%!  assert ( looptest, [1 0 0 0; 2 2 0 0; 3 4 0 0] )

%%!test % add agents
%%!  init ( struct("dt", 2, "frames", 3, "agents", 1, "goal",0) )
%%!  assert ( looptest, [1 0 0 0; 2 2 0 0; 3 4 0 0] )

%!test % move to three frames
%!  init ( struct("dt", 2, "frames", 3, "goal",0) )
%!  assert ( looptest, [1 0; 2 2; 3 4] )

%!test % basic output, changing dt
%!  init ( struct("dt", 2, "frames", 2, "goal",0) )
%!  assert ( looptest, [1 0; 2 2] )

%!test % for basic, two-frame, no-agent output
%!  init ( struct("dt", 1, "frames", 2, "goal",0) )
%!  assert ( looptest, [1 0; 2 1] )

%!test % for basic, one-frame, no-agent output
%!  init ( struct("dt", 1, "frames", 1) )
%!  assert ( looptest, [1, 0] )

%!test % that init doesn't throw an error
%!  init ( struct("dt", 1, "frames", 1) )

% test engine.m
