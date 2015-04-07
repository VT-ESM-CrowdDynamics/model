function this_delta = goalForce(agent_num)

  global buffer;
  % disp(buffer);
  tminus2 = buffer(tminus(2), 3:end);
  tminus1 = buffer(tminus(1), 3:end);
  last_delta = tminus2-tminus1;
  
  this_last_position = tminus1(2*agent_num-1:2*agent_num);

  global current_goals;
  current_goal_num = current_goals(agent_num);
  % conditional skip for nonconforming function
  if isnan(this_last_position(1))
    this_delta = [0, 0; current_goal_num, 0];
    return
  end

  this_last_delta = last_delta(2*agent_num-1:2*agent_num);
  this_delta = this_last_position+[agent_num,1];

  global goal_paths;
  global velocity_upper_limits;
  global spawn_points;
  global configuration;

  path_num = goal_paths(agent_num);

  % array of goals [x1,y1,x2,y2] for each goal
  goalArray = [[-4,-20,4,-20];[-4,0,4,0];[-4,0,-4,8];[4,0,4,8];[-14,0,-14,8];[14,0,14,8]]*300; % lines across halls in T
  % array of possible paths from goal to goal, path# assigned randomly to each agent
  % for example in T intersection can have two path# each to one exit
  % in form goalPath(path#,:, spawnPt) gives an array like [2,5] to call configuration.goalArray(2) then configuration.goalArray(5)
  % as the agent moves from goal to goal
  goalPath = cat(3,[2,3,5;2,4,6],[3,2,1;3,4,6],[4,2,1;4,3,5]);
  path = goalPath(path_num, spawn_points(agent_num), :);
  current_goal = path(current_goal_num);
  G = goalArray(path(current_goal_num),:); %get the goal array
  forceFromGoal = goalForceHelper(this_last_position, [G(1),G(2)],[G(3),G(4)], velocity_upper_limits(agent_num)*configuration.dt, this_last_delta); % get goal force from function
  %fprintf(fileID,'Agent: %3.0f forceGoal1 -> x is %8.0f , y is %8.0f\n', agent, forceFromGoal);
  % while the goal force is zero and there are more goals in the path calc a new force with the next goal 
  % if the agent is close to a goal then make the next goal active
  % the agent could possibly satisfy multiple goals at once -> while loop
  while(norm(forceFromGoal) < 1 && current_goal_num < length(path))
    %disp("in the goal loop")
    % fprintf(fileID,'Agent:%2.0f forceGoalLOOP -> # %5.0f\n', agent, current_goal_num );
    current_goal_num = current_goal_num + 1;
    path = goalPath(path_num, spawn_points(agent_num),:);
    current_goal = path(current_goal_num);
    G = goalArray(path(current_goal_num),:); %get the goal array
    forceFromGoal = goalForceHelper(this_last_position, [G(1),G(2)],[G(3),G(4)], velocity_upper_limits(agent_num)*configuration.dt, this_last_delta); % get goal force from function
    % fprintf(fileID,'Agent:%2.0f G = %4.0f %4.0f %4.0f %4.0f\n', agent, G );
    forceFromGoal = goalForceHelper(this_last_position, [G(1),G(2)],[G(3),G(4)], velocity_upper_limits(agent_num)*configuration.dt, this_last_delta);
    % fprintf(fileID,'Agent:%2.0f forceGoalLOOP -> x %5.0f , y %5.0f\n , norm =%5.0f\n', agent, forceFromGoal, norm(forceFromGoal));
  end
  %disp("EE");
  if (norm(forceFromGoal) < 1)
    %disp("REMOVE")
    %remove agent they are at the final goal
    forceFromGoal = [NaN NaN];
    % fprintf(fileID,'Agent:%2.0f REMOVED!! -> x%5.0f , y%5.0f\n , norm =%5.0f\n', agent, forceFromGoal, norm(forceFromGoal));
  end
  this_delta = forceFromGoal;
  this_delta(2,1) = current_goal_num;


end
