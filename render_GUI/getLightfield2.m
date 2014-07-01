function getLightfield2(handles, deltaU, pad_offset, focusOffset)

if (~strcmp(get(handles.figure1,'Renderer'),'zbuffer'))
    error('Renderer must be set to "zbuffer"');
end
deltaV = deltaU;
lightfield_size = [9 9];
lightfield = zeros([lightfield_size 480 640 3]);
novel_view = [6.5 6.5];
depths = zeros([lightfield_size 480 640]);

Filename = uiputfile('lightfields\.mat');
if (Filename == 0)
    return;
end

cameraPose = struct('CameraPosition', get(handles.axes1, 'CameraPosition'), 'CameraTarget', get(handles.axes1, 'CameraTarget'),...
    'CameraUpVector', get(handles.axes1, 'CameraUpVector'), 'CameraViewAngle', get(handles.axes1, 'CameraViewAngle'));
deltaV_vector = deltaV*(cameraPose.CameraUpVector./norm(cameraPose.CameraUpVector));
cameraViewAxis = cameraPose.CameraPosition - cameraPose.CameraTarget;
focus_LF = norm(cameraViewAxis)+ focusOffset;
deltaU_vector = cross(cameraViewAxis,deltaV_vector);
deltaU_vector = deltaU*(deltaU_vector./norm(deltaU_vector));

offset1 = round(lightfield_size(1)/2);
offset2 = round(lightfield_size(2)/2);
for i = 1:lightfield_size(1)
    for j = 1:lightfield_size(2)
        %perform shear transformation
        cla(handles.axes1);
        set(handles.axes1, 'CameraPosition', cameraPose.CameraPosition); %must fix pos to do shear correctly
        set(handles.axes1, 'CameraTarget', cameraPose.CameraTarget);
        shearRatio(1) = (i-offset1)*deltaU/focus_LF;
        shearRatio(2) = -(j-offset2)*deltaU/focus_LF;
        preview_OBJ(handles, shearRatio);
        %get lightfield
        position = cameraPose.CameraPosition - (i-offset1)*deltaU_vector - (j-offset2)*deltaV_vector;
        target = cameraPose.CameraTarget - (i-offset1)*deltaU_vector - (j-offset2)*deltaV_vector;
        %set(handles.axes1, 'CameraPosition', position);
        %set(handles.axes1, 'CameraTarget', target);
        image1 = capture_image(handles);
        trim_x = pad_offset(1)*(i-offset2);
        trim_y = pad_offset(1)*(j-offset1);
        T = [1,0,0; 0,1,0; -trim_x, -trim_y, 1];
        T = maketform('affine',T);
        %image1 = imtransform(image1, T,'bilinear','XData',[1 size(image1,2)],'YData',[1 size(image1,1)]); %Use imwarp for newer versions of MATLAB
        lightfield(i,j,:,:,:) = image1;
        %get depth
        [depthMap cameraCoord] = getDepthMap(handles, shearRatio);
        %depth1 = imtransform(cameraCoord(:,:,3), T,'bilinear','XData',[1 size(cameraCoord(:,:,3),2)],'YData',[1 size(cameraCoord(:,:,3),1)]);
        depths(i,j,:,:) = cameraCoord(:,:,3);
    end
end
%get novel 
cla(handles.axes1);
set(handles.axes1, 'CameraPosition', cameraPose.CameraPosition); %must fix pos to do shear correctly
set(handles.axes1, 'CameraTarget', cameraPose.CameraTarget);
shearRatio(1) = (novel_view(1)-offset1)*deltaU/focus_LF;
shearRatio(2) = -(novel_view(2)-offset2)*deltaU/focus_LF;
preview_OBJ(handles, shearRatio);
position = cameraPose.CameraPosition - (novel_view(1)-offset1)*deltaU_vector - (novel_view(2)-offset2)*deltaV_vector;
target = cameraPose.CameraTarget - (novel_view(1)-offset1)*deltaU_vector - (novel_view(2)-offset2)*deltaV_vector;
%set(handles.axes1, 'CameraPosition', position);
%set(handles.axes1, 'CameraTarget', target);
image1 = capture_image(handles);
trim_x = pad_offset(1)*(novel_view(1)-offset2);
trim_y = pad_offset(1)*(novel_view(2)-offset1);
T = [1,0,0; 0,1,0; -trim_x, -trim_y, 1];
T = maketform('affine',T);
%image1 = imtransform(image1, T,'bilinear','XData',[1 size(image1,2)],'YData',[1 size(image1,1)]);
image1 = double(image1)/255;
novel_view = image1;
[depthMap cameraCoord] = getDepthMap(handles, shearRatio);
%depth1 = imtransform(cameraCoord(:,:,3), T,'bilinear','XData',[1 size(cameraCoord(:,:,3),2)],'YData',[1 size(cameraCoord(:,:,3),1)]);      
novel_view_depth = cameraCoord(:,:,3);
set(handles.axes1, 'CameraPosition', cameraPose.CameraPosition);
set(handles.axes1, 'CameraTarget', cameraPose.CameraTarget);
lightfield = double(lightfield)/255;
focus = 480/2/tand(cameraPose.CameraViewAngle/2);
zNearFar = getZvalues(handles);
save(['lightfields\' Filename],'lightfield','depths','novel_view','deltaU','focus','zNearFar','focus_LF','novel_view_depth');