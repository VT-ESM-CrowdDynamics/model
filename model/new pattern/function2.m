function this_delta = function2(agent_num)
    global buffer;
    global frame;

    tminus2 = buffer(tminus(2, frame), 3:end);
    tminus1 = buffer(tminus(1, frame), 3:end);
    last_delta = tminus2-tminus1;
    
    this_last_position = tminus1(agent_num:1+agent_num);
    this_last_delta = last_delta(agent_num:1+agent_num);
    this_delta = this_last_position+[sqrt(this_last_position(1)), -2];
end