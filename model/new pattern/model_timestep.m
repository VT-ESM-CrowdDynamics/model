% must preload buffer with two frames
function current_frame = model_timestep()
  global frame_num;
  global configuration;
  global buffer;

  delta = zeros(1,2*configuration.agents);
  spawn_agent();
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

  delta1 = delta;

  % non-conforming functions
    switch configuration.parallel
  case 'no'
    for theAgent = 1:configuration.agents
      result = goalForce(theAgent); % position + non-conforming updates
      % goals
      delta(theAgent*2-1:theAgent*2) = result(1, :); %position
      current_goals(theAgent) = result(2, 1); % goal
    end
  case 'matlab'
    parfor theAgent = 1:configuration.agents
      result = goalForce(theAgent); % position + non-conforming updates
      % goals
      delta(theAgent*2-1:theAgent*2) = result(1, :); %position
      current_goals(theAgent) = result(2, 1); % goal
    end
  case 'octave'
    result = pararrayfun(nproc(), @goalForce, 1:configuration.agents, 'VerboseLevel', 0);
    delta = result(1, :); % positions + non-conforming updates
    % goals
    current_goals = result(2, 1:2:end);
  end

  delta = delta + delta1;

  % disp('update done')

  % increment frame # and time for current_frame for "header"
  frame_time = [buffer(tminus(1), 1) + 1, buffer(tminus(1), 2) + configuration.dt];

  tminus1 = buffer(tminus(1), 3:end);
  current_frame = [frame_time, tminus1 + delta];
  % disp('loop end')
end
