%% 
% clearPorts.m
% This function will close all open serial ports. This frees them up for 
% other programs to use.
function clearPorts()
    fclose(instrfind);
end