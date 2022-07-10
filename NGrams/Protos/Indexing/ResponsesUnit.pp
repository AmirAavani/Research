unit ResponsesUnit;
{$Mode objfpc}

interface

uses
 classes, fgl, sysutils, ProtoHelperUnit, ProtoHelperListsUnit, ProtoStreamUnit, GenericCollectionUnit;

type
  TReadFileResponse = class;
  TProcessSentenceResponse = class;

  // message ReadFileResponse
  { TReadFileResponse }
  TReadFileResponse = class(TBaseMessage)
  // Forward Declarations.

  private
    FFilename: AnsiString;

  public
    function GetFilename: AnsiString;

  public
    // string filename = 1;
    property Filename: AnsiString read FFilename write FFilename;

  protected 
    procedure SaveToStream(Stream: TProtoStreamWriter); override;
    function LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean; override;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;

  public // functions
    function DeepCopy: TReadFileResponse;

  end;

  // message ProcessSentenceResponse
  { TProcessSentenceResponse }
  TProcessSentenceResponse = class(TBaseMessage)
  // Forward Declarations.

  public type
    TTokenIDs =  TUInt64s;

  private
    FTokenIDs: TTokenIDs;


  public
    function GetTokenIDs: TTokenIDs;
    function GetOrCreateTokenIDs: TTokenIDs;

  public
    // repeated uint64 tokenIDs = 1;
    property TokenIDs: TTokenIDs read FTokenIDs write FTokenIDs;
    property ConstTokenIDs: TTokenIDs read GetTokenIDs;
    property MutableTokenIDs: TTokenIDs read GetOrCreateTokenIDs write FTokenIDs;

  protected 
    procedure SaveToStream(Stream: TProtoStreamWriter); override;
    function LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean; override;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;

  public // functions
    function DeepCopy: TProcessSentenceResponse;

  end;



implementation

function TReadFileResponse.GetFilename: AnsiString;
begin
  if Self = nil then
    Exit('');

  Result := FFilename; 

end;


constructor TReadFileResponse.Create;
begin
  inherited Create;


end;


destructor TReadFileResponse.Destroy;
begin
  Self.Clear;

  inherited;
end;

procedure TReadFileResponse.Clear;
begin

  inherited;
end;

procedure TReadFileResponse.SaveToStream(Stream: TProtoStreamWriter);
begin
  SaveString(Stream, Filename, 1);

end;


function TReadFileResponse.LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean;
var
  StartPos, FieldNumber, WireType: Integer;

begin
  StartPos := Stream.Position;
  while Stream.Position < StartPos + Len do
  begin
    Stream.ReadTag(FieldNumber, WireType);

    case FieldNumber of
    1:
      Filename := LoadString(Stream);


    end;
  end;

  Result := StartPos + Len = Stream.Position;

end;

function TReadFileResponse.DeepCopy: TReadFileResponse;
begin
  if Self = nil then
    Exit(nil);

  Result := TReadFileResponse.Create;

  Result.Filename := Self.Filename;

end;


function TProcessSentenceResponse.GetTokenIDs: TTokenIDs;
begin
  if Self = nil then
    Exit(nil);

  Result := FTokenIDs; 

end;

function TProcessSentenceResponse.GetOrCreateTokenIDs: TTokenIDs;

begin
  if Self = nil then
    Exit(nil);

  if FTokenIDs = nil then
    FTokenIDs := TTokenIDs.Create;
  Result := FTokenIDs;

end;

constructor TProcessSentenceResponse.Create;
begin
  inherited Create;


end;


destructor TProcessSentenceResponse.Destroy;
begin
  Self.Clear;

  inherited;
end;

procedure TProcessSentenceResponse.Clear;
begin
  FreeAndNil(FTokenIDs);

  inherited;
end;

procedure TProcessSentenceResponse.SaveToStream(Stream: TProtoStreamWriter);
begin
  SaveRepeatedUint64(Stream, FTokenIDs, 1);

end;


function TProcessSentenceResponse.LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean;
var
  StartPos, FieldNumber, WireType: Integer;

begin
  StartPos := Stream.Position;
  while Stream.Position < StartPos + Len do
  begin
    Stream.ReadTag(FieldNumber, WireType);

    case FieldNumber of
    1: 
      if not LoadRepeatedUint64(Stream, MutableTokenIDs) then
        Exit(False);


    end;
  end;

  Result := StartPos + Len = Stream.Position;

end;

function TProcessSentenceResponse.DeepCopy: TProcessSentenceResponse;
begin
  if Self = nil then
    Exit(nil);

  Result := TProcessSentenceResponse.Create;

  Result.FTokenIDs := Self.TokenIDs.DeepCopy;


end;



end.
