unit UMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,UCommand, Grids, ExtCtrls, ComObj, ActiveX;

const
  ExcelApp = 'Excel.Application';

type
  TFMain = class(TForm)
    BtLoadsplit: TButton;
    OdLoad: TOpenDialog;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    pnl5: TPanel;
    SgCommand: TStringGrid;
    BtGoPoint: TButton;
    pnl6: TPanel;
    SgSplit: TStringGrid;
    CbGroup: TComboBox;
    pnl7: TPanel;
    BtSort: TButton;
    Label1: TLabel;
    EdNomCommand: TEdit;
    BtSearchNomCommand: TButton;
    Panel1: TPanel;
    pnl8: TPanel;
    SgKPFail: TStringGrid;
    MeKPPlayer: TMemo;
    BtAddKP: TButton;
    EdKPFail: TEdit;
    Label2: TLabel;
    BtAddKPFailPlayer: TButton;
    BtSaveProt: TButton;
    BtSaveProtokolPlayer: TButton;
    BtSaveSplit: TButton;
    EdKolStr: TEdit;
    BtSaveObSplit: TButton;
    CbHalfHour: TCheckBox;
    EdMin: TEdit;
    Label3: TLabel;
    CbGoAddFunction: TCheckBox;
    BtSaveDop: TButton;
    Label4: TLabel;
    Label5: TLabel;
    EdDiscvalTimeMin: TEdit;
    procedure BtLoadsplitClick(Sender: TObject);
    procedure BtGoPointClick(Sender: TObject);
    procedure CbGroupClick(Sender: TObject);
    procedure SgCommandSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SgSplitDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BtSearchNomCommandClick(Sender: TObject);
    procedure BtSortClick(Sender: TObject);
    procedure BtAddKPClick(Sender: TObject);
    procedure BtAddKPFailPlayerClick(Sender: TObject);
    procedure SgKPFailSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure BtSaveProtClick(Sender: TObject);
    procedure BtSaveProtokolPlayerClick(Sender: TObject);
    procedure BtSaveSplitClick(Sender: TObject);
    procedure BtSaveObSplitClick(Sender: TObject);
    procedure BtSaveDopClick(Sender: TObject);
    procedure EdNomCommandChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;
  Command:array of TCommand;
  KPFailyre:array of TKPFailyre;
  KolCommand:Longint;
  f:TextFile;
  SelectCommandRow,SelectKPRow:LongInt;
  MyExcel: OleVariant;

implementation

{$R *.dfm}

uses UAddSplit;

function CheckExcelRun: boolean;
begin
  try
    MyExcel:=GetActiveOleObject(ExcelApp);
    Result:=True;
  except
    Result:=false;
  end;
end;

procedure ClearCommandGrid;
  var
    i,j:Word;
  begin
  with FMain do
    begin
    for i:=0 to SgCommand.ColCount-1 do
      For j:=1 to SgCommand.RowCount-1 do
        SgCommand.Cells[i,j]:='';
    end;
  end;

function SearchCommandNomber(NomberSearch,Group:string; var NomberCommand:Longint):Boolean;
begin
NomberCommand:=0;
While (NomberCommand<=Length(Command)-1) and ((NomberSearch<>Command[NomberCommand].BasicNomber) or ((Group<>Command[NomberCommand].Group) and (Group<>''))) do
  Inc(NomberCommand);
  Result:=(NomberCommand<=Length(Command)-1);
end;

procedure VivodCommand;
var
  I,j:Longint;
  n:Longint;
  st:string;
begin
ClearCommandGrid;
with FMain do
  begin
  n:=Length(Command);
  SgCommand.RowCount:=3;
  st:=CbGroup.Text;
  If n<>0 then
  i:=0;
  j:=0;
  For i:=0 to n-1 do
    IF ((CbGroup.Text='Все') or (CbGroup.Text=Command[i].Group)) and ((EdNomCommand.Text='') or (Pos(EdNomCommand.Text,Command[i].Name[1])<>0) or (Pos(EdNomCommand.Text,Command[i].Name[2])<>0)) then
    begin
    SgCommand.RowCount:=1+j*2+1+2;
    SgCommand.Cells[0,1+j*2]:=Command[i].BasicNomber;
    SgCommand.Cells[0,1+j*2+1]:=Command[i].BasicNomber;
    SgCommand.Cells[1,1+j*2]:=Command[i].Group;
    SgCommand.Cells[1,1+j*2+1]:=Command[i].Group;
    SgCommand.Cells[2,1+j*2]:=Command[i].Nomber[1];
    SgCommand.Cells[2,1+j*2+1]:=Command[i].Nomber[2];
    SgCommand.Cells[3,1+j*2]:=Command[i].Name[1];
    SgCommand.Cells[3,1+j*2+1]:=Command[i].Name[2];
    SgCommand.Cells[4,1+j*2]:=IntToStr(Command[i].Point[1]);
    SgCommand.Cells[4,1+j*2+1]:=IntToStr(Command[i].Point[2]);
    SgCommand.Cells[5,1+j*2]:=IntToStr(Command[i].PointCommand);
    If Command[i].Diskvalification then
      SgCommand.Cells[5,1+j*2+1]:='Диск.'
    else
      SgCommand.Cells[5,1+j*2+1]:=IntToStr(Command[i].PointCommand);
    Inc(j);
    end;
  end;
end;

procedure VivodSplitCommand(Nom:Longint);
var
  i,j,n:Longint;
begin
with FMain do
  begin

  For i:=0 to SgSplit.ColCount-1 do
    for j:=0 to SgSplit.RowCount-1 do
      SgSplit.Cells[i,j]:='';

  n:=Length(Command[Nom].Split[1]);
  SgSplit.ColCount:=6+n;

  SgSplit.Cells[0,1]:=Command[Nom].Name[1];
  SgSplit.Cells[1,1]:=Command[Nom].Nomber[1];
  SgSplit.Cells[2,1]:=Command[Nom].TimeDistanse[1];
  SgSplit.Cells[3,1]:=Command[Nom].Chip[1];
  SgSplit.Cells[4,1]:=IntToStr(Command[Nom].Point[1]);
  SgSplit.Cells[5,1]:=IntToStr(Command[Nom].Failyre[1]);
  If n<>0 then
  For i:=0 to n-1 do
    SgSplit.Cells[6+i,1]:=Command[Nom].Split[1][i].Nom;

  n:=Length(Command[Nom].Split[2]);
  If n+5>SgSplit.ColCount then
    SgSplit.ColCount:=n+6;
    SgSplit.Cells[0,2]:=Command[Nom].Name[2];
  SgSplit.Cells[1,2]:=Command[Nom].Nomber[2];
  SgSplit.Cells[2,2]:=Command[Nom].TimeDistanse[2];
  SgSplit.Cells[3,2]:=Command[Nom].Chip[2];
  SgSplit.Cells[4,2]:=IntToStr(Command[Nom].Point[2]);
  SgSplit.Cells[5,2]:=IntToStr(Command[Nom].Failyre[2]);
  If n<>0 then
  For i:=0 to n-1 do
    SgSplit.Cells[6+i,2]:=Command[Nom].Split[2][i].Nom;


  n:=Length(Command[Nom].KP);
  If n+5>SgSplit.ColCount then
    SgSplit.ColCount:=n+6;
  SgSplit.Cells[1,4]:=Command[Nom].BasicNomber;
  SgSplit.Cells[4,4]:=IntToStr(Command[Nom].PointCommand);
  SgSplit.Cells[5,4]:=IntToStr(Command[Nom].Failyre[1]+Command[Nom].Failyre[2]);
  If n<>0 then
  For i:=0 to n-1 do
    begin
    SgSplit.Cells[6+i,4]:=Command[Nom].KP[i].NomKP;
    SgSplit.Cells[6+i,5]:=IntToStr(Command[Nom].KP[i].Kol);
    If Command[Nom].KP[i].NomKP[1]=' ' then
      SgSplit.Cells[6+i,6]:=Command[Nom].KP[i].NomKP[2]
    else

      If Command[Nom].KP[i].Kol=2 then
        If Command[Nom].KP[i].NomKP[1]<>'9' then
          SgSplit.Cells[6+i,6]:=Copy(Command[Nom].KP[i].NomKP,1,2)
        else
          SgSplit.Cells[6+i,6]:='4'
      else
        SgSplit.Cells[6+i,6]:='0';
    If i=0 then
      SgSplit.Cells[6+i,7]:=SgSplit.Cells[6+i,6]
    else
      SgSplit.Cells[6+i,7]:=IntToStr(StrToInt(SgSplit.Cells[6+i,6])+StrToInt(SgSplit.Cells[6+i-1,7]));
    end;

  end;
end;

procedure GoSplit(NomCommand,Nom:Longint);
var
  st:string;
    n,i:Longint;
    Flag:Boolean;
begin
      Readln(f,st);
//      Command[NomCommand].StartTime:=Copy(st,7,8);
      Readln(f,st);
      Command[NomCommand].Chip[Nom]:=Copy(st,10,7);
      Readln(f,st);
      while st[1]<>'О' do
        begin
        n:=length(Command[NomCommand].Split[Nom]);
        i:=0;
        If n<>0 then
        While (i<n) and (Command[NomCommand].Split[Nom][i].Nom<>Copy(st,6,3)) do
          Inc(i);
        If i=n then
          begin
          SetLength(Command[NomCommand].Split[Nom],n+1);
          Command[NomCommand].Split[Nom][n].Nom:=Copy(st,6,3);
          If Command[NomCommand].Split[Nom][n].Nom[2]='2' then Command[NomCommand].Split[Nom][n].Nom[1]:='9';
          Command[NomCommand].Split[Nom][n].Time:=Copy(st,11,8);
          Command[NomCommand].Split[Nom][n].Split:=Copy(st,20,8);
          end;
        Readln(f,st);
        end;
      Readln(f,st);
//      Command[NomCommand].Finish[Nom]:=Copy(st,11,8);
      Readln(f,st);
      Command[NomCommand].TimeDistanse[Nom]:=Copy(st,11,8);
end;

procedure AddKpFailyre (i:Word);
var
  NomCommand,N,z:LongInt;
begin
IF SearchCommandNomber(Copy(KpFailyre[i].Nomber,2,3),KpFailyre[i].Group,NomCommand) then
  begin
  IF KpFailyre[i].Nomber[1]=Command[NomCommand].Nomber[1][1] then
    z:=1
  else
    z:=2;
  n:=length(Command[NomCommand].Split[z]);
  SetLength(Command[NomCommand].Split[z],n+1);
  Command[NomCommand].Split[z][n].Nom:=KpFailyre[i].Kp;
  end;
end;

procedure TFMain.BtLoadsplitClick(Sender: TObject);
var

  st,st1,st2,STKP,StNomber:string;
  i,n,ik,nk:LongInt;
  NomberCommand:Longint;

begin
If OdLoad.Execute then
  begin
  KolCommand:=0;
  SetLength(Command,0);
  AssignFile(f,OdLoad.FileName);
  Reset(f);
  Readln(f,st);
  Readln(f,st1);
  While st1<>'</pre></html>' do
    begin
    For i:=1 to StrToInt(EdKolStr.Text) do
      Readln(f,st1);
    Readln(F,st2);
    Readln(F,st);
    If SearchCommandNomber(Copy(st,4,3),Copy(st2,9,Length(st2)-8),NomberCommand) then
      begin
      Command[NomberCommand].Nomber[2]:=Copy(st,3,4);
      Command[NomberCommand].Name[2]:=st1;
      GoSplit(NomberCommand,2);
      end
    else
      begin
      Inc(KolCommand);
      SetLength(Command,KolCommand);
      Command[KolCommand-1]:=TCommand.Create;
      Command[KolCommand-1].BasicNomber:=Copy(st,4,3);
      Command[KolCommand-1].Nomber[1]:=Copy(st,3,4);
      Command[KolCommand-1].NameCommand:=Copy(st,19,Length(st)-18);
      Command[KolCommand-1].Name[1]:=st1;
      st:=Copy(st2,9,Length(st2)-8);
      Command[KolCommand-1].Group:=st;
      If CbGroup.Items.IndexOf(st)=-1 then
        CbGroup.Items.Add(st);
      GoSplit(KolCommand-1,1);

      end;
    Readln(f,st);
    Readln(f,st1);
    end;
  CloseFile(f);
  VivodCommand;
  n:=0;
  SetLength(KPFailyre,n);
  AssignFile(f,'KPFailyre.txt');
  Reset(f);
  while Not Eof(f) do
    begin
    Readln(f,st);
    STKP:=Copy(st,1,Pos(';',st)-1);
    StNomber:=Copy(st,Pos(';',st)+1,Length(st));
    Inc(n);
    SetLength(KPFailyre,n);
    KPFailyre[n-1].Kp:=STKP;
    KPFailyre[n-1].Nomber:=StNomber;
    AddKpFailyre(n-1);
    ik:=0;
    nk:=SgKPFail.RowCount;
    while (ik<nk) and (SgKPFail.Cells[0,ik]<>KPFailyre[n-1].Kp) do
      Inc(ik);
    if ik>=nk  then
      begin
      SgKPFail.RowCount:=nk+1;
      SgKPFail.Cells[0,nk]:=STKP;
//            AddKpFailyre(n-1);
      end;

    end;
  CloseFile(f);
  end;

If CbGoAddFunction.Checked then
  begin
  GoAllTimeKP;
  end;

end;

procedure TFMain.BtGoPointClick(Sender: TObject);
var
  i:Longint;
begin
TimeToDiscvalificationMin:=StrToInt(EdDiscvalTimeMin.Text);
BHalfHour:=CbHalfHour.Checked;
MinShtraf:=StrToInt(EdMin.Text);
If Length(Command)<>0 then
For i:=0 to Length(Command)-1 do
  begin
  Command[i].GoKPAll;
  Command[i].GoPointAll;
  end;
  VivodCommand;


end;

procedure TFMain.CbGroupClick(Sender: TObject);
begin
VivodCommand;
end;

procedure TFMain.SgCommandSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
    NomberCommand:Longint;
begin
SelectCommandRow:=ARow;
if SearchCommandNomber(SgCommand.Cells[0,ARow],SgCommand.Cells[1,ARow],NomberCommand) then
VivodSplitCommand(NomberCommand);
end;

procedure TFMain.SgSplitDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
if ARow=6 then
  begin
  If (SgSplit.Cells[ACol,5]='2') and (SgSplit.Cells[ACol,4][1]=' ') then
    begin
    SgSplit.Canvas.Brush.Color:=clYellow;
    SgSplit.Canvas.FillRect(Rect);
    SgSplit.Canvas.TextOut(Rect.Left+20,Rect.Top+5,SgSplit.Cells[Acol,Arow]);
    end
  else
  If (SgSplit.Cells[ACol,5]='2') and (SgSplit.Cells[ACol,4][1]<>' ') or
     (SgSplit.Cells[ACol,5]='1') and (SgSplit.Cells[ACol,4][1]=' ') then
    begin
    SgSplit.Canvas.Brush.Color:=clGreen;
    SgSplit.Canvas.FillRect(Rect);
    SgSplit.Canvas.TextOut(Rect.Left+20,Rect.Top+5,SgSplit.Cells[Acol,Arow]);
    end
  else
  If (SgSplit.Cells[ACol,5]='1') and (SgSplit.Cells[ACol,4][1]<>' ') then
    begin
    SgSplit.Canvas.Brush.Color:=clRed;
    SgSplit.Canvas.FillRect(Rect);
    SgSplit.Canvas.TextOut(Rect.Left+20,Rect.Top+5,SgSplit.Cells[Acol,Arow]);   
    end
  end;
end;

procedure TFMain.BtSearchNomCommandClick(Sender: TObject);
var
  i,NomberCommand:LongInt;
  BoolSelect:Boolean;
begin
if SearchCommandNomber(EdNomCommand.Text,CbGroup.Text,NomberCommand) then
  begin
  i:=0;
  while (i<SgCommand.RowCount) and (SgCommand.Cells[0,i]<>Command[NomberCommand].BasicNomber) do
    Inc(i);
  If (i<SgCommand.RowCount) then
    SgCommand.OnSelectCell(Self,0,i,BoolSelect)
  else
    ShowMessage('Команда №'+EdNomCommand.Text+' НЕ найдена');  
  end
else
ShowMessage('Команда №'+EdNomCommand.Text+' НЕ найдена');
end;

Procedure qSortCommand(l,r:LongInt);

var i,j:LongInt;
    w,q:TCommand;
begin
  i := l; j := r;
  if ((l+r) div 2<r) and ((l+r) div 2>l) then
    q := Command[(l+r) div 2]
  else
    q:=Command[l];
  repeat
    while (i<r) and ((Command[i].Group < q.Group) or (Command[i].Group = q.Group) and ((Command[i].PointCommand > q.PointCommand) or (Command[i].PointCommand = q.PointCommand) and (Command[i].TimeSekCommand < q.TimeSekCommand))) do
      inc(i);
    while (j>l) and ((Command[j].Group > q.Group) or (Command[j].Group = q.Group) and ((Command[j].PointCommand < q.PointCommand) or (Command[i].PointCommand = q.PointCommand) and (Command[i].TimeSekCommand > q.TimeSekCommand))) do
      dec(j);
    if (i <= j) then
      begin
      w:=Command[i]; Command[i]:=Command[j]; Command[j]:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSortCommand(l,j);
  if (i < r) then qSortCommand(i,r);
end;

procedure TFMain.BtSortClick(Sender: TObject);
begin
If Length(Command)<>0 then
qSortCommand(0,Length(Command)-1);
VivodCommand;
end;

procedure TFMain.BtAddKPClick(Sender: TObject);
var
  i,n:Word;
  st:string;
begin
  i:=0;
  n:=SgKPFail.RowCount;
while (i<n) and (SgKPFail.Cells[0,i]<>EdKPFail.Text) do
  Inc(i);
if i<n  then
  ShowMessage('КП уже отмечен')
else
  begin
  SgKPFail.RowCount:=n+1;
  st:=EdKPFail.Text;
  if Length(st)<>3 then
    St:=' '+st;
  SgKPFail.Cells[0,n]:=st;
  end;
end;

procedure VivodPlayerKPFailyre(Kp:String);
var
  n,i:Word;
begin
FMain.MeKPPlayer.Clear;
n:=Length(KPFailyre);
i:=0;
IF n<>0 then
While (i<n) do
  begin
  IF KPFailyre[i].Kp=KP then
    FMain.MeKPPlayer.Lines.Add(KpFailyre[i].Nomber);
  Inc(i);
  end;
end;



procedure TFMain.BtAddKPFailPlayerClick(Sender: TObject);
var
  n,i:Word;
  f:TextFile;
begin
n:=Length(KPFailyre);
i:=0;
IF n<>0 then
While (i<n) and ( not ((KPFailyre[i].Nomber=SgCommand.Cells[2,SelectCommandRow]) and (KPFailyre[i].Kp=SgKPFail.Cells[0,SelectKPRow]))) do
  Inc(i);
If (i<n) then
  ShowMessage('КП уже отмечен')
else
  begin
  SetLength(KPFailyre,n+1);
  KPFailyre[n].Kp:=SgKPFail.Cells[0,SelectKPRow];
  KPFailyre[n].Nomber:=SgCommand.Cells[2,SelectCommandRow];
  KPFailyre[n].Group:=SgCommand.Cells[1,SelectCommandRow];
  VivodPlayerKPFailyre(KPFailyre[n].Kp);
  AssignFile(f,'KPFailyre.txt');
  Rewrite(f);
  for i:=0 to n do
    Writeln (f,KPFailyre[i].Kp+';'+KPFailyre[i].Nomber);
  CloseFile(f);
  end;

AddKpFailyre(n);
VivodCommand;

end;

procedure TFMain.SgKPFailSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
SelectKPRow:=ARow;
VivodPlayerKPFailyre(SgKPFail.Cells[0,ARow]);
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
SgCommand.Cells[0,0]:='№ Команды';
SgCommand.Cells[1,0]:='Группа';
SgCommand.Cells[2,0]:='№ Участника';
SgCommand.Cells[3,0]:='ФИО';
SgCommand.Cells[4,0]:='Очки личные';
SgCommand.Cells[5,0]:='Очки командные';
SgSplit.Cells[0,0]:='ФИО';
SgSplit.Cells[1,0]:='№ Участника';
SgSplit.Cells[2,0]:='Время на дист.';
SgSplit.Cells[3,0]:='№ ЧИП';
SgSplit.Cells[4,0]:='Очки личные';
SgSplit.Cells[5,0]:='Штраф';
SgSplit.Cells[6,0]:='КП';
end;

procedure TFMain.BtSaveProtClick(Sender: TObject);
var
  i,k,n:LongInt;
  st:string;
begin
CheckExcelRun;
n:=Length(Command);
i:=0;
If n<>0 then
For k:=0 to n-1 do
IF ((CbGroup.Text='Все') or (CbGroup.Text=Command[k].Group))  then
  begin
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2,2]:=Command[k].BasicNomber;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2,3]:=Command[k].Group;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2,4]:=Command[k].NameCommand;
//  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2,4]:='';
//  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2,5]:='';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2,5]:=Command[k].Name[1];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2+1,5]:=Command[k].Name[2];
  St:=IntToStr(Command[k].PointCommand+Command[k].Failyre[1]+Command[k].Failyre[2]);
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2,6]:=st;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2,7]:=Command[k].TimeDistanse[1];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2+1,7]:=Command[k].TimeDistanse[2];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2,8]:=IntToStr(Command[k].Failyre[1]);
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2+1,8]:=IntToStr(Command[k].Failyre[2]);
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2,9]:=GoHMS(Command[k].TimeSekCommand);
  If Command[i].Diskvalification then
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2,10]:='0'
  else
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i*2,10]:=IntToStr(Command[k].PointCommand);
  inc(i);
  end;
end;

procedure TFMain.BtSaveProtokolPlayerClick(Sender: TObject);
var
  i,k,n:LongInt;
  s:Byte;
  st:string;
begin
CheckExcelRun;
n:=Length(Command);
i:=0;
If n<>0 then
For k:=0 to n-1 do
IF (CbGroup.Text='Все') or (CbGroup.Text=Command[k].Group) then
For s:=1 to 2 do
IF Command[k].Nomber[s]<>'' then
  begin
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i,2]:=Command[k].Nomber[s];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i,3]:=Command[k].Group;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i,4]:='';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i,5]:='';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i,6]:=Command[k].Name[s];
  St:=IntToStr(Command[k].Point[s]+Command[k].Failyre[s]);
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i,7]:=st;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i,8]:=Command[k].TimeDistanse[s];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i,9]:=IntToStr(Command[k].Failyre[s]);
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[5+i,10]:=IntToStr(Command[k].Point[s]);
  inc(i);
  end;
end;

procedure VivodSplitCommandExcel(Nom,Row:Longint);
var
  i,n:Longint;
  st:string;
begin
CheckExcelRun;
with FMain do
  begin
  n:=Length(Command[Nom].Split[1]);

  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,1]:=Command[Nom].Name[1];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,2]:=Command[Nom].Nomber[1];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,3]:=Command[Nom].TimeDistanse[1];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,4]:=Command[Nom].Chip[1];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,5]:=IntToStr(Command[Nom].Point[1]);
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,6]:=IntToStr(Command[Nom].Failyre[1]);
  If n<>0 then
  For i:=0 to n-1 do
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,7+i]:=Command[Nom].Split[1][i].Nom;

  n:=Length(Command[Nom].Split[2]);
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+1,1]:=Command[Nom].Name[2];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+1,2]:=Command[Nom].Nomber[2];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+1,3]:=Command[Nom].TimeDistanse[2];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+1,4]:=Command[Nom].Chip[2];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+1,5]:=IntToStr(Command[Nom].Point[2]);
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+1,6]:=IntToStr(Command[Nom].Failyre[2]);
  If n<>0 then
  For i:=0 to n-1 do
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+1,7+i]:=Command[Nom].Split[2][i].Nom;


  n:=Length(Command[Nom].KP);
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+3,2]:=Command[Nom].BasicNomber;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+3,5]:=IntToStr(Command[Nom].PointCommand);
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+3,6]:=IntToStr(Command[Nom].Failyre[1]+Command[Nom].Failyre[2]);
  If n<>0 then
  For i:=0 to n-1 do
    begin
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+3,7+i]:=Command[Nom].KP[i].NomKP;
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+4,7+i]:=IntToStr(Command[Nom].KP[i].Kol);
    If Command[Nom].KP[i].NomKP[1]=' ' then
      MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+5,7+i]:=Command[Nom].KP[i].NomKP[2]
    else

      If Command[Nom].KP[i].Kol=2 then
        MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+5,7+i]:=Copy(Command[Nom].KP[i].NomKP,1,2)
      else
        MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+5,7+i]:='0';
    If i=0 then
      begin
      st:=MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+5,7+i];
      MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+6,7+i]:=st;
      end

    else
      MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+6,7+i]:=IntToStr(StrToInt(MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+5,7+i])+StrToInt(MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+6,7+i-1]));
    end;

  end;
end;

procedure TFMain.BtSaveSplitClick(Sender: TObject);
var
  k,Row,n:Longint;
begin
Row:=5;
CheckExcelRun;
n:=Length(Command);
If n<>0 then
For k:=0 to n-1 do
IF (CbGroup.Text='Все') or (CbGroup.Text=Command[k].Group) then
  begin
  VivodSplitCommandExcel(k,Row);
  Row:=Row+8;
  end;
end;



procedure TFMain.BtSaveObSplitClick(Sender: TObject);
var
  Row,n,i,k,n1,s:LongWord;
  Row1,Row2:LongInt;
  st:string;
begin
CheckExcelRun;
Row:=1;
n:=Length(Command);
For k:=0 to n-1 do
  begin
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,1]:='Место';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,2]:='Номер';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,3]:='Группа';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,4]:='Участники';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,5]:='Очки';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,6]:='Время';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,7]:='Штраф';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,8]:='Результат';
  Row:=Row+1;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,1]:='';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,2]:=Command[k].BasicNomber;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,3]:=Command[k].Group;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,4]:=Command[k].Name[1];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+1,4]:=Command[k].Name[2];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,5]:=Command[k].Point[1]+Command[k].Failyre[1];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+1,5]:=Command[k].Point[2]+Command[k].Failyre[2];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,6]:=Command[k].TimeDistanse[1];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+1,6]:=Command[k].TimeDistanse[2];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,7]:=Command[k].Failyre[1];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row+1,7]:=Command[k].Failyre[2];
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,8]:=Command[k].PointCommand;
  Row:=Row+2;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,1]:='Участник №1';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,6]:='Участник №2';  
  Row:=Row+1;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,1]:='Путь';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,2]:='Время';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,3]:='Сплит';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,4]:='Очки';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,6]:='Путь';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,7]:='Время';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,8]:='Сплит';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row,9]:='Очки';
  Row1:=Row;
  st:=' S';
  s:=0;
  n1:=Length(Command[k].Split[1]);
  if n1<>0 then  
  qSortSplitTime(Command[k].Split[1],0,n1-1);
  if n1<>0 then
  for i:=0 to n1-1 do
    begin
    Row1:=Row1+1;
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row1,1]:=St+'->'+Command[k].Split[1][i].Nom;
    St:=Command[k].Split[1][i].Nom;
    s:=s+StrToInt(Copy(Command[k].Split[1][i].Nom,1,2));
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row1,2]:=Command[k].Split[1][i].Time;
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row1,3]:=Command[k].Split[1][i].Split;
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row1,4]:=IntToStr(s);
    end;
    Row1:=Row1+1;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row1,1]:=St+'->F';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row1,2]:=Command[k].TimeDistanse[1];
//  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row1,3]:=Command[k].Split[1][i].Split;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row1,4]:=IntToStr(s);

  Row2:=Row;
  st:=' S';
  s:=0;
  n1:=Length(Command[k].Split[2]);
  if n1<>0 then
  qSortSplitTime(Command[k].Split[2],0,n1-1);
  if n1<>0 then
  for i:=0 to n1-1 do
    begin
    Row2:=Row2+1;
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row2,6]:=St+'->'+Command[k].Split[2][i].Nom;
    St:=Command[k].Split[2][i].Nom;
    s:=s+StrToInt(Copy(Command[k].Split[2][i].Nom,1,2));
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row2,7]:=Command[k].Split[2][i].Time;
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row2,8]:=Command[k].Split[2][i].Split;
    MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row2,9]:=IntToStr(s);
    end;
    Row2:=Row2+1;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row2,6]:=St+'->F';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row2,7]:=Command[k].TimeDistanse[2];
//  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row1,3]:=Command[k].Split[1][i].Split;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[Row2,9]:=IntToStr(s);

  IF Row1>Row2 then
    Row:=Row1+3
  else
    Row:=Row2+3;
  end;
end;

procedure TFMain.BtSaveDopClick(Sender: TObject);
var
  nom,i,j:LongWord;
begin
CheckExcelRun;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[1,1]:='Номер КП';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[1,2]:='Мин. время';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[1,3]:='Ном. команды';
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[1,4]:='Кол-во команд';
If Length(MinTimeKp)<>0 then
For i:=0 to Length(MinTimeKp)-1 do
  begin
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[2+i,1]:=MinTimeKp[i].NomKp;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[2+i,2]:=MinTimeKp[i].MinTime;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[2+i,3]:=MinTimeKp[i].NomKommand;
  MyExcel.ActiveWorkBook.ActiveSheet.Cells[2+i,4]:=MinTimeKp[i].KolPeople;
  end;

nom:=Length(MinTimeKp)+4;
MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,1]:='Откуда (КП)';
MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,2]:='Куда (КП)';
MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,3]:='Мин время';
MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,4]:='Ном. команд';
MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,5]:='Среднее время';
MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,6]:='Кол-во команд';
Inc(nom);
   If Length(TimeStartToNextKp)<>0 then
   For j:=0 to Length(TimeStartToNextKp)-1 do
     begin
     MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,1]:='СТАРТ';
     MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,2]:=TimeStartToNextKp[j].NomNextKp;
     MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,3]:=TimeStartToNextKp[j].MinTime;
     MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,4]:=TimeStartToNextKp[j].NomKommand;
     MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,5]:=TimeStartToNextKp[j].MidleTime/TimeStartToNextKp[j].KolPeople;
     MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,6]:=TimeStartToNextKp[j].KolPeople;
     Inc(nom);
     end;

If Length(MinTimeKp)<>0 then
For i:=0 to Length(MinTimeKp)-1 do
   If Length(MinTimeKp[i].TimeToNextKP)<>0 then
   For j:=0 to Length(MinTimeKp[i].TimeToNextKP)-1 do
     begin
     MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,1]:=MinTimeKp[i].NomKp;
     MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,2]:=MinTimeKp[i].TimeToNextKP[j].NomNextKp;
     MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,3]:=MinTimeKp[i].TimeToNextKP[j].MinTime;
     MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,4]:=MinTimeKp[i].TimeToNextKP[j].NomKommand;
     MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,5]:=MinTimeKp[i].TimeToNextKP[j].MidleTime/MinTimeKp[i].TimeToNextKP[j].KolPeople;
     MyExcel.ActiveWorkBook.ActiveSheet.Cells[nom,6]:=MinTimeKp[i].TimeToNextKP[j].KolPeople;
     Inc(nom);
     end;

end;

procedure TFMain.EdNomCommandChange(Sender: TObject);
begin
VivodCommand;
end;

end.
