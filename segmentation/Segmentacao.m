clear all
clc

%% IR BUSCAR O DIRETÓRIO DAS PASTAS QUE CONTEM OS TRAINING DATA E GROUND TRUTH DATA
myFolder='\ISBI2016_ISIC_Part1_Training_Data';
myFolder2 ='\ISBI2016_ISIC_Part1_Training_GroundTruth';
filePattern = fullfile(pwd,myFolder, '*.jpg');
filePattern2 = fullfile(pwd,myFolder2, '*.png');
jpegFiles = dir(filePattern);
pngFiles = dir(filePattern2);
%% LER OS FICHEIROS DO TRAINING DATA, FAZER A SEGEMENTACAO DAS IMAGENS E GUARDAR NUM MATRIZ
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(pwd,myFolder, baseFileName);
  image= imread(fullFileName);
  Segment{k}=segmentImage2(image);
  %Training{k}=image;
end
%% LER OS FICHEIROS DO GROUND TRUTH DATA E GUARDAR NUM MATRIZ
for i=1:length(jpegFiles)
     baseFileName2 = pngFiles(i).name;
     fullFileName2 = fullfile(pwd,myFolder2, baseFileName2);
     Ground1{i}= im2bw(imread(fullFileName2)); %As mascaras binárias estão com os valores 255 e 0 e é para colocar em 1 e 0 para comparar depois.
end

%% CALCULAR O VALOR DO JACCARD, Sensibilidade, Accuracy e Dice
for i =1:length(jpegFiles)
     [Dice,sensitivity,specificity,accuracy,JaccardIndex] = avaliacao1(Ground1{i},Segment{i});
     Avaliacao(i,1)=sensitivity;
     Avaliacao(i,2)=specificity;
     Avaliacao(i,3)=Dice;
     Avaliacao(i,4)=JaccardIndex;
     Avaliacao(i,5)=accuracy;
end

%% Guardar as imagens segmentadas na totalidade numa pasta
% for i=1:length(Segment)
%    imwrite(Segment{i}, [pwd,'\Seg_final\',jpegFiles(i).name,'_Segmentation','.png']);
% end

%% Guardar as imagens mascaradas nas pastas respetivas
% for k=1:length(Segment)
% I=Training{k};
% [a,s,r]=size(I);
%     for j=1:a
%         for i=1:s
%             if Segment{k}(j,i)==0
%                 I(j,i,:)=0;
%             end
%         end
%     end
%     if (Avaliacao(k,4)>0.52)
%         imwrite(I, [pwd,'\Imagens_Mascaradas\',jpegFiles(k).name]);
%         imwrite(Segment{k},[pwd,'\Mascaras\',jpegFiles(k).name]);
%     end
% end

%% Reduzir as labels para o novo data set
%i=1;
% for k=1:length(Avaliacao)
% if Avaliacao(k,4)>0.52
%   labels_764(i,1)=string(labels(k,2));
%   i=i+1;
% end
% end
