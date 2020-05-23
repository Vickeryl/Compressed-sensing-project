
function imgShow(imgOut, fileName)
% show the image saved in a matrix
%
% INPUTS:
%   imgOut: a matrix containing the image to show

imgOut = uint8(imgOut);
imwrite(imgOut,fileName);

end
