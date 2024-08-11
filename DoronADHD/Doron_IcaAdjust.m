function [fileNames, pathName]=Doron_IcaAdjust(fileNames, pathName)

if nargin<2
    [fileNames, pathName]=Z_getSetsFileNames;
end;
for i=1: size(fileNames,1) 
    if size(fileNames, 1)==1 & size(fileNames{1,1}, 1)>1
        fileName=fileNames{i,1}';
    else
        fileName=fileNames{i,1};
    end;
    
    EEG = pop_loadset( [pathName fileName]);

    % Run ICA and labal it

    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'rndreset','yes','interrupt','on');
    EEG = pop_iclabel(EEG, 'default');

    disp(' ')
    disp (['Running ADJUST on dataset ' strrep(EEG.filename, '.set', '') '.set'])
    promptstr    = { 'Enter Report file name (in quote): '};
    inistr       = { '''report.txt'''};
    result       = inputdlg2( promptstr, 'ADJUST User Interface', 1,  inistr, 'pop_ADJUST_interface');
    if length( result ) == 0 return; end;

    report  = eval( [ '[' result{1} ']' ] );

    % Run Adjust
    [EEG aic] = interface_ADJDoron(EEG,report); % Running ADJUST

    % disp(['Artifact ICs list  ',[RemIC]]);

    % return the string command
    % -------------------------
    com = sprintf('pop_ADJUST_interface( %s );', EEG.filename);

    EEG = pop_subcomp( EEG, aic, 0);  % Remove artifact components

   % vis_artifacts(tempEEG,EEG)

   % EEG = tempEEG;

   if ~strcmp(EEG.setname(1, end-1:end), 'ICAdjust')
        EEG=Z_append(EEG, 'ICAdjust');
   end
   
   if ~isfield(EEG, 'recinfo') EEG.recinfo.history={}; end     
    
    EEG.recinfo.history{end+1}=[com ' ' num2str(length(aic)) ' components removed:  ' num2str(aic) ];
    EEG = eeg_checkset( EEG );  
    EEG = pop_saveset( EEG, [pathName EEG.filename]);
    fileNames{i,1}=EEG.filename;
end