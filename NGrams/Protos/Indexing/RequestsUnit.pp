unit RequestsUnit;
{$Mode objfpc}

interface

uses
 classes, fgl, sysutils, ProtoHelperUnit, ProtoHelperListsUnit, ProtoStreamUnit, GenericCollectionUnit;

type
  TReadFileRequest = class;
  TProcessSentenceRequest = class;

  // message ReadFileRequest
  { TReadFileRequest }
  TReadFileRequest = class(TBaseMessage)
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
    function DeepCopy: TReadFileRequest;

  end;

  // message ProcessSentenceRequest
  { TProcessSentenceRequest }
  TProcessSentenceRequest = class(TBaseMessage)
  // Forward Declarations.

  private
    FSentence: AnsiString;

  public
    function GetSentence: AnsiString;

  public
    // string Sentence = 1;
    property Sentence: AnsiString read FSentence write FSentence;

  protected 
    procedure SaveToStream(Stream: TProtoStreamWriter); override;
    function LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean; override;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;

  public // functions
    function DeepCopy: TProcessSentenceRequest;

  end;



implementation

function TReadFileRequest.GetFilename: AnsiString;
begin
  if Self = nil then
    Exit('');

  Result := FFilename; 

end;


constructor TReadFileRequest.Create;
begin
  inherited Create;


end;


destructor TReadFileRequest.Destroy;
begin
  Self.Clear;

  inherited;
end;

procedure TReadFileRequest.Clear;
begin

  inherited;
end;

procedure TReadFileRequest.SaveToStream(Stream: TProtoStreamWriter);
begin
  SaveString(Stream, Filename, 1);

end;


function TReadFileRequest.LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean;
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

function TReadFileRequest.DeepCopy: TReadFileRequest;
begin
  if Self = nil then
    Exit(nil);

  Result := TReadFileRequest.Create;

  Result.Filename := Self.Filename;

end;

function TProcessSentenceRequest.GetSentence: AnsiString;
begin
  if Self = nil then
    Exit('');

  Result := FSentence; 

end;


constructor TProcessSentenceRequest.Create;
begin
  inherited Create;


end;


destructor TProcessSentenceRequest.Destroy;
begin
  Self.Clear;

  inherited;
end;

procedure TProcessSentenceRequest.Clear;
begin

  inherited;
end;

procedure TProcessSentenceRequest.SaveToStream(Stream: TProtoStreamWriter);
begin
  SaveString(Stream, Sentence, 1);

end;


function TProcessSentenceRequest.LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean;
var
  StartPos, FieldNumber, WireType: Integer;

begin
  StartPos := Stream.Position;
  while Stream.Position < StartPos + Len do
  begin
    Stream.ReadTag(FieldNumber, WireType);

    case FieldNumber of
    1:
      Sentence := LoadString(Stream);


    end;
  end;

  Result := StartPos + Len = Stream.Position;

end;

function TProcessSentenceRequest.DeepCopy: TProcessSentenceRequest;
begin
  if Self = nil then
    Exit(nil);

  Result := TProcessSentenceRequest.Create;

  Result.Sentence := Self.Sentence;

end;



end.
