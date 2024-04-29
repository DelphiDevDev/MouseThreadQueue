unit MouseUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls;

type
  TMouseForm = class(TForm)
    MouseImage: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MouseForm: TMouseForm;

implementation

{$R *.dfm}

uses TThreadA;

var MousePosition: TThreadMousePosition;

procedure TMouseForm.FormDestroy(Sender: TObject);
begin
  MousePosition.Free;
end;

procedure TMouseForm.FormShow(Sender: TObject);
begin
  MousePosition:=TThreadMousePosition.Create;
  MousePosition.SetFormHandle(Self.Handle);
end;

end.
