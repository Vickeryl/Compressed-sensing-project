# Compressed-sensing-project

Abstract: </br>
In this project, Compressed Sensing was used to recover a full image from a small number of sampled pixels. Specifically, Discrete Cosine Transform (DCT) was implemented in the linear transform, and two images with relatively small and large sizes (fishing_boat.bmp and lena.bmp) were served as test images to show how DCT performed in image recovery under different sample sizes. After image recovery, Median Filtering was applied to recovered images and evaluated how filtering might improve the image quality. 

In this project, technology of DCT, L1-norm regularization, cross validation (CV) as well as Median Filter were adopted to recover image. First break the image into blocks according to their sizes. Then apply DCT, cross validation and L1-norm regularization to each of the block to find the transformation matrix and coefficients vector with different sample sizes. Recover the image block by multiply transformation matrix and coefficient vector. After recovering all blocks, recombine them together to form the recovered image. After recovery, a Median Filter was applied to decrease the recovery error. In summary, the program performs poor on both images when sample size is 10, and the recovered image quality increases as the sample size increases. Median Filter has outstanding performance in small sample sizes and large image. 

imgRead.m</br>

Load test image: e.g. A = imgRead (‘lena.bmp')</br>

Input: input file name</br>

Output: H by W matrix</br>

A( i,j )): image pixel at i th row and j th column</br>

W : image width</br>

H : image height</br>
