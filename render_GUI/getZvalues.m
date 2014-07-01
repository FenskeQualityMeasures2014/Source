function zNearFar = getZvalues(handles)

%Get selected directory
directory = get(handles.popupmenu1, 'String');
directory = directory{get(handles.popupmenu1, 'Value')};
if (strcmp(directory,'Choose directory'))
    return;
end

%Get OBJ -- Already decoded by preview OBJ
load(['data_files\' directory '\' directory '.mat']);

cameraPose = struct('CameraPosition', get(handles.axes1, 'CameraPosition'), 'CameraTarget', get(handles.axes1, 'CameraTarget'),...
    'CameraUpVector', get(handles.axes1, 'CameraUpVector'), 'CameraViewAngle', get(handles.axes1, 'CameraViewAngle'));
cameraViewAxis = cameraPose.CameraPosition - cameraPose.CameraTarget;
cameraViewAxis = -cameraViewAxis./norm(cameraViewAxis);

zDist = zeros(1,size(OBJ.vertices,1));
for i = 1:size(OBJ.vertices,1)
    zDist(i) = cameraViewAxis * (OBJ.vertices(i,:) - cameraPose.CameraPosition)';
end

zNearFar(1) = min(zDist);
zNearFar(2) = max(zDist);
