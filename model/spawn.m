function spawn()
  global fileID;
  global configuration;
  global buffer;
  global agentStruct;
  global wallPoints;
  global goalArray;
  % TODO: change to timestep
  % if configuration.frames == 2
  % disp("poop");
  extraStructSpots(1) = 0;
  %SPAWN DEM DUDES
  %flux from each entrance per second
  spawnRate1 = 1;
  spawnRate2 = 1;
  spawnRate3 = 1;
  % get an array of three random numbers [a, b, c] 
  random = 0 + (1/configuration.dt)*rand(3,1);
  structSize = length((agentStruct));
  %disp("aa")
  if (random(1) <= spawnRate1 && structSize < configuration.agents)
    %spawn a dude at 1
    %disp("11111")
    structSize = structSize+1;
    agentStruct(structSize) = spawnDude(1);
   
  end
  if (random(2) <= spawnRate2 && structSize < configuration.agents)
    %spawn a dude at 2
    %disp("2222222")
    structSize = structSize+1;
    agentStruct(structSize) = spawnDude(2);
  end
  if (random(3) <= spawnRate3 && structSize < configuration.agents)
    %spawn a dude at 3
    %disp("3333333")
    structSize = structSize+1;
    agentStruct(structSize) = spawnDude(3);
  end
  %disp("PAST");
  % disp(configuration);
end