function this_delta = rate_limit(agent_num)
  global buffer;
  global velocity_upper_limits;

  this_delta = buffer(tminus(0), 2*agent_num + 1 : 2*agent_num + 2);

  % norm(this_delta)
  velocity = norm(this_delta);
  velmax = velocity_upper_limits(agent_num);

  % TODO: add active check

  %this movement exceeded the max allowed velocity
  if (velocity > velocity_upper_limits(agent_num))
    %disp("adjust vel")
    % get direction of movement
    direction = this_delta/norm(this_delta);
    % get max velocity in that direction
    max = velocity_upper_limits(agent_num)*direction;
    norm(max);
    % get difference from current
    difference = this_delta - max;
    % reverse
    this_delta = difference * -1;
    % return
  end
% this_delta
end