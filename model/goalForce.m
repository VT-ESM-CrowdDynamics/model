% 1;

function forceFromGoal = goalForce(agentPosVector, goalPoint1, goalPoint2)
	%vector from all point to agent
	relative = agentPosVector - goalPoint1;
	%vector representing line segment
	lineVector = goalPoint2 - goalPoint1;
	%needed constants looked up formula online
	c1 = dot(relative, lineVector) ;
	c2 = dot(lineVector, lineVector);
	%length of line
	length = norm(lineVector);
	%dummy variables
	force = 0;
	forceFromGoal = [0,0];
	%prjectionMagnitude = 0;
	%if (length > 0)
	%projectionMagnitude = dot(relative, lineVector)/length^2;
	%end
	if (c1 <= 0)
		%beyond goalPoint1
		distence1 = norm(agentPosVector-goalPoint1); %distence from goalPoint to person
		if (distence1 > 100)	
			direction = (agentPosVector - goalPoint1)/distence1;
			force = -250; 
			forceFromGoal = force*direction;
		else
			%the person is at the goal!
			disp("AT GOALLLLL")
			
		end
	elseif (c2 <= c1)
		%beyond goalPoint2
		
		distence2 = norm(agentPosVector-goalPoint2); %distence from goalPoint to person
		if (distence2 > 100)	
			direction = (agentPosVector - goalPoint1)/distence2;
			force = -250; 
			forceFromGoal = force*direction;
		else
			%the person is at the goal!
			disp("AT GOALLLLL")
		end
	else 
		d = c1/c2;
		pb = goalPoint1 + d*lineVector; %point on line closest to person
		distence3 = norm(agentPosVector-pb) %distence from wall to person
		if (distence3 > 100)	
			direction = (agentPosVector - pb)/distence3;
			force = -250; 
			forceFromGoal = force*direction;
		else
			%at the goal
			disp("AT GOALLLLL")
		end
		
	end 
end

% test goalForce.m