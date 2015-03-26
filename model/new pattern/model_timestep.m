% must preload buffer with two frames
function current_frame = model_timestep(buffer_zero, buffer)
  global configuration;
  % make buffer indexing less verbose
  tminus = @(n) mod(buffer_zero - n - 1, configuration.buffer_size) + 1;

  tminus2 = buffer(tminus(2), 3:end);
  tminus1 = buffer(tminus(1), 3:end);
  delta = tminus2-tminus1;

  % for theAgent = 1:configuration.agents
  %   % disp(theAgent)
    
  %   last_position = tminus1(i:1+i);
  %   last_delta = delta(i:1+i);
  %   % current_frame = [current_frame position];
  % end

  % increment frame # and time for current_frame
  frame_time = [buffer(tminus(1), 1) + 1, buffer(tminus(1), 2) + configuration.dt];
  buffer_slot = tminus(0);
  buffer(buffer_slot, :) = [frame_time delta];
  current_frame = buffer(buffer_slot, :);
  % disp('loop end')
end
