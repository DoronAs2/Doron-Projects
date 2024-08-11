function [EEG]=Z_append(EEG, appendix);
EEG.setname=[EEG.setname ' ' appendix];
EEG.filename=[EEG.setname '.set'];
EEG.datfile=[EEG.setname '.fdt'];