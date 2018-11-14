function BW = segmentImage(I1)

[a,s,r]=size(I1);
 
I = imadjust(I1,stretchlim(I1),[]);

for j=1:a
    for i=1:s
        if j<a/4 || j>a*3/4
            if I(j,i,1)<50
            if I(j,i,2)<50
                if I(j,i,3)<50
                   I(j,i,1)=255;
                   I(j,i,2)=184;
                   I(j,i,3)=131;
                end
            end
            end
        elseif i<s/4 || i>s*3/4  
          if I(j,i,1)<50
            if I(j,i,2)<50
                if I(j,i,3)<50
                   I(j,i,1)=255;
                   I(j,i,2)=184;
                   I(j,i,3)=131;
                end
            end
        end
        end
    end
end


im = mean(I,3);
im = (im-min(im(:))) / (max(im(:))-min(im(:)));

level = multithresh(im);

im1 = im2bw(im,level);

SE = strel('disk',10);
bin =~imerode(~im1,SE);

bin =~imdilate(~bin,SE);
bin =~imdilate(~bin,SE);
bin =~imdilate(~bin,SE);
bin =~imdilate(~bin,SE);

BW = imcomplement(bin);
SE = strel('disk',20);
BW=imclose(BW,SE);
BW =imfill(BW,'holes');

cc = bwconncomp(BW, 4);
numb=cc.NumObjects;

S = regionprops(cc,'Centroid','Eccentricity','Area');
centroids = cat(1, S.Centroid);
areas=cat(1,S.Area);
circles=cat(1,S.Eccentricity);

for i=1:length(circles)
    if circles(i)<0.138 && areas(i)<250000
        BW(cc.PixelIdxList{i}) = 0;
    elseif circles(i)>0.94
        BW(cc.PixelIdxList{i}) = 0;
    end
end

cc3 = bwconncomp(BW, 4);
numb=cc3.NumObjects;
count=0;
if numb >1 
    for i=1:length(centroids)
        if centroids(i,1)>s/6 && centroids(i,1)<5*s/6 &&centroids(i,2)>a/6 && centroids(i,2)<5*a/6
            count=count+1;
        else
            BW(cc.PixelIdxList{i}) = 0;
        end
    end
end
cc1 = bwconncomp(BW, 4);
numb=cc1.NumObjects;
if numb>1
    SE = strel('disk',30);
    BW=imclose(BW,SE);
    BW=imfill(BW,'holes');
end

% cc2 = bwconncomp(BW, 4);
% numb=cc2.NumObjects;
% if numb>1
%     for i=1:length(areas)
%         if areas(i)<16600
%             BW(cc.PixelIdxList{i}) = 0;
%         end
%     end
%    
% end

cc2 = bwconncomp(BW, 4);
numb2=cc2.NumObjects;
S1 = regionprops(cc2,'Centroid','Eccentricity','Area');
areas2=cat(1,S1.Area);
if numb2>1
    for i=1:length(areas2)
        if areas2(i)<50000
            BW(cc2.PixelIdxList{i}) = 0;
        end
    end
   
end
% cc3 = bwconncomp(BW, 4);
% numb3=cc3.NumObjects;
% if numb3>1
%     BW = bwconvhull(BW);
% end
% Form masked image from input image and segmented image.
maskedImage = rgb2gray(I1);
maskedImage(~BW) = 0;
end
