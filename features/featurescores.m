function resposta = featurescores(image)
%RGB

[m,n,z]=size(image);

r = double(image(:, :, 1));
g = double(image(:, :, 2));
b = double(image(:, :, 3));
sum_r=0;
sum_g=0;
sum_b=0;

for i= 1:m
    for j=1:n
        sum_r=double(r(i,j))+sum_r;
        sum_g=double(g(i,j))+sum_g;
        sum_b=double(b(i,j))+sum_b;
    end
end

mean_r=sum_r/(m*n);
mean_g=sum_g/(m*n);
mean_b=sum_b/(m*n);

min_r= min(r(r>0));
min_g= min(g(g>0)); 
min_b= min(b(b>0));

max_r= max(r(r>0)); 
max_g= max(g(g>0)); 
max_b= max(b(b>0));

var_r=var(double(r(r>0)));
var_g=var(double(g(g>0)));
var_b=var(double(b(b>0)));
%% L*a*b image

cform = makecform('srgb2lab');
lab = applycform(image,cform);
[m,n,z]=size(lab);

l = double(lab(:, :, 1));
a = double(lab(:, :, 2));
b1 = double(lab(:, :, 3));
sum_l=0;
sum_a=0;
sum_b1=0;

for i= 1:m
    for j=1:n
        sum_l=double(l(i,j))+sum_l;
        sum_a=double(a(i,j))+sum_a;
        sum_b1=double(b1(i,j))+sum_b1;
    end
end
mean_l=sum_l/(m*n);
mean_a=sum_a/(m*n);
mean_b1=sum_b1/(m*n);

min_l= min(l(l>0));
min_a= min(a(a>0)); 
min_b1= min(b1(b1>0));

max_l= max(l(l>0)); 
max_a= max(a(a>0)); 
max_b1= max(b1(b1>0));

var_l=var(double(l(l>0)));
var_a=var(double(a(a>0)));
var_b1=var(double(b1(b1>0)));
%% HSI
%Represent the RGB image in [0 1] range
I=double(image)/255;

R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);

%Hue
numi=1/2*((R-G)+(R-B));
denom=((R-G).^2+((R-B).*(G-B))).^0.5;

%To avoid divide by zero exception add a small number in the denominator
H=acosd(numi./(denom+0.000001));

%If B>G then H= 360-Theta
H(B>G)=360-H(B>G);

%Normalize to the range [0 1]
H=H/360;

%Saturation
S=1- (3./(sum(I,3)+0.000001)).*min(I,[],3);

%Intensity
I=sum(I,3)./3;

%HSI
[m,n]=size(H);
sum_h=0;
sum_s=0;
sum_i=0;

for i= 1:m
    for j=1:n
        sum_h=double(H(i,j))+sum_h;
        sum_s=double(S(i,j))+sum_s;
        sum_i=double(I(i,j))+sum_i;
    end
end
mean_h=sum_h/(m*n);
mean_s=sum_s/(m*n);
mean_i=sum_i/(m*n);

min_h= min(H(H>0));
min_s= min(S(S>0)); 
min_i= min(I(I>0));

max_h= max(H(H>0)); 
max_s= max(S(S>0)); 
max_i= max(I(I>0));

var_h=var(double(H(H>0)));
var_s=var(double(S(S>0)));
var_i=var(double(I(I>0)));

%% HSV

A = rgb2hsv(image);

h=A(:,:,1);
s=A(:,:,2);
v=A(:,:,3);
[m,n]=size(h);
sum_h=0;
sum_s=0;
sum_v=0;

for i= 1:m
    for j=1:n
        sum_h=double(h(i,j))+sum_h;
        sum_s=double(s(i,j))+sum_s;
        sum_v=double(v(i,j))+sum_v;
    end
end
mean_v=sum_v/(m*n);

min_v= min(v(v>0));

max_v= max(v(v>0)); 

var_v=var(double(v(v>0)));


I= rgb2gray(image);

GLCM2 = graycomatrix(I,'Offset',[2 0;0 2]);
stats = GLCM_Features4(GLCM2,0);


autoc= stats(1).autoc;autoc= mean(autoc);
contr= stats(1).contr;contr= mean(contr);
corrm= stats(1).corrm;corrm= mean(corrm);
corrp= stats(1).corrp;corrp= mean(corrp);
cprom= stats(1).cprom;cprom= mean(cprom);
cshad= stats(1).cshad;cshad= mean(cshad);
dissi= stats(1).dissi;dissi= mean(dissi);
energ= stats(1).energ;energ= mean(energ);
entro= stats(1).entro;entro= mean(entro);
homom= stats(1).homom;homom= mean(homom);
homop= stats(1).homop;homop= mean(homop);
maxpr= stats(1).maxpr;maxpr= mean(maxpr);
sosvh= stats(1).sosvh;sosvh= mean(sosvh);
savgh= stats(1).savgh;savgh= mean(savgh);
svarh= stats(1).svarh;svarh= mean(svarh);
senth= stats(1).senth;senth= mean(senth);
dvarh= stats(1).dvarh;dvarh= mean(dvarh);
denth= stats(1).denth;denth= mean(denth);
inf1h= stats(1).inf1h;inf1h= mean(inf1h);
inf2h= stats(1).inf2h;inf2h= mean(inf2h);
indnc= stats(1).indnc;indnc= mean(indnc);
idmnc= stats(1).idmnc;idmnc= mean(idmnc);


resposta=[mean_r mean_g mean_b max_r max_g max_b var_r var_g var_b mean_l mean_a mean_b1 min_a min_b1 max_l max_a max_b1 var_l var_a var_b1 mean_h mean_s mean_i min_h min_s min_i max_h max_i var_h var_s var_i mean_v min_v max_v var_v autoc contr corrm corrp cprom cshad dissi energ entro homom homop maxpr sosvh savgh svarh senth dvarh denth inf1h inf2h indnc idmnc];

end

