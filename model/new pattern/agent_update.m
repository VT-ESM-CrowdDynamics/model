function update = agent_update(theAgent)
  global configuration;
  global buffer;
  global frame;

  this_delta = zeros(1,2);
  for function_number = 1:size(configuration.functions)
    this_delta = this_delta + configuration.functions{function_number}(theAgent,frame);
  end

  update = this_delta;
end