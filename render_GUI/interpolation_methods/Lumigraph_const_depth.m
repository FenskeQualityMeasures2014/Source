function image1 = Lumigraph_const_depth(lightfield,zNearFar,focus_LF,focus,deltaU)

image1 = zeros(480,640,3);
z = 2/(1/zNearFar(1) + 1/zNearFar(2));
z = zNearFar(1);
su_ratio = deltaU/(focus_LF/focus);
for rgb = 1:3
    for i = 1:480
        for j = 1:640
            image1(i,j,rgb) = QuadDepthCorrect(6.5,6.5,i,j,z,lightfield,rgb,focus,su_ratio,deltaU,focus_LF);
        end
    end
end