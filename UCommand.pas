unit UCommand;

interface

type
  TSplit = record
           Nom:string;
           Time:string;
           Split:string;
           end;
  TArrSplit = array of TSplit;
  TKPCommand = record
               NomKP:string;
               Kol:Byte;
               end;
  TFailyreGroup = record
                Group:string;
                Time:Longint;
                end;
  TKPFailyre = record
               Kp:string;
               Nomber:string;
               Group:string;
               end;
  TFailyre = array of TFailyreGroup;
  TSplitArray = array [1..2] of TArrSplit;
  TCommand = class
            BasicNomber:string;
            Group:string;
            NameCommand:string;
//            StartTime:string;
//            StartSek:Longint;
//            FinishSek:array [1..2] of Longint;
            TimeDistanse:array [1..2] of string;
            TimeSek:array [1..2] of Longint;
            Failyre:array [1..2] of Longint;
            Name:array [1..2] of  String;
            Nomber:array [1..2] of string;
            Chip:array [1..2] of string;
//            Finish:array[1..2] of string;
            Split:TSplitArray;
            KP: array of TKPCommand;
            Point:array [1..2] of Longint;
            PointCommand:Longint;
            TimeSekCommand:LongWord;
            Diskvalification:Boolean;
            constructor Create;
            destructor Destroy;
            Procedure GoKPAll;
            procedure GoPointAll;
            procedure GoFailure;
            end;

  function GoHMS(Sek:LongWord):string;
  procedure qSortSplitNom(Split:TArrSplit; l,r:LongInt);
  procedure qSortSplitTime(Split:TArrSplit; l,r:LongInt);
  function DSearchSplit(Split:TArrSplit; NomberKP:string; var NomberEl:Longint):Boolean;

Var
  BHalfHour:Boolean;
  MinShtraf:Word;
  TimeToDiscvalificationMin:LongWord;
{   ArrFailyre:TFailyre;  }

implementation

uses
  SysUtils;

function GoHMS(Sek:LongWord):string;
var
  st:string;
  Val1:LongWord;
begin
Val1:=Sek div 60;
Val1:=Val1 div 60;
St:=IntToStr(Val1);
Sek:=Sek-Val1*60*60;
Val1:=Sek div 60;
St:=St+':'+IntToStr(Val1);
Sek:=Sek-Val1*60;
St:=St+':'+IntToStr(Sek);
Result:=st;
end;

Function GoSek(st:string):Longint;
var
  k:Byte;
  Sek:Longint;
begin
k:=StrToInt(Copy(st,1,2));
Sek:=k*60*60;
K:=StrToInt(Copy(st,4,2));
Sek:=Sek+k*60;
K:=StrToInt(Copy(st,7,2));
Sek:=Sek+k;
Result:=sek;
end;

Procedure TCommand.GoFailure;
var
  i:word;
  k:LongInt;
begin
  If TimeDistanse[1]<>'' then
  TimeSek[1]:=GoSek(TimeDistanse[1])
  else
  TimeSek[1]:=0;

  If TimeDistanse[2]<>'' then
  TimeSek[2]:=GoSek(TimeDistanse[2])
  else
  TimeSek[2]:=0;
{  i:=0;
  While (i<Length(ArrFailyre)) and (ArrFailyre[i].Group<>Group) do
    inc(i);
  If (i<Length(ArrFailyre)) then
    begin                       }

    k:=StrToInt(Group[1])*60*60+MinShtraf*60-TimeSek[1];
    If k<0 then
      begin
      If Abs(k)>TimeToDiscvalificationMin*60 then
        Diskvalification:=True;
      //+1 для неполных минут
      Failyre[1]:=Abs(k) div 60+1;
      end
    else
    Failyre[1]:=0;

    k:=StrToInt(Group[1])*60*60+MinShtraf*60-TimeSek[2];
    If k<0 then
      begin
      If Abs(k)>TimeToDiscvalificationMin*60 then
        Diskvalification:=True;
      //+1 для неполных минут
      Failyre[2]:=Abs(k) div 60+1;
      end
    else
    Failyre[2]:=0;
  TimeSekCommand:=TimeSek[1]+TimeSek[2];
end;

Procedure TCommand.GoPointAll;
var
  i:Longint;
begin
{StartSek:=GoSek(StartTime);
FinishSek[1]:=GoSek(Finish[1]);
FinishSek[2]:=GoSek(Finish[2]);}
GoFailure;
Point[1]:=0;
IF Length(Split[1])<>0 then
For i:=0 to Length(Split[1])-1 do
  begin
{  If Split[1][i][1]=' ' then
    Point[1]:=Point[1]+StrToInt(Split[1][i][2]);}
  If Split[1][i].Nom[1]='9' then
    Point[1]:=Point[1]+4
  else
    Point[1]:=Point[1]+StrToInt(Copy(Split[1][i].Nom,1,2));
  end;
Point[1]:=Point[1]-Failyre[1];

Point[2]:=0;
IF Length(Split[2])<>0 then
For i:=0 to Length(Split[2])-1 do
  begin
{  If Split[2][i][1]=' ' then
    Point[2]:=Point[2]+StrToInt(Split[2][i][2]);  }
  If Split[2][i].Nom[1]='9' then
    Point[2]:=Point[2]+4
  else
    Point[2]:=Point[2]+StrToInt(Copy(Split[2][i].Nom,1,2));
  end;
Point[2]:=Point[2]-Failyre[2];

PointCommand:=0;
IF Length(KP)<>0 then
For i:=0 to Length(KP)-1 do
  begin
  If (KP[i].NomKP[1]<>' ') and (KP[i].Kol=2) then
    begin
    if KP[i].NomKP[1]='9' then
      begin
      PointCommand:=PointCommand+4;
      end
    else
      begin
      PointCommand:=PointCommand+StrToInt(KP[i].NomKP[1])*10;
      PointCommand:=PointCommand+StrToInt(KP[i].NomKP[2]);
      end;
    end;
  If KP[i].NomKP[1]=' ' then
    PointCommand:=PointCommand+StrToInt(KP[i].NomKP[2]);
  end;
PointCommand:=PointCommand-Failyre[1]-Failyre[2];

end;

procedure DeletePovt(Split:TArrSplit);
var
  i,j,n:LongWord;
begin
n:=Length(Split);
i:=0;
While i<n-1 do
  begin
  if Split[i].Nom=Split[i+1].Nom then
    begin
    for j:=i+1 to n-2 do
      Split[j]:=Split[j+1];
    n:=n-1;
    SetLength(Split,n);
    Dec(i);
    end;
  inc(i);
  end;
end;

Procedure TCommand.GoKPAll;
var
  i,j:Longint;
  n1,n2,nKP:Longint;
  NomEl:Longint;
begin
  If Length(Split[1])=0 then n1:=0
  else
  n1:=Length(Split[1])-1;
  If Length(Split[2])=0 then n2:=0
  else
  n2:=Length(Split[2])-1;
  If n1<>0 then
    begin
    qSortSplitNom(Split[1],0,n1);
//    DeletePovt(Split[1]);
    end;
  If n2<>0 then
    begin
    qSortSplitNom(Split[2],0,n2);
//    DeletePovt(Split[1]);    
    end;
  nKP:=n1;
  SetLength(KP,n1+1);
  If n1<>0 then
  For i:=0 to n1 do
    begin
    KP[i].NomKP:=Split[1][i].Nom;
    KP[i].Kol:=1;
    IF (n2<>0) and (DSearchSplit(Split[2],KP[i].NomKP,NomEl)) then
      Inc(KP[i].Kol);
    end;
  If n2<>0 then
  For i:=0 to n2 do
    begin
    If (n1<>0) and (not DSearchSplit(Split[1],Split[2][i].Nom,NomEl)) then
      begin
      Inc(nKp);
      SetLength(KP,nKp+1);
      KP[nKP].NomKP:=Split[2][i].Nom;
      KP[nKP].Kol:=1;
      end;
    end;
end;

Procedure qSortSplitNom(Split:TArrSplit; l,r:LongInt);

var i,j:LongInt;
    w,q:string;
begin
  i := l; j := r;
  if ((l+r) div 2<r) and ((l+r) div 2>l) then
    q := Split[(l+r) div 2].Nom
  else
    q:=Split[l].Nom;
  repeat
    while (i<r) and (Split[i].Nom < q) do
      inc(i);
    while (j>l) and (q < Split[j].Nom) do
      dec(j);
    if (i <= j) then
      begin
      w:=Split[i].Nom; Split[i].Nom:=Split[j].Nom; Split[j].Nom:=w;
      w:=Split[i].Time; Split[i].Time:=Split[j].Time; Split[j].Time:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSortSplitNom(Split,l,j);
  if (i < r) then qSortSplitNom(Split,i,r);
end;

Procedure qSortSplitTime(Split:TArrSplit; l,r:LongInt);

var i,j:LongInt;
    w,q:string;
begin
  i := l; j := r;
  if ((l+r) div 2<r) and ((l+r) div 2>l) then
    q := Split[(l+r) div 2].Time
  else
    q:=Split[l].Time;
  repeat
    while (i<r) and (Split[i].Time < q) do
      inc(i);
    while (j>l) and (q < Split[j].Time) do
      dec(j);
    if (i <= j) then
      begin
      w:=Split[i].Nom; Split[i].Nom:=Split[j].Nom; Split[j].Nom:=w;
      w:=Split[i].Time; Split[i].Time:=Split[j].Time; Split[j].Time:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSortSplitTime(Split,l,j);
  if (i < r) then qSortSplitTime(Split,i,r);
end;

function DSearchSplit(Split:TArrSplit; NomberKP:string; var NomberEl:Longint):Boolean;
var
  x,a,b:Longint;
begin
NomberEl:=255;
a:=0;
b:=Length(Split)-1;
if (b=0) and (Split[a].Nom=NomberKP ) then
    begin
    NomberEl:=a;
    Result:=True;
    end
else
if (b=1) then
  begin
  If Split[a].Nom=NomberKP then
    begin
    NomberEl:=a;
    Result:=True;
    end
  else
  If Split[b].Nom=NomberKP then
    begin
    NomberEl:=b;
    Result:=True;
    end
  end
else
while b-a>1 do
  begin
  If Split[a].Nom=NomberKP then
    begin
    NomberEl:=a;
    Result:=True;
    b:=a;
    end
  else
  If Split[b].Nom=NomberKP then
    begin
    NomberEl:=b;
    Result:=True;
    b:=a;
    end
  else
    begin
    x:=(b-a) div 2+a;
    if Split[x].Nom=NomberKP then
      begin
      NomberEl:=x;
      Result:=True;
      b:=a;
      end;
    if Split[x].Nom>NomberKP then b:=x
    else  a:=x;
    end;
  end;
if NomberEl=255 then
  result:=False;
end;

constructor TCommand.Create;
begin
  BasicNomber:='';
  Diskvalification:=false;
end;

destructor TCommand.Destroy;
  begin

  end;

end.
