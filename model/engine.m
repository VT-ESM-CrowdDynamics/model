##octave --eval 'test engine.m' 2>&1 | grep -v /usr/share/octave/3.8.1

1;

global configuration = struct ("dt", NaN, "frames", NaN, "agents", NaN);

function init ( config )
  global configuration;
  configuration = config;
  % disp(configuration);
end

function tracks = start
  global configuration;
  % tracks = [[1, 0]];
  tracks = [zeros(1, 2+(configuration.agents*2))]
  tracks(1,1) = 1 % frame 1 is time 0
  for frame = 2 : configuration.frames
  % if configuration.frames == 2
    disp("poop");
    % disp(configuration);

    %build current_frame to have frame # and time
    current_frame = [tracks(frame-1, 1) + 1, tracks(frame-1, 2) + configuration.dt]
    current_frame = [current_frame 0 0]
    tracks = [tracks; current_frame]
  end
  % disp(tracks);
end

%!test
%!  init ( struct("dt", 2, "frames", 3, "agents", 1) )
%!  assert ( start, [1 0 0 0; 2 2 0 0; 3 4 0 0] )

%!test
%!  init ( struct("dt", 2, "frames", 3) )
%!  assert ( start, [1 0; 2 2; 3 4] )

%!test
%!  init ( struct("dt", 2, "frames", 2) )
%!  assert ( start, [1 0; 2 2] )

%!test
%!  init ( struct("dt", 1, "frames", 2) )
%!  assert ( start, [1 0; 2 1] )

%!test
%!  init ( struct("dt", 1, "frames", 1) )
%!  assert ( start, [1, 0] )

%!test init ( struct("dt", 1, "frames", 1) )

test engine.m