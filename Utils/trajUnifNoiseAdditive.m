function trajData = trajUnifNoiseAdditive( trajData, sigma )

% Adds additive gaussian noise of relative amplitude sigma to trajectories
trajData = trajData+sigma*(randn(size(trajData)));

return