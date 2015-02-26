##octave --eval 'test engine.m' 2>&1 | grep -v /usr/share/octave/3.8.1
% trick to allow multiple functions
1;

addpath('../lib/jsonlab');
addpath('../lib/catstruct');

global configuration;

function init ( config )
  global configuration;
  defaults = loadjson('defaults.json');
  % if passed a filename, parse as JSON and use for config
  if(ischar(config) && exist(config, 'file'))
    config = loadjson(config)
  end
  configuration = catstruct(defaults, config);
  % disp(configuration);
end

function tracks = start
global configuration;
% tracks = [[1, 0]];
tracks = [zeros(1, 2+(configuration.agents*2))];
tracks(1,1) = 1 ;% frame 1 is time 0
agentStruct = struct;
%setup needs to place agents in model and give properties etc
for agent = 1:configuration.agents
	%currently arbitrary setup
	agentStruct(agent).pos = [0,0];
	agentStruct(agent).vel = [0,0];
	tracks(1, agent*2+1) = agentStruct(agent).pos(1);
	tracks(1, agent*2+2) = agentStruct(agent).pos(2);
end

for frame = 2 : configuration.frames
% if configuration.frames == 2
%disp("poop");

    % disp(configuration);

    %build current_frame to have frame # and time
    current_frame = [tracks(frame-1, 1) + 1, tracks(frame-1, 2) + configuration.dt];
    % for over each agent in the 
    MainForceVector = zeros(1,configuration.agents*2);
    for agent = 1:configuration.agents
    	%disp(agent)
    	currentAgentFileSpot = agent*2;
      if(configuration.goal==1)
     	  Xpos = tracks(frame-1, agent +2) + 100;
	        Ypos = tracks(frame-1, agent +3) + 100;
     	   current_frame = [current_frame Xpos Ypos];
       elseif(configuration.goal == 2)
   	        if (frame == 2)
           	
	       	InitialXvelocity = 50;
	           	InitialYvelocity = 50;
      	     	Xforce = 0;
           		Yforce = 0; 
           	
              	 	Xpos = tracks(frame-1, currentAgentFileSpot +1) + Xforce*(configuration.dt)^2 + InitialXvelocity;
        		 Ypos = tracks(frame-1, currentAgentFileSpot +2) + Yforce*(configuration.dt)^2 + InitialYvelocity;
        	 	current_frame = [current_frame Xpos Ypos];
	           else
           		% velocity is current position - last position / dt
           		Xvel = (tracks(frame-1, currentAgentFileSpot+1)-tracks(frame-2, currentAgentFileSpot + 1))/configuration.dt;
           		Yvel = (tracks(frame-1, currentAgentFileSpot+2)-tracks(frame-2, currentAgentFileSpot+2))/configuration.dt;
           		Xforce = 5;
           		Yforce = 5; 
      	  	Xpos = tracks(frame-1, currentAgentFileSpot +1) + Xforce*(configuration.dt)^2 + Xvel;
       	 	Ypos = tracks(frame-1, currentAgentFileSpot +2) + Yforce*(configuration.dt)^2 + Yvel;
     	   	current_frame = [current_frame Xpos Ypos];
        	   end
        	   % NEW goal using vectors and actual force function for calculations
        elseif (configuration.goal == 3)
        	% initialise a force vector for the method return
           	ForceVector = [0,0];
           	% itterate over each other agent
           	for otherAgent = 1:configuration.agents
           		if (otherAgent != agent)
           			% calculate the force vector, and add it to the current running force total
           			ForceVector = ForceVector + ForceFromAnotherAgent(agentStruct(agent).pos, agentStruct(agent).vel, agentStruct(otherAgent).pos, agentStruct(otherAgent).vel);
           		end
           	end
           	% iterate over each wall
           	for wall = 1:configuration.walls
           		ForceVector 
           		
           	end
           	%iterate over each goal
           	for goal = 1:configuration.goals
           		ForceVector
           		
           	end
           	MainForceVector(agent*2-1) = ForceVector(1);
           	MainForceVector(agent*2) = ForceVector(2);
           	
           	% dummy variable for velocity below
           	%previousPos = agentStruct(agent).pos
           	% calculate the new position att + vt + x
                    	%agentStruct(agent).pos = agentStruct(agent).pos + ForceVector*(configuration.dt)^2 + agentStruct(agent).vel*configuration.dt
                    	% calculate new velocity (current pos - previous pos) / t
                    	%agentStruct(agent).vel = (agentStruct(agent).pos - previousPos)/configuration.dt
                    	% get position for file
                    	%Xpos = agentStruct(agent).pos(1);
                    	%Ypos = agentStruct(agent).pos(2);
                    	%update file
     	%current_frame = [current_frame Xpos Ypos];
        else
       	  current_frame = [current_frame 0 0];
      end
    end
    if (configuration.goal == 3)
    	for theAgent = 1:configuration.agents
    		%disp(theAgent)
    		
    		Force = [MainForceVector(theAgent*2-1), MainForceVector(theAgent*2)];
    	% dummy variable for velocity below
           		previousPos = agentStruct(theAgent).pos;
           		% calculate the new position att + vt + x
                    		agentStruct(theAgent).pos = agentStruct(theAgent).pos + Force*(configuration.dt)^2 + agentStruct(theAgent).vel*configuration.dt;
                    		% calculate new velocity (current pos - previous pos) / t
                    		agentStruct(theAgent).vel = (agentStruct(theAgent).pos - previousPos)/configuration.dt;
                    		% get position for file
                    		Xpos = agentStruct(theAgent).pos(1);
                    		Ypos = agentStruct(theAgent).pos(2);
                    		%update file
     		current_frame = [current_frame Xpos Ypos];
    	% update the array 
    	end
    end
    tracks = [tracks; current_frame];
    
  end
  % disp(tracks);
end

% do we want equal and opposite forces?
% line of sight, sweep out an arc would be ideal...
function ForceVector = ForceFromAnotherAgent(AgentPosVector, AgentVelVector, OtherPosVector, VelOther)
	% lets assume distances are calculated in mm
	% a person is about... 500mm wide (so radius is 250mm)
	%disp('in force function')
	% maybe this function shouldnt be called for 2 people in a group, and they should have their own function, each agent could hold a list of other agents they are 'grouped' with or something
	distence = norm(AgentPosVector-OtherPosVector);
	%distence = sqrt((AgentPosVector(1)-OtherPosVector(1))^2 + (AgentPosVector(2)-OtherPosVector(2))^2)
	relativePosOfOther = OtherPosVector - AgentPosVector;
	% relativePosOfOther = [OtherPosVector(1)-AgentPosVector(1) , OtherPosVector(2)-AgentPosVector(2)]
	% we may want to specify persons size in the config files? (ie let user change it)
	% maybe each agent has a diff number here in if statement for size 
	angleOfSight = 1;
	if (norm(AgentVelVector) > 0)
		% calculate angle between vel and other's pos, assume agent is looking in direction of velocity 
		% line of sight
	angleOfSignt = dot(AgentVelVector,OtherPosVector)/norm(AgentVelVector)/norm(OtherPosVector);
	end
	
	if (distence <= 500)
		%disp('colision')
		%people would bump, special handeling? 
		%force should be "infinite" bc agents cannot move closer 
		% should we output # of collisions for user data?
		if (distence < 200 ) % if two points are exactly on top it breaks... this should never happen but
			ForceVector = [(rand - 0.5)*1000, (rand - 0.5)*1000];
		else 
			ForceVector = relativePosOfOther*1000/distence;
		end
	
	% probably want another elseif here to check line of sight (theta = acos( v1.v2) / |v1||v2|).  we still want to check if people hit bc line of sight doesnt effect that.  but if people dont see each other these forces dont matter... unless talking group stuff... 
	% should groups be handled in this function or another function designed spcifically for groups?
	elseif (angleOfSight > 0) % person has 180 view
		if (distence <= 1500)
			%disp('repel')
			% the repulsion zone
			% if forming a group this distence is too large probably 
			% this is less then a meter shoulder to shoulder
			force = 1/((distence-300)/1200)^3; %min 1, mid 5, max 212
			ForceVector = force*relativePosOfOther*-1/distence;
			
			% something should be done here with velocity so people moving towords each other 'prepare' to dodge, and someone can 'pass' another person if v in same direction etc
			% determine probability of wanting to 'dodge' right or left (culture) (should user set this?)
		elseif (distence <= 10000)
			%disp('flock')
			%flocking
			%potentially form group? 
			if (norm(VelOther) > 0.1)
				
				ForceVector = 20*VelOther/norm(VelOther);
			else 
				ForceVector = [0,0];
			end
		else
			ForceVector = [0,0];
		end
		% adjust for line of sight
		ForceVector = ForceVector*angleOfSight;
	end
	
	
	
end

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
		distence1 = norm(agentPosVector-wallPoint1) %distence from wallPoint to person
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
		
		distence2 = norm(agentPosVector-wallPoint2) %distence from wallPoint to person
		if (distence2 != 0)	
			direction = (agentPosVector - wallPoint2)/distence2;
			if (distence2 <=1250)
			
				force = 1/2/((distence-100)/1000)^3; %max around 300
			
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
		pb = wallPoint1 + d*lineVector %point on line closest to person
		distence = norm(agentPosVector-pb) %distence from wall to person
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


function forceFromGoal = goalForce(agentPosVector, goalLocation, goalRadius)
	distence = norm(agentPosVector - goalLocation);
	forceFromGoal = [0,0];
	if (distence > goalRadius)
		direction = (agentPosVector - goalLocation)/distence;
		forceFromGoal = direction*200;
	end  
	
end
% disp (catstruct(struct("a", "a", "b", "b"), struct("a", 1)))

%!test % simple wall test
%!   disp(wallForce([-500,0],[0,0],[0,0],[0,5000]))
%! 

%!test % simple wall test
%!   disp(wallForce([500,0],[0,0],[0,-5000],[0,5000]))
%! 

%!test % simple wall test
%!   disp(wallForce([0,500],[0,0],[-5000,0],[5000,0]))
%!  

%!test % increment with some force and velocity
%!  init ( struct("dt", 1, "frames", 4, "agents", 2, "goal", 3) )
%!  disp(start)

%!test % tests the force function for simple case flocking zone
%! assert( ForceFromAnotherAgent([0,0],[0,0],[3000,0],[1,0]) ,[20,0], 0.00001 )

%!test % tests the force function for repulsion zone, make 3,4,5 triangle for ez math
%! assert( ForceFromAnotherAgent([1100,1800],[0,0],[500,1000],[0,0]) ,[1/((1000-300)/1200)^3*3/5,1/((1000-300)/1200)^3*4/5], 0.00001 )

%!test % tests the force function for repulsion zone, make 3,4,5 triangle for ez math
%! assert( ForceFromAnotherAgent([500,1000],[0,0],[1100,1800],[0,0]) ,[-1/((1000-300)/1200)^3*3/5,-1/((1000-300)/1200)^3*4/5], 0.00001 )

%!test % tests the force function for simple case repulsion zone
%! assert( ForceFromAnotherAgent([0,0],[0,0],[1500,0],[0,0]) ,[-1/((1500-300)/1200)^3,0], 0.00001 )

%!test % tests the force function for simple case repulsion zone
%! assert( ForceFromAnotherAgent([0,0],[0,0],[1000,0],[0,0]) , [-1/((1000-300)/1200)^3,0] , 0.00001)

%!test % tests the force function for simple case repulsion zone
%! assert( ForceFromAnotherAgent([0,0],[0,0],[501,0],[0,0]) , [-1/((501-300)/1200)^3,0] , 0.00001)

%!test % previous test, "move to three frames", but from JSON config
%!  init ( 'testfiles/config_read_test.json' )
%!  assert ( start, [1 0; 2 2; 3 4] )

%!test % increment with some force and velocity
%!  init ( struct("dt", 1, "frames", 4, "agents", 2, "goal", 2) )
%!  assert ( start, [1 0 0 0 0 0; 2 1 50 50 50 50; 3 2 105 105 105 105; 4 3 165 165 165 165]  )

%!test % increment with some force and velocity
%!  init ( struct("dt", 1, "frames", 4, "agents", 2, "goal", 2) )
%!  assert ( start, [1 0 0 0 0 0; 2 1 50 50 50 50; 3 2 105 105 105 105; 4 3 165 165 165 165]  )

%!test % tests 2 agents with changing position
%!  init ( struct("dt", 2, "frames", 3, "agents", 2, "goal", 1) )
%!  assert ( start, [1 0 0 0 0 0; 2 2 100 100 100 100; 3 4 200 200 200 200] )

%!test % tests 2 agents
%!  init ( struct("dt", 2, "frames", 3, "agents", 2, "goal",0) )
%!  assert ( start, [1 0 0 0 0 0; 2 2 0 0 0 0; 3 4 0 0 0 0] )

%!test
%!  init ( struct("dt", 2, "frames", 3, "agents", 1, "goal",0) )
%!  assert ( start, [1 0 0 0; 2 2 0 0; 3 4 0 0] )

%!test % add agents
%!  init ( struct("dt", 2, "frames", 3, "agents", 1, "goal",0) )
%!  assert ( start, [1 0 0 0; 2 2 0 0; 3 4 0 0] )

%!test % move to three frames
%!  init ( struct("dt", 2, "frames", 3, "goal",0) )
%!  assert ( start, [1 0; 2 2; 3 4] )

%!test % basic output, changing dt
%!  init ( struct("dt", 2, "frames", 2, "goal",0) )
%!  assert ( start, [1 0; 2 2] )

%!test % for basic, two-frame, no-agent output
%!  init ( struct("dt", 1, "frames", 2, "goal",0) )
%!  assert ( start, [1 0; 2 1] )

%!test % for basic, one-frame, no-agent output
%!  init ( struct("dt", 1, "frames", 1) )
%!  assert ( start, [1, 0] )

%!test % that init doesn't throw an error
%!  init ( struct("dt", 1, "frames", 1) )

test engine.m
