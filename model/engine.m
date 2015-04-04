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

function current_frame = timestep(buffer_zero)
    global fileID;
    global configuration;
    global buffer;
    global agentStruct;
    global wallPoints;
    global goalArray;
    spawn();

    % build current_frame to have frame # and time
    current_frame = [buffer(tminus(1, buffer_zero), 1) + 1, buffer(tminus(1, buffer_zero), 2) + configuration.dt];
    
    MainForceVector = zeros(1, configuration.agents * 2);
    %disp("AA");
    % for over each agent in the model
    structSize = length((agentStruct));
    for agent = 1:structSize
      maxDistence = agentStruct(agent).maxVel*configuration.dt;
      % disp('agent')
      % disp(agent)
      currentAgentFileSpot = agent * 2;
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

      end
    end
    %disp("FF");

    current_frame = goal_update(MainForceVector, current_frame);

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
