clear all
clc


%% Ir buscar as imagens e guarda-las num imageDataStore
myFolder= fullfile(pwd);
filePattern = fullfile(myFolder, '*.jpg');
jpegFiles = dir(filePattern);


categorias = {'malignos', 'benignos'};

imds = imageDatastore(fullfile(myFolder, categorias), 'LabelSource', 'foldernames');

tbl = countEachLabel(imds)
%% Reduzir o data set para o mesmo numero de imagens malignas e benignas
minSetCount = min(tbl{:,2});
imds = splitEachLabel(imds, minSetCount, 'randomize');
countEachLabel(imds)

%% Dividir o data set em 50% para treino e 50% para validacao
[trainingSet, validationSet] = splitEachLabel(imds, 0.5, 'randomize');
%% Extrair as features e optmiza-las
bag = bagOfFeatures(trainingSet);

%% Treinar o classificador
categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);

%% Avaliacar o classificador
confMatrix = evaluate(categoryClassifier, trainingSet);
confMatrix = evaluate(categoryClassifier, validationSet);

% Compute average accuracy
mean(diag(confMatrix));

%% Classificar qualquer imagem que queira.
% [filename,pathname]=uigetfile('*.jpg');
% 
% fullFileName = fullfile(pathname, filename);
% img = imread(fullFileName);
% 
% %%img = imread(fullfile(myFolder, 'malignos', 'ISIC_0000140.jpg'));
% [labelIdx, scores] = predict(categoryClassifier, img);
% 
% % Display the string label
% 
% result =string (categoryClassifier.Labels(labelIdx));
% 
% display(strcat('A classificação da imagem é:  ',result));

