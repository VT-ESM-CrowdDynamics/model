agent_max = 5;
agents(1) = struct('x', 0);
update(1) = struct('x', 0);
%populate agent array
for agent_num = 1:agent_max
	%change assignment to pull from agentfactory
	agents(agent_num) = struct('x', 0);
endfor

t_max = 10;
for t = 1:t_max
	for agent_num = 1:agent_max
		%change to eval
		update(agent_num).x = agents(agent_num).x + rand(1,1);
	endfor
	for agent_num = 1:agent_max
		agents(agent_num).x = agents(agent_num).x + update(agent_num).x;
	endfor
	for agent_num = 1:agent_max
		disp(agents(agent_num).x);
	endfor
	disp('');
endfor


