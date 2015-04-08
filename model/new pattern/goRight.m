% lane formation
function rightForce = goRight(vel)
  
  rightForce = 0;
  if (norm(vel) != 0)
  rightForce = 500*[vel(2) -1*vel(1)]/norm(vel);
    end
end




%!test 
%!  rightForce = goRight([10,0]);
%!  assert(rightForce,[0,-50])

%!test 
%!  rightForce = goRight([0,10]);
%!  assert(rightForce,[50, 0])

%!test 
%!  rightForce = goRight([-10,0]);
%!  assert(rightForce,[0,50])

%!test 
%!  rightForce = goRight([0,-10]);
%!  assert(rightForce,[-50,0])

%!test 
%!  rightForce = goRight([10,10]);
%!  assert(rightForce,[50/sqrt(2),-50/sqrt(2)],0.0001)
