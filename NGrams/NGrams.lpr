program NGrams;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, sysutils, ParameterManagerUnit, ALoggerUnit, PipelineUnit,
  SimpleTypesUnit, BuildLineIndexUnit, StreamUnit, PathHelperUnit,
  DateTimeUtilUnit;

var
  Filename, InputDir, OutputDir, TmpDir: AnsiString;
  Pipeline: TPipeline;


begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--InputDir'].AsAnsiString;
  OutputDir:= GetRunTimeParameterManager.ValueByName['--OutputDir'].AsAnsiString;
  TmpDir:= GetRunTimeParameterManager.ValueByName['--TmpDir'].AsAnsiString;

  Pipeline := TPipeline.Create('NGram');

  Pipeline.AddNewStep(@EncodeTokenStep, 1);

  Pipeline.Run(True);
  Pipeline.Free;
end.

