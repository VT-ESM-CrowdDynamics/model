function new_position = rate_limit(agent_num)
  global buffer;
  global velocity_upper_limits;
  global configuration;

  tminus2 = buffer(tminus(2), 3:end);
  tminus1 = buffer(tminus(1), 3:end);
  last_delta = tminus2-tminus1;
  
  this_last_position = tminus1(2*agent_num-1:2*agent_num);
  this_last_delta = last_delta(2*agent_num-1:2*agent_num);
  disp(strcat('DEBUG: rate_limit this_last_delta:', num2str(this_last_delta)));

  %get this agents force
  Force = buffer(tminus(0), 2*agent_num + 1 : 2*agent_num + 2);
  disp(strcat('DEBUG: rate_limit Force:', num2str(Force)));


  % calculate the new position att + vt + x
  new_position = this_last_position + Force * (configuration.dt) ^ 2 + this_last_delta * configuration.dt;
  
  %disp(this_last_delta)
  %this movement exceeded the max allowed velocity
  if (norm(this_last_delta) > velocity_upper_limits(agent_num))
    %disp("adjust vel")
    % get direction of movement
    direction = this_last_delta/norm(this_last_delta);
    % set velocity in that direction to be max velocity
    this_last_delta = velocity_upper_limits(agent_num)*direction;
    disp(strcat('DEBUG: rate_limit new this_last_delta:', num2str(this_last_delta)));
    % calculate new position with max velocity
    new_positionw = this_last_position + this_last_delta*configuration.dt;
    %disp(previousPos);
    %disp(this_last_position);
  end

end