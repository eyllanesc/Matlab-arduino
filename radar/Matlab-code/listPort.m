function [ports]=listPort()
% Get info about all the serial ports
    serialInfo = instrhwinfo('serial');
    % Display the name of each one:d
    %for portN = 1:length(serialInfo.AvailableSerialPorts)
     %   disp(['Port ',num2str(portN),': ',...
      %       serialInfo.AvailableSerialPorts{portN}]);
    %end
    ports = serialInfo.AvailableSerialPorts;