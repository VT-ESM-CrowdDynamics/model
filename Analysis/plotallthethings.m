%Flux Data
figure(1);
plot(Fluxarray(:,1,3))
title('Positive Flux (iii)');xlabel('Time (s)');ylabel('People');
figure(2);
plot(Fluxarray(:,1,2))
title('Positive Flux (ii)');xlabel('Time (s)');ylabel('People');
figure(3);
plot(Fluxarray(:,1,1))
title('Positive Flux (i)');xlabel('Time (s)');ylabel('People');
figure(4);
plot(Fluxarray(:,2,3))
title('Negative Flux (iii)');xlabel('Time (s)');ylabel('People');
figure(5);
plot(Fluxarray(:,2,2))
title('Negative Flux (ii)');xlabel('Time (s)');ylabel('People');
figure(6);
plot(Fluxarray(:,2,1))
title('Negative Flux (i)');xlabel('Time (s)');ylabel('People');
figure(7);
plot(Fluxarray(:,3,3))
title('Gross Flux (iii)');xlabel('Time (s)');ylabel('People');
figure(8);
plot(Fluxarray(:,3,2))
title('Gross Flux (ii)');xlabel('Time (s)');ylabel('People');
figure(9);
plot(Fluxarray(:,3,1))
title('Gross Flux (i)');xlabel('Time (s)');ylabel('People');


%Velocity
figure(10)
plot(velocity)
title('Velocity of All Data Points');xlabel('Time (s/2)');ylabel('Velocity (m/s)');
figure(11)
plot(velocity*2.237)
title('Velocity of All Data Points');xlabel('Time (s/2)');ylabel('Velocity (mi/h)');


%Crowd Density
figure(12)
plot(crowddensity)
title('Crowd Density');xlabel('Time (1/60 s)');ylabel('People per square meter');

%Average Interpersonal Distance
figure(13)
plot(IPdistance)
title('Average Interpersonal Distance');xlabel('Time (1/60 s)');ylabel('Distance (m)');
figure(14)
plot(IPstd)
title('Average Interpersonal Distance Standard Deviation');
xlabel('Time (1/60 s)');ylabel('Standard Deviation');








