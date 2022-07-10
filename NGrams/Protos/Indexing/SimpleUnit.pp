unit SimpleUnit;
{$Mode objfpc}

interface

uses
 classes, fgl, sysutils, ProtoHelperUnit, ProtoHelperListsUnit, ProtoStreamUnit, GenericCollectionUnit;

type
  TUInt64 = class;

  // message UInt64
  { TUInt64 }
  TUInt64 = class(TBaseMessage)
  // Forward Declarations.

  private
    FData: UInt64;

  public
    function GetData: UInt64;

  public
    // uint64 data = 1;
    property Data: UInt64 read FData write FData;

  protected 
    procedure SaveToStream(Stream: TProtoStreamWriter); override;
    function LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean; override;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;

  public // functions
    function DeepCopy: TUInt64;

  end;



implementation

function TUInt64.GetData: UInt64;
begin
  if Self = nil then
    Exit(0);

  Result := FData; 

end;


constructor TUInt64.Create;
begin
  inherited Create;


end;


destructor TUInt64.Destroy;
begin
  Self.Clear;

  inherited;
end;

procedure TUInt64.Clear;
begin

  inherited;
end;

procedure TUInt64.SaveToStream(Stream: TProtoStreamWriter);
begin
  SaveUint64(Stream, Data, 1);

end;


function TUInt64.LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean;
var
  StartPos, FieldNumber, WireType: Integer;

begin
  StartPos := Stream.Position;
  while Stream.Position < StartPos + Len do
  begin
    Stream.ReadTag(FieldNumber, WireType);

    case FieldNumber of
    1:
      Data := LoadUint64(Stream);


    end;
  end;

  Result := StartPos + Len = Stream.Position;

end;

function TUInt64.DeepCopy: TUInt64;
begin
  if Self = nil then
    Exit(nil);

  Result := TUInt64.Create;

  Result.Data := Self.Data;

end;



end.
