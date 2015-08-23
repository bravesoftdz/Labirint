{$R-}{$Q-}{$I-}{$S-}{$E-}{$N+}{$G+}{$A+}
program Dungeon;
uses CRT,Graph,{gr,{,text1}keyb1{,math};

const MaxGrad=16; {}
const Acc=100;
      MaxSee=4;{minimum-1}
      MaxV0=100;{minimum:~10-3}

      {screen 800x600}
      screenX=800;
      ScreenY=600;

const tileX0=18;
      tileY0=18;

const free=0;{Map blocks}
      roomFree=1;
      smoke=3;

      wall=10;
      superWall=11;
      look=12;

      stairsDown=20;
      stairsUp=21;

      doorOpen=49;{unlocked}
      doorU=50;{unlocked, locked:DoorU+keyN}

      acess =251;
      acess0=252;
      door  =253;
      dig   =254;
      tmp   =255;

const surface=0;{entrance types}
      level=1;

{minimum:10x11;   Maximum:maxX x MaxY<65535  minimum MaxX/MaxY=8}
const MaxX0=42;{47}
      MaxY0=33;{37}
      symbol0=7;{3=8x8; 7=16x16; 11=24x24; 15=32x32}

{      CreateHoleInTunelWall0=1e-6*0;{*circles = %every cell}
      placeDoor0={6e-2|48k}3e-2;{*100%}
      PlaceDoorToRoom0=1;
      randomTransparent0=5e-3;
      randomKeyPlace0=1e-4*0;
{      randomGoal0=1e-3;}

      setSmoke0=1;

{      MaxHallSize0=3;{3-7x7}
{      MaxHallSACE0=3;
      HallEvent0=1e-1*0;{*100%}

      MaxDoorCount0=1;{maximum doors per tunnel}
      MaxTunnelLenghth0=4;

      MaxKeys0=20;{47}
      MaxMaxKeys=123;{200}


type MapArray=array[1..255,1..255] of byte;

type keyItem=record
  exist:boolean;
  x,y:byte;
end;

type Man=object
 x,y:byte;
 procedure MoveMe(dx,dy:shortint);
 procedure LookAround;
end;

type tunel=object
 Sx,Sy:byte;
 mx,my:shortInt;
 N:byte;
 procedure DigMe;
end;

var Map,V,R:^MapArray;
    entr:byte;
    kl:array[1..MaxMaxKeys] of keyItem;
    keysN:byte;

    MaxX,MaxY,
    MaxDoorCount,
    MaxTunnelLenghth,
{    MaxHallSize,
    MaxHallSACE,}
    setSmoke,
    symbolSize,
    KeySymbolSize,
    tileX,tileY,
    maxV,
    MaxKeys               :byte;
    circles               :word;
{    CreateHoleInTunelWall,}
    placeDoor,
    PlaceDoorToRoom,
    randomTransparent,
{    randomGoal,}
 {   HallEvent,}
    randomKeyPlace        :single;

    MaxVisibleX,MaxVisibleY:integer;

    acessFree:word;

    i,j,k,l:integer;

    t:tunel;

    flg:boolean;

    inX,InY,
    toX,toY:byte;
    x1,y1,x2,y2,lx,ly:integer;

    str1:string;

    m:man;

    restart,
    newKeyTaken,
    centered,
    AlwaysUncentered,
    Mapchanged
                  :boolean;
    closeArea
                  :byte;

    sn,cs:array[1..MaxGrad] of integer;

    computerSpeed:comp;
    OLd46c:longInt;

{-----------------------------------------------------------------------}
{-----------------------------------------------------------------------}
{-----------------------------------------------------------------------}
Procedure SetGraficMode(gm:byte);
var GraphDriver : integer;
    GraphMode   : integer;
    ErrorCode   : integer;
begin
  Graphdriver :=installUserDriver('svga256',nil);
  Graphdriver :=16;
  GraphMode:=gm;
  InitGraph(GraphDriver,GraphMode,'c:\tp7\bgi\');
end;
{-----------------------------------------------------------------------}
procedure createTable;far;
begin
 for i:=1 to MaxGrad do begin
   sn[i]:=round(acc*sin(2*pi*i/MaxGrad));
   cs[i]:=round(acc*cos(2*pi*i/MaxGrad));
 end
end;{}
{-----------------------------------------------------------------------}
var nx,ny,ij:integer;

     currentV:byte;
     jj:shortInt;
procedure check;
begin
     if (nx>0) and (ny>0) and (nx<=MaxX) and (ny<=MaxY) then begin

{        for ii:=-1 to 1 do
          for kk:=-1 to 1 do if jj<MaxSee then begin
            nx:=round(xi+ii*dx);
            ny:=round(yi+kk*dx);
            if (Map^[nx,ny]<>Roomfree) and (Map^[nx,ny]<>free) and (Map^[nx,ny]<>look) then jj:=MaxSee+1;
        end;


       nx:=round(xi);
       ny:=round(yi);
        if (jj<MaxSee) or ((Map^[nx,ny]<>Roomfree) and (Map^[nx,ny]<>free) and (Map^[nx,ny]<>look)) then}


      if V^[nx,ny]<currentV then begin
        R^[nx,ny]:=1;
        V^[nx,ny]:=currentV
      end;

      if (Map^[nx,ny]<>Roomfree) and (Map^[nx,ny]<>free) and (Map^[nx,ny]<>look) then jj:=MaxSee+1;

     end else jj:=MaxSee;

end;

{-----------------------------------------------------------------------}
procedure Man.LookAround;
const dx=0.3;
var ii:shortInt;
    llx,lly:byte;

    xi,yi:single;
{    kk:shortInt;}
begin
{ for ii:=-1 to 1 do if (x+ii>0) and (x+ii<=maxX) then
   for jj:=-1 to 1 do if (y+jj>0) and (y+jj<=maxY) then if (v^[x+ii,y+jj]=0)
     and ( ((ii=0)or(jj=0)) or (((map^[x+ii,y]=free)or (map^[x,y+jj]=free)) or
                                ((map^[x+ii,y]=RoomFree)or (map^[x,y+jj]=RoomFree))) )then begin
     v^[x+ii,y+jj]:=1;
     R^[x+ii,y+jj]:=1;
     if Map^[x+ii,y+jj]=look then begin
       llx:=x;lly:=y;
       x:=x+ii;y:=y+jj;
       LookAround;
       x:=llx;y:=lly
     end;
   end;}

      if V^[x,y]<MaxV then begin
        R^[x,y]:=1;
        V^[x,y]:=MaxV
      end;

{ V^[x,y]:=1;}
{ if map^[x,y]<>smoke then}
 for ij:=1 to MaxGrad do begin
   jj:=1;
   nx:=x;
   ny:=y;
   repeat
{     xi:=
     yi:=y+jj*cs[ij];}

     lx:=nx;
     ly:=ny;

     nx:=x+(jj*sn[ij])div acc;
     ny:=y+(jj*cs[ij])div acc;

     currentV:=(MaxV*(MaxSee-jj)) div MaxSee;
     if jj=1 then currentV:=MaxV;

     if (nx<>lx) and (ny<>ly) then begin
       llx:=nx;
       nx:=lx;
       check;
       nx:=llx;

       lly:=ny;
       ny:=ly;
       check;
       ny:=lly;
     end;

     if jj<MaxSee then check;

     inc(jj);
   until jj>MaxSee;
 end;

end;
{-----------------------------------------------------------------------}
var xx1,yy1,iii:integer;

procedure Man.MoveMe(dx,dy:shortint);
begin
 xx1:=x+dx;
 yy1:=y+dy;
 if (xx1>0) and (yy1>0) and (xx1<=MaxX) and (yy1<=MaxY) then begin
   R^[x,y]:=1;
   if (map^[xx1,yy1]=smoke) or(map^[xx1,yy1]=free) or (map^[xx1,yy1]=Roomfree)
                            or(map^[xx1,yy1]=doorU)or (map^[xx1,yy1]=doorOpen) then begin
     inc(x,dx);
     inc(y,dy);
     MapChanged:=true;

  if closeArea>0 then
    for i:=1 to MaxY do
      for j:=1 to MaxX do if (V^[j,i]>1) or ((V^[j,i]=1)and(CloseArea>1)) then begin
        if closeArea<3 then dec(V^[j,i]) else V^[j,i]:=0;
        R^[j,i]:=1;
    end;{}

   end else begin
     if (map^[xx1,yy1]>doorU) and (map^[xx1,yy1]<=doorU+keysN) then begin
       if kl[map^[xx1,yy1]-doorU].exist=false then begin
         map^[xx1,yy1]:=doorOpen;
         inc(x,dx);
         inc(y,dy);
         MapChanged:=true;
       end;
     end;

     if (Map^[xx1,yy1]=stairsDown) then begin
       MapChanged:=true;
       setFillStyle(1,100);
       if symbolSize>3 then bar(8,10*TileY,38*16,11*TileY-1)
                       else bar(8,10*TileY,38* 8,11*TileY-1);
       setColor(190);
       if symbolSize>3 then setTextstyle(0,0,2) else setTextstyle(0,0,1);
       outTextXY(8,10*TileY,'Do you wish to leave this level?(Y/N)');
       setTextstyle(0,0,0);
       iii:=0;
       repeat
         Rkey;
         if key1<>#0 then
         case key of
           'y','Y':restart:=true;
           'n','N':begin
                     setFillStyle(1,0);
                     bar(8,10*TileY,37*16,11*TileY-1);

                     yy1:={25*8 div TileY+1}11;
                     if (yy1<=MaxY) {and (yy1>0)} then begin
                       for xx1:=1 to 37*2+1 do begin
                         iii:=xx1*8 div TileX+1;
                         if iii<=MaxX then
                           R^[iii,yy1]:=1;
                       end;
                     end;
                     iii:=1;
                   end;
         end;
       until (iii>0) or (restart=true);
     end;

   end;
   for iii:=1 to keysN do if (kl[iii].exist=true) and (x=kl[iii].x) and (y=kl[iii].y) then begin
     newKeyTaken:=true;
     if iii=73 then KeySymbolSize:=3;{up to 150 keys}
     kl[iii].exist:=false;
   end;
   R^[x,y]:=1;
 end;
 lookAround
end;
{-----------------------------------------------------------------------}
{-----------------------------------------------------------------------}
{-----------------------------------------------------------------------}
function out(in1:byte):char;
var Ch:char;
begin
 case in1 of
    1:ch:='1';
    2:ch:='2';
    3:ch:='3';
    4:ch:='4';
    5:ch:='5';
    6:ch:='6';
    7:ch:='7';
    8:ch:='8';
    9:ch:='9';
   10:ch:='a';
   11:ch:='b';
   12:ch:='c';
   13:ch:='d';
   14:ch:='e';
   15:ch:='f';
   16:ch:='g';
   17:ch:='h';
   18:ch:='i';
   19:ch:='j';
   20:ch:='k';
   21:ch:='l';
   22:ch:='m';
   23:ch:='n';
   24:ch:='o';
   25:ch:='p';
   26:ch:='r';
   27:ch:='q';
   28:ch:='s';
   29:ch:='t';
   30:ch:='v';
   31:ch:='u';
   32:ch:='w';
   33:ch:='x';
   34:ch:='y';
   35:ch:='z';
   36:ch:='0';

   37:ch:='A';
   38:ch:='B';
   39:ch:='D';
   40:ch:='E';
   41:ch:='F';
   42:ch:='G';
   43:ch:='H';
   44:ch:='L';
   45:ch:='M';
   46:ch:='N';
   47:ch:='R';
   48:ch:='Q';
   49:ch:='T';
   50:ch:='U';
   51:ch:='W';
   52:ch:='Y';

   53:ch:='¡';
   54:ch:='¦';
   55:ch:=#241;{©®}
   56:ch:='©';
   57:ch:='«';
   58:ch:='­';
   59:ch:='¯';
   60:ch:='ä';
   61:ch:='ë';
   62:ch:='æ';
   63:ch:='ç';
   64:ch:='è';
   65:ch:='ì';
   66:ch:='í';
   67:ch:='î';
   68:ch:='ï';
   69:ch:='õ';
   70:ch:='ó';

   71:ch:='ˆ';
   72:ch:='”';
   73:ch:='„';
   74:ch:='š';

   75:ch:='%';
   76:ch:='$';
   77:ch:='þ';
   78:ch:='û';
   79:ch:='÷';
   80:ch:='{';
   81:ch:='}';
   82:ch:='[';
   83:ch:=']';
   84:ch:='(';
   85:ch:=')';
   86:ch:='+';
   87:ch:='\';
   88:ch:='/';
   89:ch:='?';
   90:ch:='&';
   91:ch:='^';
   92:ch:='@';
   93:ch:='ü';
   94:ch:='ø';
      {border Symbols}
   95:ch:='È';
   96:ch:='É';

   97:ch:='Ê';
   98:ch:='Ë';

   99:ch:='Ì';
  100:ch:='¹';

  101:ch:='Á';
  102:ch:='×';
  103:ch:='Í';
      {special symbols}
  104:ch:='';
  105:ch:=#1;
  106:ch:=#2;
  107:ch:=#3;
  108:ch:=#4;
  109:ch:=#5;
  110:ch:=#14;
  111:ch:=#15;
  112:ch:=#19;
  113:ch:=#20;
      {point direct}
  114:ch:=#16{r};
  115:ch:=#17{l};
  116:ch:=#30{u};
  117:ch:=#31{d};
      {arrows}
  118:ch:=#24{u};
  119:ch:=#25{d};
  120:ch:=#26{r};
  121:ch:=#27{l};
  122:ch:=#29{l-r};
  123:ch:=#18{u-d};

 end;
 out:=ch;
end;
{-----------------------------------------------------------------------}
var xn,yn,xm,ym,xnn,ynn:integer;
    grad:byte;
    cX,cy:integer;
procedure DrawTile;
begin
{     if r^[j,i]<255 then}
     case map^[j,i] of
       free:begin
                   setFillStyle(6,grad div 5);
                   bar(xn,yn,xm,ym);
                 end;
       Roomfree:begin
                   setFillStyle(4,grad div 5);
                   bar(xn,yn,xm,ym);
                 end;
       wall,superWall:begin
                   setFillStyle(1,grad div 2);
                   bar(xn{+1},yn{+1},xm{-1},ym{-1});
{                   recTangle(xn,yn,xm,ym);}
                 end;
{       door     :write('D');{*}
       look     :begin
                   setFillStyle(7,grad div 2);
                   bar(xn,yn,xm,ym);
                 end;

       stairsUp :begin
                   setFillStyle(1,64+grad div 2);
                   bar(xn,yn,xm,ym);
                   setColor(128+grad);
                   outTextXY(xnn,ynn,#24)
                 end;
      stairsDown:begin
                   setFillStyle(1,64+grad div 2);
                   bar(xn,yn,xm,ym);
                   setColor(128+grad);
                   outTextXY(xnn,ynn,#25)
                  end;
       smoke    :begin
                   setFillStyle(9,grad div 3);
                   bar(xn,yn,xm,ym);
                 end;

       doorOpen :begin
                   setFillStyle(1,0);
                   bar(xn,yn,xm,ym);
                   setColor(grad div 3);
                   outTextXY(xnn,ynn,'*');
                 end;
       doorU    :begin
                   setFillStyle(1,0);
                   bar(xn,yn,xm,ym);
                   setColor(grad div 3);
                   outTextXY(xnn,ynn,'#');
                 end;
 doorU+1..doorU+MaxMaxKeys
                :begin
                   setFillStyle(1,0);
                   bar(xn,yn,xm,ym);
{                   setColor(194+round(grad*0.9));
                   outTextXY(xnn,ynn,Out(map^[j,i]-doorU));}
                 end;
        else begin
          setFillStyle(1,250);
          bar(xn,yn,xm,ym);
        end
     end;


     if (Map^[j,i]<>wall) and (Map^[j,i]<>SuperWall) then begin
       setColor(grad);
       if (j>1) and (j<MaxX) then begin
         if (map^[j-1,i]=wall) or (map^[j-1,i]=SuperWall) then
           Line(xn,yn,xn,ym);
         if (map^[j+1,i]=wall) or (map^[j+1,i]=SuperWall) then
           Line(xm,yn,xm,ym);
       end;
       if (i>1) and (i<MaxY) then begin
         if (map^[j,i-1]=wall) or (map^[j,i-1]=SuperWall) then
           Line(xn,yn,xm,yn);
         if (map^[j,i+1]=wall) or (map^[j,i+1]=SuperWall) then
           Line(xn,ym,xm,ym);
       end;
       if (Map^[j,i]>doorU) and (map^[j,i]<=doorU+MaxMaxKeys) then begin
         setColor(194+round(grad*0.9));
         outTextXY(xnn,ynn,Out(map^[j,i]-doorU));
       end
     end;
end;
{-----------------------------------------------------------------------}
procedure DrawPlayer;
begin
 xnn:=((2*(m.x-cx)-1)*tileX-1) div 2-SymbolSize;
 ynn:=((2*(m.y-cy)-1)*tiley-1) div 2-SymbolSize;
 if centered=false then begin
   setFillStyle(1,0);
   bar(xnn-1,ynn-1,xnn+2*(SymbolSize+1),ynn+2*(SymbolSize+1));
 end;
 setColor(255);
 outTextXY(xnn,ynn,'*');
 outTextXY(xnn,ynn,'³');
end;
{-----------------------------------------------------------------------}
procedure ShowMap;
var
   maxScreenX,MaxScreenY:integer;
   xStart,xEnd,
   yStart,yEnd:integer;
begin
 setTextStyle(0,0,(symbolSize+1) div 4);
 MaxScreenX:=(MaxVisibleX)*TileX;
 MaxScreenY:=ScreenY;

 if centered=true then begin
   cx:=0;cy:=0;
 end else begin
   cx:=m.x-MaxVisibleX div 2;cy:=m.y-MaxVisibleY div 2;
   for i:=1 to MaxY do
     for j:=1 to MaxX do R^[j,i]:=1;
 end;

if centered=false then begin
 {player}
 R^[m.x,m.y]:=0;
 drawPlayer;
end;

 for i:=1 to MaxY do
   for j:=1 to MaxX do if (R^[j,i]>0) then begin


     xn:=(j-1-cx)*tileX;
     yn:=(i-1-cy)*tileY;
     xm:=(j-cx)*tileX-1;
     ym:=(i-cy)*tileY-1;

     xnn:=(xn+xm) div 2-symbolSize;
     ynn:=(yn+ym) div 2-symbolSize;
     grad:=round(63*V^[j,i]/MaxV);
     if V^[j,i]=1 then grad:=1;

   if (xn>=0) and (yn>=0) and (xn<MaxScreenX) and (yn<MaxScreenY) then begin
     if (V^[j,i]>0) or ((centered=false) and (CloseArea>1)) then begin
        DrawTile;
     end else begin
       setFillStyle(9,254);
       bar(xn,yn,xm,ym);
     end
   end;
     R^[j,i]:=0;
  end;

 {player}
 if centered=true then DrawPlayer
 else begin
   xStart:=      -cx*TileX-1; if xStart<0        then xStart:=0;   {cutBorders}
   yStart:=      -cy*TileY-1; if yStart<0        then yStart:=0;
   xEnd  :=(MaxX-cx)*tileX  ; if xEnd>MaxScreenX then xEnd  :=MaxScreenX;
   yEnd  :=(MaxY-cy)*tileY  ; if yEnd>MaxScreenY then yEnd  :=MaxScreenY;
   if closeArea>1 then setFillStyle(1,0) else setFillStyle(9,254);

   if xStart>0 then bar(0,0,xStart,MaxScreenY);
   if xEnd<MaxScreenX then bar(xEnd,0,MaxScreenX,MaxScreenY);

   if yStart>0 then bar(xStart,0,xEnd,yStart);
   if yEnd<MaxScreenY then bar(xStart,yEnd,xEnd,MaxScreenY);
 end;


 {keys}
 j:=1;
 setFillStyle(1,0);

 for i:=1 to KeysN do if (V^[kl[i].x,kl[i].y]>0) or (kl[i].exist=false) then begin
   flg:=true;
   if (kl[i].exist=true) then begin
       setTextStyle(0,0,(symbolSize+1) div 4);
       xnn:=((2*(kl[i].x-cx)-1)*tileX-1) div 2-SymbolSize;
       ynn:=((2*(kl[i].y-cy)-1)*tiley-1) div 2-SymbolSize;
       if (xnn>=0) and (ynn>=0) and (xnn<MaxScreenX) and (ynn<MaxScreenY) then
          setColor(64+round(63*V^[kl[i].x,kl[i].y]/MaxV))
       else flg:=false
     end
   else
     if newKeyTaken=true then begin
       setTextStyle(0,0,(KeySymbolSize+1) div 4);
       setColor(127);
       xnn:=(MaxVisibleX+1)*tileX;
       ynn:=   (j-1)*(KeySymbolSize+1)*2;
       if ynn>=600-(KeySymbolSize+1)*3 then begin
         xnn:=(MaxVisibleX)*tileX;
         ynn:= (j)*(KeySymbolSize+1)*2-600+1;
       end;
       inc(j);
       bar(xnn,ynn,xnn+(KeySymbolSize+1)*2,ynn+(KeySymbolSize+1)*2);

     end else flg:=false;

   if flg=true then
     outTextXY(xnn,ynn,out(i));
 end;

 MapChanged:=false;
 newKeyTaken:=false;
 setTextStyle(0,0,0);
end;
{-----------------------------------------------------------------------}
{-----------------------------------------------------------------------}
  {-------------------------------------------------------------------}
{-----------------------------------------------------------------------}
{-----------------------------------------------------------------------}
procedure Tunel.DigMe;
var doorCount{,ll}:byte;
begin
{ if (sx-mx<=MaxX) and (sx-mx>0) and (sy-my<=MaxY) and (sy-my>0) and (random<1e-1) then Map^[sx-mx,sy-my]:=wall;}

 doorCount:=0;
 x1:=sx;
 y1:=sy;
 i:=0;

{ if (mx<>0) or (my<>0) then}
  repeat
    inc(i);
    lx:=x1;
    ly:=y1;
{    x1:=x1+mx;
    y1:=y1+my;}
    inc(x1,mx);
    inc(y1,my);
{    if (x1>1) and (x1<MaxX) and (y1>1) and (y1<MaxY) then begin}
      if (map^[x1,y1]=dig) or (map^[x1,y1]=door) or (map^[x1,y1]=free) then begin
        if map^[x1,y1]=door then begin
          inc(doorCount);
          if doorCount>MaxDoorCount then map^[x1,y1]:=free;
        end;
        if (map^[x1,y1]<>door) or (random<1e-2) then map^[x1,y1]:=free;
        x2:=x1;
        y2:=y1;
        if mx<>0 then begin
          if map^[lx,y1+1]=dig then map^[lx,y1+1]:=wall;
          if map^[lx,y1-1]=dig then map^[lx,y1-1]:=wall;
        end else begin
          if map^[x1+1,ly]=dig then map^[x1+1,ly]:=wall;
          if map^[x1-1,ly]=dig then map^[x1-1,ly]:=wall;
        end;
        if (i>1) and (i<n) and (random<PlaceDoor*(MaxDoorCount-doorCount)) and (doorCount<MaxDoorCount) then begin
          inc(doorCount);
          map^[lx,ly]:=door;
        end;
      end else i:=n;
{    end;}
  until i=n;

{ doorCount:=0;
{  if random<HallEvent then begin
    ll:=0;
    repeat
    inc(ll);
    for lx:=x1-ll to x1+ll do if (lx>1) and (lx<MaxX) then
      for ly:=y1-ll to y1+ll do if (ly>1) and (ly<MaxY)then
        if (Map^[lx  ,ly]=dig) and
          ((Map^[lx+1,ly]=free) or (Map^[lx,ly+1]=free) or
           (Map^[lx-1,ly]=free) or (Map^[lx,ly-1]=free))
             then begin
               inc(DoorCount);
               if (doorCount<MaxHallSACE) and
                ((lx>x1-MaxhallSize)and(lx<x1+MaxhallSize)and
                 (ly>y1-MaxhallSize)and(ly<y1+MaxhallSize))
               then
                 Map^[lx,ly]:=free
               else
                 Map^[lx,ly]:=wall

              end;
    until ll>=MaxHallSize;
    Map^[x2,y2]:=free;
  end;}

end;
{-----------------------------------------------------------------------}
var mm,nn:byte;
procedure CheckAcess;
var sum:word;
begin
r^:=v^;{assign Temp map}
v^:=Map^;
mm:=1;{search Radius X}
nn:=1;{ - " -        Y}
V^[InX,InY]:=acess;
acessFree:=0;
repeat
  sum:=0;
  for x1:=InX-mm to InX+mm do if (x1>1) and (x1<maxX) then
    for y1:=InY-nn to InY+nn do if (y1>1) and (y1<maxY) then begin
      if (V^[x1,y1]=free) or (V^[x1,y1]=RoomFree) or ((V^[x1,y1]>=DoorU) and (V^[x1,y1]<=DoorU+KeysN)) then begin
        if (V^[x1+1,y1  ]=acess) or
           (V^[x1-1,y1  ]=acess) or
           (V^[x1  ,y1+1]=acess) or
           (V^[x1  ,y1-1]=acess) then begin
                                      if (V^[x1,y1]=free) or (V^[x1,y1]=Roomfree) then inc(acessFree);
                                      V^[x1,y1]:=acess;
                                      inc(sum);
                                    end;
    end;
  end;
  if mm<MaxX then inc(mm);{to accelerate}
  if nn<MaxY then inc(nn)
until sum=0;
end;
{--------}
procedure CreateMap;
var sum,tm1:integer;
    ii:longint;
    count,c0:integer;

    kk,ll:word;

    currentTextX,currentTextY:integer;

    div1,ll1:word;
begin
restart:=false;
clearDevice;
setColor(47);
setFillStyle(1,0);
outTextXY(1,0,'Starting...');

 MaxVisibleX:=screenX div TileX-2;
 MaxVisibleY:=ScreenY div Tiley;

if alwaysUncentered=true then centered:=false;

KeySymbolSize:=7;

circles:=round(MaxX*(MaxY/5));

currentTextY:=8;
currentTextX:=0;
repeat
{-----------------------Start data--------------------------------------}

for i:=1 to MaxY do
  for j:=1 to MaxX do if (i>1) and (j>1) and (i<MaxY) and (j<MaxX) then
                      Map^[j,i]:=dig else
                      Map^[j,i]:=wall;

i:=trunc(random*4);
if random>0.5 then entr:=surface else entr:=level;
if entr=level then begin
  inX:=round(random*(maxX-8))+4;
  inY:=round(random*(maxY-8))+4;
  for i:=-1 to 1 do
    for j:=-1 to 1 do map^[j+inX,i+inY]:=superWall;
  case i of
    0:map^[InX+1,InY]:=free;
    1:map^[InX-1,InY]:=free;
    2:map^[InX,InY+1]:=free;
    else map^[InX,InY-1]:=free;
  end;

end else begin
  case i of
    0:begin inX:=   1; inY:=round(random*(MaxY-4))+2 end;
    1:begin inX:=MaxX; inY:=round(random*(MaxY-4))+2 end;
    2:begin inY:=   1; inX:=round(random*(MaxX-4))+2 end;
    else begin inY:=MaxY; inX:=round(random*(MaxX-4))+2 end;
  end;
end;
map^[InX,InY]:=stairsUp;
x2:=inX;
y2:=inY;
{-------------------------Tunnels Part----------------------------------}
outTextXY(CurrentTextX,currentTextY,'Tunneling...');
div1:=circles div 100+1;
ll1:=0;
for ll:=0 to circles do begin

 if ll>ll1 then begin{{{{{{{{{{{{{{{{}
   str((100*(ll/circles)):3:0,str1);
   bar(CurrentTextX+13*8,currentTextY,currentTextX+17*8,currentTextY+7);
   outTextXY(currentTextX+13*8,currentTextY,str1+'%');
   inc(ll1,div1);
 end;{{{{{{{{{{{{{{{{{{}

 for k:=1 to 40 do with t do begin
  sx:=x2;
  sy:=y2;{x2,y2 - set inside 'digMe'}

  repeat
    if random>0.5 then begin
      mx:=round(random*2)-1;
      my:=0;
    end
    else begin
      mx:=0;
      my:=round(random*2)-1;
    end;
  until (mx<>0) or (my<>0);
  n:=round(random*(MaxTunnelLenghth-1))+1;

  digMe;
 end;

 x2:=0;
 for i:=2 to MaxY-1 do
   for j:=2 to MaxX-1 do if Map^[j,i]=dig then
     Begin
       if (Map^[j+1,i]=free) then begin
         x2:=j+1;
         y2:=i;
         break
       end else
       if (Map^[j-1,i]=free) then begin
         x2:=j-1;
         y2:=i;
         break
       end else
       if (Map^[j,i+1]=free) then begin
         x2:=j;
         y2:=i+1;
         break
       end else
       if (Map^[j,i-1]=free) then begin
         x2:=j;
         y2:=i-1;
         break
       end;
     end;

  if x2=0 then break
{ for i:=2 to MaxY-1 do
   for j:=2 to MaxX-1 do
      if (Map^[j,i]=wall)and (random<CreateHoleInTunelWall) then Map^[j,i]:=dig}

{ end;}
end;
bar(currentTextX+13*8,currentTextY,currentTextX+17*8,currentTextY+7);
outTextXY(currentTextX+13*8,currentTextY,'100%');
inc(currentTextY,8);

 kk:=0;
 for i:=2 to MaxY-1 do
   for j:=2 to MaxX-1 do if (Map^[j,i]=dig) then inc(kk);

if kk>MaxX*MaxY/3 then begin
  outTextXY(CurrentTextX,currentTextY,'Error!');
  inc(currentTextY,8);
end;

if currentTextY>ScreenY-4*8 then begin
  currentTextY:=1;
  inc(CurrentTextX,22*8);
  if CurrentTextX+21*8>=ScreenX then begin
    clearViewPort;
    CurrentTextX:=0;
  end;
end;

until kk<=MaxX*MaxY/3;
{------destroy incorrect doors----------------------------------}{writeLn('Correcting doors...');}
 for i:=2 to MaxY-1 do
   for j:=2 to MaxX-1 do if Map^[j,i]=door then begin
     k:=0;
     if {(Map^[j+1,i]=door) or} (Map^[j+1,i]=free) then inc(k);
     if {(Map^[j-1,i]=door) or} (Map^[j-1,i]=free) then inc(k);
     if {(Map^[j,i+1]=door) or} (Map^[j,i+1]=free) then inc(k);
     if {(Map^[j,i-1]=door) or} (Map^[j,i-1]=free) then inc(k);

     if (Map^[j+1,i]=door) or (Map^[j-1,i]=door) or
        (Map^[j,i+1]=door) or (Map^[j,i-1]=door) then map^[j,i]:=0;
     if k>2 then map^[j,i]:=0;
   end else
   if Map^[j,i]=SuperWall then map^[j,i]:=wall;

  if Inx>1 then
    if map^[Inx-1,Iny]=door then map^[inx-1,iny]:=free;
  if Iny>1 then
    if map^[Inx,Iny-1]=door then map^[inx,iny-1]:=free;
  if Inx<MaxX then
    if map^[inx+1,iny]=door then map^[inx+1,iny]:=free;
  if iny<MaxY then
    if map^[inx,iny+1]=door then map^[inx,iny+1]:=free;
{showMap;}
{-------------------------Create rooms------------------------------------}
outTextXY(CurrentTextX,currentTextY,'Creating rooms...');
inc(currentTextY,8);
for i:=2 to MaxY-1 do
  for j:=2 to MaxX-1 do if map^[j,i]=dig then begin
{     k:=0;
     if (Map^[j+1,i]=wall) then inc(k);
     if (Map^[j-1,i]=wall) then inc(k);
     if (Map^[j,i+1]=wall) then inc(k);
     if (Map^[j,i-1]=wall) then inc(k);
     if k=4 then begin{single place room}
{       k:=0;
       l:=0;
       if (Map^[j+1,i+1]=wall) and (Map^[j+1,i-1]=wall) and (j+1<MaxX) then k:= 1 else
       if (Map^[j-1,i+1]=wall) and (Map^[j-1,i-1]=wall) and (j-1>1   ) then k:=-1 else
       if (Map^[j+1,i+1]=wall) and (Map^[j-1,i+1]=wall) and (i+1<MaxY) then l:= 1 else
       if (Map^[j+1,i-1]=wall) and (Map^[j-1,i-1]=wall) and (i-1>1   ) then l:=-1;

       if (l<>0) or (k<>0) then begin
         if (map^[j+2*k,i+2*l]=free) or (map^[j+2*k,i+2*l]=roomFree) then begin
           map^[j,i]:=Roomfree;
           map^[j+k,i+l]:=door;
         end;
       end
       else Map^[j,i]:=Wall;

     end{single place room}
{     else{ if flg=false then}
{     begin{macro room}
      {1.search for whole room--------------}
       map^[j,i]:=tmp;
       tm1:=1;{search radius}
{       count:=0; room size}
       repeat
         sum:=0;
         flg:=false;
         for x1:=j-tm1 to j+tm1 do if (x1>1) and (x1<maxX) then
           for y1:=i-tm1 to i+tm1 do if (y1>1) and (y1<maxY) then
              if (map^[x1,y1]=dig) and
                ((map^[x1+1,y1]=tmp) or (map^[x1,y1+1]=tmp) or
                 (map^[x1-1,y1]=tmp) or (map^[x1,y1-1]=tmp)) then begin
                map^[x1,y1]:=tmp;
{               if (x1=j+tm1) or (y1=j+tm1) or (x1=j-tm1) or (y1=j-tm1) then flg:=true;{}
                inc(sum);
              end;
{        if flg=true then {}inc(tm1);
{         count:=count+sum;}
       until sum=0;
      {2.place a door------------------------}
      {make sure door leads to 'free' or 'roomFree'}
       flg:=false;
       ii:=0;
       repeat
         inc(ii);
         x1:=round(random*(maxX-3))+2;
         y1:=round(random*(maxY-3))+2;

         if (map^[x1,y1]=wall) then begin
           k:=0;
           l:=0;
           if map^[x1+1,y1]=tmp then k:=-1 else
           if map^[x1-1,y1]=tmp then k:=+1 else
           if map^[x1,y1+1]=tmp then l:=-1 else
           if map^[x1,y1-1]=tmp then l:=+1;

           if (k<>0) or (l<>0) then begin
             if k=0 then begin
               if (map^[x1+1,y1]=wall) and (map^[x1-1,y1]=wall) then flg:=true;
             end
             else begin
               if (map^[x1,y1+1]=wall) and (map^[x1,y1-1]=wall) then flg:=true;
             end;
             if (map^[x1+k,y1+l]<>Roomfree) and (map^[x1+k,y1+l]<>free) then flg:=false;
{{{{{{{{{{{{{{}
{             if (flg=true) and (random<5e-1) then begin
               Map^[x1,y1]:=free;
               flg:=false;
             end;
{{{{{{{{{{{{{{}
           end;
        end;
      until (flg=true) or (ii>64000);
{?}   if flg=false then k:=superWall else begin
         k:=roomFree;
         if random<PlaceDoorToRoom then l:=door else l:=free;
         Map^[x1,y1]:=l;{}
       end;
      {2.make room `RoomFree`----------------}
       for x1:=2 to maxX-1 do
         for y1:=2 to maxY-1 do
           if Map^[x1,y1]=tmp then Map^[x1,y1]:=k
{             begin
               if random>(count-10)/(count+10) then Map^[x1,y1]:=k else
                 begin
                   dec(count);
                   Map^[x1,y1]:=wall;
                 end;
             end;}
{     end;{macro room}
  end;
{-----------------------Set Up doors keys---------------------------------}

{
if Inx>   1 then if map^[InX-1,InY]=door then map^[InX-1,InY  ]:=doorU;
if Iny>   1 then if map^[InX,InY-1]=door then map^[InX  ,InY-1]:=doorU;
if Inx<maxX then if map^[InX+1,InY]=door then map^[InX+1,InY  ]:=doorU;
if Iny>MaxY then if map^[InX,InY+1]=door then map^[InX  ,InY+1]:=doorU;}

{1.scan reachable area}
{Map^[inX,InY]:=free;}
{if door reached from 2 sides - unlocked}
{4.place a key (pref. in a deadend or a room corner)}
{5.assign a door to a key (pref. far away)}
{6.scan NEW reachable area}
{7.repeat 4}
outTextXY(CurrentTextX,currentTextY,'Creating Keys...');
KeysN:=0;

count:=0;
for j:=2 to MaxX-1 do
 for i:=2 to MaxY-1 do if (Map^[j,i]=door) then inc(count);


{unlocked doors}
if count>MaxKeys then
for j:=2 to MaxX-1 do
  for i:=2 to MaxY-1 do if (Map^[j,i]=door) and (random<((count-MaxKeys)/count)/2{*2e-2})
                       then begin
                          dec(count);
                          Map^[j,i]:=doorU;
                       end;
c0:=count;
ll1:=CurrentTextX+17*8;
div1:=CurrentTextX+21*8;
repeat
 str((100*(1-count/c0)):3:0,str1);
 bar(ll1,currentTextY,div1,currentTextY+7);
 outTextXY(ll1,currentTextY,str1+'%');

  CheckAcess;
{  sum:=0;}
  flg:=true;
  count:=0;
  for i:=2 to MaxY-1 do
    for j:=2 to MaxX-1 do if Map^[j,i]=door then begin
      inc(count);
      k:=0;
      if V^[j-1,i  ]=acess then inc(k);
      if V^[j+1,i  ]=acess then inc(k);
      if V^[j  ,i-1]=acess then inc(k);
      if V^[j  ,i+1]=acess then inc(k);
      if k>=2 then begin
        V^[j,i]:=acess;
        Map^[j,i]:=doorU;
      end
      else if (k=1) and (acessFree-KeysN<2) then begin
        flg:=false;
        Map^[j,i]:=doorU;
      end;
    end;

  {find a door and place a key}
  if (keysN<MaxKeys) and (count>0) then begin
    flg:=false;
    ii:=0;
    repeat
      inc(ii);
      {find a door}
      x1:=round(random*(maxX-3))+2;
      y1:=round(random*(maxY-3))+2;

      if (map^[x1,y1]=door) then begin
{       k:=0;
       if V^[x1-1,y1  ]=acess then inc(k);
       if V^[x1+1,y1  ]=acess then inc(k);
       if V^[x1  ,y1-1]=acess then inc(k);
       if V^[x1  ,y1+1]=acess then inc(k);}

        if (V^[x1+1,y1  ]=acess) or (V^[x1-1,y1  ]=acess) or
           (V^[x1  ,y1+1]=acess) or (V^[x1  ,y1-1]=acess) then begin
          flg:=false;
          repeat
            {place a key}
            x2:=round(random*(maxX-3))+2;
            y2:=round(random*(maxY-3))+2;
            if ((Map^[x2,y2]=free) or (Map^[x2,y2]=Roomfree)) then begin
              if (V^[x2,y2]=acess) then
                if (R^[x2,y2]<>acess) or (random<randomKeyPlace) then flg:=true;

              if (KeysN>0) and (flg=true) then
                for i:=1 to KeysN do if (x2=kl[i].x) and (y2=kl[i].y) then flg:=false;
            end;
          until flg=true;
          inc(KeysN);
          kl[KeysN].exist:=true;
          kl[KeysN].x:=x2;
          kl[KeysN].y:=y2;
          Map^[x1,y1]:=doorU+keysN;
{          V^[x1,y1]:=acess;}
        end;
      end;
    until (flg=true) or (ii>64000);
    if flg=true then begin
      {find other "similar" doors}
      V^[x1,y1]:=acess0;
      k:=1;
      repeat
        sum:=0;
        for x2:=X1-k to X1+k do if (x2>1) and (x2<maxX) then
          for y2:=Y1-k to Y1+k do if (y2>1) and (y2<maxY) then begin
            if (V^[x2,y2]=free) or (V^[x2,y2]=door)or (V^[x2,y2]=doorU) {or (V^[x2,y2]=RoomFree)} then begin
            {mark acess0}
                if (V^[x2+1,y2  ]=acess0) or
                   (V^[x2-1,y2  ]=acess0) or
                   (V^[x2  ,y2+1]=acess0) or
                   (V^[x2  ,y2-1]=acess0) then
                      begin
                        if (V^[x2,y2]=door) {or (V^[x2,y2]=doorU)} and
                          ((V^[x2+1,y2  ]=acess) or
                           (V^[x2-1,y2  ]=acess) or
                           (V^[x2  ,y2+1]=acess) or
                           (V^[x2  ,y2-1]=acess)) then Map^[x2,y2]:=doorU+KeysN;
                        V^[x2,y2]:=acess0;
                        inc(sum);
                      end
            end
          end;
      inc(k);
      until sum=0;

    end;
    flg:=false;
  end;


until flg=true;
bar(CurrentTextX+17*8,currentTextY,CurrentTextX+21*8,currentTextY+7);
outTextXY(CurrentTextX+17*8,currentTextY,'100%');
inc(currentTextY,8);

  for j:=2 to MaxX-1 do
    for i:=2 to MaxY-1 do if (Map^[j,i]=door) then Map^[j,i]:=doorU;

{set goal}
outTextXY(CurrentTextX,currentTextY,'Setting GOAL...');
inc(currentTextY,8);

{??}
dec(keysN);
checkAcess;
inc(keysN);
checkAcess;

{re-write in for...for... : find in a deadend                  done
 if not found then for... : find in a corner
 else - ?????}

{ ii:=0;}
 flg:=false;
 for i:=2 to MaxY-1 do
   for j:=2 to MaxX-1 do if ((Map^[j,i]=free) or (Map^[j,i]=roomFree)) and
                     (V^[j,i]=acess) and (R^[j,i]<>acess) and (flg=false) then begin
{     inc(ii);}
     k:=0;
     l:=0;
     if map^[j-1,i  ]=wall then inc(k);
     if map^[j+1,i  ]=wall then inc(k);
     if map^[j  ,i-1]=wall then inc(l);
     if map^[j  ,i+1]=wall then inc(l);

     if (k+l=3) then begin
       flg:=true;
       x1:=j;
       y1:=i;
     end;
 end;

 if (flg=false){ and (ii>0)} then begin
   ii:=0;
   for i:=2 to MaxY-1 do
     for j:=2 to MaxX-1 do if ((Map^[j,i]=free) or (Map^[j,i]=roomFree)) and
                     (V^[j,i]=acess) and (R^[j,i]<>acess) and (flg=false) then begin
       inc(ii);
       k:=0;
       l:=0;
       x2:=j;
       y2:=i;
       if map^[j-1,i  ]=wall then inc(k);
       if map^[j+1,i  ]=wall then inc(k);
       if map^[j  ,i-1]=wall then inc(l);
       if map^[j  ,i+1]=wall then inc(l);

       if (k=1) and (l=1) then begin
         flg:=true;
         x1:=j;
         y1:=i;
         break
       end;
   end;
   if (ii>0) and (flg=false) then begin
     x1:=x2;
     y1:=y2;
     flg:=true;
   end;
 end;

 toX:=x1;
 toY:=y1;

 Map^[toX,toY]:=stairsDown;

 for x1:=InX-1 to inx+1 do if (x1>1) and (x1<=MaxX) then
   for y1:=InY-1 to inY+1 do if (y1>1) and (y1<=MaxY) then
     if map^[x1,y1]=wall then map^[x1,y1]:=superWall;

 for x1:=ToX-1 to TOx+1 do if (x1>1) and (x1<=MaxX) then
   for y1:=ToY-1 to ToY+1 do if (y1>1) and (y1<=MaxY) then
     if map^[x1,y1]=wall then map^[x1,y1]:=superWall;

 for i:=2 to MaxY-1 do
   for j:=2 to MaxX-1 do if (map^[j,i]>=DoorU) and (map^[j,i]<=DoorU+KeysN) then begin
     if map^[j+1,i  ]=wall then map^[j+1,i  ]:=SuperWall;
     if map^[j-1,i  ]=wall then map^[j-1,i  ]:=SuperWall;
     if map^[j  ,i+1]=wall then map^[j  ,i+1]:=SuperWall;
     if map^[j  ,i-1]=wall then map^[j  ,i-1]:=SuperWall;
   end;
{-------------------Set Up transparent walls------------------------------}
outTextXY(CurrentTextX,currentTextY,'SettingUp TW&S...');
for i:=2 to MaxY-1 do
 for j:=2 to MaxX-1 do {begin}
{?}{ if (map^[j,i]=RoomFree) then map^[j,i]:=free;{?}
 if (random<randomTransparent) and (map^[j,i]=wall) then map^[j,i]:=look;

{end;}

if setSmoke>0 then begin
i:=1;
ii:=0;
repeat
  inc(ii);
  x2:=round(random*(maxX-3))+2;
  y2:=round(random*(maxY-3))+2;
  if (Map^[x2,y2]=free) or (Map^[x2,y2]=roomFree) then begin
    Map^[x2,y2]:=smoke;
    repeat
      sum:=0;
      for x1:=x2-k to x2+k do if (x1>1) and (x1<maxX) then
        for y1:=y2-k to y2+k do if (y1>1) and (y1<maxY) then begin
        if (Map^[x1,y1]=free) or (Map^[x1,y1]=RoomFree) then begin
          if (Map^[x1+1,y1  ]=smoke) or
             (Map^[x1-1,y1  ]=smoke) or
             (Map^[x1  ,y1+1]=smoke) or
             (Map^[x1  ,y1-1]=smoke) then begin
                                      map^[x1,y1]:=smoke;
                                      inc(sum);
                                    end;
          end;
      end;
      inc(k);
    until sum=0;

    inc(i);
  end;
until (i>setSmoke) or (ii>6400);
end;

writeLn('Ending...');
for i:=1 to MaxY do
    for j:=1 to MaxX do begin
      R^[j,i]:=1;
      V^[j,i]:=0
    end;

with m do begin
  x:=inX;
  y:=inY;

  lookAround;
  if x>1 then
    if (map^[x-1,y]<=smoke)then moveMe(-1, 0);
  if (y>1) and (x=inX) and (y=inY) then
    if (map^[x,y-1]<=smoke) then moveMe( 0,-1);
  if (x<MaxX) and (x=inX) and (y=inY) then
    if (map^[x+1,y]<=smoke) then moveMe(+1, 0);
  if (y<MaxY) and (x=inX) and (y=inY) then
    if (map^[x,y+1]<=smoke) then moveMe( 0,+1);

end;

MapChanged:=true;
clearViewPort;
end;
{-------------------------------------------------------------------------}
procedure setUpCustomMap;
const MaxMenu=11;
      MapXMenu=MaxMenu+1;
      MapYMenu=MaxMenu+2;
{      MineSpeed=4826;}
var str1,str2,str3:string[20];
    menu:byte;
    lsymbol:integer;

    {tmp,}Ls:word;

    AddToMaxMenu:byte;

    Calc,c0:single;
begin

{ if computerSpeed=0 then begin
  recTangle(99,129,701,301);
  bar(100,130,700,300);
  outTextXY(150,180,'Wait a second...');
  outTextXY(200,200,'Calculating Computer Speed...');
  for i:=1 to 10 do begin
   old46c:=mem[0:$46c];
   computerSpeed:=0;
   while mem[0:$46c]=old46c do computerSpeed:=computerSpeed+1;
  end;
  ComputerSpeed:=round(ComputerSpeed/10);
 end;}

 menu:=1;
 addToMaxMenu:=0;

 setFillStyle(1,10);
 bar(0,30,getMaxX,getMaxY);

{ setFillStyle(1,30);}
 setTextStyle(0,0,2);

{ setColor(30);
 str(computerSpeed:20:0,str1);
 outTextXY(10,350,'ComputerSpeed:'+str1);}

 setColor(127);
 outTextXY(10,550,'MAP EDITOR: use '+#25+'/'+#24+' to choose menu and');
 outTextXY(10+12*16,570,'+/- to change value, ENTER - start.');
 ls:=0;
 lSymbol:=0;

 repeat
   setColor(50);

   if maxX<MaxY then begin
     if (MaxTunnelLenghth>MaxX div 2) then MaxTunnelLenghth:=MaxX div 2
   end else begin
     if (MaxTunnelLenghth>MaxY div 2) then MaxTunnelLenghth:=MaxY div 2
   end;

   if AlwaysUncentered=false then begin
     maxX:=ScreenX div TileX - 2;
     maxY:=ScreenY div tileY;
   end;

   if (Ls<>MaxX*MaxY) then begin
     bar(410+4*16,30,410+20*16,45);
     str(maxX:3,str1);
     str(MaxY:3,str2);
     ls:=MaxX*MaxY;
     str(ls:5,str3);
     outTextXY(410,30,'Map:'+str1+'x'+str2+'['+str3+'s]');
{     Ls:=MaxX*MaxY;}

{     calc:=ls/1000;
     calc:=(5*sqr(calc)+calc-1)/10;     {labirint Calculation Time}

{     c0:=(sqrt(abs(MaxX-MaxY)-1));
     if c0>0 then
       calc:=calc+calc*c0;              {Increment due to errors}
{     calc:=calc + calc*MaxKeys*0.35/2;  {increment due to keys Generation(crude)}
{     calc:=calc/2;

     calc:=calc*(MineSpeed/ComputerSpeed);
     bar(410,70,410+12*16,85);
     str((round(calc) div 60):2,str1);
     str((round(calc) mod 60):2,str2);
     outTextXY(410,70,'time:appr.'+str1+':'+str2+'s');}
   end;


   if tileX<=tileY then j:=tileX else j:=tileY;
   case j of
      7..15:symbolSize:= 3;
     16..23:symbolSize:= 7;
     24..31:symbolSize:=11;
     32..39:symbolSize:=15;
     40..47:symbolSize:=19;
     else   symbolSize:=23;
   end;

   if lSymbol<>SymbolSize then begin
     case symbolSize of
        3:str1:='Small( 8x 8)';
        7:str1:='LARGE(16x16)';
       11:str1:='HUGE (24x24)';
       15:str1:='SUPER(32x32)';
       19:str1:='  ?  (40x40)';
       23:str1:='  ?  (48x48)';
     end;
     bar(410,50,410+12*16,65);
     outTextXY(410,50,str1+' Symbols');
   end;

   lSymbol:=SymbolSize;


   if menu=1 then setColor(127) else setColor(127+50);
   str(TileX:2,str1);
   bar(5+11*16,30,5+13*16,45);
   outTextXY(5,30,'Tile XSize:'+str1);

   if menu=2 then setColor(127) else setColor(127+50);
   str(TileY:2,str1);
   bar(5+11*16,50,5+13*16,65);
   outTextXY(5,50,'Tile YSize:'+str1);

   if menu=3 then setColor(127) else setColor(127+50);
   str(MaxKeys:2,str1);
   bar(5+9*16,70,5+12*16,85);
   outTextXY(5,70,'Max Keys:'+str1);

   if menu=4 then setColor(127) else setColor(127+50);
   str(MaxV:3,str1);
   bar(5+13*16,90,5+16*16,105);
   outTextXY(5,90,'Memory train:'+str1);
   outTextXY(410,90,'the less, the harder');

   if menu=5 then setColor(127) else setColor(127+50);
   str(SetSmoke:2,str1);
   bar(5+10*16,110,5+12*16,125);
   outTextXY(5,110,'Set Smoke:'+str1);

   if menu=6 then setColor(127) else setColor(127+50);
   str(MaxTunnelLenghth:2,str1);
   bar(5+17*16,130,5+19*16,145);
   outTextXY(5,130,'Max tunnel lenth:'+str1);
   outTextXY(410,130,'recomended >2');

   if menu=7 then setColor(127) else setColor(127+50);
   str(round(PlaceDoor*100):3,str1);
   bar(5+11*16,150,5+14*16,165);
   outTextXY(5,150,'Place door:'+str1+'%');
   outTextXY(410,150,'recomended 3%');

   if menu=8 then setColor(127) else setColor(127+50);
   str(round(placeDoorToRoom*100):3,str1);
   bar(5+19*16,170,5+22*16,185);
   outTextXY(5,170,'Place door to room:'+str1+'%');

   if menu=9 then setColor(127) else setColor(127+50);
   str((RandomTransparent*100):5:1,str1);
   bar(5+18*16,190,5+23*16,205);
   outTextXY(5,190,'Transparent walls:'+str1+'%');

   if menu=10 then setColor(127) else setColor(127+50);
   str(round(randomKeyPlace*100):3,str1);
   bar(5+17*16,210,5+20*16,225);
   outTextXY(5,210,'Random Key Place:'+str1+'%');
   outTextXY(410,210,'recomended 0%');

   if menu=11 then setColor(127) else setColor(127+50);
   if AlwaysUncentered=true then str1:='Yes' else str1:='No';
   bar(5+18*16,230,5+21*16,245);
   outTextXY(5,230,'Always Uncentered:'+str1);
   outTextXY(390,230,'`Yes` Allows ANY map type');

   if AlwaysUncentered=true then begin
     bar(5+11*16,250,5+14*16,285);
     if menu=MapXMenu then setColor(127) else setColor(127+50);
     str(MaxX:3,str1);
     outTextXY(5,250,'Map X-Size:'+str1);
     if menu=MapYMenu then setColor(127) else setColor(127+50);
     str(MaxY:3,str1);
     outTextXY(5,270,'Map Y-Size:'+str1);
   end else begin
     bar(5,250,5+14*16,285);
   end;

   Rkey;

   case key of
     '+','-':begin
               if key='+' then k:=1 else k:=-1;
               case menu of
                 1:if (tileX+k>=8) and (tileX+k<=50) then inc(tileX,k);
                 2:if (tileY+k>=8) and (tileY+k<=50) then inc(tileY,k);
                 3:if (MaxKeys+k>=1) and (MaxKeys+k<=MaxMaxKeys) then inc(MaxKeys,k);
                 4:if (MaxV+k>=3) and (MaxV+k<=254) then inc(MaxV,k);
                 5:if (SetSmoke+k>=0) and (SetSmoke+k<=99) then inc(SetSmoke,k);
                 6:if (MaxTunnelLenghth+k>=1) and
                      (MaxTunnelLenghth+k<=MaxX div 2) and
                      (MaxTunnelLenghth+k<=MaxY div 2) then inc(MaxTunnelLenghth,k);
                 7:if (PlaceDoor+k/100>=0) and (PlaceDoor+k/100<=1) then placeDoor:=placeDoor+k/100;
                 8:if (PlaceDoorToRoom+k/100>=0) and (PlaceDoorToRoom+k/100<=1.001) then
                       placeDoorToRoom:=placeDoorToRoom+k/100;
                 9:if (RandomTransparent+k/1000>=0) and (RandomTransparent+k/1000<=1) then
                       RandomTransparent:=RandomTransparent+k/1000;
                10:if (RandomKeyPlace+k/100>=0) and (RandomKeyPlace+k/100<=1) then
                       RandomKeyPlace:=RandomKeyPlace+k/100;
                11:if alwaysUncentered=false then begin
                     AlwaysUncentered:=true;
                     AddToMaxMenu:=2;
                   end else begin
                     AlwaysUncentered:=false;
                     AddToMaxMenu:=0;
                   end;
          MapXMenu:if ((MaxX+k)*(maxY/2)>=5*11) and (MaxX+k>5) and (MaxX+k<=255) then inc(MaxX,k);
          MapYMenu:if ((MaxY+k)*(maxX/2)>=5*11) and (MaxY+k>5) and (MaxY+k<=255) then inc(MaxY,k);

               end;
             end;
          #0:begin
              if key1=up then begin
                if menu>1 then dec(menu) else menu:=MaxMenu+AddToMaxMenu;
              end else
              if key1=down then begin
                if menu<MaxMenu+AddToMaxMenu then inc(menu) else menu:=1;
              end

             end;
  end;
 until key=enter;
end;
{-------------------------------------------------------------------------}
procedure SetUpMap;
begin
    AlwaysUncentered:=false;

    maxV:=maxV0;

    MaxX:=MaxX0;
    MaxY:=MaxY0;

    tileX:=tileX0;
    tileY:=tileY0;
    symbolSize:=symbol0;{3=8x8; 7=16x16}

    MaxDoorCount:=MaxDoorCount0;
    MaxTunnelLenghth:=MaxTunnelLenghth0;
    MaxKeys:=MaxKeys0;

{    CreateHoleInTunelWall:=CreateHoleInTunelWall0;}
    placeDoor:=placeDoor0;
    PlaceDoorToRoom:=PlaceDoorToRoom0;
    randomTransparent:=randomTransparent0;
    randomKeyPlace:=randomKeyPlace0;
    setSmoke:=setSmoke0;

{    MaxHallSize:=MaxHallSize0;
    HallEvent:=HallEvent0;
    if sqr(MaxHallSize-1)-1>MaxHallSACE0 then
      MaxHallSACE:=MaxHallSACE0
    else
      MaxHallSACE:=sqr(MaxHallSize-1)-1;}

    setFillStyle(1,10);
    bar(0,0,getMaxX,getMaxY);

    setColor(127);
    setTextStyle(0,0,3);
    outTextXY(100,  1,'Welcome to LABIRINT ver 1.44');
    setTextStyle(0,0,2);
    setColor(50);
    outTextXY(100, 31,'Please choose mode(enter - default)');
    setColor(128+50);
    outTextXY(10, 51,'1(default) - 42x33, 20 keys [1386s] LARGE SYMBOLS');
    outTextXY(10, 71,'     2     - 78x60, 47 keys [4680s] Small Symbols');
    outTextXY(10, 91,'     3     - 28x23, 10 keys [ 646s] HUGE  SYMBOLS');
    outTextXY(10,111,'     4     - 55x42, 36 keys [2310s]  Uncentered  ');
    setColor(128+30);
    outTextXY(10,131,'     5     - custom map');

    setColor(50);
    outTextXY(100, 161,'InGame Control Keys:');
    setColor(128+50);
    outTextXY(10, 181,'ArrowKeys: Move player');
    outTextXY(10, 201,'   F10   : Exit game');
    outTextXY(10, 221,'   F9    : Restart map');
    outTextXY(10, 241,'Shift-F9 : This Menu');
    outTextXY(10, 261,'  Alt-D  : `Memory training mode` level 0..3');
    outTextXY(10, 281,'  Alt-C  : Uncentered Lab on/off');


    setColor(50);
    outTextXY(100, 301,'Game Rules:');
    setColor(128+50);
    outTextXY(10, 321,'The goal of the game is to find     ( ),'{exit});
    outTextXY(10, 341,'starting from the         ( ).');
    outTextXY(10, 361,'During your exploration you can meet:');


    {stairs down}
      setFillStyle(1,98);
      bar(10+37*16,321,10+38*16,337);
      setColor(128+63);
      outTextXY(11+37*16,322,#25);
    {stairs Up}
      setFillStyle(1,98);
      bar(10+27*16,341,10+28*16,357);
      setColor(128+63);
      outTextXY(11+27*16,342,#24);
    setColor(50);
    outTextXY(10+32*16,321,'Exit');
    outTextXY(10+18*16,341,'Entrance');

    {free/room Free}
      setFillStyle(6,63 div 5);
      bar(10,381,26,396);
      setFillStyle(4,63 div 5);
      bar(50,381,66,396);
    setColor(128+50);
    outTextXY(32,381,'/');
    setColor(50);
    outTextXY(100, 381,'Floor');
    setColor(128+50);
    outTextXY(100+5*16, 381,', you can step here;');

     {wall/superWall}
       setFillStyle(1,32);
       bar(30,401,46,416);
       setColor(63);
       recTangle(29,400,47,417);
    setColor(50);
    outTextXY(100, 401,'Wall');
    setColor(128+50);
    outTextXY(100+4*16, 401,', you cannot step here;');

     {smoke}
       setFillStyle(9,63 div 3);
       bar(30,421,46,436);
    setColor(50);
    outTextXY(100, 421,'Smoke');
    setColor(128+50);
    outTextXY(100+5*16, 421,', you see worse here;');

     {look}
       setFillStyle(7,63 div 2);
       bar(30,441,46,456);
    setColor(50);
    outTextXY(100, 441,'Transparent Wall');
    setColor(128+50);
    outTextXY(100+16*16, 441,', you can see');
    outTextXY(110, 461,'through it, but cannot move here;');

     {doorOpen/DoorU}
       setFillStyle(1,0);
       setColor(63 div 3);
       bar(10,481,26,496);{doorU}
         outTextXY(11,482,'#');
       bar(50,481,66,496);{doorOpen}
         outTextXY(51,482,'*');
    setColor(128+50);
    outTextXY(32,481,'/');
    setColor(50);
    outTextXY(100, 481,'Open door');
    setColor(128+50);
    outTextXY(100+9*16, 481,', you can move through it;');

     {locked door/key}
    outTextXY(10,501,'You can also meet                          ,'{doors});
    outTextXY(10,521,'you can go through it only after taking a certain'{key});
    outTextXY(10+23*16,541,'.'{key});

    setColor(194+57);
    outTextXY(10+18*16,501,'red letters(Locked Doors)');
    setColor(127);
    outTextXY(10,541,'blue letters(Door Keys)');

      {unexplored}
    setColor(128+50);
    outTextXY(10,561,'The sign   marks yet                .');
      setFillStyle(9,254);
      bar(10+9*16,561,26+9*16,576);
    setColor(50);
    outTextXY(10+21*16,561,'Unexplored Area');


    key1:=#0;
    flg:=false;
    repeat
      RKey;
      case key of
        '1',enter:
             flg:=true;
        '2':begin
             tileX:=10;
             tileY:=10;
             MaxX:=78;
             MaxY:=60;
             MaxKeys:=40;
             SymbolSize:=3;
             flg:=true
            end;
        '3':begin
             tileX:=26;
             tileY:=26;
             MaxX:=28;
             MaxY:=23;
             MaxKeys:=10;
             SymbolSize:=11;
             flg:=true
            end;
        '4':begin
             tileX:=18;
             tileY:=18;
             MaxX:=55;
             MaxY:=42;
             MaxKeys:=36;
             SymbolSize:=7;
             flg:=true;
             AlwaysUncentered:=true
            end;
        '5':begin
             setUpCustomMap;
             flg:=true;
            end;
      end;
    until flg=true;
    setTextStyle(0,0,0);
end;
{-------------------------------------------------------------------------}
BEGIN
new(map);
new(V);
new(R);
computerSpeed:=0;
setGraficMode(3);
closeArea:=0;
for i:=0 to 63 do setRGBPalette(i    ,i,i,i);
for i:=0 to 63 do setRGBPalette(i +64,0,0,i);
for i:=0 to 63 do setRGBPalette(i+128,0,i,0);
for i:=0 to 60 do setRGBPalette(i+194,i,0,0);
setRGBPalette(255,60,60, 0);
setRGBPalette(254,20,20,43);

createTable;
randomize;
centered:=true;
SetUpMap;
restart:=true;
repeat
  if restart=true then CreateMap;

  if MapChanged=true then showMap;

  key1:=#0;
  rkey;
  if key=#0 then
  case key1 of
      up :m.moveMe( 0,-1);
    down :m.moveMe( 0,+1);
    left :m.moveMe(-1, 0);
    right:m.moveMe(+1, 0);
{shift-f1}
      #84:begin
           for i:=1 to MaxX do
             for j:=1 to maxY do begin
               V^[i,j]:=MaxV;
               R^[i,j]:=1;
             end;
           MapChanged:=true;
          end;
       f9:restart:=true;
{alt-D}
      #32:begin
            if CloseArea<3 then inc(CloseArea) else closeArea:=0;
              setFillStyle(1,254);
              bar(8,10*TileY,37*16,11*TileY-1);

              setTextStyle(0,0,2);
              str(closeArea,str1);
              setColor(255);
              outTextXY(10,10*TileY,'Memory Mode '+str1);
              setTextStyle(0,0,0);

              yy1:={25*8 div TileY+1}11;
              MapChanged:=true;
              if (yy1<=MaxY) {and (yy1>0)} then begin
                for xx1:=1 to 37*2+1 do begin
                  iii:=xx1*8 div TileX+1;
                  if iii<=MaxX then R^[iii,yy1]:=1;
                end;
              end;
              RKey;
          end;
{alt-c}
      #46:if AlwaysUncentered=false then begin
             MapChanged:=true;
             centered:=not centered;
             for i:=1 to MaxY do
               for j:=1 to MaxX do R^[j,i]:=1;
          end;
{shift-f9}
      #92:begin
            setUPMap;
            restart:=true;
          end;
  end;
  while KeyPressed=true do Rkey;
until key1=#68;

dispose(Map);
dispose(V);
dispose(R);
restoreCRTmode;
closeGraph
END.