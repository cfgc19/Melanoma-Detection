clc
clear all
filePattern2 = fullfile(pwd,'Imagens_Mascaradas_764', '*.jpg');
pngFiles2 = dir(filePattern2);
cores=[];
for l=1:length(pngFiles2)
  baseFileName = pngFiles2(l).name;
  fullFileName = fullfile(pwd,'Imagens_Mascaradas_764', baseFileName);
  image= imread(fullFileName);
  al=featurescores(image);
  cores=vertcat(cores,al);
end


%%
binaria=[];
nomes=[];

myFolder ='Mascaras_764';
filePattern = fullfile(pwd,myFolder, '*.jpg');
pngFiles = dir(filePattern);
for k = 1:length(pngFiles)
  baseFileName = pngFiles(k).name;
  fullFileName = fullfile(pwd,myFolder, baseFileName);
  image= imread(fullFileName);
  image=im2bw(image);

  cc3 = bwconncomp(image, 4);
numb3=cc3.NumObjects;
if numb3>1
    image = bwconvhull(image);
end

b  = regionprops(image,'Area','ConvexArea',...
'Eccentricity','EquivDiameter','Extent',...
'FilledArea','MajorAxisLength','MinorAxisLength','Orientation',...
'Perimeter','Solidity');
c1=struct2cell(b);
c1=cell2mat(c1)';

c= regionprops(image,'ConvexHull','BoundingBox','Centroid','Area','Perimeter');
n_convexhull= length(c.ConvexHull());

centro_ret_x= c.BoundingBox(1,1)+ c.BoundingBox(1,3)/2;
centro_ret_y= c.BoundingBox(1,2)+ c.BoundingBox(1,4)/2;
X = [centro_ret_x,centro_ret_y ; c.Centroid(1,1),c.Centroid(1,2)];
dist= pdist(X);

allAreas = [c.Area];
boundingBoxes = [c.BoundingBox];
allBBAreas = boundingBoxes(3:4:end) .* boundingBoxes(4:4:end);

m=c.Area;
[n,e]=size(image);
m1=n*e;

as=m/m1*100;

l=c.Perimeter;

border=(l^2)/(4*pi()*m);

compactness= l^2/(4*pi()*m);
 
 c=[n_convexhull dist as border compactness];
 c1=horzcat(c1,c);
 
 binaria=vertcat(binaria,c1);

end
%%
total=horzcat(binaria,cores);

%%
load('labels_764.mat');
numlables=[];
for i=1:length(labels_764)
    if strcmp(labels_764(i,1),'malignant')==1
        numlables=vertcat(numlables,1);
    else
        numlables=vertcat(numlables,0);
    end
end
%%
% features1=horzcat(total,numlabels);
% 
% save features_764 features1
% 
% csvwrite('features_764.csv',features1);