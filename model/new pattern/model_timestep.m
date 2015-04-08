% must preload buffer with two frames
function current_frame = model_timestep()
  global frame_num;
  global configuration;
  global buffer;

  zero = zeros(1,2*configuration.agents);
  spawn_agent();
  % disp('update start')


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

  delta = regular + nonconform;
  % save to buffer so can rate limit
  slot_num = tminus(0);
  buffer(slot_num, 3:end) = delta;


  % rate limit
  braking = zero;
  switch configuration.parallel
  case 'no'
    for theAgent = 1:configuration.agents
      braking(theAgent*2-1:theAgent*2) = rate_limit(theAgent);
    end
  case 'matlab'
    parfor theAgent = 1:configuration.agents
      braking(theAgent*2-1:theAgent*2) = rate_limit(theAgent);
    end
  case 'octave'
    braking = pararrayfun(nproc(), @rate_limit, 1:configuration.agents, 'VerboseLevel', 0);
  end

  delta = delta + braking;


  % increment frame # and time for current_frame for "header"
  frame_time = [buffer(tminus(1), 1) + 1, buffer(tminus(1), 2) + configuration.dt];
  tminus1 = buffer(tminus(1), 3:end);
  current_frame = [frame_time, tminus1 + delta];
  % disp('update done')
end
