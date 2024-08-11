%% import EEG

 [fileNames, pathName]=DoronADHD_importASAFiles_withindex(1:3, 4:7, 8:10);
 fileNames = fileNames';

%% Insert events
[fileNames, pathName]=H1H7_Rest_insert_events(2, fileNames, pathName);

%% Data filteration - 1-100 bandpass
[fileNames, pathName] = H1H7_New_2WayFilter(1,100,0, fileNames, pathName);


% data filteration - notch 48-52 (For Soroka and Croatia sites)
[fileNames, pathName]=H1H7_New_2WayFilter(48,52,1, fileNames, pathName);


%% Automated pre processing for ICA

 [fileNames, pathName]= Doron_Rest_rejSpec( fileNames, pathName);

%% Mark segmants
% [fileNames, pathName]= H1H7_segment({'Smark'}, -1, 1, []);

%% Automated ICA

 [fileNames, pathName]= Doron_IcaAdjust(fileNames, pathName);

 Doron_Rest_interpTreatment;

 Doron_Areref('cZ');

 pop_select(EEG,'rmchannel',contains({EEG.chanlocs.labels}))

