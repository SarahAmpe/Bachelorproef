% testing van de wave functie:
t = 0.01:0.01:4;
plot(t,wave(2,4*pi,t));

% FMC invoerwaardes en testing
c = 3*10^6;
waveInfo = [2,2*pi,-2:0.01:2];
materialInfo = [c,2,2];
elementInfo = [4,1,2];

[fmc,S,F,d,pr,pt,A] = FMC(waveInfo,materialInfo,elementInfo);

% fout in het programma:

% dit is de output:
S(:,:,1) % dit is oke voor gelijk welke waarde (buiten 201)
S(:,:,201) % dit zijn NaN's (alleen voor 201)
fmc(:,:,3) % deze matrix staat vol (wss door de NaN waarde in S)

% laten we nu eens handmatig rij 201 van S uitrekenen:
G(:,:,201) = F(201).*exp(-1i*(2*pi/t(201))*d/c);
G(:,:,201) % geen NaN's
H(:,:,201) = pr*pt.*A.*G(:,:,201); % exact zelfde formules als in FMC
H(:,:,201) % deze waarden worden wel berkend

