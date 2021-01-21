unit UAddSplit;

interface

Uses UMainForm,UCommand,SysUtils;

type

  TTimeToNextKP = record
                  NomNextKp:string;
                  MinTime:TDateTime;
                  MidleTime:TDateTime;
                  NomKommand:string;
                  KolPeople:Word;
                  end;

  ArrayTTimeToNextKP = array of TTimeToNextKP;

  TTimeKp = record
            NomKp:string;
            MinTime:TDateTime;
            NomKommand:string;
            KolPeople:Word;
            TimeToNextKP:ArrayTTimeToNextKP;
            end;

procedure GoAllTimeKP;

var
   MinTimeKp:array of TTimeKp;
   TimeStartToNextKp:ArrayTTimeToNextKP;
   KolKP:LongWord;

implementation

function SearthKpInArray(Kp:string; var NomKp:LongWord):Boolean;
var
    i:LongWord;
    SearcthEnd:Boolean;
begin
SearcthEnd:=False;
If Length(MinTimeKp)<>0 then
  begin
  for i:=0 to Length(MinTimeKp)-1 do
    if MinTimeKp[i].NomKp=Kp then
      begin
      SearcthEnd:=True;
      NomKp:=i;
      end;
  Result:=SearcthEnd;
  end
else
  Result:=False;
end;

procedure AddNextKp(var TimeToNextKP:ArrayTTimeToNextKP; NextKp:string; TimeToKp:TDateTime; NomPeople:string);
var
  i,n:LongWord;
begin
n:=Length(TimeToNextKP);
If n=0 then
  begin
  SetLength(TimeToNextKP,1);
  TimeToNextKP[0].NomNextKp:=NextKp;
  TimeToNextKP[0].MinTime:=TimeToKp;
  TimeToNextKP[0].MidleTime:=TimeToKp;
  TimeToNextKP[0].NomKommand:=NomPeople;
  TimeToNextKP[0].KolPeople:=1;
  end
else
  begin
  i:=0;
  while (i<=n-1) and (TimeToNextKP[i].NomNextKp<>NextKp) do
     Inc(i);
  If i=n then
    begin
    SetLength(TimeToNextKP,n+1);
    TimeToNextKP[i].NomNextKp:=NextKp;
    TimeToNextKP[i].MinTime:=TimeToKp;
    TimeToNextKP[i].MidleTime:=TimeToKp;
    TimeToNextKP[i].NomKommand:=NomPeople;
    TimeToNextKP[i].KolPeople:=1;
    end
  else
    begin
    IF TimeToNextKP[i].MinTime>TimeToKp then
      begin
      TimeToNextKP[i].MinTime:=TimeToKp;
      TimeToNextKP[i].NomKommand:=NomPeople;
      end;
    TimeToNextKP[i].MidleTime:=TimeToNextKP[i].MidleTime+TimeToKp;
    Inc(TimeToNextKP[i].KolPeople);
    end;
  end;
end;

procedure GoAllTimeKP;
var
  i,j,NomKp:LongWord;
  z:Byte;
begin
KolKP:=0;
SetLength(MinTimeKp,0);
If Length(Command)<>0 then
For i:=0 to Length(Command)-1 do
  for z:=1 to 2 do
    If Length(Command[i].Split[z])<>0 then
    for j:=0 to Length(Command[i].Split[z])-1 do
    IF Command[i].Split[z][j].Time<>'' then
    begin

    if SearthKpInArray(Command[i].Split[z][j].Nom,NomKp) then
      begin
      Inc(MinTimeKp[NomKp].KolPeople);
      if MinTimeKp[NomKp].MinTime>StrToTime(Command[i].Split[z][j].Time) then
        MinTimeKp[NomKp].MinTime:=StrToTime(Command[i].Split[z][j].Time);
      end
    else
      begin
      Inc(KolKP);
      SetLength(MinTimeKp,KolKP);
      MinTimeKp[KolKP-1].NomKp:=Command[i].Split[z][j].Nom;
      MinTimeKp[KolKP-1].MinTime:=StrToTime(Command[i].Split[z][j].Time);
      MinTimeKp[KolKP-1].NomKommand:=Command[i].BasicNomber;
      MinTimeKp[KolKP-1].KolPeople:=1;
      NomKp:=KolKp-1
      end;

    IF j=0 then
      AddNextKp(TimeStartToNextKp,Command[i].Split[z][j].Nom,StrToTime(Command[i].Split[z][j].Split),Command[i].BasicNomber);
    IF j<Length(Command[i].Split[z])-2 then
      if Command[i].Split[z][j+1].Split<>'' then
      AddNextKp(MinTimeKp[NomKp].TimeToNextKP,Command[i].Split[z][j+1].Nom,StrToTime(Command[i].Split[z][j+1].Split),Command[i].BasicNomber);

    end;
end;

end.
