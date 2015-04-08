function agent_factory(agents, start_spawn)
  global configuration;
  agent_num = agents + start_spawn;
  global goal_paths;
  global velocity_upper_limits;
  global spawn_points;
  spawn_points(agent_num) = start_spawn;
  global current_goals;
  current_goals(agent_num) = 1;

  % array of spawns like goals
  spawnArray = [[-4,-20,4,-20];[-14,0,-14,8];[14,0,14,8]]*300;
  
  goal_paths(agent_num) = randi([1 2]); % get the random path num

  spawn = spawnArray(start_spawn,:); % get the random spawn line
  if (spawn(1) > spawn(3))
    positionX = randi([(spawn(3)+200) (spawn(1)-200)]);
  elseif (spawn(1) < spawn(3))
    positionX = randi([(spawn(1)+200) (spawn(3)-200)]);
    else
    positionX = spawn(1);
  end
  if (spawn(2) > spawn(4))
    positionY = randi([(spawn(4)+200) (spawn(2)-200)]);
  elseif(spawn(4) > spawn(2))
    positionY = randi([(spawn(2)+200) (spawn(4)-200)]);
    else 
    positionY = spawn(2);
  end

  global buffer;

  % set last position
  buffer(tminus(1), 1+2*agent_num:2+2*agent_num) = [positionX, positionY];
  % set velocity 0 ( no difference from last last position )
  buffer(tminus(1), 1+2*agent_num:2+2*agent_num) = [positionX, positionY];

  current_goals(agent_num) = 1;
  velocity_upper_limits(agent_num) = (2.0*300 + randi([0 240]))*configuration.dt;
end