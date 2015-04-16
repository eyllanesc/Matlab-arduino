ranger_min = 2; % 2cm is Min Range for HCSR04(datasheet) 
%clearPorts();
listPort();
serial_arduino = setupSerialPort(1);
cmdStart = 't';
cmdRead = 'r';
while cmdStart~='s'
    cmdStart = fread(serial_arduino,1,'uchar');
end
%if cmdStart=='s'
    %disp('Serial Start')
%end
%cm = 150*ones(1,180);
x = zeros(1,5000);
y = zeros(1,5000);
z = zeros(1,5000);
t=[];
%x = 0;
%y = 0;
%z = 0;
alpha = 0.99;
figure
hold on
   draw_vector(1,0,0,'r');
   draw_vector(0,1,0,'g');
   draw_vector(0,0,1,'b');
   hold off
while true
   tic
   writeCmd(serial_arduino, cmdStart);
   writeCmd(serial_arduino, cmdRead);
   [xtmp ytmp ztmp] = readData(serial_arduino);
   %x = x*alpha + (1-alpha)*xtmp;  
   %y = y*alpha + (1-alpha)*ytmp;
   %z = z*alpha + (1-alpha)*ztmp;
   x = [x(2:end) xtmp];
   y = [y(2:end) ytmp];
   z = [z(2:end) ztmp];
   plot(1:5000,[x;y;z])

   draw_vector(xtmp,ytmp,ztmp,'k');
   axis([-3 3 -3 3 -3 3])
   grid on
%    if(cmtmp >=ranger_min && angletmp~= 0)
%    cm(angletmp)=cmtmp;
%    polar(linspace(0,pi, length(cm)),cm/58,'r')
%    hold on
%    polar(linspace(0,pi, length(cm)), 150*ones(1,180),'k')
%    hold off
   %pause(0.1)
   drawnow
   tfinal = toc;
   t = [t tfinal];
   pause(0.08-tfinal)
   %axis equal
   %end
end