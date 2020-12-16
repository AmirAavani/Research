unit ProcessDocumentsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Pipeline.Types, PipelineUnit;

function ProcessDocuments(Task: TTask; Args: TPointerArray): Boolean;

implementation
uses
  Pipeline.Utils, ParameterManagerUnit, ALoggerUnit;

function ProcessMyDocuments(Task: TTask; Data: AnsiString; AllDIndices: TInt64List): Boolean;
var
  DocIndex: Integer;

begin
  Result := True;
  DocIndex := Task.ID - 1;
  FMTDebugLn('Task.ID: %d DocIndex: %d Task.Count: %d', [Task.ID, DocIndex, Task.Count]);

  Sleep(10 + Random(1000));
  Exit;
  while DocIndex < AllDIndices.Count - 1 do
  begin
    Inc(DocIndex, Task.Count);


     FMTDebugLn('Task.ID: %d DocIndex: %d', [Task.ID, DocIndex]);
     if 1000 < DocIndex then
        break;
//    FMTDebugLnEveryN(100, 'Task.ID: %d DocIndex: %d', [Task.ID, DocIndex]);
  end;

end;

function ProcessDocuments(Task: TTask; Args: TPointerArray): Boolean;
var
  Filename, InputDir, OutputDir: AnsiString;
  AllDIndices: TInt64List;
  Data: AnsiString;
  Delta: Integer;

begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--TmpDir'].AsAnsiString;
  OutputDir:= GetRunTimeParameterManager.ValueByName['--TmpDir'].AsAnsiString;
  DebugLn(Format('Task.ID: %d InputDir = %s OutputDir = %s',
    [Task.ID, InputDir, OutputDir]));

  Filename := ConcatPaths([InputDir, 'wiki.train.tokens.sentence.index']);
  DebugLn(Filename);

  AllDIndices := TInt64List.LoadFromFile(Filename);
  FMTDebugLn('AllDIndices.Count: %d', [AllDIndices.Count]);
  Delta := 10 + Random(1000);
  FMTDebugLn('Delta: %d', [Delta]);
  Sleep(Delta);
  DebugLn(Format('Done with Task: %d', [Task.ID]));
  AllDIndices.Free;
  Exit(True);

  Result := True;
  Data := ''; //PAnsiString(Args[0])^;
  FMTDebugLn('Length(Data): %d', [Length(Data)]);

  Result := ProcessMyDocuments(Task, Data, AllDIndices);

  AllDIndices.Free;
  DebugLn(Format('Done with Task: %d', [Task.ID]));

end;

end.

