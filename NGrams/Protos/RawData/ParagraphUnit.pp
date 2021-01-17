unit ParagraphUnit;
{$Mode objfpc}

interface

uses
 classes, sysutils, ProtoHelperUnit, ProtoHelperListsUnit, ProtoStreamUnit, GenericCollectionUnit;

type
  TParagraph = class;

  { Tparagraph }
  TParagraph = class(TBaseMessage)
  // Forward Declarations.

  // Declarations for uint32 ID = 1;
  private
    FID: UInt32;
  public
    property ID: UInt32 read FID write FID;

  // Declarations for uint32 doc_index = 2;
  private
    FDocIndex: UInt32;
  public
    property DocIndex: UInt32 read FDocIndex write FDocIndex;

  // Declarations for uint32 paragraph_index = 3;
  private
    FParagraphIndex: UInt32;
  public
    property ParagraphIndex: UInt32 read FParagraphIndex write FParagraphIndex;

  // Methods for repeated string tokens = 4;
  public type
    TTokens =  TAnsiStrings;

  private
    FTokens: TTokens;


    // Getter Functions
    function GetTokens(Index: Integer): AnsiString;
    function GetOrCreateTokens: TTokens;

  public
    property Tokens[Index: Integer]: AnsiString read GetTokens;
    property ConstTokens: TTokens read FTokens;
    property MutableTokens: TTokens read GetOrCreateTokens write FTokens;

  protected 
    procedure SaveToStream(Stream: TProtoStreamWriter); override;
    function LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean; override;

  public
    constructor Create;
    destructor Destroy; override;

  end;



implementation


// Methods for repeated string tokens = 4;
// Getter Functions

function TParagraph.GetTokens(Index: Integer): AnsiString;
begin
  Result := FTokens[Index];

end;

function TParagraph.GetOrCreateTokens: TTokens;

begin
  if FTokens = nil then
    FTokens := TTokens.Create;
  Result := FTokens;

end;


constructor TParagraph.Create;
begin
  inherited Create;


end;


destructor TParagraph.Destroy;
begin
  FTokens.Free;

  inherited;
end;

procedure TParagraph.SaveToStream(Stream: TProtoStreamWriter);
begin
  SaveUint32(Stream, ID, 1);

  SaveUint32(Stream, DocIndex, 2);

  SaveUint32(Stream, ParagraphIndex, 3);

  SaveRepeatedString(Stream, FTokens, 4);

end;


function TParagraph.LoadFromStream(Stream: TProtoStreamReader; Len: Integer): Boolean;
var
  StartPos, FieldNumber, WireType: Integer;

begin
  StartPos := Stream.Position;
  while Stream.Position < StartPos + Len do
  begin
    Stream.ReadTag(FieldNumber, WireType);

    case FieldNumber of
    1: ID := LoadUint32(Stream);
    2: DocIndex := LoadUint32(Stream);
    3: ParagraphIndex := LoadUint32(Stream);
    4: 
    begin
      FTokens := TTokens.Create;
      if not LoadRepeatedString(Stream, FTokens) then
        Exit(False);
    end;


    end;
  end;

  Result := StartPos + Len = Stream.Position;

end;


end.
