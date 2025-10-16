clc;
close all;
clearvars;
% Generate a small sample image and display it (enlarged).
grayImage = randi(255, [30, 40])
imshow(grayImage, [], 'InitialMagnification', 800);
hold on;
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Find the min value.
[minValue, minLinearIndex] = min(grayImage(:));
% Find out the rows and columns where it occurs.
% There may be more than 1!!!
[minRows, minCols] = find(grayImage == minValue);
% For every min pixel found, plot a box around it.
lineWidth = 2;
for p = 1 : length(minRows)
  % Get the coordinates at the EDGES of the pixels.
  y1 = minRows(p)-0.5;
  y2 = minRows(p) + 0.5;
  x1 = minCols(p) - 0.5;
  x2 = minCols(p) + 0.5;
  % Get the vertices of a closed box around this point.
  % This will be 5 coordinates if the box is to be closed.
  boxX = [x1 x2 x2 x1 x1];
  boxY = [y1 y1 y2 y2 y1];
  % Now finally plot the box around this pixel.
  plot(boxX, boxY, 'r-', 'LineWidth', lineWidth);
end

    % Get the coordinates at the EDGES of the pixels.
%       y1 = maxRows(p)-0.5;
%       y2 = maxRows(p) + 0.5;
%       x1 = maxCols(p) - 0.5;
%       x2 = maxCols(p) + 0.5;
%       % Get the vertices of a closed box around this point.
%       % This will be 5 coordinates if the box is to be closed.
%       boxX = [x1 x2 x2 x1 x1];
%       boxY = [y1 y1 y2 y2 y1];
%       plot(boxX, boxY, 'k-', 'LineWidth', lineWidth);