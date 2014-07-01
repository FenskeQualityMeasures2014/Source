function polygons = preview_OBJ(handles, shearRatio)

if (nargin < 2)
    shearRatio = [0 0];
end

popupmenu_handle = handles.popupmenu1;
axes_handle = handles.axes1;
polygons = 0;

%Get selected directory
directory = get(popupmenu_handle, 'String');
directory = directory{get(popupmenu_handle, 'Value')};
if (strcmp(directory,'Choose directory'))
    return;
end

%Check if .obj has been read, if not, read and save it
if ~(exist(['data_files\' directory '\' directory '.mat']))
    if ~(exist(['data_files\' directory '\' directory '.obj']))
        error('Missing .obj file');
    end
    OBJ = read_wobj(['data_files\' directory '\' directory '.obj']);
    save(['data_files\' directory '\' directory '.mat'], 'OBJ');
else
    load(['data_files\' directory '\' directory '.mat']);
end

%Put image on axes
polygons = disp_OBJ(OBJ,handles,directory, shearRatio);
