% 1;

function forceFromWall = wallForce(agentPosVector, agentVelVector, wallPoint1, wallPoint2)
	%vector from all point to agent
	relative = agentPosVector - wallPoint1;
	%vector representing line segment
	lineVector = wallPoint2 - wallPoint1;
	%needed constants looked up formula online
	c1 = dot(relative, lineVector) ;
	c2 = dot(lineVector, lineVector);
	%length of line
	length = norm(lineVector);
	%dummy variables
	force = 0;
	forceFromWall = [0,0];
	%prjectionMagnitude = 0;
	%if (length > 0)
	%projectionMagnitude = dot(relative, lineVector)/length^2;
	%end
	if (c1 <= 0)
		%beyond wallPoint1
		distence1 = norm(agentPosVector-wallPoint1); %distence from wallPoint to person
		if (distence1 != 0)	
			direction = (agentPosVector - wallPoint1)/distence1;
			if (distence1 <=1250)
			
				force = 1/2/((distence1-100)/1000)^3; %max around 300
			
				if (distence1 <= 250)
				% collision with wall
				force = 1000;
				end	
				 	
				forceFromWall = force*direction;
			end
		else
			%the person is in the wall, this is bad
			
		end
	elseif (c2 <= c1)
		%beyond wallPoint2
		
		distence2 = norm(agentPosVector-wallPoint2); %distence from wallPoint to person
		if (distence2 != 0)	
			direction = (agentPosVector - wallPoint2)/distence2;
			if (distence2 <=1250)
			
				force = 1/2/((distence2-100)/1000)^3; %max around 300
			
				if (distence2 <= 250)
				% collision with wall
				force = 1000;
				end	
				 	
				forceFromWall = force*direction;
			end
		else
			%the person is in the wall, this is bad
			
		end
	else 
		%closer
		%the distence matters here
		d = c1/c2;
		pb = wallPoint1 + d*lineVector; %point on line closest to person
		distence = norm(agentPosVector-pb); %distence from wall to person
		if (distence != 0)	
			direction = (agentPosVector - pb)/distence;
			if (distence <=1250)
			
				force = 1/((distence-100)/1000)^3; %max around 300
			
				if (distence <= 250)
				% collision with wall
				force = 1000;
				end	
				 	
				forceFromWall = force*direction;
			end
		else
			%the person is in the wall, this is bad
			
		end
		
	end 
end



%%!test % simple wall test
%%!   disp(wallForce([-500,0],[0,0],[0,0],[0,5000]))
%%! 
%
%%!test % simple wall test
%%!   disp(wallForce([500,0],[0,0],[0,-5000],[0,5000]))
%%! 
%
%%!test % simple wall test
%%!   disp(wallForce([0,500],[0,0],[-5000,0],[5000,0]))
%%!  

% test wallForce.m