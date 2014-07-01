function image1 = Lumigraph_variable_depth(lightfield,zNearFar,focus_LF,focus,deltaU,depths)

image1 = zeros(480,640,3);
z1 = 2/(1/zNearFar(1) + 1/zNearFar(2));
su_ratio = deltaU/(focus_LF/focus);
CameraViewAngle = 75;
h_B = deltaU/2*tand(CameraViewAngle/2);
pix_shift = (480)*h_B/(focus_LF-h_B);
%z_depth = warp3dImage(cat(3,squeeze(depths(6,6,:,:)),squeeze(depths(6,6,:,:)),squeeze(depths(6,6,:,:))),squeeze(depths(6,6,:,:)),[pix_shift pix_shift],focus_LF,zNearFar);
z_depth = depths;
for rgb = 1:3
    for i = 1:480
        for j = 1:640
            %z = (depths(6,6,i,j)+depths(6,7,i,j)+depths(7,6,i,j)+depths(7,7,i,j))/4;
            z = z_depth(i,j,1);
            if (z==0) z=z1; end
            if (z>=zNearFar(2)-.01)
                image1(i,j,rgb) = 0;
            else
                image1(i,j,rgb) = QuadDepthCorrect(6.5,6.5,i,j,z,lightfield,rgb,focus_LF,su_ratio,deltaU,focus_LF);
            end
        end
    end
end