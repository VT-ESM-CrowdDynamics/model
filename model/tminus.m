% make buffer indexing less verbose
function new_index = tminus(n, buffer_zero)
	global configuration;
	new_index = mod(buffer_zero - n - 1, configuration.buffer_size) + 1;
end