function p = squareColorSwatches(varargin)
%squareColorSwatches Display a set of color squares with equal aspect ratio.
%   squareColorSwatches(colors) displays a set of colors on individual
%   squares arranged in a row. The input matrix, colors, is Px3 for a set
%   of P colors. The columns of P are the red, green, and blue components.
%   Each square is 1.0x1.0, and the squares are separated by a gap of 0.5.
%
%   Note that the axes aspect ratio is set to be [1 1 1] so that the color
%   swatches actually appear square. The axes is also set to be invisible
%   so that the axes background and tick labels do not appear.
%
%   squareColorSwatches(colors,gap), where gap is a nonnegative scalar,
%   specifies the gap between each square. By default, gap is 0.5.
%
%   squareColorSwatches(colors,sz), where sz is a two-element array,
%   arranges the color squares into a grid where sz(1) is the number of
%   rows and sz(2) is the number of columns. By default, sz is [1
%   size(colors,1)]. Colors are arranged in left-to-right, top-to-bottom
%   order.
%
%   Specify both the gap and the grid size using either
%   squareColorSwatches(colors,gap,sz) or
%   squareColorSwatches(colors,sz,gap).
%
%   squareColorSwatches(ax,___) displays the colors in the specified axes.
%
%   p = squareColorSwatches(___) returns a handle to the patch object
%   containing all the colors.

%   Copyright 2019-2020 The MathWorks, Inc.
%   License: https://github.com/mathworks/matlab-color-tools/blob/master/license.txt

pp = colorSwatches(varargin{:});
ax = ancestor(pp,'axes');
ax.DataAspectRatio = [1 1 1];
ax.Visible = 'off';

% Only return the patch object if the function was called with an output
% argument.
if nargout > 0
   p = pp;
end
