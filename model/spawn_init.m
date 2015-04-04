function spawn_init()
  global wallPoints;
  global goalArray;
  global configuration;
  global buffer;
  global fileID;
  global agentStruct;
  agentStruct = struct;
  % array of wall points
  % needs to be configured from the starting file
  % 1ft = 304.8mm (300)
  wallPoints = [[-4,-20];[-4,0];[4,-20];[4,0];[-4,0];[-14,0];[4,0];[14,0];[-14,8];[14,8]]*300; % T
  % array of goals [x1,y1,x2,y2] for each goal
  goalArray = [[-4,-20,4,-20];[-4,0,4,0];[-4,0,-4,8];[4,0,4,8];[-14,0,-14,8];[14,0,14,8]]*300; % lines across halls in T
  % array of possible paths from goal to goal, path# assigned randomly to each agent
  % for example in T intersection can have two path# each to one exit
  % in form goalPath(path#,:, spawnPt) gives an array like [2,5] to call configuration.goalArray(2) then configuration.goalArray(5)
  % as the agent moves from goal to goal
  goalPath = cat(3,[2,3,5;2,4,6],[3,2,1;3,4,6],[4,2,1;4,3,5]);
  paths = 2; % # of possible paths for each spawn
  spawns = 3; % # possible spawns
  % array of spawns like goals
  spawnArray = [[-4,-20,4,-20];[-14,0,-14,8];[14,0,14,8]]*300;
  % setup needs to place agents in model and give properties etc
  %x=configuration.initialAgents
  for agent = 1 : 1%configuration.initialAgents
    % randomly spawn agents in spawn points
    % wont work right now bc all agents will spawn too close
    % need to populate hallways one by one
    %disp(agent)
    thisSpawn = randi([1 3]);
    agentStruct(agent) = spawnDude(thisSpawn);
    %thisPath = randi([1 2])
    %spawn = spawnArray(thisSpawn,:); % get the random spawn line
    %thePath = goalPath(thisPath,:,thisSpawn); % get the random path 
    %if (spawn(1) > spawn(3))
      %positionX = randi([spawn(3) spawn(1)])
    %else
      %positionX = randi([spawn(1) spawn(3)])
    %end
    %if (spawn(2) > spawn(4))
      %positionY = randi([spawn(4) spawn(2)])
    %else
      %positionY = randi([spawn(2) spawn(4)])
    %end
    %agentStruct(agent).pos = [positionX, positionY];
    %agentStruct(agent).vel = [0, 0];
    buffer(1, agent * 2 + 1) = agentStruct(agent).pos(1);
    buffer(1, agent * 2 + 2) = agentStruct(agent).pos(2);
    %%
    %agentStruct(agent).goalNum = 1;
    %agentStruct(agent).goalPath = thePath;
    %agentStruct(agent).pathLength = size(thePath)(2);
    %agentStruct(agent).inModel = true;
    %agentStruct(agent).maxVel = 4.5*300;
    fprintf(fileID,'START------------------ START\n');
  end

end