%draw hogel rays
%get an idea of hogel to voxel representation
%1 dimensional case

renderArea = [-50 50 0 80];
hogels = -40:2:40;
degreeResolution = (-30:5:30)/180*pi;
figure
hold on
for i=1:length(hogels)
    for j=1:length(degreeResolution)
        rayx = [hogels(i) 100*sin(degreeResolution(j))];
        rayy = [0 100*cos(degreeResolution(j))];
        plot(rayx,rayy,'-');
    end
end
axis(renderArea);