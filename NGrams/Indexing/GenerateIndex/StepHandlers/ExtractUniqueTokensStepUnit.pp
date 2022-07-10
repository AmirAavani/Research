unit ExtractUniqueTokensStepUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, PipelineUnit;

function ExtractUniqueTokensStep(Task: TTask): Boolean;

implementation
uses
  ParameterManagerUnit, Pipeline.Utils, Pipeline.TypesUnit, ALoggerUnit;

function ExtractUniqueTokensStep(Task: TTask): Boolean;
var
  TmpDir: AnsiString;
  InputPattern: TFilePattern;
  AllMyFiles: TAnsiStringList;

  FileName: AnsiString;

begin
  {if Task.ID <> 1 then
    Exit(True);
  }InputPattern := TFilePattern.Create(
    GetRunTimeParameterManager.
      ValueByName['--InputPattern'].
      AsAnsiString);
  TmpDir := GetRunTimeParameterManager.ValueByName['--TmpDir'].AsAnsiString;

  AllMyFiles := InputPattern.FilterMyFilesModule(Task);
  InputPattern.Free;

  for FileName in AllMyFiles do
    FMTDebugLn('Task: %d Filename: %s', [Task.ID, FileName]);

  AllMyFiles.Free;



end;

end.

