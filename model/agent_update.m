% agent_update runs all the conforming functions (must be side-effect-less)
% defined in the configuraion.functions cell array
function this_delta = agent_update(theAgent)
  global configuration;
  global buffer;

  this_delta = [0,0];

  % agent inactive - don't do forces
  if isnan(buffer(tminus(1),:)(1+2*theAgent))
    return;
  end

  % function loop
  for function_number = 1:length(configuration.functions)
    % disp(function_number)
    % disp(configuration.functions{function_number})
    this_delta = this_delta + configuration.functions{function_number}(theAgent);
  end
end
