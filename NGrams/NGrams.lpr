program NGrams;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, ParameterManagerUnit,
  PipelineUnit,
  ALoggerUnit, IndexDocumentsUnit, ProcessDocumentsUnit
  { you can add units after this };

var
  Pipeline: TPipeline;

begin
  Pipeline := TPipeline.Create('ngrams');
  Pipeline.AddNewStep(@IndexDocuments, 1);
  Pipeline.AddNewStep(@ProcessDocuments, 5);

  Pipeline.RunFromStep(GetRunTimeParameterManager.ValueByName['--Pipeline.FromStepID'].AsInteger);

  Pipeline.Free;
  DebugLn('Done');

end.

