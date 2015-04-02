function model_loop
  global configuration;
  global buffer;
  % stage first two frames for buffer
  buffer = zeros(configuration.buffer_size, configuration.agents * 2 + 2);
  buffer(1, 1:2) = [1 0]; % frame 1 is time 0
  buffer(2, 1:2) = [2 1]; % frame 2 is time 1

  % display a vector as tsv
  tsv_out = @(frame) disp(sprintf('%d\t', frame)(1:end-1));

  % print the staged frames
  tsv_out(buffer(1,:));
  tsv_out(buffer(2,:));

  global frame;
  % loop through requested frames
  for frame = 3 : configuration.frames
    % disp('looping!')
    % disp(frame)
    % disp(buffer)
    current_frame = model_timestep();
    buffer(tminus(0, frame),:) = current_frame;
    tsv_out(current_frame);
    % disp('-------')
  end
end