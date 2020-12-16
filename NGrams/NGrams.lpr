program NGrams;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, sysutils, ParameterManagerUnit,
  PipelineUnit, StreamUnit,
  ALoggerUnit, IndexDocumentsUnit, ProcessDocumentsUnit, Pipeline.Types
  { you can add units after this };

var
  Pipeline: TPipeline;
  Stream: TMyTextStream;
  Filename, InputDir: AnsiString;
  Data: AnsiString;

begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--InputDir'].AsAnsiString;
  Filename := ConcatPaths([InputDir, 'wiki.train.tokens']);
  DebugLn(Format('%d Filename: %s', [ThreadID, Filename]));
  Stream := TMyTextStream.Create(TFileStream.Create(
    Filename, fmOpenRead),
    True
  );
  DebugLn(Format('+Filename: %s', [Filename]));
  Data := Stream.ReadAll;
  Stream.Free;
  DebugLn(Format('Len(Data): %d', [Length(Data)]));

  Pipeline := TPipeline.Create('ngrams');
  Pipeline.AddNewStep(@IndexDocuments, 1, [@Data]);
  Pipeline.AddNewStep(@ProcessDocuments, 10, [@Data]);

  TPipeline.Run(Pipeline);

  SetLength(Data, 0);
  Pipeline.Free;

  DebugLn('Done');

end.

