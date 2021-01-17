unit ExtractParagraphsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Pipeline.TypesUnit, PipelineUnit;

function ExtractParagraphs(Task: TTask; Args: TPointerArray): Boolean;

implementation
uses
  Pipeline.Utils, ParameterManagerUnit, OnceUnit, ALoggerUnit, ElfHashUnit,
  ParagraphUnit, StringUnit, ProtoStreamUnit, Pipeline.IOUnit, PathHelperUnit;

function ExtractParagraphs(Task: TTask; constref Data: AnsiString;
    constref AllDIndices: TInt64List; Writer: TPipelineWriter): Boolean;

  function ProcessParagraph(DocIndex, PIndex: UInt32; Start, Last: PChar): TParagraph;
  var
    pc: PChar;
    CurChar: Char;
    CurToken: AnsiString;

  begin
    Result := TParagraph.Create;
    Result.ID := ElfHash(Start, Last);
    Result.DocIndex := DocIndex;
    Result.ParagraphIndex := PIndex;
    pc := Start;

    CurToken := '';
    while pc <= Last do
    begin
       CurChar := pc^;
       Inc(pc);

       if CurChar = sLineBreak then
       begin
         if CurToken <> '' then
         begin
           Result.MutableTokens.Add(CurToken);
           CurToken := '';

         end;
         Continue;

       end;
       CurToken += CurChar;

    end;

  end;

  procedure ProcessDoc(DocIndex: UInt32; Start, Last: PChar; Writer: TPipelineWriter);
  var
    Current, Prev, Next: PChar;
    PIndex: UInt32;
    StartParagraph: PChar;
    BraceBalance: Integer;
    Paragraph: TParagraph;

  begin
    Prev := Start;
    Current := Start + 1;
    Next := Current + 1;
    BraceBalance := 0;

    StartParagraph := Current;
    PIndex := 0;
    while Current <= Last do
    begin
       if Current^ = '(' then
         Inc(BraceBalance)
       else if Current^ = ')' then
         Dec(BraceBalance);

      if Current^ = sLineBreak then
        StartParagraph := Next
      else if (BraceBalance = 0) and (Prev^ = ' ') and (Current^ = '.') and (Next^ = ' ') then
      begin
        Paragraph := ProcessParagraph(DocIndex, PIndex, StartParagraph, Current);
        StartParagraph := Next;
        Inc(PIndex);

      end;
      Inc(Prev);
      Inc(Current);
      Inc(Next);
    end;
    if Current <> StartParagraph then
    begin
      Paragraph := ProcessParagraph(DocIndex, PIndex, StartParagraph, Current);
      Writer.WriteProto(Paragraph);

    end;

  end;

var
  Start, Last: Integer;
  DocIndex: UInt32;

begin
  Result := True;
  DocIndex := Task.ID - 1;
  FMTDebugLn('Task.ID: %d DocIndex: %d Task.Count: %d', [Task.ID, DocIndex, Task.Count]);

  while DocIndex < AllDIndices.Count - 1 do
  begin
     Start := AllDIndices[DocIndex];
     Last := Length(Data);
     if DocIndex <> AllDIndices.Count - 1 then
        Last := AllDIndices[DocIndex + 1] - 1;
     ProcessDoc(DocIndex, @Data[1] + Start - 1, @Data[1] + Last, nil);

    Inc(DocIndex, Task.Count);

     FMTDebugLn('Task.ID: %d DocIndex: %d', [Task.ID, DocIndex]);
     if 10 < DocIndex then
        break;
//    FMTDebugLnEveryN(100, 'Task.ID: %d DocIndex: %d', [Task.ID, DocIndex]);
  end;

end;

var
  LoadAllDIndicesOnce: TOnce;
  AllDIndices: TInt64List;

function ExtractParagraphs(Task: TTask; Args: TPointerArray): Boolean;
var
  InputDir, OutputDir: AnsiString;
  Data: AnsiString;
  Delta: Integer;
  MyOutputFiles: TAnsiStringList;
  Writer: TPipelineWriter;

begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--TmpDir'].AsAnsiString;
  OutputDir:= GetRunTimeParameterManager.ValueByName['--TmpDir'].AsAnsiString;
  MyOutputFiles := Task.ExtractModule(
    JoinPath(OutputDir, Format('Step2/part@32', [Task.Count])));
  FMTDebugLn('Task.ID: %d InputDir = %s OutputFiles = %s ',
    [Task.ID, InputDir, MyOutputFiles.ToString]);

  Writer := TPipelineWriter.Create(MyOutputFiles[0]);

  LoadAllDIndicesOnce.Run;

  FMTDebugLn('AllDIndices.Count: %d', [AllDIndices.Count]);

  Result := True;
  Data := PAnsiString(Args[0])^;
  FMTDebugLn('Length(Data): %d', [Length(Data)]);

  Result := ExtractParagraphs(Task, Data, AllDIndices, Writer);

  Writer.Free;

  MyOutputFiles.Free;

end;

procedure LoadAllDIndices(Arguments: TPointerArray);
var
  InputDir, Filename: AnsiString;

begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--TmpDir'].AsAnsiString;
  Filename := ConcatPaths([InputDir, 'wiki.train.tokens.sentence.index']);

  AllDIndices := TInt64List.LoadFromFile(Filename);

end;

initialization
  AllDIndices := nil;
  LoadAllDIndicesOnce := TOnce.Create(@LoadAllDIndices, nil);

finalization
  LoadAllDIndicesOnce.Free;
  AllDIndices.Free;

end.

