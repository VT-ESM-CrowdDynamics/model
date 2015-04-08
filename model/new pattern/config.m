% common settings between demo and demo_big
global configuration;
% 1ft = 304.8mm (300)
configuration.wallPoints = [[-4,-20];[-4,0];[4,-20];[4,0];[-4,0];[-14,0];[4,0];[14,0];[-14,8];[14,8]]*300;
configuration.dt = .1;
configuration.buffer_size = 5;
configuration.functions = {@wallForce, @frictionForce, @agent_agent_force, @ufoForce};
configuration.parallel = 'no';
configuration.view_size = 8000;
configuration.goalArray = [[-4,-20,4,-20];[-4,0,4,0];[-4,0,-4,8];[4,0,4,8];[-14,0,-14,8];[14,0,14,8]]*300;
