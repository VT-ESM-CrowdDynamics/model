
function anAgent = spawnDude(thisSpawn)
	
	goalPath = cat(3,[2,6,5;2,3,4],[3,6,5;3,2,1],[6,2,1;6,3,4]);
	spawnArray = [[-4165,-1460,-4165,978];[4217,978,4217,-1460];[-1280,6822,1280, 6822,]];
	
	thisPath = randi([1 2]);
	spawn = spawnArray(thisSpawn,:); % get the random spawn line
	thePath = goalPath(thisPath,:,thisSpawn); % get the random path 
	offset = 410;
	if (spawn(1) > spawn(3))
  	positionX = randi([(spawn(3)+offset) (spawn(1)-offset)]);
	elseif (spawn(1) < spawn(3))
  	positionX = randi([(spawn(1)+offset) (spawn(3)-offset)]);
  	else
  	positionX = spawn(1);
	end
	if (spawn(2) > spawn(4))
  	positionY = randi([(spawn(4)+offset) (spawn(2)-offset)]);
	elseif(spawn(4) > spawn(2))
  	positionY = randi([(spawn(2)+offset) (spawn(4)-offset)]);
  	else 
  	positionY = spawn(2);
	end
	anAgent.pos = [positionX, positionY];
	anAgent.vel = [0, 0];
	%
	anAgent.goalNum = 1;
	anAgent.goalPath = thePath;
	anAgent.pathLength = size(thePath)(2);
	anAgent.inModel = true;
	anAgent.maxVel = 4.0*300 + randi([0 240]);
	anAgent.goalForce = [0,0];
	%disp(anAgent)
end