function extra_init()
  % goals init
  global configuration;
  global current_goals = zeros(1, configuration.agents);
  global goal_paths = zeros(1, configuration.agents);
  global velocity_upper_limits = zeros(1, configuration.agents);

end