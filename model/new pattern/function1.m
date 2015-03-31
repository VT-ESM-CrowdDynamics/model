function this_delta = function1(agent_num, frame)
    global buffer;

    tminus2 = buffer(tminus(2, frame), 3:end);
    tminus1 = buffer(tminus(1, frame), 3:end);
    last_delta = tminus2-tminus1;
    
    this_last_position = tminus1(agent_num:1+agent_num);
    this_last_delta = last_delta(agent_num:1+agent_num);
    this_delta = this_last_position+[agent_num,1];
end