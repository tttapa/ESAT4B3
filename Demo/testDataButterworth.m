angles = [  0  0  0  0  0 22.37   33.66   0 ];
poles =  [  0  0  0  0  0 1       1       1 ];
radii =  [ -1 -1 -1 -1 -1 0.60505 0.83599 0.52057 ];

%{
angles = [ 0 45 30 0 0 0 0 0 0 ];
poles =  [ 1 1  0  0 0 0 0 0 0];
radii =  [ 1 1  0.5  0 0 0 0 0 0 ];
%}

angles = angles * pi / 180;

save('angles', 'angles');
save('radii', 'radii');
save('poles', 'poles');