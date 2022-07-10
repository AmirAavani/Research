unit BuildLineIndexUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Pipeline.TypesUnit, PipelineUnit;

function BuildLineIndex(Task: TTask): Boolean;

implementation
uses
  Pipeline.Utils, ParameterManagerUnit, ALoggerUnit,
  StreamUnit, Pipeline.IOUnit, PathHelperUnit, StringUnit;

function BuildLineIndex(Task: TTask): Boolean;
var
  Stream: TMyTextStream;
  Writer: TPipelineWriter;
  InputDir, OutputDir, TmpDir: AnsiString;
  InputFile: AnsiString;
  InputPattern, OutputPattern: AnsiString;
  MyInputFiles, MyOutputFiles: TAnsiStringList;
  Line: AnsiString;
  Tokens: TStringList;
  Token: AnsiString;

begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--InputDir'].AsAnsiString;
  OutputDir:= GetRunTimeParameterManager.ValueByName['--OutputDir'].AsAnsiString;
  TmpDir:= GetRunTimeParameterManager.ValueByName['--TmpDir'].AsAnsiString;

  InputPattern := JoinPath(InputDir, 'training-monolingual.tokenized.shuffled/news.en@100');
  OutputPattern := JoinPath(TmpDir, Format('Step1/lineindex.bin@%d', [Task.StepInfo.NumTasks]));
  FMTDebugLn('InputPattern = %s OutputPath = %s ',
    [InputPattern, OutputPattern]);

  MyInputFiles := Task.FilterFilesModule(InputPattern);
  MyOutputFiles := Task.FilterFilesModule(OutputPattern);

  Writer := TPipelineWriter.Create(MyOutputFiles);

  Result := True;

  for InputFile in MyInputFiles do
  begin
    Stream := TMyTextStream.Create(TFileStream.Create(InputFile, fmOpenRead), True);

    while Stream.Position < Stream.Size do
    begin
      Line := Stream.ReadLine;
      Tokens := Split(Line, ' ');

      For Token in Tokens do
        Writer.WriteAnsiString(Token);

    end;

  end;

  Writer.Free;

end;


end.

