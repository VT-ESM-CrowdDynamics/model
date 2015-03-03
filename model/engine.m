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
    config = loadjson(config)
  end
  configuration = catstruct(defaults, config);
  % disp(configuration);
end

function tracks = looptest
  global configuration;
  % tracks = [[1, 0]];

  tracks(1, 1) = 1; % frame 1 is time 0
  agentStruct = struct;
  % setup needs to place agents in model and give properties etc
  for agent = 1:configuration.agents
    % currently arbitrary setup
    agentStruct(agent).pos = [0, 0];
    agentStruct(agent).vel = [0, 0];
    tracks(1, agent * 2 + 1) = agentStruct(agent).pos(1);
    tracks(1, agent * 2 + 2) = agentStruct(agent).pos(2);
  end

  for frame = 2 : configuration.frames
    % if configuration.frames == 2
    % disp("poop");

    % disp(configuration);

    % build current_frame to have frame # and time
    current_frame = [tracks(frame - 1, 1) + 1, tracks(frame - 1, 2) + configuration.dt];
    % for over each agent in the
    MainForceVector = zeros(1, configuration.agents * 2);
    for agent = 1:configuration.agents
      % disp(agent)
      currentAgentFileSpot = agent * 2;
      if (configuration.goal == 1)
        Xpos = tracks(frame - 1, agent + 2) + 100;
        Ypos = tracks(frame - 1, agent + 3) + 100;
        current_frame = [current_frame Xpos Ypos];
      elseif (configuration.goal == 2)
        if (frame == 2)

          InitialXvelocity = 50;
          InitialYvelocity = 50;
          Xforce = 0;
          Yforce = 0;

          Xpos = tracks(frame - 1, currentAgentFileSpot + 1) + Xforce * (configuration.dt) ^ 2 + InitialXvelocity;
          Ypos = tracks(frame - 1, currentAgentFileSpot + 2) + Yforce * (configuration.dt) ^ 2 + InitialYvelocity;
          current_frame = [current_frame Xpos Ypos];
        else
          % velocity is current position - last position / dt
          Xvel = (tracks(frame - 1, currentAgentFileSpot + 1) - tracks(frame - 2, currentAgentFileSpot + 1)) / configuration.dt;
          Yvel = (tracks(frame - 1, currentAgentFileSpot + 2) - tracks(frame - 2, currentAgentFileSpot + 2)) / configuration.dt;
          Xforce = 5;
          Yforce = 5;
          Xpos = tracks(frame - 1, currentAgentFileSpot + 1) + Xforce * (configuration.dt) ^ 2 + Xvel;
          Ypos = tracks(frame - 1, currentAgentFileSpot + 2) + Yforce * (configuration.dt) ^ 2 + Yvel;
          current_frame = [current_frame Xpos Ypos];
        end
        % NEW goal using vectors and actual force function for calculations
      elseif (configuration.goal == 3)
        % initialise a force vector for the method return
        ForceVector = [0, 0];
        % itterate over each other agent
        for otherAgent = 1:configuration.agents
          if (otherAgent != agent)
            % calculate the force vector, and add it to the current running force total
            ForceVector = ForceVector + ForceFromAnotherAgent(agentStruct(agent).pos, agentStruct(agent).vel, agentStruct(otherAgent).pos, agentStruct(otherAgent).vel);
          end
        end
        % iterate over each wall
        for wall = 1:configuration.walls
          ForceVector

        end
        % iterate over each goal
        for goal = 1:configuration.goals
          ForceVector

        end
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
        % get position for file
        Xpos = agentStruct(theAgent).pos(1);
        Ypos = agentStruct(theAgent).pos(2);
        % update file
        current_frame = [current_frame Xpos Ypos];
        % update the array
      end
    end
    tracks = [tracks; current_frame];

  end
  % disp(tracks);
end


%!test % increment with some force and velocity
%!  init ( struct("dt", 1, "frames", 4, "agents", 2, "goal", 3) )
%!  disp(looptest)

%!test % previous test, "move to three frames", but from JSON config
%!  init ( 'testfiles/config_read_test.json' )
%!  assert ( looptest, [1 0; 2 2; 3 4] )

%!test % increment with some force and velocity
%!  init ( struct("dt", 1, "frames", 4, "agents", 2, "goal", 2) )
%!  assert ( looptest, [1 0 0 0 0 0; 2 1 50 50 50 50; 3 2 105 105 105 105; 4 3 165 165 165 165]  )

%!test % increment with some force and velocity
%!  init ( struct("dt", 1, "frames", 4, "agents", 2, "goal", 2) )
%!  assert ( looptest, [1 0 0 0 0 0; 2 1 50 50 50 50; 3 2 105 105 105 105; 4 3 165 165 165 165]  )

%!test % tests 2 agents with changing position
%!  init ( struct("dt", 2, "frames", 3, "agents", 2, "goal", 1) )
%!  assert ( looptest, [1 0 0 0 0 0; 2 2 100 100 100 100; 3 4 200 200 200 200] )

%!test % tests 2 agents
%!  init ( struct("dt", 2, "frames", 3, "agents", 2, "goal",0) )
%!  assert ( looptest, [1 0 0 0 0 0; 2 2 0 0 0 0; 3 4 0 0 0 0] )

%!test
%!  init ( struct("dt", 2, "frames", 3, "agents", 1, "goal",0) )
%!  assert ( looptest, [1 0 0 0; 2 2 0 0; 3 4 0 0] )

%!test % add agents
%!  init ( struct("dt", 2, "frames", 3, "agents", 1, "goal",0) )
%!  assert ( looptest, [1 0 0 0; 2 2 0 0; 3 4 0 0] )

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

test engine.m
