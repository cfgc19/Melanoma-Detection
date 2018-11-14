function [Dice,sensitivity,specificity,accuracy,JaccardIndex] = avaliacao1( reference, toTest )
%   reference = grouth truth binary image
%   toTest = binary image to be compared to the reference image

%  TP = numel(find(reference==1 & toTest==1)==1); % True positive
%  FP = numel(find(reference==0 & toTest==1)==1); % False positive
%  TN = numel(find(reference==0 & toTest==0)==1); % True negative
%  FN = numel(find(reference==1 & toTest==0)==1); % False negative

%Outra maneira de calcular 
 TP = nnz(reference==1 & toTest==1); % True positive
 FP = nnz(reference==0 & toTest==1); % False positive
 TN = nnz(reference==0 & toTest==0); % True negative
 FN = nnz(reference==1 & toTest==0); % False negative

P = TP + FN; % Total positive for the true class (= reference)
N = FP + TN; % TOtal negative for the true class (= reference)

FPrate = FP/N; % False positive rate
TPrate = TP/P; % True positive rate

precision = TP/(TP+FP);
accuracy = (TP+TN)/(P+N);

sensitivity=TP/(TP+FN);
specificity=TN/(TN+FP);
Dice= 2*TP/(2*TP+FN+FP);

JaccardIndex = TP / (FP+TP+FN);

end