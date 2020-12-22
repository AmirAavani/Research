unit SentenceUnit;
{$Mode objfpc}

interface

uses
 classes, fgl, sysutils, ProtoHelperUnit, ProtoHelperListsUnit, ProtoStreamUnit;

type
  TSentence = class;

  { TSentence }
  TSentence = class(TBaseMessage)
  // Forward Declarations.

  // Declarations for uint32 ID = 1;
  private
    FID: UInt32;
  public
    property ID: UInt32 read FID write FID;

  // Declarations for uint32 DocIndex = 2;
  private
    FDocIndex: UInt32;
  public
    property DocIndex: UInt32 read FDocIndex write FDocIndex;

  // Declarations for uint32 SentenceIndex = 3;
  private
    FSentenceIndex: UInt32;
  public
    property SentenceIndex: UInt32 read FSentenceIndex write FSentenceIndex;

  // Methods for repeated string tokens = 4;
  public type
    TTokens =  TAnsiStrings;

  private
    FTokens: TTokens;


    // Getter Functions
    function GetTokens(Index: Integer): AnsiString;
    function GetAllTokens: TTokens;
    function GetOrCreateAllTokens: TTokens;

  public
    property Tokens[Index: Integer]: AnsiString read GetTokens;
    property ConstAllTokens: TTokens read GetAllTokens;
    property AllTokens: TTokens read GetOrCreateAllTokens;

  protected 
    procedure SaveToStream(Stream: TProtoStreamWriter); override;
    function LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean; override;

  public
    constructor Create;
  constructor Create(aID: UInt32; aDocIndex: UInt32; aSentenceIndex: UInt32; aTokens: TTokens);
    destructor Destroy; override;

  end;



implementation


// Methods for repeated string tokens = 4;
// Getter Functions

function TSentence.GetTokens(Index: Integer): AnsiString;
begin
  Result := FTokens[Index];

end;

function TSentence.GetAllTokens: TTokens;
begin
  if Self = nil then
    Exit(nil);
  Result := FTokens;

end;

function TSentence.GetOrCreateAllTokens: TTokens;

begin
  if FTokens = nil then
    FTokens := TTokens.Create;
  Result := FTokens;

end;


constructor TSentence.Create;
begin
  inherited Create;


end;

constructor TSentence.Create(aID: UInt32; aDocIndex: UInt32; aSentenceIndex: UInt32; aTokens: TTokens);
begin
  inherited Create;

  FID := aID; 
  FDocIndex := aDocIndex; 
  FSentenceIndex := aSentenceIndex; 
  FTokens := aTokens; 

end;

destructor TSentence.Destroy;
begin
  FTokens.Free;

  inherited;
end;

procedure TSentence.SaveToStream(Stream: TProtoStreamWriter);
begin
  SaveUInt32(Stream, ID, 1);

  SaveUInt32(Stream, DocIndex, 2);

  SaveUInt32(Stream, SentenceIndex, 3);

  SaveRepeatedAnsiString(Stream, FTokens, 4);

end;


function TSentence.LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean;
var
  StartPos, FieldNumber, WireType: Integer;

begin
  StartPos := Stream.Position;
  while Stream.Position < StartPos + Len do
  begin
    Stream.ReadTag(FieldNumber, WireType);

    case FieldNumber of
    1: ID := LoadUInt32(Stream);
    2: DocIndex := LoadUInt32(Stream);
    3: SentenceIndex := LoadUInt32(Stream);
    4: 
    begin
      FTokens := TTokens.Create;
      if not LoadRepeatedAnsiString(Stream, FTokens) then
        Exit(False);
    end;


    end;
  end;

  Result := StartPos + Len = Stream.Position;
end;


end.
