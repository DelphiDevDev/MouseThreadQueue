unit TThreadB;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Types,
  System.Generics.Collections,
  MouseUnit;

type
  TThreadMouseMove=class(TThread)
  private
    NotTerminate: Boolean;
    FComplete: Boolean;
    FMousePosition: TPoint;
    FMousePositionsQueue: TThreadedQueue<TPoint>;
  protected
    procedure Execute; override;
  public
    constructor Create(AMousePositionsQueue: TThreadedQueue<TPoint>);
    destructor Destroy; override;
    property MousePosition: TPoint read FMousePosition write FMousePosition;
    property Complete: Boolean read FComplete write FComplete;
  end;

implementation

constructor TThreadMouseMove.Create(AMousePositionsQueue: TThreadedQueue<TPoint>);
begin
  inherited Create(False);
  FreeOnTerminate:=True;
  FMousePositionsQueue:=AMousePositionsQueue;
  NotTerminate:=True;
  FMousePosition:=TPoint.Zero;
  FComplete:=False;
end;

procedure TThreadMouseMove.Execute;
begin
  while NotTerminate do
  begin
    if Assigned(FMousePositionsQueue) then if FMousePositionsQueue.ShutDown then Break;
    if (FMousePositionsQueue.QueueSize > 0) and FComplete then
    begin
      FMousePosition:=FMousePositionsQueue.PopItem;
      MouseForm.MouseImage.Left:=FMousePosition.X-8;
      MouseForm.MouseImage.Top:=FMousePosition.Y-33;
      MouseForm.Label1.Caption:='Queue length: '+
        IntToStr(FMousePositionsQueue.TotalItemsPushed-FMousePositionsQueue.TotalItemsPopped);
      MouseForm.Label2.Caption:='X: '+IntToStr(FMousePosition.X);
      MouseForm.Label3.Caption:='Y: '+IntToStr(FMousePosition.Y);
      FComplete:=False;
    end;
    Sleep(1);
  end;
end;

destructor TThreadMouseMove.Destroy;
begin
  NotTerminate:=False;
end;

end.
