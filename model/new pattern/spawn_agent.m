function spawn_agent()
  % global fileID;
  global configuration;
  global buffer;

  % buffer
  slot_num = tminus(1);
  buffer_slot = buffer(slot_num, :);
  last_frame = buffer_slot(3:end);
  nanframe = isnan(last_frame);
  nans = sum(nanframe);
  active = configuration.agents - nans/2;

  %SPAWN DEM DUDES
  %flux from each entrance per second
  spawnRate1 = 10;
  spawnRate2 = 10;
  spawnRate3 = 10;
  % get an array of three random numbers [a, b, c] 
  random = 0 + (1/configuration.dt)*rand(3,1);
  %disp("aa")
  if (random(1) <= spawnRate1 && active < configuration.agents)
    %spawn a dude at 1
    %disp("11111")
    agent_factory(active, 1);
  end
  if (random(2) <= spawnRate2 && active + 1 < configuration.agents)
    %spawn a dude at 2
    %disp("2222222")
    agent_factory(active, 2);
  end
  if (random(3) <= spawnRate3 && active  + 2< configuration.agents)
    %spawn a dude at 3
    %disp("3333333")
    agent_factory(active, 3);
  else
  %disp("PAST");
end
