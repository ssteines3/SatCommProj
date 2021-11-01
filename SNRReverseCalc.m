

% Earth Station 1 Parameters

Gtx_dB = 55;
Gtx = 10^(Gtx_dB./10);
fup = 83.5.*10^9;
wavelenup = 3.*10^8./fup;
Bandwidth = .5.*10^9;

% Earth Station 2 Parameters

fdown = 73.5.*10^9;
wavelendown = 3.*10^8./fdown;
TantES = 10;
Grx_dB = 50;
Grx = 10^(Grx_dB./10);
NFlna_dB = 1;
NFlna = 10^(NFlna_dB./10);
Tlna = 275.*(NFlna - 1);
Glna_dB = 30;
Glna = 10^(Glna_dB./10);
NFmix_dB = 1;
NFmix = 10^(NFmix_dB./10);
Tmix = 275.*(NFmix - 1);
Gmix_dB = 0;
Gmix = 10^(Gmix_dB./10);

% Satellite Parameters 

distance = 35878.*1000;
TantSat = 100;
GrSat_dB = 10;
GrSat = 10^(GrSat_dB./10);
NFlnaSat_dB = 2;
NFlnaSat = 10^(NFlnaSat_dB./10);
TlnaSat = 275.*(NFlnaSat - 1);
GlnaSat_dB = 30;
GlnaSat = 10^(GlnaSat_dB./10);
NFmixSat_dB = 5;
NFmixSat = 10^(NFmixSat_dB./10);
TmixSat = 275.*(NFmixSat - 1);
GmixSat_dB = 0;
GmixSat = 10^(GmixSat_dB./10);

% Loss Parameterization

Lclearsky_dB = .2;
R = 20;
rainHeight = 100.*1000; 
angle = 80;
alphaup = 1.41*(fup).^(-0.0779);
kappaup = 4.09*10.^(-10).*(fup./(10.^9)).^0.069;
Lrainup_dB = rainHeight./sin(angle).*kappaup.*(R).^alphaup;
alphadown = 1.41*(fdown).^(-0.0779);
kappadown = 4.09*10.^(-10).*(fdown./(10.^9)).^0.069;
Lraindown_dB = rainHeight./sin(angle).*kappadown.*(R).^alphadown;
Lbeamedge_dB = -3;
Lmisc_dB = 1;
Lpathup_dB = 20.*log10(wavelenup./(4.*pi.*distance));
Lpathdown_dB = 20.*log10(wavelendown./(4.*pi.*distance));
Trainup = 275.*(1-10.^(-(Lrainup_dB+Lclearsky_dB)./10));
Traindown = 275.*(1-10.^(-(Lrainup_dB+Lclearsky_dB)./10));

% CNtotal and Bit Error Rate Calculation

ErrorProb = .0001;
EbN = -log(2.*ErrorProb);
EbN_dB = 10.*log10(EbN);
InformationRate = 10.*1000;
CNtotal_dB = EbN_dB - 10.*log10(Bandwidth) + 10.*log10(InformationRate)
CNtotal = 10.^(CNtotal./10);
%Assuming SNR of downlink to be 15 dB
CNdown_dB = 15;

% CNup Calculation

Cup = 10.*log10(Pt) + Gtx_dB + GrSat_dB + Lpathup_dB - Lrainup_dB - Lbeamedge_dB...
    - Lmisc_dB + GlnaSat_dB + GmixSat_dB;
Tsysup = Trainup + TantSat + TlnaSat + TmixSat./GlnaSat;
Nup = 10.*log10(1.38.*10.^(-23).*Tsysup.*Bandwidth) + GlnaSat_dB + GmixSat_dB;
CNup_dB = Cup - Nup
CNup = 10.^(CNup_dB./10);

% CNdown Calculation

Cdown = 10.*log10(PtSat) + GrSat_dB + Grx_dB + Lpathdown_dB - Lraindown_dB - Lbeamedge_dB...
    - Lmisc_dB + Glna_dB + Gmix_dB;
Tsysdown = Traindown + TantES + Tlna + Tmix./Glna;
Ndown = 10.*log10(1.38.*10.^(-23).*Tsysdown.*Bandwidth) + Glna_dB + Gmix_dB;
CNdown_dB = Cdown - Ndown
CNdown = 10.^(CNdown_dB./10);

