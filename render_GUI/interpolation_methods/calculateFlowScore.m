function opticalFlowScore = calculateFlowScore(img1, img2, img3, img4)
%takes double [0-1] and converts to uint8
%assume 1 and 4 are a pair and 2 and 3 are a pair
%uses function optical_flow_sand


[u1 v1] = optic_flow_sand(uint8(255*(img1)), uint8(255*(img4)));
f = cat(3, u1, v1);
% figure;
% imshow(flowToColor(f));
[u2 v2] = optic_flow_sand(uint8(255*(img2)), uint8(255*(img3)));
f = cat(3, u2, v2);
% figure;
% imshow(flowToColor(f));
flowMag = [sqrt(u1.^2 + v1.^2) sqrt(u2.^2 + v2.^2)];
flowMag = flowMag(:);
flowMag = flowMag(flowMag~=0);
flowMag = sort(flowMag);
% figure;
% plot(log(flowMag));
opticalFlowScore = mean(flowMag(floor(.8*length(flowMag)):end)); %take mean of worst 20% that is non-zero