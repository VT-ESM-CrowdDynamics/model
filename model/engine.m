##octave --eval 'test engine.m' 2>&1 | grep -v /usr/share/octave/3.8.1
% trick to allow multiple functions
1;

addpath('../lib/jsonlab');
addpath('../lib/catstruct');

global configuration;

function init ( config )
  global configuration;
  defaults = loadjson('defaults.json');
  % if passed a filename, parse as JSON and use for config
  if(ischar(config) && exist(config, 'file'))
    config = loadjson(config)
  end
  configuration = catstruct(defaults, config);
  % disp(configuration);
end

function tracks = start
  global configuration;
  % tracks = [[1, 0]];
  tracks = [zeros(1, 2+(configuration.agents*2))];
  tracks(1,1) = 1 ;% frame 1 is time 0
  for frame = 2 : configuration.frames
  % if configuration.frames == 2
    % disp("poop");
    % disp(configuration);

    %build current_frame to have frame # and time
    current_frame = [tracks(frame-1, 1) + 1, tracks(frame-1, 2) + configuration.dt];
    % for over each agent in the model
    for agent = 1:configuration.agents
    	%disp(agent)
      if(configuration.goal==1)
        Xpos = tracks(frame-1, agent +2) + 100;
        Ypos = tracks(frame-1, agent +3) + 100;
        current_frame = [current_frame Xpos Ypos];
        elseif(configuration.goal == 2)
           if (frame == 2)
           	InitialXvelocity = 50;
           	InitialYvelocity = 50;
           	Xforce = 0;
           	Yforce = 0; 
              	 Xpos = tracks(frame-1, agent +2) + Xforce*(configuration.dt)^2 + InitialXvelocity;
        	 Ypos = tracks(frame-1, agent +3) + Yforce*(configuration.dt)^2 + InitialYvelocity;
        	 current_frame = [current_frame Xpos Ypos];
           else
           	% velocity is current position - last position / dt
           	Xvel = (tracks(frame-1, agent+2)-tracks(frame-2, agent+2))/configuration.dt;
           	Yvel = (tracks(frame-1, agent+3)-tracks(frame-2, agent+3))/configuration.dt;
           	Xforce = 5;
           	Yforce = 5; 
      	  Xpos = tracks(frame-1, agent +2) + Xforce*(configuration.dt)^2 + Xvel;
       	 Ypos = tracks(frame-1, agent +3) + Yforce*(configuration.dt)^2 + Yvel;
     	   current_frame = [current_frame Xpos Ypos];
           end
        else
         current_frame = [current_frame 0 0];
      end
    end
    % update the array 
    tracks = [tracks; current_frame];
  end
  % disp(tracks);
end

% disp (catstruct(struct("a", "a", "b", "b"), struct("a", 1)))

%!test % previous test, "move to three frames", but from JSON config
%!  init ( 'testfiles/config_read_test.json' )
%!  assert ( start, [1 0; 2 2; 3 4] )

%!test % increment with some force and velocity
%!  init ( struct("dt", 1, "frames", 4, "agents", 2, "goal", 2) )
%!  assert ( start, [1 0 0 0 0 0; 2 1 50 50 50 50; 3 2 105 105 105 105; 4 3 165 165 165 165]  )

%!test % tests 2 agents with changing position
%!  init ( struct("dt", 2, "frames", 3, "agents", 2, "goal", 1) )
%!  assert ( start, [1 0 0 0 0 0; 2 2 100 100 100 100; 3 4 200 200 200 200] )

%!test % tests 2 agents
%!  init ( struct("dt", 2, "frames", 3, "agents", 2, "goal",0) )
%!  assert ( start, [1 0 0 0 0 0; 2 2 0 0 0 0; 3 4 0 0 0 0] )

%!test
%!  init ( struct("dt", 2, "frames", 3, "agents", 1, "goal",0) )
%!  assert ( start, [1 0 0 0; 2 2 0 0; 3 4 0 0] )

%!test % add agents
%!  init ( struct("dt", 2, "frames", 3, "agents", 1, "goal",0) )
%!  assert ( start, [1 0 0 0; 2 2 0 0; 3 4 0 0] )

%!test % move to three frames
%!  init ( struct("dt", 2, "frames", 3, "goal",0) )
%!  assert ( start, [1 0; 2 2; 3 4] )

%!test % basic output, changing dt
%!  init ( struct("dt", 2, "frames", 2, "goal",0) )
%!  assert ( start, [1 0; 2 2] )

%!test % for basic, two-frame, no-agent output
%!  init ( struct("dt", 1, "frames", 2, "goal",0) )
%!  assert ( start, [1 0; 2 1] )

%!test % for basic, one-frame, no-agent output
%!  init ( struct("dt", 1, "frames", 1) )
%!  assert ( start, [1, 0] )

%!test % that init doesn't throw an error
%!  init ( struct("dt", 1, "frames", 1) )

test engine.m