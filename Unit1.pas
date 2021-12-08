unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DCPcrypt2, DCPblockciphers, DCPdes, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtChave: TEdit;
    edtSenha: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    edtResultado: TEdit;
    Label4: TLabel;
    dcp_3ds1: TDCP_3des;
    edt1: TEdit;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    function  IsDividedBy2(number: integer) : boolean;
    function  SplitStringInHalf(var S: string; var Left, Right: string; var Size: Integer): boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function StrToHex(Dado: String): String;
var cTemp: String;
I: Integer;
begin
  cTemp := '';
  for i := 1 to Length(Dado) Do
    cTemp := cTemp + IntToHex(Ord(Dado[i]), 2);
  Result := cTemp;
end;

function HexToInt(s: string): Longword;
var
  b: Byte;
  c: Char;
begin
  Result := 0;
  s := UpperCase(s);
  for b := 1 to Length(s) do
    begin
      Result := Result * 16;
      c := s[b];
      case c of
        '0'..'9': Inc(Result, Ord(c) - Ord('0'));
        'A'..'F': Inc(Result, Ord(c) - Ord('A') + 10);
        else
          raise EConvertError.Create('No Hex-Number');
      end;
    end;
end;

function HexToAsc(Dado: String): String;
  var cTemp: String;
      I: Integer;
begin
  cTemp := '';
  for i := 1 to Length(Dado) Do
  Begin
    if Not Odd(i) Then
      Begin
        cTemp := cTemp + Chr(HexToInt(Copy(Dado, i - 1, 2)));
      End;
  End;
  Result := cTemp;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  IV, Senha, Chave: string;
begin
  Senha := Self.edtSenha.Text;
  Chave := HexToAsc(Self.edtChave.Text);
  IV    := StringOfChar(#0, 8);

  Self.DCP_des1.Init(Chave[1],64,@IV[1]);
  Self.DCP_des1.EncryptCBC(Senha[1], Senha[1], Length(Senha));
  Self.DCP_des1.Burn;

  Self.edtResultado.Text := StrToHex(Senha);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Result,IV, Senha1, Senha2, Chave1,  Texto : string;
  tamanhoChave, tamanhoSenha ,K: Integer;
begin

  Chave1 := HexToAsc(Self.edtChave.Text);

  //wk cryptografada
  Senha1 := HexToAsc(Self.edtSenha.Text);
  Senha2 := HexToAsc(Self.edtSenha.Text);


  IV     := StringOfChar(#0, 8);
  tamanhoChave := Length(Self.edtChave.Text);
  tamanhoSenha := Length(Senha1);
  if tamanhoSenha  = 32  then
  begin
        Texto := Self.edtChave.Text;
        SplitStringInHalf(Texto ,Senha1,Senha2,tamanhoSenha);

  end;

  Self.dcp_3ds1.Init(Chave1[1],128,@IV[1]);
  Self.dcp_3ds1.DecryptCBC(Senha1[1], Senha1[1], tamanhoSenha);
  Self.dcp_3ds1.Burn;


  Senha1 := Senha1 ;
  for K := 1 To Length(Senha1) do
              Result := Result + Chr( Ord(Senha1[K]) );

            Result := StrToHex(Result);
  Self.edtResultado.Text := Result;
end;

function TForm1.SplitStringInHalf(var S: string; var Left, Right: string; var Size: Integer): boolean;
var
  I, TextSize: Integer;

begin

    TextSize := Length(S);
    if IsDividedBy2(TextSize) then
    begin
      I := Length(S) div 2;
      Left := Copy(S, 1, I);
      Right := Copy(S, I + 1, Length(S));
      Size := I;
      Result := true;
    end
    else
    begin
      Result := false;
    end;
end;

function TForm1.IsDividedBy2(number: integer) : boolean;
begin
  if (number mod 2 = 0) then
  begin
    Result := true;
  end
  else
  begin
    Result := false;
  end;
end;

end.
