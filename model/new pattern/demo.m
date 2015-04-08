global configuration;
config;
configuration.frames = 200;
configuration.agents = 1;
configuration.dt = .2;
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
