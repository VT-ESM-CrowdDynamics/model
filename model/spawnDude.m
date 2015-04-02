
function anAgent = spawnDude(thisSpawn)
	
	goalPath = cat(3,[2,3,5;2,4,6],[3,2,1;3,4,6],[4,2,1;4,3,5]);
	spawnArray = [[-4,-20,4,-20];[-14,0,-14,8];[14,0,14,8]]*300;
	
	thisPath = randi([1 2]);
	spawn = spawnArray(thisSpawn,:); % get the random spawn line
	thePath = goalPath(thisPath,:,thisSpawn); % get the random path 
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
	anAgent.pos = [positionX, positionY];
	anAgent.vel = [0, 0];
	%
	anAgent.goalNum = 1;
	anAgent.goalPath = thePath;
	anAgent.pathLength = size(thePath)(2);
	anAgent.inModel = true;
	anAgent.maxVel = 4.0*300 + randi([0 240]);
	%disp(anAgent)
end