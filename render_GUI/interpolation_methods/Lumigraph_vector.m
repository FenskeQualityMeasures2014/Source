function [image1 opticalFlowScore] = Lumigraph_vector(lightfield,zNearFar,focus_LF,focus,deltaU,depths)

tic;
image1 = zeros(480,640,3);
%assuming h_uv and h_st are normalized to 1 in this implementation
s = 6.5; %desired view
t = 6.5;
u = 1:480;
v = 1:640;
u_floor1 = zeros(480,640);
u_ceil1  = zeros(480,640);
v_floor1 = zeros(480,640);
v_ceil1  = zeros(480,640);
u_floor2 = zeros(480,640);
u_ceil2  = zeros(480,640);
v_floor2 = zeros(480,640);
v_ceil2  = zeros(480,640);
depths(depths==0) = .00001;
su_ratio = deltaU/(focus_LF/focus);
depth_adj = (focus_LF-depths)./depths*su_ratio;
t01 = toc;
for i = 1:480
    u_floor1(i,:) = u(i) - (s-floor(s))*depth_adj(i,:);
    u_floor2(i,:) = u(i) + (s-floor(s))*depth_adj(i,:);
    u_ceil1(i,:)  = u(i) - (s- ceil(s))*depth_adj(i,:);
    u_ceil2(i,:)  = u(i) + (s- ceil(s))*depth_adj(i,:);
end
t02 = toc;
for j = 1:640
    v_floor1(:,j) = v(j) - (s-floor(s))*depth_adj(:,j);
    v_floor2(:,j) = v(j) + (s-floor(s))*depth_adj(:,j);
    v_ceil1(:,j)  = v(j) - (s- ceil(s))*depth_adj(:,j);
    v_ceil2(:,j)  = v(j) + (s- ceil(s))*depth_adj(:,j);
end
t3 = toc;
u_floor1 = max(1, min(480, u_floor1));
u_ceil1  = max(1, min(480, u_ceil1 ));
v_floor1 = max(1, min(640, v_floor1));
v_ceil1  = max(1, min(640, v_ceil1 ));
u_floor2 = max(1, min(480, u_floor2));
u_ceil2  = max(1, min(480, u_ceil2 ));
v_floor2 = max(1, min(640, v_floor2));
v_ceil2  = max(1, min(640, v_ceil2 ));
t4 = toc;
u_floor1(depths>=zNearFar(2)-.01) = 1;
u_floor2(depths>=zNearFar(2)-.01) = 1;
v_floor1(depths>=zNearFar(2)-.01) = 1;
v_floor2(depths>=zNearFar(2)-.01) = 1;
u_ceil1( depths>=zNearFar(2)-.01) = 1;
u_ceil2( depths>=zNearFar(2)-.01) = 1;
v_ceil1( depths>=zNearFar(2)-.01) = 1;
v_ceil2( depths>=zNearFar(2)-.01) = 1;
t5 = toc;
w1  = (1-abs(floor(u_floor1) - u_floor1)).*(1-abs(floor(v_floor1) - v_floor1));
w2  = (1-abs(floor(u_floor1) - u_floor1)).*(1-abs(ceil(v_floor1)  - v_floor1));
w3  = (1-abs(ceil(u_floor1)  - u_floor1)).*(1-abs(floor(v_floor1) - v_floor1));
w4  = (1-abs(ceil(u_floor1)  - u_floor1)).*(1-abs(ceil(v_floor1)  - v_floor1));
w5  = (1-abs(floor(u_floor2) - u_floor2)).*(1-abs(floor(v_ceil2 ) - v_ceil2 ));
w6  = (1-abs(floor(u_floor2) - u_floor2)).*(1-abs(ceil(v_ceil2 )  - v_ceil2 ));
w7  = (1-abs(ceil(u_floor2)  - u_floor2)).*(1-abs(floor(v_ceil2 ) - v_ceil2 ));
w8  = (1-abs(ceil(u_floor2)  - u_floor2)).*(1-abs(ceil(v_ceil2 )  - v_ceil2 ));
w9  = (1-abs(floor(u_ceil2 ) - u_ceil2 )).*(1-abs(floor(v_floor2) - v_floor2));
w10 = (1-abs(floor(u_ceil2 ) - u_ceil2 )).*(1-abs(ceil(v_floor2)  - v_floor2));
w11 = (1-abs(ceil(u_ceil2 )  - u_ceil2 )).*(1-abs(floor(v_floor2) - v_floor2));
w12 = (1-abs(ceil(u_ceil2 )  - u_ceil2 )).*(1-abs(ceil(v_floor2)  - v_floor2));
w13 = (1-abs(floor(u_ceil1 ) - u_ceil1 )).*(1-abs(floor(v_ceil1 ) - v_ceil1 ));
w14 = (1-abs(floor(u_ceil1 ) - u_ceil1 )).*(1-abs(ceil(v_ceil1 )  - v_ceil1 ));
w15 = (1-abs(ceil(u_ceil1 )  - u_ceil1 )).*(1-abs(floor(v_ceil1 ) - v_ceil1 ));
w16 = (1-abs(ceil(u_ceil1 )  - u_ceil1 )).*(1-abs(ceil(v_ceil1 )  - v_ceil1 ));
t6 = toc;
w1  = w1(:);
w2  = w2(:);
w3  = w3(:);
w4  = w4(:);
w5  = w5(:);
w6  = w6(:);
w7  = w7(:);
w8  = w8(:);
w9  = w9(:);
w10 = w10(:);
w11 = w11(:);
w12 = w12(:);
w13 = w13(:);
w14 = w14(:);
w15 = w15(:);
w16 = w16(:);
t7 = toc;
s1 = floor(s);
s2 =  ceil(s);
t1 = floor(t);
t2 =  ceil(t);
w_1 = (1-abs(s - floor(s)))*(1-abs(t - floor(t)));
w_2 = (1-abs(s - floor(s)))*(1-abs(t -  ceil(t)));
w_3 = (1-abs(s -  ceil(s)))*(1-abs(t - floor(t)));
w_4 = (1-abs(s -  ceil(s)))*(1-abs(t -  ceil(t)));
t8 = toc;
ind1  = s1 + 9*(t1-1) + 9*9*(floor(u_floor1)-1) + 9*9*480*(floor(v_floor1)-1);
ind2  = s1 + 9*(t1-1) + 9*9*(floor(u_floor1)-1) +  9*9*480*(ceil(v_floor1)-1);
ind3  = s1 + 9*(t1-1) +  9*9*(ceil(u_floor1)-1) + 9*9*480*(floor(v_floor1)-1);
ind4  = s1 + 9*(t1-1) +  9*9*(ceil(u_floor1)-1) +  9*9*480*(ceil(v_floor1)-1);
ind5  = s1 + 9*(t2-1) + 9*9*(floor(u_floor2)-1) + 9*9*480*(floor(v_ceil2 )-1);
ind6  = s1 + 9*(t2-1) + 9*9*(floor(u_floor2)-1) +  9*9*480*(ceil(v_ceil2 )-1);
ind7  = s1 + 9*(t2-1) +  9*9*(ceil(u_floor2)-1) + 9*9*480*(floor(v_ceil2 )-1);
ind8  = s1 + 9*(t2-1) +  9*9*(ceil(u_floor2)-1) +  9*9*480*(ceil(v_ceil2 )-1);
ind9  = s2 + 9*(t1-1) + 9*9*(floor(u_ceil2 )-1) + 9*9*480*(floor(v_floor2)-1);
ind10 = s2 + 9*(t1-1) + 9*9*(floor(u_ceil2 )-1) +  9*9*480*(ceil(v_floor2)-1);
ind11 = s2 + 9*(t1-1) +  9*9*(ceil(u_ceil2 )-1) + 9*9*480*(floor(v_floor2)-1);
ind12 = s2 + 9*(t1-1) +  9*9*(ceil(u_ceil2 )-1) +  9*9*480*(ceil(v_floor2)-1);
ind13 = s2 + 9*(t2-1) + 9*9*(floor(u_ceil1 )-1) + 9*9*480*(floor(v_ceil1 )-1);
ind14 = s2 + 9*(t2-1) + 9*9*(floor(u_ceil1 )-1) +  9*9*480*(ceil(v_ceil1 )-1);
ind15 = s2 + 9*(t2-1) +  9*9*(ceil(u_ceil1 )-1) + 9*9*480*(floor(v_ceil1 )-1);
ind16 = s2 + 9*(t2-1) +  9*9*(ceil(u_ceil1 )-1) +  9*9*480*(ceil(v_ceil1 )-1);
t9 = toc;
ind1  = ind1(:);
ind2  = ind2(:);
ind3  = ind3(:);
ind4  = ind4(:);
ind5  = ind5(:);
ind6  = ind6(:);
ind7  = ind7(:);
ind8  = ind8(:);
ind9  = ind9(:);
ind10 = ind10(:);
ind11 = ind11(:);
ind12 = ind12(:);
ind13 = ind13(:);
ind14 = ind14(:);
ind15 = ind15(:);
ind16 = ind16(:);
t10 = toc;
%extra code to grab for optical flow comparisons
v1 = zeros(480,640,3);
v2 = zeros(480,640,3);
v3 = zeros(480,640,3);
v4 = zeros(480,640,3);
%end extra code
for rgb = 1:3
    rgb_lin_ind = (rgb-1)*9*9*480*640;
    temp1 = zeros(480*640,1);
    temp2 = zeros(480*640,1);
    temp1 = temp1 + w1 .*lightfield(ind1 + rgb_lin_ind);
    temp1 = temp1 + w2 .*lightfield(ind2 + rgb_lin_ind);
    temp1 = temp1 + w3 .*lightfield(ind3 + rgb_lin_ind);
    temp1 = temp1 + w4 .*lightfield(ind4 + rgb_lin_ind);
    temp2 = temp2 + w_1.*temp1;
    v1(:,:,rgb) = vec2mat(temp1,480)';
    temp1 = zeros(480*640,1);
    temp1 = temp1 + w5 .*lightfield(ind5 + rgb_lin_ind);
    temp1 = temp1 + w6 .*lightfield(ind6 + rgb_lin_ind);
    temp1 = temp1 + w7 .*lightfield(ind7 + rgb_lin_ind);
    temp1 = temp1 + w8 .*lightfield(ind8 + rgb_lin_ind);
    temp2 = temp2 + w_2.*temp1;
    v2(:,:,rgb) = vec2mat(temp1,480)';
    temp1 = zeros(480*640,1);
    temp1 = temp1 + w9 .*lightfield(ind9 + rgb_lin_ind);
    temp1 = temp1 + w10.*lightfield(ind10 + rgb_lin_ind);
    temp1 = temp1 + w11.*lightfield(ind11 + rgb_lin_ind);
    temp1 = temp1 + w12.*lightfield(ind12 + rgb_lin_ind);
    temp2 = temp2 + w_3.*temp1;
    v3(:,:,rgb) = vec2mat(temp1,480)';
    temp1 = zeros(480*640,1);
    temp1 = temp1 + w13.*lightfield(ind13 + rgb_lin_ind);
    temp1 = temp1 + w14.*lightfield(ind14 + rgb_lin_ind);
    temp1 = temp1 + w15.*lightfield(ind15 + rgb_lin_ind);
    temp1 = temp1 + w16.*lightfield(ind16 + rgb_lin_ind);
    temp2 = temp2 + w_4.*temp1;
    v4(:,:,rgb) = vec2mat(temp1,480)';
    image1(:,:,rgb) = vec2mat(temp2,480)';
end
t11 = toc;
opticalFlowScore = calculateFlowScore(v1,v2,v3,v4);
%opticalFlowScore = 0;
% figure;
% plot([t01 t02 t3 t4 t5 t6 t7 t8 t9 t10 t11]);
    