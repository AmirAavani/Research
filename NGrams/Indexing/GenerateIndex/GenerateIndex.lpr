program GenerateIndex;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, PipelineUnit, ALoggerUnit, ParameterManagerUnit, HeapUnit,
ExtractUniqueTokensStepUnit
  { you can add units after this };

var
  p: TPipeline;
  Config: TPipelineConfig;

begin
  Config := TPipelineConfig.DefaultConfig.SetNumberOfThreads(16);

  p := TPipeline.Create('Token2ID', Config);
  p.AddNewStep(@ExtractUniqueTokensStepUnit.ExtractUniqueTokensStep, 16);
  p.Run;
  p.Free;
  Config.Free;

end.

