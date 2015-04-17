global configuration;
configuration.frames = 500;
configuration.agents = 20;
config;
model_init(configuration);
% disp('serial')
% configuration.parallel = 'no';
% model_loop;
% configuration.parallel = 'matlab';
% disp('matlab parallel')
% model_loop;
configuration.parallel = 'octave';
% disp('octave parallel')
model_loop;
