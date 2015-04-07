global configuration;
configuration.dt = 1;
configuration.frames = 500;
configuration.agents = 100;
configuration.buffer_size = 5;
configuration.functions = {@function1, @function2, @wallForce, @frictionForce};
configuration.parallel = 'no';
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