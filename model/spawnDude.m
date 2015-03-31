
function anAgent = spawnDude(thisSpawn)
	
	goalPath = cat(3,[2,3,5;2,4,6],[3,2,1;3,4,6],[4,2,1;4,3,5]);
	spawnArray = [[-4,-20,4,-20];[-14,0,-14,8];[14,0,14,8]]*300;
	
	thisPath = randi([1 2]);
	spawn = spawnArray(thisSpawn,:); % get the random spawn line
	thePath = goalPath(thisPath,:,thisSpawn); % get the random path 
	if (spawn(1) > spawn(3))
  	positionX = randi([spawn(3) spawn(1)]);
	else
  	positionX = randi([spawn(1) spawn(3)]);
	end
	if (spawn(2) > spawn(4))
  	positionY = randi([spawn(4) spawn(2)]);
	else
  	positionY = randi([spawn(2) spawn(4)]);
	end
	anAgent.pos = [positionX, positionY];
	anAgent.vel = [0, 0];
	%
	anAgent.goalNum = 1;
	anAgent.goalPath = thePath;
	anAgent.pathLength = size(thePath)(2);
	anAgent.inModel = true;
	anAgent.maxVel = 4.5*300;
	%disp(anAgent)
end