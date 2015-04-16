function [cm, angle zz] = readData(port)
cm = 0;
angle = 0;
zz = 0;
if port.BytesAvailable>0
    data =str2num(fscanf(port));
    if(~isempty(data))
        cm = data(1);
        angle = data(2);
        zz = data(3);
    end
end
end