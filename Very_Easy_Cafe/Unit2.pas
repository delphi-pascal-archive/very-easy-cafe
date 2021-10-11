unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBTables,DateUtils, ComCtrls, XPMan, Grids,
  DBGrids, ExtCtrls,StrUtils;

type
  TForm2 = class(TForm)
    DataSource1: TDataSource;
    Table1: TTable;
    list: TListBox;
    mois: TMonthCalendar;
    Clients: TEdit;
    Ressette: TEdit;
    XPManifest1: TXPManifest;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Shape1: TShape;
    Label6: TLabel;
    Image1: TImage;
    Image2: TImage;
    Shape2: TShape;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    j1: TShape;
    j2: TShape;
    j3: TShape;
    j4: TShape;
    j5: TShape;
    j6: TShape;
    j7: TShape;
    j8: TShape;
    j9: TShape;
    j10: TShape;
    j11: TShape;
    j12: TShape;
    j13: TShape;
    j14: TShape;
    j15: TShape;
    j16: TShape;
    j17: TShape;
    j18: TShape;
    j19: TShape;
    j20: TShape;
    j21: TShape;
    j22: TShape;
    j23: TShape;
    j24: TShape;
    j25: TShape;
    j26: TShape;
    j27: TShape;
    j28: TShape;
    j29: TShape;
    j30: TShape;
    j31: TShape;
    Image6: TImage;
    Shape3: TShape;
    Image7: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    num1: TLabel;
    num2: TLabel;
    num4: TLabel;
    num3: TLabel;
    num8: TLabel;
    num7: TLabel;
    num6: TLabel;
    num5: TLabel;
    num9: TLabel;
    num10: TLabel;
    num12: TLabel;
    num11: TLabel;
    num16: TLabel;
    num15: TLabel;
    num14: TLabel;
    num13: TLabel;
    num17: TLabel;
    num18: TLabel;
    num20: TLabel;
    num19: TLabel;
    num24: TLabel;
    num23: TLabel;
    num22: TLabel;
    num21: TLabel;
    num25: TLabel;
    num26: TLabel;
    num28: TLabel;
    num27: TLabel;
    num31: TLabel;
    num30: TLabel;
    num29: TLabel;
    Label42: TLabel;
    Labelmax: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure moisClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;
  tmp:variant;
implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
 list.Clear;
 Clients.Clear;
 Ressette.Clear;
 Table1.Open;
 Table1.Edit;
 Table1.First;
 While Table1.Eof=false do
 begin
   Table1.Delete;
 end;
end;

procedure TForm2.moisClick(Sender: TObject);
var moi,moi2,jour,max,i : integer;  wek : string;
jr : TShape; num : Tlabel;
t : array[1..31]of integer;
begin
 Clients.Text := '0' ;  //  inissialise les client a 0
 Ressette.Text := '0' ; //  inissialise la ressette a 0
 List.Clear ;//vide la liste avants chaque affichage
 Table1.Open;
 Table1.First ;//se maitre au debutde la table
   WHILE  Table1.Eof = false do  // tanque pas la fin de la table faire
   begin
   if (dateof((Table1.FieldByName('debut')).AsDateTime)=mois.Date) then  //si la datte selectionée = la datte rencontrer dans la table alors
     begin
     List.AddItem(timetostr((Table1.FieldByName('debut')).AsDateTime)+'  ------>  '+ timetostr((Table1.FieldByName('fin')).AsDateTime)+'   |   '+inttostr((Table1.FieldByName('cout')).Asinteger),list); //affiche le debut,lafin et le cout sur une memme ligne
     Clients.Text := inttostr(strtoint(clients.Text)+1); //incremente le nobre des client apres les convertions nessécaires
     Ressette.Text:=inttostr((strtoint(ressette.Text))   +   (Table1.FieldByName('cout') ).Asinteger    ); //cumulle les couts des clients apres les convertions nessécaires
     end;
    Table1.Next  ;
   end;
///////////////////////  Graphe

moi:=MonthOf(mois.Date);
Table1.First ;//se maitre au debutde la table
WHILE  Table1.Eof = false do  // tanque pas la fin de la table faire
begin
moi2:= MonthOf(dateof((Table1.FieldByName('debut')).AsDateTime));
    if moi = moi2 then
   begin
    jour:= DayOf(dateof((Table1.FieldByName('debut')).AsDateTime));
    t[jour]:=t[jour]+ strtoint(Table1.FieldByName('cout').AsString);
   end;
Table1.Next  ; //
end;
max := t[1];
for i:=2 to 31 do if t[i]>max then max:=t[i] ; //cherche la ressete max du mois
for i:=1 to 31 do //renissialisation du graphe avant modification
begin
jr :=TShape(Form2.FindComponent('j'+inttostr(i)));
num :=TLabel(Form2.FindComponent('num'+inttostr(i)));
jr.Height:= 200 ;//;
jr.Top:= 280;
jr.Visible := false;
num.Visible := false;
end;
labelmax.Visible := false;
Labelmax.Caption := inttostr(max)+' Da';
for i:=1 to 31 do //affichage du graphe
begin
if max<>0 then
  begin
  jr :=TShape(Form2.FindComponent('j'+inttostr(i)));
  num :=TLabel(Form2.FindComponent('num'+inttostr(i)));
  jr.Height:= round((t[i]) / max* 200) ;//;
  if ((t[i])=max) and(max <> 0) then
  begin
   labelmax.Left := jr.Left - (labelmax.Width div 2);
   labelmax.Visible := true;
   end ;
  jr.Top:= jr.Top+ (200-jr.Height);
  jr.Hint:=inttostr(t[i])+ ' Da' ;  //   02/04/2005
  wek := MidStr(datetostr(mois.Date),3,8);
  wek :=inttostr(i)+wek;
  if i<= DaysInAMonth(yearof(mois.Date),Monthof(mois.Date)) then   //si la datte existe on la colore et on l"affiche
    begin
    if DayOfWeek(strtodate(wek)) =7 then jr.Brush.Color :=$00EEDDFF else // samedi  --> la couleure la plus claire
      if DayOfWeek(strtodate(wek)) =1 then jr.Brush.Color :=$00E9D2FF else // dimanche
        if DayOfWeek(strtodate(wek)) =2 then jr.Brush.Color :=$00E2C6FF else // lundi
          if DayOfWeek(strtodate(wek)) =3 then jr.Brush.Color :=$00DDBBFF else // mardi
            if DayOfWeek(strtodate(wek)) =4 then jr.Brush.Color :=$00D5AAFF else // mercredi
              if DayOfWeek(strtodate(wek)) =5 then jr.Brush.Color :=$00CB97FF else // jeudi
                if DayOfWeek(strtodate(wek)) =6 then jr.Brush.Color :=$00C082FF ;    // vendredi  --> la couleure la plus Foncée
    jr.Visible := true;
    num.Visible := true;
    end;

  end;
end;
///////////////////////  Graphe

end;
procedure TForm2.FormCreate(Sender: TObject);
begin
mois.Date := now;
end;

end.

