% 1;

function forceFromGoal = goalForce(agentPosVector, goalLocation, goalRadius)
	distence = norm(agentPosVector - goalLocation);
	forceFromGoal = [0,0];
	if (distence > goalRadius)
		direction = (agentPosVector - goalLocation)/distence;
		forceFromGoal = direction*200;
	end  
	
end

% test goalForce.m