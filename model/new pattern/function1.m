% example function
function this_delta = function1(agent_num)
  global buffer;

  % last last frame
  tminus2 = buffer(tminus(2), 3:end);
  % last frame
  tminus1 = buffer(tminus(1), 3:end);
  % last velocities
  last_delta = tminus2-tminus1;
  
  % last position for this agent
  this_last_position = tminus1(2*agent_num-1:2*agent_num);
  % last velocity for this agent
  this_last_delta = last_delta(2*agent_num-1:2*agent_num);
  % example trivial change
  this_delta = this_last_position+[agent_num,1];
end
