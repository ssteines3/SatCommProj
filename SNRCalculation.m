


% Earth Station 1 Parameters

    % Location and EL angle calculation
    
    ES1Lat = 40;
    ES1Long = 95;
    SatLat = 0;
    SatLong = 95;
    phi1 = acosd(sind(ES1Lat).*sind(SatLat)+cosd(ES1Lat).*cosd(SatLong-ES1Long));
    EL1 = acosd(sind(phi1)./(sqrt(1+(6563./42348).^2-2.*(6563./42348).*cosd(phi1))));
    distanceup = (35785+6378.137).*1000.*sind(phi1)./cosd(EL1);

    % Transmission Parameters

    Gtx_dB = 55;
    Gtx = 10^(Gtx_dB./10);
    Pt = 10000;
    fup = 83.5.*10^9;
    wavelenup = 3.*10^8./fup;
    Bandwidth = .5.*10^9;

% Earth Station 2 Parameters

    % Location and EL angle calculation

    ES2Lat = 45;
    ES2Long = 110;
    phi2 = acosd(sind(ES2Lat).*sind(SatLat)+cosd(ES2Lat).*cosd(SatLong-ES2Long));
    EL2 = acosd(sind(phi2)./(sqrt(1+(6563./42348).^2-2.*(6563./42348).*cosd(phi2))));
    distancedown = (35785+6378.137).*1000.*sind(phi2)./cosd(EL2);

    % Transmission Parameters

    fdown = 83.5.*10^9;
    wavelendown = 3.*10^8./fdown;
    TantES = 0;
    Grx_dB = 50;
    Grx = 10^(Grx_dB./10);
    NFlna_dB = .2;
    NFlna = 10^(NFlna_dB./10);
    Tlna = 275.*(NFlna - 1);
    Glna_dB = 30;
    Glna = 10^(Glna_dB./10);
    NFmix_dB = .2;
    NFmix = 10^(NFmix_dB./10);
    Tmix = 275.*(NFmix - 1);
    Gmix_dB = 0;
    Gmix = 10^(Gmix_dB./10);

% Satellite Parameters 

    TantSat = 0;
    GrSat_dB = 30;
    GrSat = 10^(GrSat_dB./10);
    NFlnaSat_dB = .2;
    NFlnaSat = 10^(NFlnaSat_dB./10);
    TlnaSat = 275.*(NFlnaSat - 1);
    GlnaSat_dB = 30;
    GlnaSat = 10^(GlnaSat_dB./10);
    NFmixSat_dB = .2;
    NFmixSat = 10^(NFmixSat_dB./10);
    TmixSat = 275.*(NFmixSat - 1);
    GmixSat_dB = 0;
    GmixSat = 10^(GmixSat_dB./10);
    PtSat = 1000;

% Loss Parameterization

    Lclearsky_dB = .2;
    %{
    R = 66;
    rainHeight = 1.*1000; 
    angle = 75;
    alphaup = 1.44*(fup./(10.^9)).^(-.0779);
    kappaup = 4.21*10.^(-5).*(fup./(10.^9)).^2.42;
    Lrainup_dB = rainHeight./sind(angle).*kappaup.*(R).^alphaup;
    alphadown = 1.44*(fdown./(10.^9)).^(-.0779);
    kappadown = 4.21*10.^(-5).*(fdown./(10.^9)).^2.42;
    Lraindown_dB = rainHeight./sind(angle).*kappadown.*(R).^alphadown;
    %}
    Lbeamedge_dB = -3;
    Lmisc_dB = 1;
    Lpathup_dB = 20.*log10(wavelenup./(4.*pi.*distanceup));
    Lpathdown_dB = 20.*log10(wavelendown./(4.*pi.*distancedown));
    %Trainup = 275.*(1-10.^(-(Lrainup_dB+Lclearsky_dB)./10));
    %Traindown = 275.*(1-10.^(-(Lrainup_dB+Lclearsky_dB)./10));

% CNup Calculation

Cup = 10.*log10(Pt) + Gtx_dB + GrSat_dB + Lpathup_dB - Lbeamedge_dB...
    - Lmisc_dB + GlnaSat_dB + GmixSat_dB;
Tsysup = TantSat + TlnaSat + TmixSat./GlnaSat;
Nup = 10.*log10(1.38.*10.^(-23).*Tsysup.*Bandwidth) + GlnaSat_dB + GmixSat_dB;
CNup_dB = Cup - Nup
CNup = 10.^(CNup_dB./10);

% CNdown Calculation

Cdown = 10.*log10(PtSat) + GrSat_dB + Grx_dB + Lpathdown_dB - Lbeamedge_dB...
    - Lmisc_dB + Glna_dB + Gmix_dB;
Tsysdown = TantES + Tlna + Tmix./Glna;
Ndown = 10.*log10(1.38.*10.^(-23).*Tsysdown.*Bandwidth) + Glna_dB + Gmix_dB;
CNdown_dB = Cdown - Ndown
CNdown = 10.^(CNdown_dB./10);

% CNtotal and Bit Error Rate Calculation

CNtotal = ((1./CNup)+(1./CNdown)).^-1;
CNtotal_dB = 10.*log10(CNtotal)
InformationRate = 10.*1000;
EbN_dB = CNtotal_dB + 10.*log10(Bandwidth) - 10.*log10(InformationRate)
EbN = 10.^(EbN_dB./10);
ErrorProb = .5.*exp(-EbN)

% Sat/ES Plots
    [X, Y, Z] = sphere;
    [XES, YES, ZES] = sphere;
    XSAT = XES.*.2;
    YSAT = YES.*.2;
    ZSAT = ZES.*.2;
    XES = XES.*.1;
    YES = YES.*.1;
    ZES = ZES.*.1;
    ES1Lat = 40;
    ES1Long = 95;
    ES2Lat = 45;
    ES2Long = 110; 
    SatLong = 95;
    SatLat = 0;
    ES1X = sind(ES1Lat-90).*cosd(ES1Long);
    ES1Y = sind(ES1Lat-90).*sind(ES1Long);
    ES1Z = cosd(ES1Lat-90);
    ES2X = sind(ES2Lat-90).*cosd(ES2Long);
    ES2Y = sind(ES2Lat-90).*sind(ES2Long);
    ES2Z = cosd(ES2Lat-90);
    SatX = 6.61069.*sind(SatLat-90).*cosd(SatLong);
    SatY = 6.61069.*sind(SatLat-90).*sind(SatLong);
    SatZ = 6.61069.*cosd(SatLat-90);
    line1x = linspace(ES1X,SatX);
    line2x = linspace(ES2X,SatX);
    line1y = linspace(ES1Y,SatY);
    line2y = linspace(ES2Y,SatY);
    line1z = linspace(ES1Z,SatZ);
    line2z = linspace(ES2Z,SatZ);
    ES1X = ES1X + XES;
    ES1Y = ES1Y + YES;
    ES1Z = ES1Z + ZES;
    ES2X = ES2X + XES;
    ES2Y = ES2Y + YES;
    ES2Z = ES2Z + ZES;
    SatX = SatX + XSAT;
    SatY = SatY + YSAT;
    SatZ = SatZ + ZSAT;
    surf(X,Y,Z)
    shading interp
    axis equal
    grid off
    set(gca,'Color','k')
    xlim([-7,7])
    ylim([-7,7])
    zlim([-7,7])
    hold on
    surf(ES1X,ES1Y,ES1Z,'FaceColor','g', 'FaceAlpha',0.5, 'EdgeColor','none')
    surf(ES2X,ES2Y,ES2Z,'FaceColor','r', 'FaceAlpha',0.5, 'EdgeColor','none')
    surf(SatX,SatY,SatZ,'FaceColor','b', 'FaceAlpha',0.5, 'EdgeColor','none')
    plot3(line1x,line1y,line1z)
    plot3(line2x,line2y,line2z)








