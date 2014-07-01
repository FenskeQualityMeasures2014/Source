function polygons = disp_OBJ(OBJ, handles, directory, shearRatio)
if (nargin < 4), shearRatio = [0 0]; end
shearTransformMatrix = createShearTransformMatrix(handles, shearRatio);
no_texture = get(handles.checkbox1, 'Value');
axes_handle = handles.axes1;
axes(axes_handle);
polygons = 0;
materials_list = {};
texture_list = {};
has_texture = zeros(1,length(OBJ.material));
Ka_list = {}; %to use in case no texture
transparency_list = zeros(1,length(OBJ.material));
for i = 1:length(OBJ.material)
    if (strcmp(OBJ.material(i).type,'newmtl'))
        materials_list{length(materials_list)+1} = OBJ.material(i).data;
    end
    if (strcmp(OBJ.material(i).type,'map_Kd'))
        texture_list{length(materials_list)} = OBJ.material(i).data;
        has_texture(length(materials_list)) = 1;
    end
    if (strcmp(OBJ.material(i).type,'Ka'))
        Ka_list{length(materials_list)} = OBJ.material(i).data;
    end
    if (strcmp(OBJ.material(i).type, 'd'))
        transparency_list(length(materials_list)) = OBJ.material(i).data;
    end
end

for i = 1:length(OBJ.objects)
    object_tag = OBJ.objects(i).type;
    if (strcmp(object_tag,'usemtl'))
        material = OBJ.objects(i).data;
        for j = 1:length(materials_list)
            if (strcmp(materials_list(j),'default'))
                material_index = j;
            end
            if (strcmp(materials_list(j),material))
                material_index = j;
                break;
            end
        end
    end
    
    if (strcmp(object_tag,'f'))
        if (has_texture(material_index)&&~no_texture)
            %patcht
            image_filename = ['data_files/' directory '/' texture_list{material_index}];
            image_texture = imread(image_filename);
            image_texture = image_texture(:,:,1:3);
            Options.EdgeColor = 'none';
            Options.Clipping = 'on';
            vt = [OBJ.vertices_texture(:,2) OBJ.vertices_texture(:,1)];
            vt = vt - floor(vt);
            verts = (shearTransformMatrix*[OBJ.vertices ones(size(OBJ.vertices, 1), 1)]')';
            %patcht(OBJ.objects(i).data.vertices,OBJ.vertices,OBJ.objects(i).data.texture,vt,imrotate(image_texture,180),Options);
            patcht(OBJ.objects(i).data.vertices,verts(:,1:3),OBJ.objects(i).data.texture,vt,imrotate(image_texture,180),Options);
            polygons = polygons + size(OBJ.objects(i).data.vertices,1);
        else
            %patch
            C = Ka_list{material_index};
            verts = (shearTransformMatrix*[OBJ.vertices ones(size(OBJ.vertices, 1), 1)]')';
            verts = verts(:,1:3);
            faces = OBJ.objects(i).data.vertices;
            h = patch('Faces', faces, 'Vertices', verts, 'FaceColor', C);
            set(h,'Edgecolor','none');
            set(h, 'FaceAlpha', transparency_list(material_index));
            polygons = polygons + size(OBJ.objects(i).data.vertices,1);
        end
    end
        
end
axis equal;
lighting phong;