unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus,StrUtils, Grids, DBGrids, DB, DBTables, ExtCtrls,
  ImgList,DateUtils, XPMan, ComCtrls,IniFiles, OleCtrls, SHDocVw, jpeg,
  ScktComp;

type
  TForm1 = class(TForm)
    Start: TButton;
    Debut: TButton;
    Fin: TButton;
    Nb: TEdit;
    a: TEdit;
    b: TEdit;
    PcOff: TImage;
    PcOn: TImage;
    allume: TImage;
    etaint: TImage;
    prix: TEdit;
    cout: TEdit;
    poste: TLabel;
    XPManifest1: TXPManifest;
    Shape1: TShape;
    Da: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Vide: TButton;
    DataSource1: TDataSource;
    Table1: TTable;
    Button1: TButton;
    Timer1: TTimer;
    consom: TEdit;
    pl: TLabel;
    eg: TLabel;
    totale: TEdit;
    Image1: TImage;
    Shape2: TShape;
    Image3: TImage;
    Image2: TImage;
    Timer2: TTimer;
    procedure StartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure prixChange(Sender: TObject);
    procedure NbChange(Sender: TObject);
    procedure prixClick(Sender: TObject);
    procedure NbClick(Sender: TObject);
    procedure VideClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ServerClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure prixKeyPress(Sender: TObject; var Key: Char);
    procedure NbKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
{=====================================================================}
  private { Déclarations privées }
{=====================================================================}
  public  { Déclarations publiques }
  Procedure entre(Sender: TObject); //declaration publique de la procedure des boutons Debut
  Procedure sorte(Sender: TObject); //declaration publique de la procedure des boutons Fin
  Procedure deplace (Sender: TObject); //procedure de changement de poste
  Procedure efface (Sender: TObject); //procedure de mise a zero
  Procedure consomation (Sender: TObject);
  Procedure entiere (Sender: TObject; var Key: Char); //pour interdire les valeurs non entieres
  procedure CError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);// Sever - Client
  procedure CRead(Sender: TObject;   Socket: TCustomWinSocket);// Sever
  procedure ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
  Procedure effaceconsom (Sender: TObject);
  end;
{=====================================================================}
var
  Form1: TForm1;
  posx,posy , i ,nbp: integer ;
  dtdp,hdp,IP,NUM,msg,msgcons,tmp,consomtmp :string;
  Tarifini : TIniFile;
  boule1: boolean ;
  t,confirm:array[1..999]of string;
implementation

uses Unit2;

{$R *.dfm}
{=====================================================================}
Procedure TForm1.entre(Sender: TObject); //procedure des boutons debut
var j,i,msg :string ;
     Edita,consom :tedit;
     Buttonf,debut : Tbutton;
     ImagePcOn :TImage ;
     Client : TClientSocket ;
     //repetition :integer;
Begin
  {--------------------------------}//Identification des composant
  j:=TButton(Sender).Name;//le nom du bouton qui a fait l'action
  i:= MidStr(j,6,3);//recuperation du numero du bouton apartir de son nom
  Edita:=TEdit(Form1.FindComponent('a'+i));//creation du nom du champ de debut en cours
  Buttonf:=TButton(Form1.FindComponent('fin'+i));//creation du nom du bouton de fin en cours
  debut:= Tbutton(Form1.FindComponent('debut'+i));//
  consom:= TEdit(Form1.FindComponent('consom'+i));
  imagePcOn:=TImage(Form1.FindComponent('PcOn'+i));//creation du nom de l'image du Pc allume
  Client :=TClientSocket(Form1.FindComponent('Client'+i));
  {--------------------------------}//Identification des composant
  {--------------------------------}//Traitement
  //confirm[strtoint(i)]:= 'non';   repetition:=0;
  Edita.Text:= timetostr(now); // affiche de l'eure de debut dans le champ en cours
  Buttonf.Enabled := true ; //rend le bouton fin clicable
  debut.Enabled := false;
  ImagePcOn.Visible := true; // affiche l'image du Pc Alumer
  consom.Enabled := true;
  {--------------------------------}//Traitement
  {--------------------------------}//ini
   Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
   Tarifini.WriteString(i,'Debut',datetimetostr(now));   //Ecrit dans le fichier ini
   msg:='min'+Edita.Text+'00:00:00'; //min ets le message d'ouverture de sission qui seras envoyer au cliet poste:i
   Client.Close ;
   Client.Port:=2000; //Definit le port
   Client.Host := (Tarifini.ReadString(i,'IP','')); //recuper l(adresse IP du client i du fichier ini enregistré precedament
   if  Client.Host<>'' then
   begin
     //while  (repetition<=4)do
     //begin
      // if (confirm[strtoint(i)]= 'non') then
      // begin
       //showmessage(Client.Host);
       t[strtoint(i)]:= msg;
       Client.Open;
       //sleep(500);
        
       //showmessage(inttostr(repetition));
     //end;
   //repetition:=repetition+1;
   //end;
   end;
   Tarifini.Free;
  {--------------------------------}//ini
End;
{=====================================================================}
Procedure TForm1.sorte(Sender: TObject);//procedure des boutons fin
var j,i,msg ,  minutes: string  ;
   Editb,Editcout,totale,consom:tedit;
   ImagePcOn:TImage ;
   fin : Tbutton;
   Client : TClientSocket ;
   //repetition : integer;
Begin
  {--------------------------------}//Identification du composant
  j:=TButton(Sender).Name;//le nom du bouton qui a fait l'action
  i:= MidStr(j,4,3);//recuperation du numerodu bouton apartir de son nom
  Editb:=TEdit(Form1.FindComponent('b'+i));//creation du nom du champ cible
  Editcout:=TEdit(Form1.FindComponent('cout'+i));// /creation du nom du champ du cout
  totale:=TEdit(Form1.FindComponent('totale'+i));//
  consom:=TEdit(Form1.FindComponent('consom'+i));//
  fin:= Tbutton(Form1.FindComponent('fin'+i));//
  ImagePcOn:=TImage(Form1.FindComponent('PcOn'+i));//creation du nom de l'image du Pc allume
  Client :=TClientSocket(Form1.FindComponent('Client'+i));
  {--------------------------------}//Identification du composant
Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
  {--------------------------------}//Traitement
  //confirm[strtoint(i)]:= 'non';  repetition:=0;
  Editb.Text := timetostr(now); // affiche le l'eure de fin
  minutes:=inttostr(minutesbetween(strtodatetime(Tarifini.Readstring(i,'Debut','')),(now)) ); // renvoit le nombre de minutes entre Edittmpa.text et Edittmpb.texte apres convertion vers datetime et reconvertion du resulta de intger vers tsr
  Editcout.Text :=vartostr(int( ( StrToFloat(prix.Text)/60   )  *  StrToFloat(minutes) )); // le produit du nombre de minutes tmpc et le prix d'une minute pour avoir le cout total
  totale.Text := inttostr((StrToint(Editcout.Text)+StrToint(consom.Text)));
  Totale.Enabled := true;
  Totale.Cursor := crHandPoint;
  ImagePcOn.Visible := false ;// Cache l'image du Pc Alumer
  fin.Enabled := false;
  consom.Enabled := false ;
   Table1.Last;
   Table1.Insert; {--------------------------------}//partie enregistrement dans la table
   Table1.FieldByName('debut').AsString:= (Tarifini.Readstring(i,'Debut',''));   //enregistrement dans la bdd de la dete + l'heur d'entrée contenue dans tmpd
   Table1.FieldByName('fin').AsString:= datetimetostr(now);   //  enregistrement dans la bdd de la dete + l'heur de sortie contenue dans tmpd
   Table1.FieldByName('cout').AsString:=totale.Text; // enregistrment du cout de connexion

   table1.Post;
   {--------------------------------}//Traitement
   {--------------------------------}//ini
   Tarifini.WriteString(i,'Debut','*');   //Ecrit dans le fichier ini
   Tarifini.WriteString(i,'consom','000');
   msg:='max';//min ets le message de frmeture de sission qui seras envoyer au cliet poste:i
   Client.Close ;
   Client.Port:=2000; //Definit le port >= 1024 (ex:2000)
   Client.Host := (Tarifini.ReadString(i,'IP','')); //Definit l'adresse de l'hote (adresse ip)
   if  Client.Host<>'' then
   begin
    // while (confirm[strtoint(i)]= 'non') or (repetition<=4)do
    // begin
     //showmessage(Client.Host);
     t[strtoint(i)]:= msg;
     Client.Open;
     
    // sleep(500);
    // repetition:=repetition+1;
    // end;
   end;
   Tarifini.Free;
  {--------------------------------}//ini
End;
{=====================================================================}
procedure TForm1.StartClick(Sender: TObject);//procedure de creation des composants
 var i : integer;
  Edita,Edittmpa,consom :tedit;
  Buttonf : Tbutton;
  ImagePcOn :TImage ;
  Server: TServerSocket ;
  Client: TClientSocket ;
  tmpa :string;
 begin
  Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
  boule1:=false;
  nbp:=strtoint(nb.Text);
  posy:=3;//position horizontal initiale
  posx:=7;
  Vide.Enabled :=true; //le bouton d'efacement des pc
  for i :=1 to strtoint(nb.Text) do
  begin
  if (posy > form1.ClientWidth-325)then  posy :=3; //si posy > a la taille horisontale de lla fiche - 275 pixel( la taille aproximative d'un poste avec ces marges ..pour afficher soit en 2 ou 3ou en 4 rangés
  if (posy=3) then  posx:=posx+70  ;  //petit astuce pour sauter de ligne chque 2 oui 3 iteration de boucle
                        {----------------------------------------------------------------}
          {------------}//debut de creation des element qui constitue un seule poste//{------------}
   {----------------------------}//Image cadre
  Shape1 := TShape.Create(Self);
  Shape1.Parent := Self;
  Shape1.Name := 'Shape1' + inttostr(i);
  Shape1.top := posx ;  Shape1.Left := posy;
  Shape1.Brush.Style := bsClear;
  Shape1.Width := 330;
  {----------------------------}//Image cadre
  {----------------------------}//Image PcOff
  PcOff := TImage.Create(Self);
  PcOff.Parent := Self;
  PcOff.Name := 'PcOff' + inttostr(i);
  PcOff.top := Shape1.top +5;  PcOff.Left:=5 +   Shape1.Left  ;
  PcOff.Picture :=etaint.Picture;
  PcOff.Transparent := true;
  PcOff.OnClick := deplace;
  PcOff.AutoSize := true ;
  {----------------------------}//Image PcOff
  {----------------------------}//Image PcOn
  PcOn := TImage.Create(Self);
  PcOn.Parent := Self;
  PcOn.Name := 'PcOn' + inttostr(i);
  PcOn.top := PcOff.Top ; PcOn.Left:=PcOff.Left ;
  PcOn.Picture :=allume.Picture;
  PcOn.Transparent := true;
  PcOn.Visible := false;
  PcOn.OnClick := deplace;
  PcOn.Hint :='Cliquez ici pour déplacer le client de ce poste vers un autre poste éteint .';
  PcOn.ShowHint := true;
  PcOn.AutoSize := true ;
  PcOn.Cursor :=  crHandPoint;
  {----------------------------}//Image PcOn
  {----------------------------}//labele de poste
  Poste := Tlabel.Create(Self);
  Poste.Parent := Self;
  Poste.Name := 'Poste' + inttostr(i);
  Poste.top := PcOff.Top+46 ; Poste.Left:=PcOff.Left-2 ;
  Poste.Caption :=Poste.Name;
  Poste.Transparent := true;
  //Poste.Font.Size := 10;
  Poste.font.Style :=[fsBold];
  {----------------------------}//labele de poste
  {----------------------------}//Champ a
  a := TEdit.Create(Self);
  a.Parent := Self;
  a.Name := 'a' + inttostr(i);
  a.top := Shape1.Top+5; a.left := PcOn.Left+55; a.Width := 49;
  a.Clear;
  a.Ctl3D := false;
  a.Enabled := false;
  {----------------------------}//Champ a
  {----------------------------}//Bouton Debut
  Debut := TButton.Create(Self);
  Debut.Parent := Self;
  Debut.Name := 'Debut' + inttostr(i);
  Debut.top := a.top + 30;  Debut.Left := a.Left;  debut.Width :=a.Width ;
  Debut.OnClick :=  entre;
  Debut.Caption := 'Début' ;
  Debut.Hint :='Cliquez ici pour Commencer une session sur ce poste .';
  Debut.ShowHint := true;
  {----------------------------}//Bouton Debut
  {----------------------------}//Champ b
  b := TEdit.Create(Self);
  b.Parent := Self;
  b.Name := 'b' + inttostr(i);
  b.top := a.top ;    b.left := a.Width+a.Left + 5; b.Width :=a.Width;
  b.Clear;
  b.Ctl3D := false;
  b.Enabled := false;
  {----------------------------}//Champ b
  {----------------------------}//Bouton Fin
  Fin := TButton.Create(Self);
  Fin.Parent := Self;
  Fin.Name := 'Fin' + inttostr(i);
  Fin.top := Debut.top; Fin.left :=b.Left ;  fin.Width:=a.Width;
  Fin.OnClick :=  sorte;
  Fin.Enabled := false;
  Fin.Caption := 'Fin' ;
  Fin.Hint :='Cliquez ici pour Arrêter la session  et calculer le montant de ce poste .';
  Fin.ShowHint := true;
  {----------------------------}//Bouton Fin
  {----------------------------}//Champ cout
  cout := TEdit.Create(Self);
  cout.Parent := Self;
  cout.Name := 'cout' + inttostr(i);
  cout.top := b.top ;    cout.left :=  b.Width +b.Left+5;  cout.Height := b.Height   ;
  cout.Clear;
  cout.Width :=b.Width;
  cout.Ctl3D := false;
  cout.Hint :='Cliquez ici pour vider ce poste .';
  cout.ShowHint := true;
  cout.Enabled := false;
  cout.Color := $00EFD3C6  ;
  {----------------------------}//Champ cout
  {----------------------------}//Champ consom
  consom := TEdit.Create(Self);
  consom.Parent := Self;
  consom.Name := 'consom' + inttostr(i);
  consom.top := cout.top + cout.Height+15 ;    consom.left := cout.Left; // consom.Height := fin.Height;
  consom.Width :=cout.Width;
  consom.Ctl3D := false;
  consom.Hint :='Gravure , Impression , Traitement de texte , ou autres consommations ...';
  consom.ShowHint := true;
  consom.Text := '000' ;
  consom.OnChange := consomation;
  consom.OnKeyPress := entiere;
  consom.OnClick := effaceconsom;
  consom.Enabled := false ;
  consom.Color := $00EFD3C6  ;
  consom.Cursor :=  crHandPoint;
  {----------------------------}//Champ consom
  {----------------------------}//labele +
  pl := Tlabel.Create(Self);
  pl.Parent := Self;
  pl.Name := 'pl' + inttostr(i);
  pl.top :=cout.top + cout.Height-5  ; pl.Left:=cout.Left+20 ;
  pl.Caption :='+';
  pl.Font.Size :=10;
  pl.Font.Name := 'Arial Black';
  pl.Font.Size :=12;
  pl.Font.Color := $00984E00;
  pl.Transparent := true;
  {----------------------------}//labele +
  {----------------------------}//labele =
  eg := Tlabel.Create(Self);
  eg.Parent := Self;
  eg.Name := 'eg' + inttostr(i);
  eg.top :=consom.top + 2  ; eg.Left:=consom.Left+ consom.Width+2 ;
  eg.Caption :='=';
  eg.Font.Size :=10;
  eg.Font.Name := 'Arial Black';
  eg.Font.Size :=12;
  eg.Font.Color := $00984E00;
  eg.Transparent := true;
  {----------------------------}//labele =
  {----------------------------}//Champ totale
  totale := TEdit.Create(Self);
  totale.Parent := Self;
  totale.Name := 'totale' + inttostr(i);
  totale.top := b.top +9;    totale.left :=  cout.Width +cout.Left+15; // totale.Height := 60   ;
  totale.OnClick := efface;
  totale.Clear;
  totale.Width :=60;
  totale.Font.Size :=20;
  totale.Font.Color := $00984E00;
  totale.Font.Name := 'Arial Black';
  totale.Ctl3D := false;
  totale.Color :=clInfoBk;
  totale.Hint :='Cliquez ici pour vider ce poste .';
  totale.ShowHint := true;
  Totale.Enabled := false  ;
  {----------------------------}//Champ totale
  {----------------------------}//labele Da
  Da := Tlabel.Create(Self);
  Da.Parent := Self;
  Da.Name := 'Da' + inttostr(i);
  Da.top :=totale.Top+8 ; Da.Left:=totale.Left+totale.Width+2 ;
  Da.Caption :='Da';
  Da.Font.Size :=18;
  Da.Font.Name := 'Arial Black';
  Da.Font.Color := $00984E00;
  Da.Transparent := true;
  {----------------------------}//labele Da
  {----------------------------}//Server
  Server := TServerSocket.Create(Self);
  Server.Name := 'Server' + inttostr(i);
  Server.OnClientRead := CRead;
  Server.Port:=2000+i; //Définit le port utilisé >=1024 (ex:2000)
  Server.Open;
  Server.OnClientError := CError;
  {----------------------------}//Server
  {----------------------------}//Client
  Client := TClientSocket.Create(Self);
  Client.Name := 'Client' + inttostr(i);
  Client.OnError := CError;
  Client.OnConnect := ClientConnect;
  {----------------------------}//Client
           {------------}//fin de creation des element qui constitue un seule poste//{------------}
                      {------------------------------------------------------------}
  posy:=posy+333;//increment la position horiontal par la taille horizontal d'un pc avec la marge droite
     {----------------------------}// ini / verification si le poste crée ne contient pas un enregistrement deja actif dans le ini
     if ((Tarifini.ReadString(inttostr(i),'Debut',''))<>'*') and ((Tarifini.ReadString(inttostr(i),'Debut',''))<>'')then
     begin
     {----------------------------}//Réactivation
     a.Text :=  timetostr(strtodatetime(Tarifini.Readstring(inttostr(i),'Debut',''))) ;//timetostr(strtodatetime(tmpa)); // affiche de l'eure de debut dans le champ en cours
     consom.Text :=  Tarifini.ReadString(inttostr(i),'consom','');
     consom.Enabled := true;
     fin.Enabled := true ; //rend le bouton fin clicable
     debut.Enabled := false ;
     PcOn.Visible := true;
     {----------------------------}//Réactivation
     end;
end;
  {----------------------------}//ini /sauvegarde du nobre de poste et du tarif de conexion actuele pour une prochaine utilisation
   Tarifini.WriteString('Nb','Nb',nb.Text);   //Ecrit dans le fichier ini le nombre de postes
   Tarifini.WriteString('prix','prix',prix.Text);   //Ecrit dans le fichier ini le tarif
   Tarifini.Free;
  {----------------------------}//ini /sauvegarde du nobre de poste et du tarif de conexion actuele pour une prochaine utilisation
  form1.Caption :='VeryEasyCafe'+' - '+nb.Text +' Poste(s)';//affichage dans la bare des titres
  Nb.Clear;//efacement du nombre de pc a crée apres leurs creation pour rendre la bouton star(crée) disabled pour eviter que l'utilisateure clicke dessue de nouveaux
  boule1:= true;
end;
{=====================================================================}
procedure TForm1.FormCreate(Sender: TObject);
begin

 boule1 := true;
 DoubleBuffered := true;
 form1.Caption := 'VeryEasyCafe';//affichage dans la bare des titres
 table1.Open;
 table1.Last; //deplassement vers la dernier position de la table
 Vide.Enabled := false ; //on cache le bouton vide
 if (Screen.Width>800) then form1.ClientWidth :=1014 else if (Screen.Width=800) then form1.ClientWidth :=687 else form1.ClientWidth:=340; //petite prevention
 Application.HintPause:=200; //200ms
 Application.HintHidePause:=5000; //2 secondes (2000ms)
 {----------------------------}//ini /recuperatin du tarif et du nombre de poste precedant pour les reutiliser directement
   Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
   if ((Tarifini.ReadString('Nb','Nb','')) <>'*')then Nb.Text :=(Tarifini.ReadString('Nb','Nb','')); //si la clé Nombre de poste dans le ini n'est pas vide alors on la reutilise
   if ((Tarifini.ReadString('prix','prix','')) <>'*')then prix.Text :=(Tarifini.ReadString('prix','prix','')); //si la clé prix dans le ini n'est pas vide alors on la reutilise
   Tarifini.Free;
   if (Nb.Text<>'')and(prix.Text<>'') then Start.Click;//si les champs prix et nombre de poste sont non vide crée les poste
 {----------------------------}//ini /recuperatin du tarif et du nombre de poste precedant pour les reutiliser directement
end;
{=====================================================================}
Procedure TForm1.deplace(Sender: TObject);
Var i,j,k,msg,hh,mm :string ;    ecoule : integer;
     Edita,Editb,totale,consom :tedit;
     Buttonf,Buttond : Tbutton;
     ImagePcOn :TImage ;
     Client : TClientSocket ;
    // repetition,l:integer;

Begin
  boule1:=false;
  j:=TImage(Sender).Name;//le nom du bouton qui a fait l'action
  k:= MidStr(j,1,4)  ; //recuperation des 4 letre du nom de limage apartire du premier caractaire
if (k='PcOn') and (HDp ='' )then {------------------------------------------}// si l'image clickée est celle d'un poste Origine (pc allumé)a deplacer alors
begin
    {----------------------------}//Identification des composants
    i:= MidStr(j,5,3);//recuperation du numero du bouton ( l'image) apartir de son nom
    consom:=TEdit(Form1.FindComponent('consom'+i));//creation du nom du champ a deplacer
    Edita:=TEdit(Form1.FindComponent('a'+i));//creation du nom du champ a deplacer
    Editb:=TEdit(Form1.FindComponent('b'+i));//creation du nom du champ a deplacer
    totale:=TEdit(Form1.FindComponent('totale' + i));
    Buttonf:=TButton(Form1.FindComponent('fin'+i));//creation du nom du bouton de fin en cours
    Buttond:=TButton(Form1.FindComponent('debut'+i));
    ImagePcOn:=TImage(Form1.FindComponent('PcOn'+i));//creation du nom de l'image du Pc allume
    Client :=TClientSocket(Form1.FindComponent('Client'+i));
    {----------------------------}//Identification du composant
    //confirm[strtoint(i)]:= 'non';  repetition:=0;
    consom.OnChange := nil;//desactive a procedure consom.Onchange avant le traitement pour ne pas qu'il y est une interferance a avec son execution parce quelle utilise des variable partagées qui risquent d'etre perdues
    Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
    tmp :=Tarifini.readString(i,'Debut','*');   //Ecrit dans le fichier ini
    consomtmp :=Tarifini.readString(i,'consom','');
    {----------------------------}//Traitement de deplacement ( lecture )
    Buttonf.Enabled := false ; //rend le bouton fin a du poste a deplacer invisible
    Buttond.Enabled := true ;
    ImagePcOn.Visible := false; // cache l'image du Pc Alumer apres le clike de deplacement
    dtdp:= tmp; //tmp:='';// effacement de la date+heure apres auvegarde dans la variable date+heure de deplacement DtDp
    hdp :=  Edita.Text;
    Edita.Clear;// effacement de la l'heure apres auvegarde dans la variable heure de deplacement HDp
    Editb.Clear;
    totale.Clear;
    consom.Text :='000';//
    consom.Enabled := false ;
    {----------------------------}//Traitement de deplacement ( lecture )
    {----------------------------}//ini /suprime l'heure d'entré de ce poste , du fichie ini
    msg:='max'; //min ets le message de fermeture de sission qui seras envoyer au cliet poste:i
    Client.Close ;
    Client.Port:=2000; //Definit le port
    Client.Host := (Tarifini.ReadString(i,'IP','')); //recuper l(adresse IP du client i du fichier ini enregistré precedament
    if  Client.Host<>'' then
    begin
     //while (confirm[strtoint(i)]= 'non') or (repetition<=4)do
     //begin
     //showmessage(Client.Host);
     t[strtoint(i)]:= msg;
     Client.Open;
    
    // sleep(500);
    // repetition:=repetition+1;
    // end;
    end;
    Tarifini.WriteString(i,'Debut','*');   //Ecrit dans le fichier ini
    Tarifini.WriteString(i,'consom','000');
    Tarifini.Free;
    form1.Cursor :=  crDrag;
    {----------------------------}//ini /suprime l'heure d'entré de ce poste , du fichie ini
end;{---------------------------------------------------------------------------------------------}
if (k='PcOf') and (HDp <>'' )then {---------------------------------------------}// si l'image clickée est celle d'un poste Cible (pc etaint)etaint ET Hdp n'est pas vid alors
begin
    {----------------------------}//Identification des composants
    i:= MidStr(j,6,3);//recuperation du numero du bouton (TImage) apartir de son nom
    consom:=TEdit(Form1.FindComponent('consom'+i));//creation du nom du champ a deplacer
    Edita:=TEdit(Form1.FindComponent('a'+i));//creation du nom du champ de debut de destination qui affiche l'heure d'entrée
    Buttonf:=TButton(Form1.FindComponent('fin'+i));//creation du nom du bouton de fin de destination
    Buttond:=TButton(Form1.FindComponent('debut'+i));
    ImagePcOn:=TImage(Form1.FindComponent('PcOn'+i));//creation du nom de l'image du Pc a allumer de destination
    Client :=TClientSocket(Form1.FindComponent('Client'+i));
    {----------------------------}//Identification du composant
    {----------------------------}//Traitement de deplacement ( Ecriture )
   // confirm[strtoint(i)]:= 'non';   repetition:=0;
    boule1:=false;
    Buttonf.Enabled := true ; //rend le bouton fin clickable
    Buttond.Enabled := False ;
    ImagePcOn.Visible := true; // affiche l'image du Pc Alumer
    tmp :=dtdp;// afectation de la datte +heure du poste Origine
    Edita.Text :=hdp    ; //affichage de l'heure du poste Origine
    DtDp := ''; //vidage au cas ou ;-)
    HDp  :=''; // showmessage(consomtmp);       //vidage au cas ou ;-)
    consom.Enabled := true ;
    {----------------------------}//Traitement de deplacement ( Ecriture )
    {----------------------------}//ini /ecrit l'eure de conexion de ce pc dans le ini
    Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
    Tarifini.WriteString(i,'Debut', tmp);   //Ecrit dans le fichier ini
    Tarifini.WriteString(i,'consom', consomtmp);
    {----------------------------}//ini /ecrit l'eure de conexion de ce pc dans le ini
    //msg:='min'+edita.Text+consomtmp;
    ecoule:=(minutesbetween(strtodatetime(tmp),(now)));
    hh:=inttostr(ecoule div 60); if Length(hh)=1 then hh:='0'+hh;
    mm:=inttostr(ecoule mod 60); if Length(mm)=1 then mm:='0'+mm;
    msg:='min'+edita.Text+(hh+':'+mm+':'+'00')+consomtmp;

    Client.Close ;
    //t[strtoint(i)]:='min'+edita.Text+consomtmp;
    Client.Port:=2000; //Definit le port
    Client.Host := (Tarifini.ReadString(i,'IP','')); //recuper l(adresse IP du client i du fichier ini enregistré precedament
    if  Client.Host<>'' then
   begin
    // while (confirm[strtoint(i)]= 'non') or (repetition<=4)do
    // begin
     //showmessage(Client.Host);
     t[strtoint(i)]:= msg;
     Client.Open;
     
     //sleep(500);
     //repetition:=repetition+1;
    // end;
   end;
    Tarifini.Free;
    form1.Cursor :=  crDefault;    consom.Text := consomtmp;  consomtmp:='';
    consom.OnChange := consomation; // reactive la procedure on change a la fin du deplacement
    end;{-----------------------------------------------------------------------}
boule1:=true;
end;
{=====================================================================}
Procedure TForm1.efface(Sender: TObject);
Var j,k :string ;
     Edita,Editb,Editcout :tedit;
     debut,fin : Tbutton;
     ImagePcOn :TImage ;
Begin
  j:=TEdit(Sender).Name;//le nom du bouton qui a fait l'action
  k:= MidStr(j,7,3)  ;
  {----------------------------}//Identification des composants
  totale:=TEdit(Form1.FindComponent('totale'+k));//creation du nom du champ a deplacer
  consom:=TEdit(Form1.FindComponent('consom'+k));//creation du nom du champ a deplacer
  Edita:=TEdit(Form1.FindComponent('a'+k));//creation du nom du champ a deplacer
  debut:=TButton(Form1.FindComponent('debut'+k));//creation du nom du bouton de fin en cours
  fin:=TButton(Form1.FindComponent('fin'+k));//creation du nom du bouton de fin en cours
  Editb:=TEdit(Form1.FindComponent('b'+k));//creation du nom du champ de debut qui contien la date + heure a deplacer
  Editcout:=TEdit(Form1.FindComponent('cout'+k));//creation du nom du champ de debut qui contien l
  ImagePcOn:=TImage(Form1.FindComponent('PcOn'+k));//creation du nom de l'image du Pc allume
  {----------------------------}//Identification du composant
  {----------------------------}//Traitement
  debut.Enabled := true ; //vidage
  fin.Enabled := false ;
  Edita.Clear;
  Editb.Clear;
  Editcout.Clear;
  consom.Text :='000';
  totale.Clear;
  totale.Enabled := false;
  ImagePcOn.Visible := false;
  {----------------------------}//vidage
  {----------------------------}//ini
   Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
   Tarifini.WriteString(k,'Debut','*');   //Ecrit dans le fichier ini
   Tarifini.Free;
  {----------------------------}//ini
end;
{=====================================================================}
procedure TForm1.prixChange(Sender: TObject);
begin
if (prix.Text<>'') and(strtoint(prix.Text)<>0 )then Nb.Enabled:=true else nb.Enabled :=false;
end;
{=====================================================================}
procedure TForm1.NbChange(Sender: TObject);
begin
if (nb.Text<>'') and(strtoint(nb.Text)<>0 )  and (vide.Enabled = false)then Start.Enabled:=true else Start.Enabled :=false;
end;
{=====================================================================}
procedure TForm1.prixClick(Sender: TObject);
begin
prix.Clear;
end;
{=====================================================================}
procedure TForm1.NbClick(Sender: TObject);
begin
Nb.Clear;
end;
{=====================================================================}
procedure TForm1.VideClick(Sender: TObject);
Var i:Integer;
begin
   vide.Enabled := false ;
  For i:=ComponentCount-1 DownTo 33 Do Components[i].Free; //25 est le nombre d'object et parents deja present sur la fiche avant la creation dees poste
   form1.Caption :='VeryEasyCafe';
   Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
   Tarifini.WriteString('Nb','Nb','*');   //Ecrit dans le fichier ini le nombre de postes
   Tarifini.WriteString('prix','prix','*');   //Ecrit dans le fichier ini le tarif
   Tarifini.Free;
end;
{=====================================================================}
procedure TForm1.Button1Click(Sender: TObject);
begin
form2.Show;
end;
{=====================================================================}
procedure TForm1.Button2Click(Sender: TObject);
begin

end;

{=====================================================================}
procedure TForm1.ServerClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
ErrorCode := 0 ;
end;
{=====================================================================}
procedure TForm1.ClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
ErrorCode := 0 ;
end;
{=====================================================================}
procedure TForm1.Timer1Timer(Sender: TObject);
var i : integer;
begin
for i := 1 to  nbp  do
begin

end;
end;
{=====================================================================}
Procedure TForm1.consomation(Sender: TObject);//procedure des des champ de consomation secondaire qui enregistre la valeure dans le ini si pendant  son introduction
Var j,k :string ;
     consom :tedit;
     Client :TClientSocket;
Begin

Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
j:=TEdit(Sender).Name;//le nom du bouton qui a fait l'action
k:= MidStr(j,7,3)  ;
  {----------------------------}//Identification des composants
  consom:=TEdit(Form1.FindComponent('consom'+k));//creation du nom du champ a deplacer
  Client :=TClientSocket(Form1.FindComponent('Client'+k));
  {----------------------------}//Identification du composant
if (consom.Text ='') then
begin
consom.Text:='000';
consomation(consom); //rapelle de la procedure apres le changement de la valeure pour qu'elle fasse le reste du travaille
end;
if (boule1=true ) and (consomtmp ='') and (totale.Text ='')then  Tarifini.WriteString(k,'consom',consom.Text);   //Ecrit dans le fichier ini
   msg:='con'+inttostr(strtoint(consom.Text )); //min ets le message d'ouverture de sission qui seras envoyer au cliet poste:i
   Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
   Client.Close ;
   Client.Port:=2000; //Definit le port
   Client.Host := (Tarifini.ReadString(k,'IP',''));// showmessage('rrr');//recuper l(adresse IP du client i du fichier ini enregistré precedament
   if  (Client.Host<>'')  then
   begin
   //showmessage(Client.Host);
   t[strtoint(k)]:= msg;
   Client.Open; //Ouvre la connexion de socket  , et a l'ouverture le message contenue dans msg seras envoyer avec l'evenement onclientconnecte
   end;


end;
{=====================================================================}
Procedure TForm1.entiere(Sender: TObject; var Key: Char);//procedure des des champ de consomation secondaire qui enregistre la valeure dans le ini si pendant  son introduction
Begin
if not (Key in ['0'..'9']) then Key := #0;
end;
{=====================================================================}
procedure TForm1.prixKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key in ['0'..'9']) then Key := #0;
end;
{=====================================================================}
procedure TForm1.NbKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key in ['0'..'9']) then Key := #0;
end;
{=====================================================================}
procedure TForm1.FormResize(Sender: TObject);
begin
Shape2.Width :=form1.Width - 8;
Image3.Left:= (form1.Width div 2)-(Image3.Width div 2);
image2.Top := (form1.Height div 2) - (image2.Height div 2)+20 ;  if image2.Top< 74 then image2.Top :=74 ;
image2.Left := (form1.Width div 2) - (image2.Width div 2) ;
{if (form1.Width <375) and (form1.Width >355) then form1.Width :=350;
if (form1.Width <715) and (form1.Width >695) then form1.Width :=690;
if (form1.Width <1055) and (form1.Width >1035) then form1.Width :=1030; }
end;
{=====================================================================}
procedure TForm1.CError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
ErrorCode := 0 ;
end;
{=====================================================================}
procedure TForm1.CRead(Sender: TObject;   Socket: TCustomWinSocket);
var x,ip,num,msg,hh,mm:string; ecoule : integer;
ImagePcOn : timage;
edita,consom :tedit;
Client : TClientSocket;
begin
  x:=(Socket.ReceiveText);
  
  if MidStr(x,1,3) = 'num' then {---------------------------------------------}
    begin
    NUM:= inttostr(strtoint(MidStr(x,4,3)));
    IP:=  MidStr(x,7,15);
  // if (x = 'ressue') then confirm[strtoint(num)]:= 'oui';
    ImagePcOn:=TImage(Form1.FindComponent('PcOn'+num));//creation du nom de l'image du Pc allume
    edita:=Tedit(Form1.FindComponent('a'+num));
    consom:=Tedit(Form1.FindComponent('consom'+num));
    Client :=TClientSocket(Form1.FindComponent('Client'+num));

    Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
    Tarifini.WriteString(num,'IP',IP);   //Ecrit dans le fichier ini
    
    if (imagepcon.Visible = true)  then
    begin
      ecoule:=(minutesbetween(strtodatetime(Tarifini.readString(num,'Debut','*')),(now)));
      hh:=inttostr(ecoule div 60); if Length(hh)=1 then hh:='0'+hh;
      mm:=inttostr(ecoule mod 60); if Length(mm)=1 then mm:='0'+mm;
      msg:='min'+edita.Text+(hh+':'+mm+':'+'00')+consom.Text;

    end else   msg:='max';
    Client.Close ;
    Client.Port :=2000;
    Client.Host := IP; //Definit l'adresse de l'hote (adresse ip)
    if  Client.Host<>'' then
    begin
    //showmessage(Client.Host);
    t[strtoint(num)]:= msg;
    Client.Open; //Ouvre la connexion de socket
    end;
    end;
Tarifini.Free;
end;
{=====================================================================}
procedure TForm1.ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var i,j : string;
Client :TClientSocket;
begin
  j:=TClientSocket(Sender).Name;//le nom du bouton qui a fait l'action
  i:= MidStr(j,7,3);
  Client :=TClientSocket(Form1.FindComponent('Client'+i));
  Client.Socket.SendText(t[strtoint(i)]); //showmessage(msg);
  //t[strtoint(i)]:='';
  //Client.Close ;
end;
{=====================================================================}

Procedure TForm1.effaceconsom(Sender: TObject);
Var j,k :string ;
     consom:tedit;
Begin
  j:=TEdit(Sender).Name;//le nom du bouton qui a fait l'action
  k:= MidStr(j,7,3)  ;
  {----------------------------}//Identification des composants
  consom:=TEdit(Form1.FindComponent('consom'+k));//creation du nom du champ a deplacer
  {----------------------------}//Identification du composant
  {----------------------------}//Traitement

  consom.Text :='000';

  {----------------------------}//vidage
  {----------------------------}//ini
   //Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
   //Tarifini.WriteString(k,'Debut','*');   //Ecrit dans le fichier ini
   //Tarifini.Free;
  {----------------------------}//ini
end;
{=====================================================================}
procedure TForm1.Timer2Timer(Sender: TObject);
var i:integer;
  minutes: string  ;
   Editb,Editcout,totale,consom:tedit;
   ImagePcOn:TImage ;


begin
if (nbp<>0)then
  for i:=1 to nbp do
  begin
  {--------------------------------}//Identification du composant
  ImagePcOn:=TImage(Form1.FindComponent('PcOn'+inttostr(i)));//creation du nom de l'image du Pc allume
  Editb:=TEdit(Form1.FindComponent('b'+inttostr(i)));//creation du nom du champ cible
  Editcout:=TEdit(Form1.FindComponent('cout'+inttostr(i)));// /creation du nom du champ du cout
  totale:=TEdit(Form1.FindComponent('totale'+inttostr(i)));//
  consom:=TEdit(Form1.FindComponent('consom'+inttostr(i)));//
  {--------------------------------}//Identification du composant
Tarifini:=TIniFile.Create('d:\tmp\Tarifini.ini');
  {--------------------------------}//Traitement
if ( ImagePcOn.Visible = true )and (prix.Text<>'') then begin
  Editb.Text := timetostr(now); // affiche le l'eure de fin
  minutes:=inttostr(minutesbetween(strtodatetime(Tarifini.Readstring(inttostr(i),'Debut','')),(now)) ); // renvoit le nombre de minutes entre Edittmpa.text et Edittmpb.texte apres convertion vers datetime et reconvertion du resulta de intger vers tsr
  Editcout.Text :=vartostr(int( ( StrToFloat(prix.Text)/60   )  *  StrToFloat(minutes) )); // le produit du nombre de minutes tmpc et le prix d'une minute pour avoir le cout total
  totale.Text := inttostr((StrToint(Editcout.Text)+StrToint(consom.Text)));
end;
  end ;
end;
{=====================================================================}
end.
