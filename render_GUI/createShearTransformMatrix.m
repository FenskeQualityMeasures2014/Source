function shearTransformMatrix = createShearTransformMatrix(handles, shearRatio)

cameraPose = struct('CameraPosition', get(handles.axes1, 'CameraPosition'), 'CameraTarget', get(handles.axes1, 'CameraTarget'),...
    'CameraUpVector', get(handles.axes1, 'CameraUpVector'), 'CameraViewAngle', get(handles.axes1, 'CameraViewAngle'));
% translateToCamera = [1 0 0 cameraPose.CameraPosition(1); 0 1 0 cameraPose.CameraPosition(2); 0 0 1 cameraPose.CameraPosition(3); 0 0 0 1];
% translateRestore = [1 0 0 -cameraPose.CameraPosition(1); 0 1 0 -cameraPose.CameraPosition(2); 0 0 1 -cameraPose.CameraPosition(3); 0 0 0 1];
translateToCamera = [1 0 0 -cameraPose.CameraTarget(1); 0 1 0 -cameraPose.CameraTarget(2); 0 0 1 -cameraPose.CameraTarget(3); 0 0 0 1];
translateRestore = [1 0 0 cameraPose.CameraTarget(1); 0 1 0 cameraPose.CameraTarget(2); 0 0 1 cameraPose.CameraTarget(3); 0 0 0 1];
cameraViewAxis = cameraPose.CameraPosition - cameraPose.CameraTarget;
cameraViewAxis = cameraViewAxis/norm(cameraViewAxis);
cameraViewAxis2 = cameraViewAxis/norm([cameraViewAxis(1) cameraViewAxis(3)]);
rotateToCam1 = [cameraViewAxis2(3) 0 -cameraViewAxis2(1) 0; 0 1 0 0; cameraViewAxis2(1) 0 cameraViewAxis2(3) 0; 0 0 0 1]; 
rotatedUpVector = (rotateToCam1(1:3,1:3)*cameraPose.CameraUpVector')';
rotatedUpVector = rotatedUpVector/norm(rotatedUpVector);
rotateToCam2 = [1 0 0 0; 0 rotatedUpVector(2) rotatedUpVector(3) 0; 0 -rotatedUpVector(3) rotatedUpVector(2) 0; 0 0 0 1];
shearingMatrix = [1 0 shearRatio(1) 0; 0 1 shearRatio(2) 0; 0 0 1 0; 0 0 0 1];

shearTransformMatrix = translateRestore*rotateToCam1'*rotateToCam2'*shearingMatrix*rotateToCam2*rotateToCam1*translateToCamera;



