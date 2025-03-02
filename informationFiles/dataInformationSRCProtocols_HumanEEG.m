function [subjectNames,expDates,protocolNames,dataFolderSourceString] = dataInformationSRCProtocols_HumanEEG(gridType,protocolType)

if ~exist('gridType','var')                            
    gridType = 'EEG';
end

% FolderSourceString for extracted dataset
if strcmp(getenv('computername'),'RAYLABPC-ARITRA') || strcmp(getenv('username'),'RayLabPC-Aritra')
    dataFolderSourceString = 'E:\data\human\SRCLong';
else
    dataFolderSourceString = 'M:\';
end

[allSubjectNames,allExpDates,allProtocolNames,~,~,~] = eval(['allProtocolsCRFAttention' gridType 'v1']);

% stimList = cell(1,4);
if strcmp(protocolType, 'SRC-Long_Psychophysics')
    protocolList{1} =  247;  % AD  M
    protocolList{2} =  249;  % NN  F
    protocolList{3} =  251;  % NM  M
    protocolList{4} =  260;  % SSP M
    protocolList{5} =  264;  % SK  M
    protocolList{6} =  266;  % AB  M
    protocolList{7} =  271;  % LK  F
    protocolList{8} =  276;  % DG  F
    protocolList{9} =  287;  % SW  M
    protocolList{10} = 293;  % AR  M
    protocolList{11} = 299;  % SN  M
    protocolList{12} = 305;  % AM  M
    protocolList{13} = 314;  % SU  F
    protocolList{14} = 323;  % ArD M
    protocolList{15} = 333;  % UG  F
    protocolList{16} = 340;  % SS  M
    protocolList{17} = 348;  % SNS F
    protocolList{18} = 355;  % SG  F
    protocolList{19} = 361;  % MK  F
    protocolList{20} = 382;  % SR  M
    protocolList{21} = 386;  % SP  M
    protocolList{22} = 408;  % RG  M
    protocolList{23} = 414;  % IJ  F
    protocolList{24} = 422;  % SM  F
    protocolList{25} = 444;  % SJP M
    protocolList{26} = 459;  % SC  F

elseif strcmp(protocolType, 'SRC-Long')
    protocolList{1} = 248;  % AD
    protocolList{2} = 250;  % NN
    protocolList{3} = 252;  % NM
    protocolList{4} = 263;  % SSP
    protocolList{5} = 265;  % SK
    protocolList{6} = 270;  % AB
    protocolList{7} = 273;  % LK
    protocolList{8} = 277;  % DG
    protocolList{9} = 288;  % SW
    protocolList{10} = 294;  % AR
    protocolList{11} = 300;  % SN
    protocolList{12} = 306;  % AM
    protocolList{13} = 317;  % SU
    protocolList{14} = 325;  % ArD
    protocolList{15} = 334;  % UG
    protocolList{16} = 342;  % SS
    protocolList{17} = 350;  % SNS
    protocolList{18} = 356;  % SG
    protocolList{19} = 362;  % MK
    protocolList{20} = 383;  % SR
    protocolList{21} = 403;  % SP
    protocolList{22} = 409;  % RG
    protocolList{23} = 417;  % IJ
    protocolList{24} = 425;  % SM
    protocolList{25} = 446;  % SJP
    protocolList{26} = 460;  % SC

 
elseif strcmp(protocolType, 'SRC-Short')
    protocolList{1} = [];
    protocolList{2} = [];
    protocolList{3} = [];
    protocolList{4} = [];
    protocolList{5} = [];
    protocolList{6} = [];
    protocolList{7} = [];

end

numSubjects = length(protocolList);
subjectNames = cell(numSubjects,length(protocolList{1}));
expDates = cell(numSubjects,length(protocolList{1}));
protocolNames = cell(numSubjects,length(protocolList{1}));

for i=1:numSubjects
    subjectNames{i} = allSubjectNames{protocolList{i}};
    expDates{i} = allExpDates{protocolList{i}};
    protocolNames{i} = allProtocolNames{protocolList{i}};
end

