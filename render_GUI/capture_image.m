function image1 = capture_image(handles)
image1 = frame2im(getframe(handles.figure1));
axes_pos = get(handles.axes1,'Position');
figure_pos = get(handles.figure1, 'Position');
%image1 = image1(67:546,31:670,:);
image1 = image1((2+figure_pos(4)-(axes_pos(2)+axes_pos(4))):(figure_pos(4)-axes_pos(2)+1),axes_pos(1):(axes_pos(1)+axes_pos(3)-1),:);