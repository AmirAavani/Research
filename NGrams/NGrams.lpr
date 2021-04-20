program NGrams;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, sysutils, ParameterManagerUnit, StreamUnit, ALoggerUnit,
  ProtoHelperUnit, SharedDataUnit,  BaseMapperUnit,
  DataLineUnit, SourcerUnit, MapperOptionUnit, PairUnit, Mapper.TypesUnit
  { you can add units after this };

var
  Filename, InputDir: AnsiString;
  dl: TDataLine;


begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--InputDir'].AsAnsiString;
  Filename := ConcatPaths([InputDir, 'wiki.train.tokens']);
  FMTDebugLn('%d Filename: %s', [ThreadID, Filename]);

  dl := TDataLine.Create(TNewLineReader.Create(Filename, sLineBreak)).
    Map('TokenizeDoc', TBaseMapper.Create,
      TMappingOptions.Create.SetNumShards(10)).
    Map('Count', TBaseMapper.Create, TMappingOptions.Create);

  FMTDebugLn('Run?: %s', [BoolToStr(dl.Run(False, True), 'True', 'False')]);

  dl.Report;

  FMTDebugLn('Wait?: %s', [BoolToStr(dl.Wait, 'True', 'False')]);
  DebugLn('Done');

end.

