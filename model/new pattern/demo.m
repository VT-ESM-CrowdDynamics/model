model_init('defaults.json');
global configuration;
configuration.dt = 1;
configuration.frames = 50;
configuration.agents = 30;
configuration.functions = {@function1};
model_loop;