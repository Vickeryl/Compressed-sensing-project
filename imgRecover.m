
function imgOut = imgRecover(imgIn, blkSize, numSample)
% Recover the input image from a small size samples
%
% INPUT:
%   imgIn: input image
%   blkSize: block size
%   numSample: how many samples in each block
%
% OUTPUT:
%   imgOut: recovered image
    imgIn=imgRead('fishing_boat.bmp');
    sz = size(imgIn);% size of image
    blks = 8%blks is block size
    block_Count = sz ./blks; %number of blocks on each side
    X = mat2cell(imgIn, blks * ones(block_Count(1),1), blks *ones(block_Count(2),1));% break image into blocks with size blks*blks

    s = 50;% s is number of sample points
    counter = 1
    
    
    for c = 1:block_Count(1)
        for r = 1:block_Count(2)%for each block in the image
            fprintf('count: %d', counter)
            xb = cell2mat(X(c,r)); %each block 
            T = dctTransform2(xb, blks); 
            xbF = reshape(xb.',[],1); %flatten each block into column vector
%             disp('flattened block size');
%             size(xbF);
            
            %randomly sample S pixels from each block
            msize = numel(xb);
            randices = sort(randsample(1:msize,s,false));%randomly pick indices of C in order
            sampleC = xbF(randices); %randomly sample each block with random indices
            Ttrim = T(randices, :); %retained corresponding rows from the transformation matrix
%             sizeT = size(Ttrim);
            counter = counter+1;
            
            %Cross-validation with random subsets
            M = 20;
%             L = [0.000001 0.00001 0.0001 0.001 0.01 0.1 1 10 100 1000 10000 100000 1000000];% lambda has range from 1e-6 to 1e+6
            
            L = [0.000001 0.00001 0.0001]
            m = floor(s/6);
            errorList = [];

% 
            for j = 1:length(L)
                l = L(j)
                mselist = [];
                for i = 1:M
                    randSubInd = sort(randsample(1: size(sampleC,1), m));
                    Ctest = sampleC(randSubInd, :);
                    Ctrain = sampleC;
                    Ctrain(randSubInd, :) = [];
                    Ttest = Ttrim(randSubInd, :);
                    Ttrain = Ttrim;
                    Ttrain(randSubInd, :) = [];

                    %find coefficient vector alfa B
                    [B,FitInfo] = lasso(Ttrain,Ctrain, 'lambda', l);
                    intercept = FitInfo.Intercept(1);
                    
                    size(B);
                    Cpredicted = Ttest* B + intercept;
%                     Cpredicted = Ttest*B;
                    mseList(i)  = immse(Cpredicted, Ctest);

                end
                errorList(j) = mean(mseList);
            end 
            [minVa,minLoc] = min(errorList(1:end));
            lambda = L(minLoc)
            [alpha,fitInfo] = lasso(Ttrim, sampleC, 'lambda', lambda);
            intercept1 = fitInfo.Intercept(1)
            %predict missing  pixels using the model parameters found via LASSO
            recoVec = T * alpha + intercept1;
            recBlo = reshape(recoVec, blks, blks);
            recImgB{c,r} = transpose(recBlo);% assign reconstructed block into cell
%             recImgB = recBlo;
            
        end
    end

    imgOut = cell2mat(recImgB);%convert reconstructed cells into matrix
    imgShow(imgOut);
    title({'Unfiltered reconstructed fishing boat', 'sample size = 50'});
    fileName1 = 'uf fishing boat s50.bmp';
    imgSave(imgOut, fileName1);%save image without filter
   
    filImageOut=medfilt2(imgOut,[3 3]);%apply median filter on reconstructed image
    imgShow(filImageOut);
    title({'Filtered reconstructed fishing boat', 'sample size = 50'});   
    fileName2 = 'f fishing boat s50.bmp';
    imgSave(filImageOut, fileName2);%save image with filer
    recov_error = mean(mean((imgOut-imgIn).^2));% recovery error without filter
    recov_error_filtered = mean(mean((filImageOut-imgIn).^2));%recovery error with filter
    disp(recov_error)
    disp(recov_error_filtered)

end