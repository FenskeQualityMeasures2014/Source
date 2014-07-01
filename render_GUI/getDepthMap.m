function [depthMap, cameraCoord] = getDepthMap(handles, shearRatio)

if (nargin < 2)
    shearRatio = [0 0];
end
shearTransformMatrix = createShearTransformMatrix(handles, shearRatio);

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
cameraUp = -cameraPose.CameraUpVector./norm(cameraPose.CameraUpVector);
cameraRight = cross(cameraUp, cameraViewAxis);

faces = [];
for i = 1:length(OBJ.objects)
    object_tag = OBJ.objects(i).type;
    if (strcmp(object_tag,'f'))        
            faces = [faces; OBJ.objects(i).data.vertices];
    end
end

FM = faces;
VM = (shearTransformMatrix*[OBJ.vertices ones(size(OBJ.vertices, 1), 1)]')';

width = 640;
height = 480;
TcV = [-cameraPose.CameraPosition(1) -cameraPose.CameraPosition(2) -cameraPose.CameraPosition(3)]'; %Vector to Camera in World Coordinates
RcM = [cameraRight; cameraUp; cameraViewAxis]; %Rotational Camera Matrix
fcV = ones(2,1)*(height/2/tand(cameraPose.CameraViewAngle/2)); 
    %Focal length vector, distance in world coordinates at which translation is one pixel
ccV = [(width - 1)/2; (height -1)/2]; %Principal Point vector, center of image
TcV = RcM*TcV;
CamParamS = struct('TcV',TcV,'RcM',RcM,'fcV',fcV,'ccV',ccV);

ImageSizeV = [480 640];
zNearFarV = getZvalues(handles);
zNearFarV = [zNearFarV(1)-.01,zNearFarV(2)+.01];
zoomFactor = 1;
invertedDepth = 1;

[DepthImageM, CameraCoordT] = RenderDepthMesh(FM, VM, CamParamS, ImageSizeV, ...
						zNearFarV, zoomFactor, invertedDepth);
                    
depthMap = DepthImageM;
cameraCoord = CameraCoordT;