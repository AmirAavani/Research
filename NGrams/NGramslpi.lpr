program NGramslpi;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, ParameterManagerUnit, PipelineUnit, WideStringUnit, HeapUnit,
  SyncUnit, RunInAThreadUnit, ALoggerUnit, IndexSentencesUnit
  { you can add units after this };

var
  Pipeline: TPipeline;

begin
  Pipeline := TPipeline.Create('ngrams');
  Pipeline.AddNewStep(@IndexSentences, 2);

  Pipeline.Run;

  Pipeline.Free;
end.

