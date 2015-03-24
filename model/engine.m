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
end

function tracks = looptest
  global wallPoints;
  global goalArray;
  global configuration;
  % tracks = [[1, 0]];
  % TODO: init stuff needs to move to init
  global buffer;
  buffer = zeros(configuration.buffer_size, configuration.agents * 2 + 2);
  buffer(1, 1) = 1; % frame 1 is time 0
  global agentStruct;
  agentStruct = struct;
  % array of wall points
  % needs to be configured from the starting file
  % 1ft = 304.8mm (300)
  wallPoints = [[-4,-20];[-4,0];[4,-20];[4,0];[-4,0];[-14,0];[4,0];[14,0];[-14,8];[14,8]]*300; % T
  % array of goals [x1,y1,x2,y2] for each goal
  goalArray = [[-4,-20,4,-20];[-4,0,4,0];[-4,0,-4,8];[4,0,4,8];[-14,0,-14,8];[14,0,14,8]]*300; % lines across halls in T
  % array of possible paths from goal to goal, path# assigned randomly to each agent
  % for example in T intersection can have two path# each to one exit
  % in form goalPath(path#,:, spawnPt) gives an array like [2,5] to call goalArray(2) then goalArray(5)
  % as the agent moves from goal to goal
  goalPath = cat(3,[2,3,5;2,4,6],[3,2,1;3,4,6],[4,2,1;4,3,5]);
  paths = 2; % # of possible paths for each spawn
  spawns = 3; % # possible spawns
  % array of spawns like goals
  spawnArray = [[-4,-20,4,-20];[-14,0,-14,8];[14,0,14,8]]*300;
  % setup needs to place agents in model and give properties etc
  for agent = 1:configuration.agents
    % randomly spawn agents in spawn points
    % wont work right now bc all agents will spawn too close
    % need to populate hallways one by one
    thisSpawn = randi([1 3])
    thisPath = randi([1 2])
    spawn = spawnArray(thisSpawn,:); % get the random spawn line
    thePath = goalPath(thisPath,:,thisSpawn); % get the random path 
    if (spawn(1) > spawn(3))
      positionX = randi([spawn(3) spawn(1)])
    else
      positionX = randi([spawn(1) spawn(3)])
    end
    if (spawn(2) > spawn(4))
      positionY = randi([spawn(4) spawn(2)])
    else
      positionY = randi([spawn(2) spawn(4)])
    end
    agentStruct(agent).pos = [positionX, positionY];
    agentStruct(agent).vel = [0, 0];
    buffer(1, agent * 2 + 1) = agentStruct(agent).pos(1);
    buffer(1, agent * 2 + 2) = agentStruct(agent).pos(2);
    %
    agentStruct(agent).goalNum = 1;
    agentStruct(agent).goalPath = thePath;
    agentStruct(agent).pathLength = size(thePath)(2);
    agentStruct(agent).inModel = true;
    agentStruct(agent).maxVel = 4.5*300;
    
  end

  % disp('start tracks')
  tracks = buffer(1,:);
  for frame = 2 : configuration.frames
    % disp('looping!')
    % disp(frame)
    % disp(buffer)
    current_frame = timestep(frame);
    tracks = [tracks; current_frame];
    % disp('-------')
  end
end

function new_index = tminus(n, buffer_zero)
  global configuration;
  new_index = mod(buffer_zero - n - 1, configuration.buffer_size) + 1;
end

% pass in agentstruct? is deprecated - remove when possible
function current_frame = timestep(buffer_zero)

    global configuration;
    global buffer;
    global agentStruct;
    global wallPoints;
    global goalArray;
    % TODO: change to timestep
    % if configuration.frames == 2
    % disp("poop");

    % disp(configuration);

    % build current_frame to have frame # and time
    current_frame = [buffer(tminus(1, buffer_zero), 1) + 1, buffer(tminus(1, buffer_zero), 2) + configuration.dt];
    % for over each agent in the
    MainForceVector = zeros(1, configuration.agents * 2);
    for agent = 1:configuration.agents
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
      % NEW goal using vectors and actual force function for calculations
      if (configuration.goal == 3)
        % initialise a force vector for the method return
        ForceVector = [0, 0];
        % itterate over each other agent
        for otherAgent = 1:configuration.agents
          if (otherAgent != agent && agentStruct(agent).inModel)
            % calculate the force vector, and add it to the current running force total
            ForceVector = ForceVector + ForceFromAnotherAgent(agentStruct(agent).pos, agentStruct(agent).vel, agentStruct(otherAgent).pos, agentStruct(otherAgent).vel);
          end
        end
        
        % iterate over each wall
        for wall = 1:5 %configuration.walls
          ForceVector = ForceVector + wallForce(agentStruct(agent).pos, agentStruct(agent).vel, wallPoints(wall*2 - 1,:), wallPoints(wall*2,:), maxDistence);

        end
        % iterate over each goal
        disp("GOALS");
        
        G = goalArray(agentStruct(agent).goalPath(agentStruct(agent).goalNum),:) %get the goal array
        forceFromGoal = goalForce(agentStruct(agent).pos, [G(1),G(2)],[G(3),G(4)], maxDistence); % get goal force from function
        % while the goal force is zero and there are more goals in the path calc a new force with the next goal 
        agentStruct(agent).goalNum
        agentStruct(agent).pos
        while(norm(forceFromGoal) < 1 && agentStruct(agent).goalNum < agentStruct(agent).pathLength)
        disp("in the goal loop")
          agentStruct(agent).goalNum = agentStruct(agent).goalNum + 1;
          G = goalArray(agentStruct(agent).goalPath(agentStruct(agent).goalNum),:);
          forceFromGoal = goalForce(agentStruct(agent).pos, [G(1),G(2)],[G(3),G(4)]);
        end
        if (norm(forceFromGoal) < 1)
          %remove agent they are at the final goal
          agentStruct(agent).inModel = false;
        end
        ForceVector = ForceVector + forceFromGoal; 

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
      else
        current_frame = [current_frame 0 0];
      end
    end
    % add in all the forces calculated before
    if (configuration.goal == 3)
      for theAgent = 1:configuration.agents
        % disp(theAgent)
        
        Force = [MainForceVector(theAgent * 2 - 1), MainForceVector(theAgent * 2)];
        % dummy variable for velocity below
        previousPos = agentStruct(theAgent).pos;
        % calculate the new position att + vt + x
        agentStruct(theAgent).pos = agentStruct(theAgent).pos + Force * (configuration.dt) ^ 2 + agentStruct(theAgent).vel * configuration.dt;
        % calculate new velocity (current pos - previous pos) / t
        agentStruct(theAgent).vel = (agentStruct(theAgent).pos - previousPos) / configuration.dt;
        %this movement exceeded the max allowed velocity
        if (agentStruct(agent).vel > agentStruct(agent).maxVel)
        	% get direction of movement
        	direction = agentStruct(agent).vel/norm(agentStruct(agent).vel);
        	% set velocity in that direction to be max velocity
        	agentStruct(agent).vel = agentStruct(agent).maxVel*direction;
        	% calculate new position with max velocity
        	agentStruct(agent).pos = previousPos + agentStruct(agent).vel*configuration.dt;
        end
        % get position for file
        Xpos = agentStruct(theAgent).pos(1);
        Ypos = agentStruct(theAgent).pos(2);
        % update file
        current_frame = [current_frame Xpos Ypos];
        % update the array
      end
    end
    buffer_slot = tminus(0, buffer_zero);
    buffer(buffer_slot,:) = current_frame;
    % disp('loop end')
end


%!test % increment with some force and velocity
%!  init ( struct("dt", 0.2, "frames", 60, "agents", 1, "goal", 3) )
%!  disp(looptest/300)

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
