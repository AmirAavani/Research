unit ExtractSentencesUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Pipeline.Types, PipelineUnit;

function ExtractSentences(Task: TTask; Args: TPointerArray): Boolean;

implementation
uses
  Pipeline.Utils, ParameterManagerUnit, OnceUnit, ALoggerUnit;

function ExtractMySentences(Task: TTask; constref Data: AnsiString;
    constref AllDIndices: TInt64List): Boolean;

  procedure ExtractSentecesFromDoc(Start, Fin: PChar);

  begin

  end;

var
  Start, Fin: Integer;
  DocIndex: Integer;

begin
  Result := True;
  DocIndex := Task.ID - 1;
  FMTDebugLn('Task.ID: %d DocIndex: %d Task.Count: %d', [Task.ID, DocIndex, Task.Count]);

  while DocIndex < AllDIndices.Count - 1 do
  begin
     Start := AllDIndices[DocIndex];
     Fin := Length(Data);
     if DocIndex <> AllDIndices.Count - 1 then
        Fin := AllDIndices[DocIndex + 1] - 1;
     ExtractSentecesFromDoc(@Data[1] + Start - 1, @Data[1] + Fin - 1);

    Inc(DocIndex, Task.Count);

     FMTDebugLn('Task.ID: %d DocIndex: %d', [Task.ID, DocIndex]);
     if 1000 < DocIndex then
        break;
//    FMTDebugLnEveryN(100, 'Task.ID: %d DocIndex: %d', [Task.ID, DocIndex]);
  end;

end;

var
  LoadAllDIndicesOnce: TOnce;
  AllDIndices: TInt64List;

function ExtractSentences(Task: TTask; Args: TPointerArray): Boolean;
var
  InputDir, OutputDir: AnsiString;
  Data: AnsiString;
  Delta: Integer;

begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--TmpDir'].AsAnsiString;
  OutputDir:= GetRunTimeParameterManager.ValueByName['--TmpDir'].AsAnsiString;
  FMTDebugLn('Task.ID: %d InputDir = %s OutputDir = %s',
    [Task.ID, InputDir, OutputDir]);

  LoadAllDIndicesOnce.Run;

  FMTDebugLn('AllDIndices.Count: %d', [AllDIndices.Count]);

  Result := True;
  Data := PAnsiString(Args[0])^;
  FMTDebugLn('Length(Data): %d', [Length(Data)]);

  Result := ExtractMySentences(Task, Data, AllDIndices);

  AllDIndices.Free;

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

