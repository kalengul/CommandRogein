unit UCommand;

interface

type
  TArrSplit = array of Word;
  TCommand = class
            BasicNomber:string;
            Name:array [1..2] of  String;
            Nomber:array [1..2] of string;
            Split:array [1..2] of TArrSplit;
            constructor Create;
            destructor Destroy;
            end;

  procedure qSortSplit(Split:TArrSplit; l,r:LongInt);
  function DSearchSplit(Split:TArrSplit; NomberKP:Word; var NomberEl:Word):Boolean;

implementation

Procedure qSortSplit(Split:TArrSplit; l,r:LongInt);

var i,j:LongInt;
    w,q:Word;
begin
  i := l; j := r;
  if ((l+r) div 2<r) and ((l+r) div 2>l) then
    q := Split[(l+r) div 2]
  else
    q:=Split[l];
  repeat
    while (i<r) and (Split[i] < q) do
      inc(i);
    while (j>l) and (q < Split[j]) do
      dec(j);
    if (i <= j) then
      begin
      w:=Split[i]; Split[i]:=Split[j]; Split[j]:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSortSplit(Split,l,j);
  if (i < r) then qSortSplit(Split,i,r);
end;

function DSearchSplit(Split:TArrSplit; NomberKP:Word var NomberEl:Word):Boolean;
var
  x,a,b:Word;
begin
NomberEl:=255;
a:=0;
b:=Length(Split)-1 do
while b-a>1 do
  begin
  x:=(b-a) mod 2;
  if Split[x]=NomberKP then
    begin
    NomberEl:=x;
    Result:=True;
    b:=a;
    end;
  if Split[x]>NomberKP then b:=x
  else  a:=x;
  end;
if NomberEl=255 then
  result:=False;
end;

constructor TCommand.Create;
begin
  BasicNomber:='';
end;

destructor TCommand.Destroy;
  begin

  end;

end.
