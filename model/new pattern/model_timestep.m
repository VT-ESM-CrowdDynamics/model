% must preload buffer with two frames
function current_frame = model_timestep(frame)
  global configuration;
  global buffer;

  delta = zeros(1,2*configuration.agents);

  for theAgent = 1:configuration.agents
    this_delta = zeros(1,2);
    for 
    delta(theAgent:1+theAgent) = this_delta;
  end

  % increment frame # and time for current_frame
  frame_time = [buffer(tminus(1, frame), 1) + 1, buffer(tminus(1, frame), 2) + configuration.dt];
  current_frame = [frame_time, delta];
  % disp('loop end')
end
