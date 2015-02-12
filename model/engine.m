##octave --eval 'test engine.m' 2>&1 | grep -v /usr/share/octave/3.8.1
% trick to allow multiple functions
1;

global configuration = struct ("dt", NaN, "frames", NaN, "agents", NaN, "goal" ,NaN);

function init ( config )
  global configuration;
  configuration = config;
  % disp(configuration);
end

function tracks = start
  global configuration;
  % tracks = [[1, 0]];
  tracks = [zeros(1, 2+(configuration.agents*2))];
  tracks(1,1) = 1 ;% frame 1 is time 0
  for frame = 2 : configuration.frames
  % if configuration.frames == 2
    %disp("poop");
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
              	 Xpos = tracks(frame-1, agent +2) + 0.5*Xforce*(configuration.dt)^2 + InitialXvelocity;
        	 Ypos = tracks(frame-1, agent +3) + 0.5*Yforce*(configuration.dt)^2 + InitialYvelocity;
           else
           	% velocity is current position - last position / dt
           	Xvel = (tracks(frame-2, agent+2)-tracks(frame-1, agent+2))/configuratiobn.dt;
           	Yvel = (tracks(frame-2, agent+3)-tracks(frame-1, agent+3))/configuration.dt;
           	Xforce = 500;
           	Yforce = 500; 
      	  Xpos = tracks(frame-1, agent +2) + 0.5*Xforce*(configuration.dt)^2 + Xvel;
       	 Xpos = tracks(frame-1, agent +2) + 0.5*Xforce*(configuration.dt)^2 + Yvel;
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

%!test
%!  init ( struct("dt", 2, "frames", 3, "agents", 2, "goal", 1) )
%!  assert ( start, [1 0 0 0 0 0; 2 2 100 100 100 100; 3 4 200 200 200 200] )

%!test
%!  init ( struct("dt", 2, "frames", 3, "agents", 2, "goal", 1) )
%!  assert ( start, [1 0 0 0 0 0; 2 2 100 100 100 100; 3 4 200 200 200 200] )

%!test
%!  init ( struct("dt", 2, "frames", 3, "agents", 2, "goal",0) )
%!  assert ( start, [1 0 0 0 0 0; 2 2 0 0 0 0; 3 4 0 0 0 0] )

%!test
%!  init ( struct("dt", 2, "frames", 3, "agents", 1, "goal",0) )
%!  assert ( start, [1 0 0 0; 2 2 0 0; 3 4 0 0] )

%!test
%!  init ( struct("dt", 2, "frames", 3, "agents",0, "goal",0) )
%!  assert ( start, [1 0; 2 2; 3 4] )

%!test
%!  init ( struct("dt", 2, "frames", 2, "agents",0, "goal",0) )
%!  assert ( start, [1 0; 2 2] )

%!test
%!  init ( struct("dt", 1, "frames", 2, "agents",0, "goal",0) )
%!  assert ( start, [1 0; 2 1] )

%!test
%!  init ( struct("dt", 1, "frames", 1, "agents",0) )
%!  assert ( start, [1, 0] )

%!test init ( struct("dt", 1, "frames", 1, "agents",0) )

test engine.m