unit TThreadA;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Types,
  Winapi.Windows,
  System.Generics.Collections,
  System.Win.ScktComp;

const
  QUEUE_MAX_LENGTH = 100;

type
  TThreadMousePosition=class(TThread)
  private
    NotTerminate: Boolean;
    FFormHandle: HWND;
    ServerSocket: TServerSocket;
    MousePositionsQueue: TThreadedQueue<TPoint>;
    NewMousePosition,OldMousePosition: TPoint;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetFormHandle(FormHandle: HWND);
  end;

implementation

uses TThreadB;

var MouseMove: TThreadMouseMove;

constructor TThreadMousePosition.Create;
begin
  inherited Create(False);
  ServerSocket:=TServerSocket.Create(nil);
  ServerSocket.Port:=55000;
  ServerSocket.Active:=True;
  MousePositionsQueue:=TThreadedQueue<TPoint>.Create(QUEUE_MAX_LENGTH);
  NotTerminate:=True;
  NewMousePosition:=TPoint.Zero;
  OldMousePosition:=TPoint.Zero;
  FreeOnTerminate:=True;
end;

procedure TThreadMousePosition.Execute;
var
  MousePosition: TPoint;
  FormRect: TRect;
  I: Integer;
begin
  MouseMove:=TThreadMouseMove.Create(MousePositionsQueue);
  while NotTerminate do
  begin
    GetWindowRect(FFormHandle,FormRect);
    GetCursorPos(NewMousePosition);
    if ((NewMousePosition.X <> OldMousePosition.X) or (NewMousePosition.Y <> OldMousePosition.Y)) and
       (MousePositionsQueue.QueueSize < QUEUE_MAX_LENGTH) then
    begin
      MousePosition.X:=NewMousePosition.X-FormRect.Left;
      MousePosition.Y:=NewMousePosition.Y-FormRect.Top;
      MousePositionsQueue.PushItem(MousePosition);
      OldMousePosition:=NewMousePosition;
    end;
    if not MouseMove.Complete then
    begin
      I:=0;
      while I < ServerSocket.Socket.ActiveConnections do
      begin
        ServerSocket.Socket.Connections[I].SendText(IntToStr(MouseMove.MousePosition.X)+'|'+IntToStr(MouseMove.MousePosition.Y));
        Inc(I);
      end;
      MouseMove.Complete:=True;
    end;
    Sleep(10);
  end;
end;

destructor TThreadMousePosition.Destroy;
begin
  NotTerminate:=False;
  MousePositionsQueue.DoShutDown;
  Sleep(500);
  MousePositionsQueue.Free;
  ServerSocket.Free;
end;

procedure TThreadMousePosition.SetFormHandle(FormHandle: HWND);
begin
  FFormHandle:=FormHandle;
end;

end.
