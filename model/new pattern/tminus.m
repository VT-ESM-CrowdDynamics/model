% make circular buffer indexing less verbose
function new_index = tminus(n)
  global configuration;
  global frame_num;
  new_index = mod(frame_num - n - 1, configuration.buffer_size) + 1;
end
