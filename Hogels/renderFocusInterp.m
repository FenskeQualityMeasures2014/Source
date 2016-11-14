function image = renderFocusInterp(lightfield, focalLength)
image = zeros(380,380,4);
%Lightfield is assumed to be of size [9,9,380,380,3];
lensletAngles = zeros(5,1);
lensletFocalLength = 10; %pixels
for i = 1:5
    lensletAngles(i) = atan(abs(i-1)/lensletFocalLength); %Use Euclidian or Manhattan distance?
end

imageAngles = zeros(192,1);
imageCenter = [190 190];
for i=1:192
	imageAngles(i) = atan(abs(i-1)/focalLength);
end

imageAngleIndex = zeros(192,1);
imageInterp = zeros(193,1);
for i=1:192
    imageAngleIndex(i) = find(lensletAngles<=imageAngles(i),1,'last');
    if imageAngleIndex(i) == 5, imageInterp(i) = 5; else
    imageInterp(i) = imageAngleIndex(i) + (imageAngles(i) - lensletAngles(imageAngleIndex(i)))/(lensletAngles(imageAngleIndex(i)+1)-lensletAngles(imageAngleIndex(i))); end
end
imageAngleIndex = imageAngleIndex - 1;

tic;
for i=1:380
    disp(i)
    for j=1:380
        quadrant = sign([i j] - imageCenter);
        if quadrant(1)==0, quadrant(1) = 1; end
        if quadrant(2)==0, quadrant(2) = 1; end
        angleLoc = [5+quadrant(1)*imageAngleIndex(abs(i-imageCenter(1))+1),5+quadrant(2)*imageAngleIndex(abs(j-imageCenter(2))+1)];
        %image = lightfield(5+quadrant(1)*imageAngleIndex(abs(i-imageCenter(1))+1),5+quadrant(2)*imageAngleIndex(abs(j-imageCenter(2))+1),i,j,:);
        if (angleLoc(1)==1||angleLoc(2)==1||angleLoc(1)==9||angleLoc(2)==9)
            image(i,j,:) = lightfield(5+quadrant(1)*imageAngleIndex(abs(i-imageCenter(1))+1),5+quadrant(2)*imageAngleIndex(abs(j-imageCenter(2))+1),i,j,:);
        else
        Z = lightfield([angleLoc(1),angleLoc(1)+quadrant(1)],[angleLoc(2),angleLoc(2)+quadrant(2)],i,j,:);
        Z = squeeze(Z);
        image(i,j,1) = interp2([angleLoc(1),angleLoc(1)+quadrant(1)],[angleLoc(2),angleLoc(2)+quadrant(2)],Z(:,:,1),5+quadrant(1)*(imageInterp(abs(190-i)+1)-1),5+quadrant(2)*(imageInterp(abs(190-j)+1)-1));
        image(i,j,2) = interp2([angleLoc(1),angleLoc(1)+quadrant(1)],[angleLoc(2),angleLoc(2)+quadrant(2)],Z(:,:,2),5+quadrant(1)*(imageInterp(abs(190-i)+1)-1),5+quadrant(2)*(imageInterp(abs(190-j)+1)-1));
        image(i,j,3) = interp2([angleLoc(1),angleLoc(1)+quadrant(1)],[angleLoc(2),angleLoc(2)+quadrant(2)],Z(:,:,3),5+quadrant(1)*(imageInterp(abs(190-i)+1)-1),5+quadrant(2)*(imageInterp(abs(190-j)+1)-1));
        %image(i,j,:) = [interp2([angleLoc(1),angleLoc(1)+quadrant(1)],[angleLoc(2),angleLoc(2)+quadrant(2)],Z(:,:,1),5+quadrant(1)*(imageInterp(abs(190-i)+1)-1),5+quadrant(2)*(imageInterp(abs(190-j)+1)-1)) interp2([angleLoc(1),angleLoc(1)+quadrant(1)],[angleLoc(2),angleLoc(2)+quadrant(2)],Z(:,:,2),5+quadrant(1)*(imageInterp(abs(190-i)+1)-1),5+quadrant(2)*(imageInterp(abs(190-j)+1)-1)) interp2([angleLoc(1),angleLoc(1)+quadrant(1)],[angleLoc(2),angleLoc(2)+quadrant(2)],Z(:,:,3),5+quadrant(1)*(imageInterp(abs(190-i)+1)-1),5+quadrant(2)*(imageInterp(abs(190-j)+1)-1))];
        end
    end
end
t = toc;
image = image(:,:,1:3);
image = image/max(max(max(image)));