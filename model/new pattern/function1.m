function this_delta = function1(agent_num)
    global buffer;
    tminus2 = buffer(tminus(2, frame), 3:end);
    tminus1 = buffer(tminus(1, frame), 3:end);
    last_delta = tminus2-tminus1;
    this_last_position = tminus1(theAgent:1+theAgent);
    this_last_delta = last_delta(theAgent:1+theAgent);
    this_delta = this_last_position+[theAgent,1];
end