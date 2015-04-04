% must preload buffer with two frames
function current_frame = model_timestep()
  global frame;
  global configuration;
  global buffer;

  delta = zeros(1,2*configuration.agents);

  % disp('update start')

  switch configuration.parallel
  case 'no'
    for theAgent = 1:configuration.agents
      delta(theAgent*2-1:theAgent*2) = agent_update(theAgent);
      % delta
    end
  case 'matlab'
    parfor theAgent = 1:configuration.agents
      delta(theAgent*2-1:theAgent*2) = agent_update(theAgent);
    end
  case 'octave'
    delta = pararrayfun(nproc(), @agent_update, 1:configuration.agents, 'VerboseLevel', 0);
    % delta
  end

  % disp('update done')

  % increment frame # and time for current_frame for "header"
  frame_time = [buffer(tminus(1, frame), 1) + 1, buffer(tminus(1, frame), 2) + configuration.dt];

  % update auxiliary data structures




  current_frame = [frame_time, delta];
  % disp('loop end')
end
