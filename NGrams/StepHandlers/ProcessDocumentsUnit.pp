unit ProcessDocumentsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PipelineUnit;

function ProcessDocuments(Task: TTask): Boolean;

implementation
uses
  Pipeline.Utils, ParameterManagerUnit, ALoggerUnit;

function ProcessMyDocuments(Task: TTask; AllDIndices: TInt64List): Boolean;
var
  MyDIndices: TInt64List;
  i: Integer;

begin
  Result := True;

  MyDIndices := TInt64List.Create;
  AllDIndices.ComputeModule(Task.Count, Task.ID, MyDIndices);

  MyDIndices.Free;

end;

function ProcessDocuments(Task: TTask): Boolean;
var
  Filename, InputDir, OutputDir: AnsiString;
  AllDIndices: TInt64List;

begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--OutputDir'].AsAnsiString;
  OutputDir:= GetRunTimeParameterManager.ValueByName['--OutputDir'].AsAnsiString;
  DebugLn(Format('%d Task.ID: %d InputDir = %s OutputDir = %s',
    [ThreadID, Task.ID, InputDir, OutputDir]));

  Filename := ConcatPaths([InputDir, 'wiki.train.tokens.sentence.index']);
  DebugLn(Filename);
  // AllDIndices := TInt64List.LoadFromFile(Filename);
  Result := True;

  // Result := ProcessMyDocuments(Task, AllDIndices);

  // AllDIndices.Free;
  DebugLn(Format('Done with Task: %d', [Task.ID]));

end;

end.

