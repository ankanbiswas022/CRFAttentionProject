% Spectral Analysis of EEG signals for Contrast Conditions for Monkey
% Microelectrode Data
% who performed GRF Protocol for stimuli centred on the RF of
% microelectrode grid
clear; clc; close all;

electrodeNumLists{1} = [32 41 77]; % Electrodes of Interest
% electrodeNumLists{2} = [29 28 60 61]; % Electrodes of Interest

blRange = [-0.25 0]; stRange = [0.25 0.5];
a=1; e=1; s = 1; f = 1; o =1; t= 2;

freqLims = [0 100];

plotPos = [0.1 0.1 0.85 0.85]; plotGap = 0.1;

indexList = 45; %[];
[expDates,protocolNames,stimType] = getAllProtocols('tutu','Microelectrode');
folderSourceString='H:'; subjectName = 'tutu';gridType = 'Microelectrode';


for i=1:length(indexList)
%     subjectName = subjectNames{indexList(i)};
    expDate = expDates{indexList(i)};
    protocolName = protocolNames{indexList(i)};
    load(fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'extractedData','parameterCombinations.mat'));    
    load(fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'segmentedData','LFP','lfpInfo.mat'));           
    

        Fs=2000;  
%         blRange = [-0.25 0]; stRange = [0.25 0.5];
        N = round(Fs*diff(blRange)); ysbl = Fs*(0:1/N:1-1/N);
        N = round(Fs*diff(stRange)); ysst = Fs*(0:1/N:1-1/N);        
        blPos = find(timeVals>=blRange(1),1) + (1:N);
        stPos = find(timeVals>=stRange(1),1) + (1:N);
        blPostf = find(timeVals>=blRange(1),1) + (1:N);
        stPostf = find(timeVals>=stRange(1),1) + (1:N);
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot %%%%%%%%%%%%%%%%%%%%%%%%%%%
     figure(i)
     plotHandlesPSD = getPlotHandles((length(cValsUnique)-1)/3,(length(cValsUnique)+1)/2,plotPos,plotGap,plotGap,0);
     
     figure(i+numel(indexList)); colormap jet;
     plotHandlesTF = getPlotHandles((length(cValsUnique)-1)/3,(length(cValsUnique)+1)/2,plotPos,plotGap,plotGap,0);
     
     figure(i+2*numel(indexList));
     
     electrodeNumList = electrodeNumLists{1}; % Right Side
    
     AlphaRange = [8 12]; BetaRange = [16 30]; GammaRange = [30 80]; SSVEPRange = 2*tValsUnique(t);
     
     
     for c=1:length(cValsUnique)
        clear goodPos
      
        goodPos = parameterCombinations{a,e,s,f,o,c,t};
       
         analogData = [];
            for j = 1:length(electrodeNumList) % Rigth side 
                    elecNum = electrodeNumList(j);
                    electrodeData = load(fullfile(folderSourceString,'data',subjectName,gridType,expDate,protocolName,'segmentedData','LFP',['elec' num2str(elecNum) '.mat']));
                    analogData = cat(1,analogData,electrodeData.analogData(goodPos,:));
            end
       
               clear dataMean sizeDTA dataToAnalyseBLMatrix dataToAnalyseBLCorrected
                
                dataMean = mean(analogData(:,blPos),2);
                sizeDTA = size(analogData,2);
                dataToAnalyseBLMatrix = repmat(dataMean,1,sizeDTA);
                dataToAnalyseBLCorrected = analogData;% - dataToAnalyseBLMatrix;
%                 erpData = mean(dataToAnalyseBLCorrected,1);   %You get one value for Raw EEG amplitude for all 2048 Time Points 
                
        
           
        params.tapers = [1 1]; %(where K is less than or equal to 2TW-1)
        params.pad = -1;
        params.Fs = Fs;
        params.fpass = freqLims;
        params.trialave = 1; 
        
       
        figure(i);
        subplot(plotHandlesPSD(c));
        [blPower,blFreq] = mtspectrumc(dataToAnalyseBLCorrected(:,blPostf)',params);
        plot(blFreq,log(blPower),'b'); hold on;
        [stPower,stFreq] = mtspectrumc(dataToAnalyseBLCorrected(:,stPostf)',params);
        plot(stFreq,log(stPower),'r');
        title(['Contrast: ' num2str(cValsUnique(c)) '%']);
        xlabel('Frequency(Hz)'); ylabel('log10(Power)'); ylim([-8 4]);
        legend('Baseline','Stimulus');
        
        figure(i+numel(indexList));
        subplot(plotHandlesTF(c));
%         movingwin = [0.25 0.025];
        movingwin = [diff(blRange) 0.01]; % in seconds. Change i from 1 to 4.
        [tfPower,tfTime,tfFreq] = mtspecgramc(dataToAnalyseBLCorrected',movingwin,params);
        chPower = 10*(log10(tfPower)' - repmat(log10(blPower),1,size(tfPower,1)));
        pcolor(tfTime+timeVals(1),tfFreq,(chPower)); shading interp; xlabel('Time Period (second)'); ylabel('Frequency')
        title(['Contrast: ' num2str(cValsUnique(c)) '%']);
        colorbar; caxis([-10 10]);
        xlim([-0.5 0.75]); 
        
        
        AlphaPos = find(blFreq>=AlphaRange(1) & blFreq<=AlphaRange(2));
        BetaPos = find(blFreq>=BetaRange(1) & blFreq<=BetaRange(2));
        GammaPos = find(blFreq>=GammaRange(1) & blFreq<=GammaRange(2));
        SSVEPPos = find(blFreq == SSVEPRange);
        
%         clear AlphaPowerChange BetaPowerChange GammaPowerChange
        AlphaPowerChange(c) = 10*log10(mean((stPower(AlphaPos,:)),1))-10*log10(mean((blPower(AlphaPos,:)),1));
        BetaPowerChange(c) = 10*log10(mean((stPower(BetaPos,:)),1))-10*log10(mean((blPower(BetaPos,:)),1));
        GammaPowerChange(c) = 10*log10(mean((stPower(GammaPos,:)),1))-10*log10(mean((blPower(GammaPos,:)),1));
        SSVEPPowerChange(c) = 10*log10(stPower(SSVEPPos))-10*log10(blPower(SSVEPPos));
        
        semAlphaPowerChange(c) = std((10*log10(stPower(AlphaPos,:))-10*log10(blPower(AlphaPos,:))))/sqrt(length(stPower(AlphaPos,:)));
        semBetaPowerChange(c) = std((10*log10(stPower(BetaPos,:))-10*log10(blPower(BetaPos,:))))/sqrt(length(stPower(BetaPos,:)));
        semGammaPowerChange(c) = std((10*log10(stPower(GammaPos,:))-10*log10(blPower(GammaPos,:))))/sqrt(length(stPower(GammaPos,:)));
       
     end
     
        figure(i+2*numel(indexList));
        scaledxaxis = [log2(cValsUnique(2))-(log2(cValsUnique(3))-log2(cValsUnique(2))) log2(cValsUnique(2:end))];
%         plot(scaledxaxis,AlphaPowerChange,'bo-','LineWidth',2); hold on;
%         plot(scaledxaxis,BetaPowerChange,'ko-','LineWidth',2);
%         plot(scaledxaxis,GammaPowerChange,'ro-','LineWidth',2);hold on;
        
        errorbar(scaledxaxis,AlphaPowerChange,semAlphaPowerChange,'bo-','LineWidth',2); hold on;
        errorbar(scaledxaxis,BetaPowerChange,semBetaPowerChange,'ko-','LineWidth',2);
        errorbar(scaledxaxis,GammaPowerChange,semGammaPowerChange,'ro-','LineWidth',2); 
        plot(scaledxaxis,SSVEPPowerChange,'co-','LineWidth',2); hold on;
        ax = gca;
        ax.XTick = [scaledxaxis];
        ax.XTickLabel = {'0','3.125','6.25', '12.5', '25', '50', '100'};
        legend('Change in Alpha Power','Change in Beta Power','Change in Gamma Power ')
        xlabel('Contrast(%)'),ylabel('Change in Power (decibel)');
        title(['Change in Power at Alpha-Beta-Gamma for Monkey: ',subjectName]);
        
    

        
 end        