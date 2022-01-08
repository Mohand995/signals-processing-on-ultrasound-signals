clear
clc
Fs=50*10^6;         %%sampling freq                              
F=3.5*10^6;        %%probe freq                                
t=linspace(0,0.1,5*10^(6));   %%5 m sample                     
tx=sin(2*pi*F*t);                                  
subplot(6,1,1)
plot(t,tx)                                          
axis([0 .0001 -1 1])
title('Transmit')  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Rx
% 5m sample will be  divided on 3 time intervals
% so each interva will have 166667 sample
t1=linspace(0,0.033,1666667);  %%first interval                          
t2=linspace(0.033,0.067,1666667);   %%second interval                 
t3=linspace(0.067,1,1666667);         %% third interval              
F1=3.5*10^6;             %%stationery wall                           
F2=3.504*10^6;             %%blood cells moving towards probe                            
F3=3.492*10^6;              %%blood cells moving apart                           
Rx1=sin(2*pi*F1*t(1:1666666));      %%(first 166667 sample of 5 m)                          
Rx2=sin(2*pi*F2*t(1666667:3333334));   %%(sec 166667 sample of 5 m)                       
Rx3=sin(2*pi*F3*t(3333335:5000000));   %%(third 166667 sample of 5 m)                      
RX=[Rx1 Rx2 Rx3];       %% our reciever signal is a composite signal (concatinate of three signals)                     
subplot(6,1,2)
plot(t,RX)                                   
axis([0 0.0001 -1 1])
title('Recieved')
 %%quadrature mixing 
 %%in this way we have to input signals one is our trasmitter(direct channel) and the
 %%second is same transmitter with phase shift 90 degree(quadrature
 %%channel) 
 tx2=cos(2*pi*F*t); %%phase shift 
 mixing1=tx .* RX ;%direct channel%% %%out=0.5*[cos(wf)-cos(2w+wf)+cos(wb)-cos(2w-wb)]
 mixing2=tx2 .* RX ;%%quadrature channel%% %%% out=0.5*[sin(2w+wf)+sin(wf)+sin(2w-wb)-sin(wb)]
 w=lppf ;%%to get rid of high freq signal "w0"
 r1=filter(w,mixing1);%cos(wf)+cos(wb)
 r2=filter(w,mixing2); %sin(wf)-sin(wb)
 o=hilbert(r1) ;%%(pi/2 phase shift by adding [1 -1 -1 1] img part to our vector  %sin(wf)+sin(wb)
 n=imag(o)+r2 ; %%sin(wf)
 t=linspace(0,0.1,5*10^6) ;
  subplot(6,1,3)
  e=filter(hhp2,n) ;%%to remove noise in start of signal
 plot(t,e);
 axis([0 0.1 -1 1 ])
 title('forward') 
 q=imag(o)-r2 ; %%sin(wb)
   
 y=filter(hhp,q) ;%%same for e
 subplot(6,1,4)
 plot(t,y);
  axis([0 0.1 -1 1 ])
 title('back') 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%hetrodyne mixing
 fh=10*10^3; 
 H=sin(2*pi*fh*t) ;%%heterondyne signal .
 mix=tx .* H ; %%0.5[cos(wo+wh)+cos(wo-wh)]
 a=filter(lppf,mix) ; %% cos(wo-wh) 
 mix2=a .* RX ; %% 0.5[sin(2wo-wh-wf) + sin(2wo-wh-wb)+cos(wh+wf)+cos(wh-wb)]
 v=filter(bpf1,mix2) ;%%cos(wh+wf)+cos(wh-wb)
 back=filter(lppf2,v) ;
 forward=filter(hpf,v) ;
  subplot(6,1,5)
 plot(t,back)  ;
 title('back hetro')
  subplot(6,1,6)
 plot(t,forward) ;
  title('forward hetro')
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
 