global configuration;
config;
configuration.frames = 300;
configuration.agents = 1;
configuration.dt = .1;
model_init(configuration);
% disp('serial')
% configuration.parallel = 'no';
% model_loop;
% configuration.parallel = 'matlab';
% disp('matlab parallel')
% model_loop;
% configuration.parallel = 'octave';
% disp('octave parallel')
model_loop;
