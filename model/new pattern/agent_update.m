function update = agent_update(theAgent)
  global configuration;
  global buffer;
  global frame;

  update = [0,0];
  this_delta = [0,0];

  % agent inactive - don't do forces
  if isnan(buffer(tminus(1, frame),:)(2+theAgent))
    return;
  end

  for function_number = 1:size(configuration.functions)
    this_delta = this_delta + configuration.functions{function_number}(theAgent,frame);
    
  end

  update = this_delta;
end