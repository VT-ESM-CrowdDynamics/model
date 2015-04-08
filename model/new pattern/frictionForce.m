function this_delta = frictionForce(agent_num)
  global buffer;

  tminus2 = buffer(tminus(2), 3:end);
  tminus1 = buffer(tminus(1), 3:end);
  last_delta = tminus2-tminus1;
  
  % this_last_position = tminus1(2*agent_num-1:2*agent_num);
  this_last_delta = last_delta(2*agent_num-1:2*agent_num);
  % this_delta = this_last_position+[agent_num,1];

  % originally: friction = -2*vel;
  this_delta = this_last_delta * -2;
end
