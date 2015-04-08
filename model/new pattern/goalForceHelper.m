function forceFromGoal = goalForceHelper(agentPosVector, goalPoint1, goalPoint2, maxDistance, agentVelVector)
	% if debug
 %    disp(strcat('DEBUG: current_goal_num:', num2str(current_goal_num)));
	% end
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
	force = -4000;
	forceFromGoal = [0,0];
	%prjectionMagnitude = 0;
	%if (length > 0)
	%projectionMagnitude = dot(relative, lineVector)/length^2;
	%end
	if (c1 <= 0)
		%beyond goalPoint1
		distance1 = norm(agentPosVector-goalPoint1); %distance from goalPoint to person
		if (distance1 > maxDistance+50)	
			direction = (agentPosVector - goalPoint1)/distance1;
			%force = -500; 
			forceFromGoal = force*direction;
		else
			%the person is at the goal!
			%disp("AT GOALLLLL")

			
		end
	elseif (c2 <= c1)
		%beyond goalPoint2
		
		distance2 = norm(agentPosVector-goalPoint2); %distance from goalPoint to person
		if (distance2 > maxDistance+50)	
			direction = (agentPosVector - goalPoint1)/distance2;
			%force = -500; 
			forceFromGoal = force*direction;
		else
			%the person is at the goal!

			%disp("AT GOALLLLL")

		end
	else 
		d = c1/c2;
		pb = goalPoint1 + d*lineVector; %point on line closest to person
		distance3 = norm(agentPosVector-pb); %distance from wall to person

		if (distance3 > maxDistance+50)	

			direction = (agentPosVector - pb)/distance3;
			%force = -500; 
			forceFromGoal = force*direction;
			% we only want to apply a 'move to the right side of a hallway force' 
		% if the person is still headed towords the goal 
		% hopefully this will prevent someone from going down a hallway on their right
		% without it being a goal
			if (norm(pb-goalPoint1) > 500 && norm(pb-goalPoint2) > 500)
			forceFromGoal = forceFromGoal + goRight(-1*direction);
			end
		else
			%at the goal

			%disp("AT GOALLLLL")

		end
		
		
	end 
end
