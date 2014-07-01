function [deltaU, pad_offset, focusOffset] = getMinSpacing(handles,zNearFar)
%Minimum sampling rate for lightfields
%Light Field Sampling p. 27 eq. (3.13)
% dX = 2*pi/(dB)
% where dB = pi*f*(1/d_min - 1/d_max)
%assumes focus length is close to CameraTarget property
%and adjusts focus for integer padd_offset values

oversampleRatio = .02;

cameraPose = struct('CameraPosition', get(handles.axes1, 'CameraPosition'), 'CameraTarget', get(handles.axes1, 'CameraTarget'),...
    'CameraUpVector', get(handles.axes1, 'CameraUpVector'), 'CameraViewAngle', get(handles.axes1, 'CameraViewAngle'));
cameraViewAxis = cameraPose.CameraTarget - cameraPose.CameraPosition;

focusOffset = 0;

f = norm(cameraViewAxis) + focusOffset;
deltaS = tand(cameraPose.CameraViewAngle/2)*f/(480/2);
deltaU = 2*deltaS/(oversampleRatio*f*(1/zNearFar(1) - 1/zNearFar(2)));
pad_offset_fraction = deltaU/(2*f*tand(cameraPose.CameraViewAngle/2));

%Readjust f and deltaU for integer pad values
% pad_offset_fraction = round(160*pad_offset_fraction)/160; %160 is gcf of 640 and 480
% f = sqrt(2/(1/zNearFar(1) - 1/zNearFar(2))/(2*pad_offset_fraction*tand(cameraPose.CameraViewAngle/2)));
% deltaU = sqrt(2/(1/(2*pad_offset_fraction*tand(cameraPose.CameraViewAngle/2))*(1/zNearFar(1) - 1/zNearFar(2))));
% deltaU = 2/(f*(1/zNearFar(1) - 1/zNearFar(2)));
% pad_offset_fraction = deltaU/(2*f*tand(cameraPose.CameraViewAngle/2));
pad_offset(2) = (pad_offset_fraction*640); %Should be integers
pad_offset(1) = (pad_offset_fraction*480); %Round because of rounding errors
%only use y dim since the view angle is defined for this only...assume x
%dim is the same
