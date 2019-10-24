%----------------------------------------------------------------------
% This function generate the spatial domain of the Gabor wavelets
% which are specified by number of scales and orientations and the 
% maximun and minimun center frequency.
%
%	"esta função gera o dominio espacial das wavelets de Gabor, as quais 
%	são especificadas pelo número de escalas e orientações e o centro de 
%	freqüência máximo e mínimo."
%
%
% 
%         N : the size of rectangular grid to sample the gabor
%     index : [s,n] specify which gabor filter is selected
%      freq : [Ul,Uh] specify the maximun and minimun center frequency
% partition : [stage,orientation] specify the total number of filters
%      flag : 1 -> remove the dc value of the real part of Gabor
%             0 -> not to remove
%----------------------------------------------------------------------

% Minhas observacoes na tentativa de deixar o filtro G como o do paper (Leila)
% Xvar = sigma_u
% Yvar = Sigma_v
% Uvar = sigma_x = a da formula
% Vvar = sigma_y = b da formula
%
%----------------------------------------------------------------------
% Minhas observacoes na tentativa de deixar o filtro G como o do paper (Mauricio)
% Xvar = sigma_x
% Yvar = Sigma_y
% Uvar = sigma_u 
% Vvar = sigma_v 
%
%----------------------------------------------------------------------
% CONSIDERAR PARAMETROS: freq: 0.05 a 0.4
%								N = 256
%								stage = 4
%								orientation = 6



function [Gr,Gi]=Gabor(N,index,freq,partition)

% get parameters

s=index(1); % numero do estagio atual
n=index(2); % orientacao atual

Ul=freq(1); % frenquencia mais baixa
Uh=freq(2); % frequencia mais alta

stage=partition(1); % total de estagios 
orientation=partition(2);% total de orientacoes

% computer ratio a for generating wavelets

base=Uh/Ul; %frequencia maior dividida pela menor (NO CASO, 8)
C=zeros(1,stage); % montagem do vetor C de uma linha e 'stage' posicoes zeradas;
						% este vetor contem os coeficientes de um polinomio.
C(1)=1; % primeira posicao recebe 1
C(stage)=-base; % ultima posicao recebe -base (NO CASO, -8)

P=abs(roots(C)); % calculo das raizes (coeficientes) do polinomio C e pegando a parte positiva
a=P(1); % recebe a primeira raiz 

% computer best variance of gaussian envelope

u0=Uh/(a^(stage-s)); % (?) não encontrei este cálculo no paper, deve ser para 
							% particionar o intervalo de freq. escolhido


Uvar=((a-1)*u0)/((a+1)*sqrt(2*log(2))); % (?) no lugar de u0 é Uh, no paper
													% equação 3-6, pag 28                     
 

z=-2*log(2)*Uvar^2/u0; % equação 3-7, pag 28
Vvar=tan(pi/(2*orientation))*(u0+z)/sqrt(2*log(2)-z*z/(Uvar^2)); % equação 3-7, pag 28

% generate the spatial domain of gabor wavelets

if (rem(N,2)==0) % se resto da divisao de N (tamanho da imagem) por 2 for = 0 
    side=N/2-0.5; % side recebe N / 2 - 0.5 
else
    side=fix(N/2); % fix joga (N/2) para o inteiro mais próximo
end;

x=-side:1:side;
l=length(x); % numero de elementos do vetor
y=x'; % y recebendo a transposta de x
X=ones(l,1)*x; % X recebe matriz de l x l com valores de -side a +side por linha
Y=y*ones(1,l); % Y recebe matriz de l x l com valores de -side a +side por coluna

t1=cos(pi/orientation*(n-1)); % parametros da formula de G
t2=sin(pi/orientation*(n-1)); 

XX=X*t1+Y*t2;
YY=-X*t2+Y*t1;

Xvar=1/(2*pi*Uvar);
Yvar=1/(2*pi*Vvar);

coef=1/(2*pi*Xvar*Yvar);

Gr = a^(stage-s)*coef*exp(-0.5*((XX.*XX)./(Xvar^2)+(YY.*YY)./(Yvar^2))).*cos(2*pi*u0*XX);
Gi = a^(stage-s)*coef*exp(-0.5*((XX.*XX)./(Xvar^2)+(YY.*YY)./(Yvar^2))).*sin(2*pi*u0*XX);


