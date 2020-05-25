dt=0.0001;
T=15;
t=0:dt:T;
g=9.8;
L=1;
m=10;
k=5;
theta0=3.1;
v0=0;
v=zeros(size(t));
theta=zeros(size(t));
v(1)=v0;
theta(1)=theta0;
for n=1:length(t)
   v(n+1)=v(n)+(g*sin(theta(n))-k./m.*v(n)).*dt;
   theta(n+1)=theta(n)-1./L.*v(n).*dt;
end
% [AX,H1,H2]=plotyy(t,v(1:length(t)),t,theta(1:length(t)),'plot');
% set(H1,'LineStyle','-');
% set(H2,'LineStyle','-.');
% set(get(AX(1),'Ylabel'),'String','���ٶ�');
% set(get(AX(2),'Ylabel'),'String','���ٶ�');
% xlabel('ʱ��');
% legend(H1,'���ٶ�',2);
% legend(H2,'���ٶ�',1);
xlabel('ʱ�� t');

yyaxis left;
plot(t,v(1,length(t)),'-');ylabel('���ٶ�');

yyaxis right;
plot(t,theta(1,length(t)),'-.');ylabel('���ٶ�');