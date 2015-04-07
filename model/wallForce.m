% 1;

function forceFromWall = wallForce(agentPosVector, agentVelVector, wallPoint1, wallPoint2, maxDistence)
	
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
	forceMultiplyer = 20; %arbitrary const to balance
	forceFromWall = [0,0];
	%prjectionMagnitude = 0;
	%if (length > 0)
	%projectionMagnitude = dot(relative, lineVector)/length^2;
	%end
	if (c1 <= 0)
		%beyond wallPoint1
		distence = norm(agentPosVector-wallPoint1); %distence from wallPoint to person
		if (distence != 0)	
			direction = (agentPosVector - wallPoint1)/distence;
			if (distence <= 500)
				force = (1480 + 1000/((distence+200)/700)^2);
			elseif (distence <=1200)
			
				force = 40/((distence-100)/1000)^3; 
				 		
			end
			forceFromWall = force*direction*forceMultiplyer;
		else
			%the person is in the wall, this is bad
			
		end
	elseif (c2 <= c1)
		%beyond wallPoint2
		
		distence = norm(agentPosVector-wallPoint2); %distence from wallPoint to person
		if (distence != 0)	
			direction = (agentPosVector - wallPoint2)/distence;
			if (distence <= 500)
				force = (1480 + 1000/((distence+200)/700)^2);
			elseif (distence <=1200)
			
				force = 40/((distence-100)/1000)^3; 
				 		
			end
			forceFromWall = force*direction*forceMultiplyer;
		else
			%the person is in the wall, this is bad
			
		end
	else 
		%disp("in wall")
		%wallPoint1
		%wallPoint2
		%agentPosVector
		%closer
		%the distence matters here
		d = c1/c2;
		pb = wallPoint1 + d*lineVector; %point on line closest to person
		distence = norm(agentPosVector-pb); %distence from wall to person
		if (distence != 0)	
			%disp("distence isnt zero")
			direction = (agentPosVector - pb)/distence;
			if (distence <= 500)
				%disp("aa")
				force = 2*(1480 + 1000/((distence+200)/700)^2);
			elseif (distence <=1200)
				%disp("bb")
				force = 80/((distence-100)/1000)^3; %max around 900
				 		
			end
			forceFromWall = force*direction*forceMultiplyer;
		else
			%the person is in the wall, this is bad
			
		end
		
	end 
end



%!test % simple wall test
%!   disp(wallForce([-500,0],[0,0],[0,0],[0,5000]))
%! 

%!test % simple wall test
%!   disp(wallForce([500,0],[0,0],[0,-5000],[0,5000]))
%! 

%!test % simple wall test
%!   disp(wallForce([0,500],[0,0],[-5000,0],[5000,0]))
%!  

% test wallForce.m