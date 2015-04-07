function this_delta = agent_update(theAgent)
  global configuration;
  global buffer;

  this_delta = [0,0];

  % agent inactive - don't do forces
  if isnan(buffer(tminus(1),:)(1+2*theAgent))
    return;
  end

  for function_number = 1:size(configuration.functions)
    this_delta = this_delta + configuration.functions{function_number}(theAgent);
  end
end
