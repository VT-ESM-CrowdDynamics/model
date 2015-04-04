function model_init (config)
  addpath('../../lib/jsonlab');
  addpath('../../lib/catstruct');
  global configuration;
  defaults = loadjson('defaults.json');
  % if passed a filename, parse as JSON and use for config
  if (ischar(config) && exist(config, 'file'))
    config = loadjson(config);
  end
  configuration = catstruct(defaults, config);
  % disp(configuration);
  if exist('OCTAVE_VERSION') ~= 0  
    % you'll need to run this once, to install the package:
    % pkg install -forge parallel
    pkg load parallel
  end
end