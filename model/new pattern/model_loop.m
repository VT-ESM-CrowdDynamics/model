function model_loop
  global configuration;
  global buffer;
  % stage first two frames for buffer
  buffer = nan(configuration.buffer_size, configuration.agents * 2 + 2);
  buffer(1, 1:2) = [1 0]; % frame 1 is time 0
  buffer(2, 1:2) = [2 1]; % frame 2 is time 1

  % print the staged frames
  disp(tsv_out(buffer(1,:)));
  disp(tsv_out(buffer(2,:)));

  % extra init scripts hook
  extra_init;

  global frame_num;
  % loop through requested frames
  for frame_num = 3 : configuration.frames
    % disp('looping!')
    % disp(frame_num)
    % disp(buffer)
    current_frame = model_timestep();
    buffer(tminus(0, frame_num),:) = current_frame;
    disp(tsv_out(current_frame));
    % disp('-------')
  end
  pause
  disp('');
end
