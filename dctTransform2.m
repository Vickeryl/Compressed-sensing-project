function [T] = dctTransform(block, blkSize)
%
% INPUT:
%   block: block matrix
%   blkSize: block size
%
% OUTPUT:
%   T: transformation matrix
sz  = size(block);
P = sz(1);% number of pixels in horizontal direction
Q = sz(2);% number of pixels in vertical direction
T1 = [];

for x = 1:blkSize
    for y = 1:blkSize
        Tsub = [];
        for u = 1: P
            for v = 1:Q
                if u == 1
                    alfaU = sqrt(1/P);
                else
                    alfaU = sqrt(2/P);
                end

                if v == 1
                    betaU = sqrt(1/Q);
                else
                    betaU = sqrt(2/Q);
                end
                Tsub1 = alfaU * cos(pi*(2*x-1)*(u-1)/(2*P));
                Tsub2 = betaU * cos(pi*(2*y-1)*(v-1)/(2*Q));
                Tsub=[Tsub;Tsub1*Tsub2];
                size(Tsub);
            end
        end
        T1 = [T1;transpose(Tsub)];
    end
end
T = T1;
end 