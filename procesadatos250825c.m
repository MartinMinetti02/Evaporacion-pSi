clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%cargo los datos%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nombre= '250825c'; %nombre sin la extension txt

Ni=120;
Nf=317;

Npc=1;  %Numero de curvas a promediar
Ncs=1;  %relacion de curvas a tomar (se toman 1 de cada Ncs)

Ti=0.25; %tiempo de integración utilizado
Np=1;  %Suavizado de puntos adyacentes

%rango de longitudes de onda a considerar
lambdai=500;
lambdaf=1000;


% figure
% hold on
% xlabel('Longitud de onda')
% ylabel('Reflectancia Normalizada [u.a.]')

%map=colormap;
cont=1;

for k=Ni:Npc*Ncs:Nf-Npc;
    k
    salida=0;
    for j=1:Npc

        if k+j<10
            c=[nombre,'0000',num2str(k+j),'.txt'];
            fid=fopen(c);
            [x B]= textscan (fid, '%f %f', 'HeaderLines', 20);  % reads file correctly
            fclose(fid);
            datos=cell2mat(x);

            
        elseif k+j<100
            c=[nombre,'000',num2str(k+j),'.txt'];
            fid=fopen(c);
            [x B]= textscan (fid, '%f %f', 'HeaderLines', 20);  % reads file correctly
            fclose(fid);
            datos=cell2mat(x);
            
        elseif k+j<1000
            c=[nombre,'00',num2str(k+j),'.txt'];
            fid=fopen(c);
            [x B]= textscan (fid, '%f %f', 'HeaderLines', 20);  % reads file correctly
            fclose(fid);
            datos=cell2mat(x);
            
        elseif k+j<10000
            c=[nombre,'0',num2str(k+j),'.txt'];
            fid=fopen(c);
            [x B]= textscan (fid, '%f %f', 'HeaderLines', 20);  % reads file correctly
            fclose(fid);
            datos=cell2mat(x);
            
        else
            c=[nombre,'',num2str(k+j),'.txt'];
            fid=fopen(c);
            [x B]= textscan (fid, '%f %f', 'HeaderLines', 20);  % reads file correctly
            fclose(fid);
            datos=cell2mat(x);
            
        end

        datos(parecido(datos(:,1),lambdaf):end,:)=[];
        datos(1:parecido(datos(:,1),lambdai),:)=[];

        aux1=conv(datos(:,1),ones(Np,1))/Np;
        aux2=conv(datos(:,2),ones(Np,1))/Np;
        aux1=aux1(Np:end-Np);
        aux2=aux2(Np:end-Np);
        salida=salida+aux2;
    end
    aux2=salida/Npc;
%     plot(aux1,aux2)%,'Color',map(ceil(64*(Nf-j+1)/(Nf-Ni+1)),:))
%     [lh,cmap]=cmapline('ax',gca,'colormap','jet');
%     colormap(flipud(cmap))
%     colorbar

    z(cont,:)=aux2;

    cont=cont+1;
    %     y(j-Ni+1)=z(j-Ni+1,parecido(520,aux1));

end

% int1=sum(z(:,parecido(350,aux1):parecido(450,aux1)),2);
% int2=sum(z(:,parecido(590,aux1):parecido(1000,aux1)),2);

% figure
% plot(int1)
% hold on
% plot(int2)

% figure
% loglog(int2)

% tiempo=(Ni-5:Ni+size(int2,1)-6)*Ti;
% figure
% semilogx(tiempo,int2)

tiempo=(1:size(z,1))*Ti*Ncs;
figure
contourf(aux1,tiempo,z)
xlabel('longitud de onda [nm]')
ylabel('Tiempo [s]')

figure
plot(aux1,z)
xlabel('longitud de onda [nm]')
ylabel('Tiempo [s]')
cmapline(jet)

eval(['save datos' nombre(1:end) '.dat z -ascii'])
eval(['save tiempo' nombre(1:end) '.dat tiempo -ascii'])
eval(['save lambda' nombre(1:end) '.dat aux1 -ascii'])
