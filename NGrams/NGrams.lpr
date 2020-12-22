program NGrams;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, sysutils, ParameterManagerUnit, PipelineUnit, StreamUnit,
  ALoggerUnit, IndexDocumentsUnit, ExtractSentencesUnit, SentenceUnit,
  Pipeline.TypesUnit, ProtoHelperUnit, FastMD5Unit, Pipeline.IOUnit
  { you can add units after this };

var
  Pipeline: TPipeline;
  Stream: TMyTextStream;
  Filename, InputDir: AnsiString;
  Data: AnsiString;

begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--InputDir'].AsAnsiString;
  Filename := ConcatPaths([InputDir, 'wiki.train.tokens']);
  FMTDebugLn('%d Filename: %s', [ThreadID, Filename]);
  Stream := TMyTextStream.Create(TFileStream.Create(
    Filename, fmOpenRead),
    True
  );
  FMTDebugLn('+Filename: %s', [Filename]);
  Data := Stream.ReadAll;
  Stream.Free;
  FMTDebugLn('Len(Data): %d', [Length(Data)]);

  Pipeline := TPipeline.Create('ngrams');
  Pipeline.AddNewStep(@IndexDocuments, 1, [@Data]);
  Pipeline.AddNewStep(@ExtractSentences, 1, [@Data]);

  TPipeline.Run(Pipeline);

  SetLength(Data, 0);
  Pipeline.Free;

  DebugLn('Done');

end.

