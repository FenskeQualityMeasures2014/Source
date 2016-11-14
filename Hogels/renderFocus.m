function image = renderFocus(lightfield, focalLength)
image = zeros(380,380,4);
%Lightfield is assumed to be of size [9,9,380,380,3];
lensletAngles = zeros(5,1);
lensletFocalLength = 10; %pixels
for i = 1:5
    lensletAngles(i) = atan(abs(i-1)/lensletFocalLength); %Use Euclidian or Manhattan distance?
end

imageAngles = zeros(191,1);
imageCenter = [190 190];
for i=1:191
	imageAngles(i) = atan(abs(i-1)/focalLength);
end

imageAngleIndex = zeros(191,1);
imageInterp = zeros(191,1);
for i=1:189
    imageAngleIndex(i) = find(lensletAngles<=imageAngles(i),1,'last')-1;
end
tic;
for i=1:380
    for j=1:380
        quadrant = sign([i j] - imageCenter);
        image(i,j,:) = lightfield(5+quadrant(1)*imageAngleIndex(abs(i-imageCenter(1))+1),5+quadrant(2)*imageAngleIndex(abs(j-imageCenter(2))+1),i,j,:);
    end
end
t = toc;
image = image(:,:,1:3);
image = image/max(max(max(image)));
