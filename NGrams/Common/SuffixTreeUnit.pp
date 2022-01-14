unit SuffixTreeUnit;

interface
uses
  GenericCollectionUnit;

// Imported from https://marknelson.us/posts/1996/08/01/suffix-trees.html

const
  MAX_LENGTH: Integer = 1000;
  HashTableSize: Integer = 2179;  //A prime roughly 10% larger

type
  TIntList = specialize TCollection<Int16>;

  { TBaseDoc }

  TBaseDoc = class(TObject)
  protected
    function GetCount: Integer; virtual; abstract;
    function GetCharAt(Index: Integer): Int16; virtual; abstract;

  public
    property CharAt[Index: Integer]: Int16 read GetCharAt;
    property Count: Integer read GetCount;

  end;


  { TSuffix }

  TSuffix = class(TObject)
  private
    FFirstCharIndex: Integer;
    FLastCharIndex: Integer;
    FOriginNode: Integer;

  public
    property OriginNode: Integer read FOriginNode;
    property FirstCharIndex: Integer read FFirstCharIndex;
    property LastCharIndex: Integer read FLastCharIndex;
    constructor Create(Node, Start, Stop: Integer; aDoc: TBaseDoc);

    function IsExplicit: Boolean;
    function IsImplicit: Boolean;
    procedure Canonize(Doc: TBaseDoc);

    procedure Print(constref Title: AnsiString);
  end;

  { TEdge }

  TEdge = class(TObject)
    class function Find(OriginNode, FirstChar: Integer): TEdge;
    class function Hash(Node, c: Int64): Int64;

  private
    FEndNode: Integer;
    FFirstCharIndex: Integer;
    FLastCharIndex: Integer;
    FStartNode: Integer;
    FText: TIntList;

  public
    property FirstCharIndex: Integer read FFirstCharIndex;
    property LastCharIndex: Integer read FLastCharIndex;
    property StartNode: Integer read FStartNode;
    property EndNode: Integer read FEndNode;

    procedure Insert(Doc: TBaseDoc);
    procedure Remove(Doc: TBaseDoc);
    function SplitEdge(Suffix: TSuffix; Doc: TBaseDoc): Integer;

    constructor Create;
    constructor Create(InitFirstcharIndex, InitLastCharIndex, ParentNode: Integer);

    procedure Print(constref Title: AnsiString);

  end;

  TEdges = specialize TMap<Int64, TEdge>;

  { TNode }

  TNode = class(TObject)
    class function Next: Integer;
  private
    FSuffixNodeID: Integer;
  public
    property SuffixNodeID: Integer read FSuffixNodeID;

    constructor Create;

  end;

  TNodes = specialize TObjectCollection<TNode>;
  { TStringDoc }

  TStringDoc = class(TBaseDoc)
  protected
    FStr: AnsiString;

    function GetCount: Integer; override;
    function GetCharAt(Index: Integer): Int16; override;

  public
    constructor Create(Str: AnsiString);
  end;

  { TSuffixTree }

  TSuffixTree = class(TObject)
  private
    FRoot: TNode;

    procedure AddPrefix(Doc: TBaseDoc; Active: TSuffix; LastCharIndex: Integer);
    procedure DumpEdges(Doc: TbaseDoc; CurrentN: Integer);

  public
    property Root: TNode read FRoot;

    constructor Create;
    destructor Destroy; override;

    procedure Print(Doc: TBaseDoc);
    function Validate(Doc: TBaseDoc): Boolean;
    procedure AddString(Doc: TBaseDoc);
  end;

implementation
uses
  sysutils, Classes, CollectionUnit, ALoggerUnit;

{ TNode }

var
  Nodes: TNodes;

{ TStringDoc }

function TStringDoc.GetCount: Integer;
begin
  Result := Length(FStr);

end;

function TStringDoc.GetCharAt(Index: Integer): Int16;
begin
  Result := Ord(FStr[Index + 1]);

end;

constructor TStringDoc.Create(Str: AnsiString);
begin
  inherited Create;

  FStr := Str;

end;

{ TSuffixTree }

procedure TSuffixTree.AddPrefix(Doc: TBaseDoc; Active: TSuffix;
  LastCharIndex: Integer);
var
  ParentNode, LastParentNode: Integer;
  Edge, NewEdge: TEdge;
  Span: Integer;
  Round: Integer;

begin
  LastParentNode := -1;

  Round := 0;
  while True do
  begin
    Inc(Round);
    ParentNode := Active.OriginNode;


    if Active.IsExplicit then
    begin
      Edge := TEdge.Find(Active.OriginNode, Doc.CharAt[LastCharIndex]);
      if Edge <> nil then
        Break;

    end
    else
    begin
      Edge := Edge.Find(Active.OriginNode, Doc.CharAt[Active.FirstCharIndex]);
      Span := Active.LastCharIndex - Active.FirstCharIndex;
      if Doc.CharAt[Edge.FirstCharIndex + Span + 1] = Doc.CharAt[LastCharIndex] then
        Break;
      ParentNode := Edge.SplitEdge(Active, Doc);

    end;

    NewEdge := TEdge.Create(LastCharIndex, Doc.Count - 1, ParentNode);
    NewEdge.Print('new_edge');
    NewEdge.Insert(Doc);
    if 0 < LastParentNode then
    begin
      Nodes[LastParentNode].FSuffixNodeID := ParentNode;

    end;
    LastParentNode := ParentNode;
//

    if Active.OriginNode = 0 then
      Active.FFirstCharIndex += 1
    else
      Active.FOriginNode := Nodes[Active.OriginNode].SuffixNodeID;
    Active.Canonize(Doc);

  end;

  if 0 < LastParentNode then
    Nodes[LastParentNode].FSuffixNodeID := ParentNode;

  Active.FLastCharIndex += 1;
  Active.Canonize(Doc);

end;

var
  Edges: TEdges;

procedure TSuffixTree.DumpEdges(Doc: TbaseDoc; CurrentN: Integer);
var
  j, Top, l: Integer;
  it: TEdges.TPairEnumerator;
  s: TEdge;

begin
  it := Edges.GetEnumerator;
  while it.MoveNext do
  begin
    s := it.Current.Value;
    Write(Format('%5d %5d %3d  %5d %6d ' , [
     s.StartNode,
     s.EndNode,
     Nodes[s.EndNode].SuffixNodeID,
     s.FirstCharIndex,
     S.LastCharIndex
     ]));

    if CurrentN > s.LastCharIndex then
      Top := s.LastCharIndex
    else
        Top := CurrentN;

    for l := s.FirstCharIndex to Top do
      Write(Chr(Doc.CharAt[l]));
    WriteLn;

  end;

end;

constructor TSuffixTree.Create;
begin
  inherited Create;

end;

destructor TSuffixTree.Destroy;
begin
  inherited Destroy;
end;

procedure TSuffixTree.Print(Doc: TBaseDoc);
begin
  DumpEdges(Doc, 0);
end;

function TSuffixTree.Validate(Doc: TBaseDoc): Boolean;
var
  AllStr: TStringList;
  AllChars, Degs: TInt64Collection;

  procedure Collect(StartNode: Integer; Current: AnsiString);
  var
    Edge: TEdge;
    Ch: Integer;
    Tmp: AnsiString;
    i: Integer;

  begin
    while Degs.Count <= StartNode do
      Degs.Add(0);

    for Ch in AllChars do
    begin
      Tmp := Current;

      Edge := TEdge.Find(StartNode, Ch);
      if Edge = nil then
        Continue;
      Degs[StartNode] := Degs[StartNode] + 1;
      for i := Edge.FirstCharIndex to Edge.LastCharIndex do
        Tmp += Chr(Doc.CharAt[i]);
      Collect(Edge.EndNode, Tmp);

    end;
    if Degs[StartNode] = 0 then
      AllStr.Add(Tmp);
  end;

var
  i, Index: Integer;
  AllSuffixes: TStringList;
  S: AnsiString;

begin
  AllChars := TInt64Collection.Create;
  Degs := TInt64Collection.Create;
  for i := 0 to  Doc.Count - 1 do
    AllChars.Add(Doc.CharAt[i]);

  AllChars.Sort;
  i := 0;
  Index := 0;
  while i < AllChars.Count - 1 do
  begin
    inc(i);
    if AllChars[Index] = AllChars[i] then
      Continue;
    Inc(Index);
    AllChars[Index] := AllChars[i];

  end;
  AllChars.Count := Index + 1;

  AllStr := TStringList.Create;

  Collect(0, '');

  AllChars.Free;
  AllStr.Sort;

  AllSuffixes := TStringList.Create;
  S := '';
  for i := Doc.Count - 1 downto 0 do
  begin
    S := Chr(Doc.CharAt[i]) + S;
    AllSuffixes.Add(S);

  end;
  AllSuffixes.Sort;
  WriteLn(AllStr.Text);

  for i := 0 to AllStr.Count - 1 do
    if AllSuffixes[i] <> AllStr[i] then
    begin
      WriteLn(i);
      WriteLn(AllStr[i]);
      WriteLn(AllSuffixes[i]);
      Exit(False);

    end;

  AllStr.Free;
  AllSuffixes.Free;

  Result := True;
end;

procedure TSuffixTree.AddString(Doc: TBaseDoc);
var
  Active: TSuffix;
  i: Integer;

begin
  Active := TSuffix.Create(0, 0, -1, Doc);  // The initial active prefix
  for i := 0 to Doc.Count - 1 do
  begin
    AddPrefix(Doc, Active, i);
  //  DumpEdges(i + 1);
  end;
  // DumpEdges(FDoc.Count);


end;

class function TNode.Next: Integer;
begin
  Nodes.Add(TNode.Create);

  Exit(Nodes.Count - 1);

end;

constructor TNode.Create;
begin
  inherited Create;

  FSuffixNodeID := -1;
end;


{ TEdge }

class function TEdge.Find(OriginNode, FirstChar: Integer): TEdge;
var
  Index: Int64;

begin
  Index := Hash(OriginNode, FirstChar);
  Result := nil;
  Edges.TryGetData(Index, Result);

end;

class function TEdge.Hash(Node, c: Int64): Int64;
begin
  Result := (Node shl 32 + c); // mod HashTableSize;

end;

procedure TEdge.Insert(Doc: TBaseDoc);
var
  Index: Int64;

begin
  Self.Print('Insert');
  Index := Hash(FStartNode, Doc.CharAt[FFirstCharIndex]);
  if Edges.Find(Index) <> nil then
    WritelN('Dupes!?');
  Edges.Add(Index, Self);

end;

procedure TEdge.Remove(Doc: TBaseDoc);
var
  Index: Int64;

begin
  Self.Print('Remove');
  Index := Hash(FStartNode, Doc.CharAt[FirstCharIndex]);
  Edges.Delete(Index, True);

end;

function TEdge.SplitEdge(Suffix: TSuffix; Doc: TBaseDoc): Integer;
var
  NewEdge: TEdge;

begin
  Remove(Doc);
  NewEdge := TEdge.Create(
    FirstCharIndex,
    FirstCharIndex + Suffix.LastCharIndex - Suffix.FirstCharIndex,
    Suffix.OriginNode);
  NewEdge.Print('new_edge');

  NewEdge.Insert(Doc);
  Nodes[NewEdge.EndNode].FSuffixNodeID := Suffix.OriginNode;
  FFirstCharIndex += Suffix.LastCharIndex - Suffix.FirstCharIndex + 1;
  FStartNode := NewEdge.EndNode;
  Insert(Doc);
  Result := NewEdge.EndNode;

end;

constructor TEdge.Create;
begin
  inherited Create;

  FStartNode := -1;
end;

constructor TEdge.Create(InitFirstcharIndex, InitLastCharIndex,
  ParentNode: Integer);
begin
  FFirstCharIndex := InitFirstcharIndex;
  FLastCharIndex := InitLastCharIndex;
  FStartNode := ParentNode;
  FEndNode := TNode.Next;

end;

procedure TEdge.Print(constref Title: AnsiString);
begin
  Exit;
  FMTDebugLN('%s FirstCharIndex: %d LastCharIndex: %d EndNode: %d StartNode: %d',
  [Title, FirstCharIndex, LastCharIndex, EndNode, StartNode]);

end;

{ TSuffix }

constructor TSuffix.Create(Node, Start, Stop: Integer; aDoc: TBaseDoc);
begin
  inherited Create;

  FOriginNode := Node;
  FFirstCharIndex := Start;
  FLastCharIndex := Stop;

end;

function TSuffix.IsExplicit: Boolean;
begin
  Result := LastCharIndex < FirstCharIndex;

end;

function TSuffix.IsImplicit: Boolean;
begin
  Result := FirstCharIndex <= LastCharIndex;

end;

procedure TSuffix.Canonize(Doc: TBaseDoc);
var
  Edge: TEdge;
  EdgeSpan: Integer;

begin
  if IsExplicit then
      Exit;

  Edge := TEdge.Find(OriginNode, Doc.CharAt[FFirstCharIndex]);
  EdgeSpan := Edge.LastCharIndex - Edge.FirstCharIndex;
  while EdgeSpan <= LastCharIndex - FirstCharIndex do
  begin
    FFirstCharIndex := FirstCharIndex + EdgeSpan + 1;
    FOriginNode := Edge.EndNode;

    if FirstCharIndex <= LastCharIndex then
    begin
      Edge := TEdge.Find(Edge.EndNode, Doc.CharAt[FFirstCharIndex]);
      EdgeSpan := Edge.LastCharIndex - Edge.FirstCharIndex;

    end;

  end;

end;

procedure TSuffix.Print(constref Title: AnsiString);
begin
  FMTDebugLN('%s OriginNode: %d FirstCharIndex: %d LastCharIndex: %d Implicit: %s',
    [Title, OriginNode, FirstCharIndex, LastCharIndex, specialize IfThen<String>(IsImplicit, '1', '0')]);

end;

initialization
  Nodes := TNodes.Create;
  Edges := TEdges.Create;
  Nodes.Add(TNode.Create);

finalization
  Nodes.Free;
  Edges.Free;

end.

