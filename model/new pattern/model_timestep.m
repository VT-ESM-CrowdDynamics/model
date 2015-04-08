% must preload buffer with two frames
function current_frame = model_timestep()
  global frame_num;
  global configuration;
  global buffer;

  zero = zeros(1,2*configuration.agents);
  spawn_agent();
  % disp('update start')

  % TODO: these three loops need refactored to one loop so threads can stay
  % active longer and decrease parallel overhead

  % each of these switches runs with serial or matlab parallel or octave
  % parallel, depending on configuration.parallel

  % regular forces
  regular = zero;
  switch configuration.parallel
  case 'no'
    for theAgent = 1:configuration.agents
      regular(theAgent*2-1:theAgent*2) = agent_update(theAgent);
      % regular
    end
  case 'matlab'
    parfor theAgent = 1:configuration.agents
      regular(theAgent*2-1:theAgent*2) = agent_update(theAgent);
    end
  case 'octave'
    regular = pararrayfun(nproc(), @agent_update, 1:configuration.agents, 'VerboseLevel', 0);
    % regular
  end


  % non-conforming functions
  % goal force needs to update outside parallel environment
  nonconform = zero;
  switch configuration.parallel
  case 'no'
    for theAgent = 1:configuration.agents
      result = goalForce(theAgent); % position + non-conforming updates
      nonconform(theAgent*2-1:theAgent*2) = result(1, :); %position
      current_goals(theAgent) = result(2, 1); % goal
    end
  case 'matlab'
    parfor theAgent = 1:configuration.agents
      result = goalForce(theAgent); % position + non-conforming updates
      nonconform(theAgent*2-1:theAgent*2) = result(1, :); %position
      current_goals(theAgent) = result(2, 1); % goal
    end
  case 'octave'
    result = pararrayfun(nproc(), @goalForce, 1:configuration.agents, 'VerboseLevel', 0);
    nonconform = result(1, :); % positions + non-conforming updates
    current_goals = result(2, 1:2:end);
  end

  forces = regular + nonconform;
  % save to buffer so can rate limit
  slot_num = tminus(0); % current slot as temporary space
  buffer(slot_num, 3:end) = forces;


  % rate limit
  limited = zero;
  switch configuration.parallel
  case 'no'
    for theAgent = 1:configuration.agents
      limited(theAgent*2-1:theAgent*2) = rate_limit(theAgent);
    end
  case 'matlab'
    parfor theAgent = 1:configuration.agents
      limited(theAgent*2-1:theAgent*2) = rate_limit(theAgent);
    end
  case 'octave'
    limited = pararrayfun(nproc(), @rate_limit, 1:configuration.agents, 'VerboseLevel', 0);
  end

  % increment frame # and time for current_frame for "header"
  frame_time = [buffer(tminus(1), 1) + 1, buffer(tminus(1), 2) + configuration.dt];
  % new positions from limited
  current_frame = [frame_time, limited];
  % disp('update done')
end
